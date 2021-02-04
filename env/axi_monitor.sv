`ifndef AXI_MONITOR__SV
`define AXI_MONITOR__SV


typedef struct packed {
    logic [ 27:0]   raddr                  ; 
    logic [  7:0]   rlen                   ; 
}  moninfo;


class axi_monitor extends uvm_monitor;

   virtual tvip_axi_if vaxi;
   virtual tvip_ini_if vini;

   uvm_analysis_port #(axi_transaction)  ap;
   uvm_blocking_get_port #(axi_transaction)  port;

   reg [7:0]     data_cnt ;  

   `uvm_component_utils(axi_monitor)
   function new(string name = "axi_monitor", uvm_component parent = null);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db#(virtual tvip_axi_if)::get(this, "", "vaxi", vaxi))
         `uvm_fatal("axi_monitor", "virtual interface must be set for vaxi!!!")
      if(!uvm_config_db#(virtual tvip_ini_if)::get(this, "", "vini", vini))
         `uvm_fatal("axi_monitor", "virtual interface must be set for vini!!!")
      ap = new("ap", this);
      port = new("port", this);
   endfunction

   extern task main_phase(uvm_phase phase);
   extern task collect_one_pkt(axi_transaction tr);
endclass

task axi_monitor::main_phase(uvm_phase phase);
   axi_transaction tr;
   axi_transaction dtr;
 
   moninfo  minfo_queue[$];
   moninfo  aminfo;
   moninfo  bminfo;

   data_cnt = 0 ;

   tr = new("tr");

   tr.axi_enable = 1 ;
   tr.axi_write  = 0 ;

   fork
	while(1) begin
		 port.get(dtr); 
  		 `uvm_info("axi_monitor", "get one transaction, copy and print it:", UVM_HIGH)
		 `ifdef UVM_HIGH
   		 	dtr.print();
	 	 `endif
		 aminfo.raddr=dtr.axi_raddr;
		 aminfo.rlen=dtr.axi_len;
		 minfo_queue.push_front(aminfo);
	end	
   	while(1) begin
   	       @(posedge vaxi.aclk);
   	     	if(vaxi.rvalid)  begin
			if (data_cnt=='d0 ) begin 
			       	bminfo=minfo_queue.pop_back();
				tr.axi_raddr = bminfo.raddr ;
				tr.axi_len   = bminfo.rlen ;
			end
   	       		`uvm_info("axi_monitor", "begin to collect one pkt", UVM_HIGH);
   	     		tr.axi_rdata =  vaxi.rdata      ;
   	      		`uvm_info("axi_monitor", "end collect one pkt, print it:", UVM_HIGH);
			`ifdef UVM_HIGH
   	     			tr.print();
			`endif
   	       		ap.write(tr);
   	     		if (data_cnt==tr.axi_len)    data_cnt <= 0 ;
   	      		else   data_cnt <= data_cnt + 1 ;
   	     	end
   	end
   join
endtask

task axi_monitor::collect_one_pkt(axi_transaction tr);
   while(1) begin
      @(posedge vaxi.aclk);
      if(vaxi.rvalid) break;
   end

   `uvm_info("axi_monitor", "begin to collect one pkt", UVM_HIGH);
   tr.axi_rdata =  vaxi.rdata;
   `uvm_info("axi_monitor", "end collect one pkt, print it:", UVM_HIGH);
   `ifdef UVM_HIGH
    	tr.print();
    `endif
endtask


`endif
