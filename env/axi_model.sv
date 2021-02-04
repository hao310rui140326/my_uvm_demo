`ifndef AXI_MODEL__SV
`define AXI_MODEL__SV



typedef struct packed {
    logic [ 27:0]   raddr                  ; 
    logic [  7:0]   rlen                   ; 
}  mdlinfo;


class axi_model extends uvm_component;
  
   virtual tvip_mem_if vmem;
   reg  [7:0]  data_cnt ;

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
  
   moninfo  minfo_queue[$];
   moninfo  aminfo;
   moninfo  bminfo;
   
   //axi_transaction new_tr;
   super.main_phase(phase);
   
    tr = new("tr");
    //tr.axi_raddr   =  dtr.axi_raddr;
    //tr.axi_len     =  dtr.axi_len  ;
    tr.axi_write   =  0  ;
    tr.axi_enable  =  1  ;

   data_cnt = 0 ; 
   fork
	while(1) begin
		 port.get(dtr); 
  		 `uvm_info("axi_model", "get one transaction, copy and print it:", UVM_HIGH)
		 `ifdef UVM_HIGH
   			 dtr.print();
	 	 `endif
		 aminfo.raddr=dtr.axi_raddr;
		 aminfo.rlen=dtr.axi_len;
		 minfo_queue.push_front(aminfo);
	end	
   	while(1) begin
   	       @(posedge vmem.aclk);
   	       if(vmem.rvld)  begin
		       if (data_cnt=='d0 )  begin
			       bminfo=minfo_queue.pop_back();
			       tr.axi_raddr  = bminfo.raddr ;
			       tr.axi_len   = bminfo.rlen ;
		       end
   	              	`uvm_info("axi_model", "begin to collect one pkt", UVM_HIGH);
   	       		tr.axi_rdata   =  vmem.rdout;
   	          	`uvm_info("axi_model", "end collect one pkt, print it:", UVM_HIGH);
			`ifdef UVM_HIGH
   	       			tr.print();
			`endif
   	       		ap.write(tr);
   	                 if (data_cnt==tr.axi_len)   data_cnt <= 0 ;
   	                 else   data_cnt <= data_cnt + 1 ; 
   	       end 
   	 end
    join
endtask


task axi_model::collect_one_pkt(axi_transaction tr);
   while(1) begin
      @(posedge vmem.aclk);
      if(vmem.rvld) break;
   end

   `uvm_info("axi_model", "begin to collect one pkt", UVM_HIGH);
   tr.axi_rdata =  vmem.rdout;
   `uvm_info("axi_model", "end collect one pkt, print it:", UVM_HIGH);
   `ifdef UVM_HIGH 
   	tr.print();
   `endif
endtask




`endif
