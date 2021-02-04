`ifndef APB_MONITOR__SV
`define APB_MONITOR__SV
class apb_monitor extends uvm_monitor;

   virtual tvip_apb_if vapb;
   virtual tvip_ini_if vini;

   uvm_analysis_port #(apb_transaction)  ap;

   `uvm_component_utils(apb_monitor)
   function new(string name = "apb_monitor", uvm_component parent = null);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db#(virtual tvip_apb_if)::get(this, "", "vapb", vapb))
         `uvm_fatal("apb_monitor", "virtual interface must be set for vapb!!!")
      if(!uvm_config_db#(virtual tvip_ini_if)::get(this, "", "vini", vini))
         `uvm_fatal("apb_monitor", "virtual interface must be set for vini!!!")
      ap = new("ap", this);
   endfunction

   extern task main_phase(uvm_phase phase);
   extern task collect_one_pkt(apb_transaction tr);
endclass

task apb_monitor::main_phase(uvm_phase phase);
   apb_transaction tr;
   while(1) begin
      tr = new("tr");
      collect_one_pkt(tr);
      ap.write(tr);      
   end
endtask

task apb_monitor::collect_one_pkt(apb_transaction tr);
   while(1) begin
      @(posedge vapb.aclk);
      //if(vapb.apb_ready&&vapb.apb_enable) break;
      if(vapb.apb_ready&&vapb.apb_enable&&~vapb.apb_write) break;
   end

   `uvm_info("apb_monitor", "begin to collect one pkt", UVM_HIGH);
   tr.apb_addr  =  vapb.apb_addr;
   tr.apb_wdata =  vapb.apb_write ?  vapb.apb_wdata  :  'd0 ;
   if(vapb.apb_write)   tr.apb_rd_wr=apb_transaction::APB_WRITE  ;
   else                     tr.apb_rd_wr=apb_transaction::APB_READ   ;
   @(posedge vapb.aclk);
   tr.apb_rdata =  vapb.apb_rdata;
   tr.apb_enable =   1'd1;
   
   `uvm_info("apb_monitor", "end collect one pkt, print it:", UVM_HIGH);
   `ifdef UVM_HIGH
    	tr.print();
    `endif
endtask


`endif
