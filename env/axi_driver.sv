`ifndef AXI_DRIVER__SV
`define AXI_DRIVER__SV

typedef struct packed {
    logic [27:0]   waddr                 ; 
    logic [ 7:0]   wlen                  ; 
} t_winfo;

class axi_driver extends uvm_driver#(axi_transaction);

   virtual tvip_axi_if vaxi;
   virtual tvip_ini_if vini;
   virtual tvip_mem_if vmem;

   uvm_analysis_port #(axi_transaction)  ap;
   uvm_analysis_port #(axi_transaction)  ap_mdl;

   axi_transaction montr; 	

   reg  [ 31:0]   taddr ;   
   reg  [ 31:0]   raddr ;   
   reg  [255:0]   tdata ;   
   reg  [ 15:0]   waddr_cnt ;   
   reg  [ 31:0]   wdata_cnt ;   
   reg  [ 15:0]   raddr_cnt ;   
   reg  [ 31:0]   rdata_cnt ;
   t_winfo        winfo_fifo[$]  ;   
   t_winfo        rinfo_fifo[$]  ;   
   t_winfo        rmem_fifo[$]   ;   
   t_winfo        winfo          ;   
   t_winfo        wmem_info          ;   
   t_winfo        raxi_info          ;   
   t_winfo        rmem_info          ;   

   reg                  rflag              ;   
   reg  [15:0]          rwcnt              ;   

   `uvm_component_utils(axi_driver)
   function new(string name = "axi_driver", uvm_component parent = null);
      super.new(name, parent);
      `uvm_info("axi_driver", "new is called", UVM_LOW);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info("axi_driver", "build_phase is called", UVM_LOW);
      if(!uvm_config_db#(virtual tvip_axi_if)::get(this, "", "vaxi", vaxi))
         `uvm_fatal("axi_driver", "virtual interface must be set for vaxi!!!")
      if(!uvm_config_db#(virtual tvip_ini_if)::get(this, "", "vini", vini))
         `uvm_fatal("axi_driver", "virtual interface must be set for vini!!!")
      if(!uvm_config_db#(virtual tvip_mem_if)::get(this, "", "vmem", vmem))
         `uvm_fatal("axi_driver", "virtual interface must be set for vmem!!!")
      ap = new("ap", this); 
      ap_mdl = new("ap_mdl", this); 
   endfunction

   extern virtual task main_phase(uvm_phase phase);
   extern task drive_waxi_one(axi_transaction tr);
   extern task drive_raxi_one(axi_transaction tr);
   extern task drive_wraxi_all(axi_transaction tr);
endclass

task axi_driver::main_phase(uvm_phase phase);
   //axi_transaction tr;	
   //phase.raise_objection(this);
   `uvm_info("axi_driver", "main_phase is called", UVM_LOW);
   while(!vini.ini_done)
      @(posedge vaxi.aclk);
   `uvm_info("axi_driver", "ddr3_ini_done", UVM_LOW);

    while(1) begin
    	seq_item_port.get_next_item(req);
        `uvm_info("axi_driver", "get_next_item", UVM_HIGH);
	`ifdef 	UVM_HIGH
    		req.print();
	`endif
	if((req.axi_rd_wr==axi_transaction::AXI_SEQ_ONE)&&req.axi_write)                    drive_waxi_one(req);
	else  if((req.axi_rd_wr==axi_transaction::AXI_SEQ_ONE)&&~req.axi_write)             drive_raxi_one(req);
	else  if(req.axi_rd_wr==axi_transaction::AXI_SEQ_ALL)                               drive_wraxi_all(req);
	else  if(req.axi_rd_wr==axi_transaction::AXI_RAND_ALL)                              drive_wraxi_all(req);
	else  `uvm_info("axi_driver", "CASE ERROR", UVM_HIGH);	
    	seq_item_port.item_done();
    end
    //phase.drop_objection(this);
endtask

task axi_driver::drive_waxi_one(axi_transaction tr);
   `uvm_info("axi_driver", "Transaction From AXI Master Driver..", UVM_MEDIUM)
   `uvm_info("axi_driver", "begin to WAXI_ONE", UVM_HIGH);
//   reg  [31:0]   taddr ;
   @(posedge vaxi.aclk);
   vaxi.awvalid    <= 1'b1;     
   vaxi.arvalid    <= 1'b0;     
   vaxi.awaddr[27:3]     <= tr.axi_waddr[27:3];
   vaxi.awaddr[ 2:0]     <= 'd0 ;
   vaxi.wstrb      <= 32'hffff_ffff;
   vaxi.awlen      <= tr.axi_len;
   vaxi.awid       <= $random;
   vaxi.wdata  <= tr.axi_wdata; //$random;
   vmem.we     <= 'd0 ;
   vmem.re     <= 'd0 ;
   vmem.wdata     <= 'd0 ;
   vmem.wb        <= 32'hffff_ffff ;
   vmem.waddr     <= 'd0 ;
   vmem.raddr     <= 'd0 ;
   taddr          <= tr.axi_waddr/8;
   tdata          <= tr.axi_wdata;   
          while(1) begin
             @(posedge vaxi.aclk);	   
	     if(vaxi.awready && vaxi.awvalid) begin
		vaxi.awvalid    <= 1'b0;  
             end
	     if (vaxi.wready) begin 
		vaxi.wdata  <= vaxi.wdata  + 1'd1 ;
		vmem.we     <= 'd1 ;
		vmem.wdata  <=  tdata ;
		vmem.waddr  <=  taddr ;
		taddr       <=  taddr + 1'b1;
		tdata       <=  tdata + 1'b1;
		if(vaxi.wlast)  break;
	     end
     	     else begin
		vmem.we     <= 'd0 ;
	     end
	   end
          @(posedge vaxi.aclk);
		vmem.we     <= 'd0 ;

   `uvm_info("axi_driver", "end WAXI_ONE", UVM_HIGH);
endtask


task axi_driver::drive_raxi_one(axi_transaction tr);
   `uvm_info("axi_driver", "Transaction From AXI Master Driver..", UVM_MEDIUM)
   `uvm_info("axi_driver", "begin to RAXI_ONE", UVM_HIGH);
   //reg  [31:0]   taddr ;  
   montr = new("montr"); 
   montr.copy(tr);
   ap.write(montr);
   ap_mdl.write(montr);

   //ap.write(tr);
   //ap_mdl.write(tr);
   
   @(posedge vaxi.aclk);
   vaxi.awvalid    <= 1'b0;     
   vaxi.arvalid    <= 1'b1;     
   vaxi.araddr     <= tr.axi_raddr;
   vaxi.arlen      <= tr.axi_len;
   vmem.we     <= 'd0 ;
   vmem.re     <= 'd0 ;
   vmem.wdata     <= 'd0 ;
   vmem.wb        <= 'd0 ;
   vmem.waddr     <= 'd0 ;
   vmem.raddr     <= 'd0 ;
   taddr          <= tr.axi_raddr/8;
       
          while(1) begin
             @(posedge vaxi.aclk);	   
	     if(vaxi.arready && vaxi.arvalid) begin
		vaxi.arvalid    <= 1'b0;  
             end
	     if (vaxi.rvalid) begin
		vmem.re     <= 'd1 ;
		vmem.raddr  <=  taddr ;
		taddr       <=  taddr + 1'b1;
		if(vaxi.rlast)  break;
	     end
     	     else begin 
		vmem.re     <= 'd0 ;
	     end
	   end
          @(posedge vaxi.aclk);
		vmem.re     <= 'd0 ;

   `uvm_info("axi_driver", "end RAXI_ONE", UVM_HIGH);
endtask

task axi_driver::drive_wraxi_all(axi_transaction tr);
   `uvm_info("axi_driver", "Transaction From AXI Master Driver..", UVM_MEDIUM)
   `uvm_info("axi_driver", "begin to WRAXI_SEQ_ALL", UVM_HIGH);

   montr = new("montr");    
   montr.copy(tr);
   
   waddr_cnt  <= 'd0 ;   
   wdata_cnt  <= 'd0 ;   
   raddr_cnt  <= 'd0 ;   
   rdata_cnt  <= 'd0 ;   

 @(posedge vaxi.aclk);
   vaxi.awvalid    <= 1'b1;     
   vaxi.arvalid    <= 1'b0;     
   vaxi.awaddr     <= {tr.axi_waddr[27:3],3'b0};
   vaxi.wstrb      <= 32'hffff_ffff;
   vaxi.awlen      <= tr.axi_len%16;
   vaxi.arlen      <= tr.axi_len%16;
   vaxi.awid       <= $random;
   vaxi.wdata  <= tr.axi_wdata; //$random;
   vmem.we        <= 'd0 ;
   vmem.re        <= 'd0 ;
   vmem.wdata     <= 'd0 ;
   vmem.wb        <= 32'hffff_ffff ;
   vmem.waddr     <= 'd0 ;
   vmem.raddr     <= 'd0 ;
   taddr          <=  {tr.axi_waddr[27:3],3'b0} ;
   raddr          <=  {tr.axi_waddr[27:3],3'b0} ;
   tdata          <=  tr.axi_wdata  ;     

   winfo.waddr   =  {tr.axi_waddr[27:3],3'b0}  ;
   winfo.wlen    =  tr.axi_len%16    ;
   winfo_fifo.push_back(winfo)    ;
   rinfo_fifo.push_back(winfo)    ;
   rmem_fifo.push_back(winfo)    ;
   wmem_info = winfo_fifo.pop_front() ;
   raxi_info = rinfo_fifo.pop_front() ;
   rmem_info = rmem_fifo.pop_front() ;
   rflag    <=  'd0 ; 
   rwcnt    <=  'd0 ;

          while(1) begin
            		 @(posedge vaxi.aclk);
	    		 //////////////////////////////////////////////
  	    		 //axi waddr	     
	    		 if(vaxi.awready && vaxi.awvalid) begin
	    		         if (waddr_cnt>=tr.axi_sim_cnt)  begin 
	    		    		vaxi.awvalid    <= 1'b0     ;
				        $display("axi driver  %d  tx  done !!!",tr.axi_sim_cnt);	
	    		         end
	    		         else begin
	    		    		vaxi.awvalid    <= 1'b1;
					if(req.axi_rd_wr==axi_transaction::AXI_RAND_ALL)  begin 
	    		    			vaxi.awaddr[27:3]     <=  {$random} ;	
	    		    			vaxi.awaddr[ 2:0]     <=  'd0     ;
						vaxi.awlen            <=  {$random}%16 ;	
					end
					else begin 
	    		    			vaxi.awaddr     <= vaxi.awaddr + 8*16 ;	
					end
	    		                waddr_cnt       <= waddr_cnt   +  'd1 ;			
	    		         end
				 if (|waddr_cnt)   begin
	    		    		winfo.waddr   =  vaxi.awaddr   ;
   	    		    		winfo.wlen    =  vaxi.awlen    ;
   	    		    		winfo_fifo.push_back(winfo)    ;
   	    		    		rinfo_fifo.push_back(winfo)    ;
   	    		    		rmem_fifo.push_back(winfo)    ;
	    		         end 
            		 end
	    		 //////////////////////////////////////////////
	    		 //axi raddr	     
	    		 if (rinfo_fifo.size>1) begin
	    		     if (rwcnt>=1024) begin
	    		    	rflag  <= 1'd1 ;
	    		     end
	    		     else begin
	    		    	rwcnt  <= rwcnt + 'd1 ;
	    		     end
	    		 end
	    		 else begin
	    		    	rflag  <= 1'd0 ;
	    		    	rwcnt  <=  'd0  ;
	    		 end
	    		 if ( (rwcnt==1023) &&(rinfo_fifo.size>1)) begin
	    		    vaxi.arvalid    <= 1'b1;     
	    		    vaxi.araddr     <= raxi_info.waddr;
	    		    vaxi.arlen      <= raxi_info.wlen ;	
	    		 end
	    		 else if (vaxi.arready && vaxi.arvalid&&rflag) begin
   	    		    raxi_info = rinfo_fifo.pop_front() ;
	    		    vaxi.arvalid    <= 1'b1;     
	    		    vaxi.araddr     <= raxi_info.waddr;
	    		    vaxi.arlen      <= raxi_info.wlen ;		
	    		 end
	    		 else if (vaxi.arready && vaxi.arvalid&&~rflag)  begin 
	    		    vaxi.arvalid    <= 1'b0;     
	    		 end
	    		 //axi rdata
            		 if (vaxi.rvalid) begin
	    		    vmem.re     <= 'd1 ;
	    		    vmem.raddr  <=  raddr[31:3] ;
	    		    raddr       <=  raddr + 'd8;
	    		    if(vaxi.rlast)    begin
	    		    	if (rmem_fifo.size<=1) begin
					$display("axi driver  read done !!!");	
	    		    		break;
	    		    	end
	    		    	else begin	
	    		    		rmem_info   =  rmem_fifo.pop_front()  ;
	    		    		raddr       <= rmem_info.waddr;
	    		    	end
	    		    end
	    		 end
     	    		 else begin 
	    		    vmem.re     <= 'd0 ;
	    		 end
	    		 //////////////////////////////////////////////
	    		 //axi wdata
	    		 if (vaxi.wready) begin 
	    		    vaxi.wdata  <=  {8{$random}} ; //tdata ; {$random}
	    		    vmem.we     <=  'd1   ;
	    		    vmem.wdata  <=   vaxi.wdata ;
	    		    vmem.waddr  <=  taddr[31:3] ;		
	    		    if(vaxi.wlast)  begin
	    		    	wmem_info   = winfo_fifo.pop_front();
	    		    	taddr       <= wmem_info.waddr ;
	    		    end
	    		    else begin
	    		    	taddr       <=  taddr + 'd8;			
	    		    end
	    		 end
     	    		 else begin
	    		    vmem.we     <= 'd0 ;
	    		 end
			 if (vaxi.arready && vaxi.arvalid) begin
	    		    //tr.axi_enable = 1'd1 ;
   	    		    //tr.axi_write  = 1'd0 ;
   	    		    //tr.axi_len    = vaxi.arlen       ; 
   	    		    //tr.axi_raddr  = vaxi.araddr     ; 
   	    		    //ap.write(tr);
   	    		    //ap_mdl.write(tr);

			    montr.axi_enable = 1'd1 ;
   	    		    montr.axi_write  = 1'd0 ;
   	    		    montr.axi_len    = vaxi.arlen      ; 
   	    		    montr.axi_raddr  = vaxi.araddr     ; 
   	    		    montr.axi_waddr  = 'd0             ; 
   	    		    montr.axi_wdata  = 'd0             ; 
			    ap.write(montr);
			    ap_mdl.write(montr);

   			    `uvm_info("axi_driver", "print_out_tr", UVM_HIGH);   			    
			`ifdef 	UVM_HIGH
	    		    montr.print();
		    	`endif
            		 end
	   end
          @(posedge vaxi.aclk);
		vmem.we     <= 'd0 ;
		vmem.re     <= 'd0 ;

   `uvm_info("axi_driver", "end_WRAXI_SEQ_ALL ", UVM_HIGH);
endtask


`endif
