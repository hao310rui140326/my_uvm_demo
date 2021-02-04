`ifndef AXI_MODEL__SV
`define AXI_MODEL__SV



typedef struct packed {
    logic [ 27:0]   raddr                  ; 
    logic [255:0]   rdata                  ; 
    logic [  7:0]   rlen                   ; 
}  minfo;


class axi_model extends uvm_component;
  
   virtual tvip_mem_if vmem;
   reg  [7:0]  data_cnt ;

   minfo  minfo_queue[$];
   minfo  aminfo;

   uvm_blocking_get_port #(axi_transaction)  port;
   uvm_analysis_port #(axi_transaction)  ap;

   extern function new(string name, uvm_component parent);
   extern function void build_phase(uvm_phase phase);
   extern virtual  task main_phase(uvm_phase phase);
   extern task collect_one_pkt(axi_transaction tr);

   `uvm_component_utils(axi_model)
endclass 

function axi_model::new(string name, uvm_component parent);
   super.new(name, parent);
endfunction 

function void axi_model::build_phase(uvm_phase phase);
   super.build_phase(phase);
   if(!uvm_config_db#(virtual tvip_mem_if)::get(this, "", "vmem", vmem))
         `uvm_fatal("axi_model", "virtual interface must be set for vmem!!!")
   ap = new("ap", this);
   port = new("port", this);
endfunction

task axi_model::main_phase(uvm_phase phase);
   axi_transaction tr;
   axi_transaction dtr;
   //axi_transaction new_tr;
   super.main_phase(phase);
   port.get(dtr); 
  `uvm_info("axi_model", "get one transaction, copy and print it:", UVM_LOW)
   dtr.print();
   
   tr = new("tr");

    tr.axi_raddr   =  dtr.axi_raddr;
    tr.axi_len     =  dtr.axi_len  ;
    tr.axi_write   =  0  ;
    tr.axi_enable  =  1  ;

   data_cnt = 0 ; 
   while(1) begin
          //port.get(tr);
          //new_tr = new("new_tr");
          //new_tr.copy(tr);
          //`uvm_info("axi_model", "get one transaction, copy and print it:", UVM_LOW)
          //new_tr.print();
          //ap.write(new_tr);
                //collect_one_pkt(tr);
          //while(1) begin
          //  @(posedge vmem.aclk);
          //  if(vmem.rvld) break;
          //end
          @(posedge vmem.aclk);
          if(vmem.rvld)  begin
                 	`uvm_info("axi_model", "begin to collect one pkt", UVM_LOW);
          		tr.axi_rdata   =  vmem.rdout;
             		`uvm_info("axi_model", "end collect one pkt, print it:", UVM_LOW);
          		tr.print();
          		ap.write(tr);

                    if (data_cnt==dtr.axi_len)   begin 
                	    port.get(dtr);
                	    `uvm_info("axi_model", "get one transaction, copy and print it:", UVM_LOW)
                	    dtr.print();
                            data_cnt <= 0 ;
              	            tr.axi_raddr   =  dtr.axi_raddr;
              	            tr.axi_len     =  dtr.axi_len  ;    
                    end                   
                    else   data_cnt <= data_cnt + 1 ; 
          end 
    end
endtask


task axi_model::collect_one_pkt(axi_transaction tr);
   while(1) begin
      @(posedge vmem.aclk);
      if(vmem.rvld) break;
   end

   `uvm_info("axi_model", "begin to collect one pkt", UVM_LOW);
   tr.axi_rdata =  vmem.rdout;
   `uvm_info("axi_model", "end collect one pkt, print it:", UVM_LOW);
    tr.print();
endtask




`endif
