`ifndef APB_DRIVER__SV
`define APB_DRIVER__SV
class apb_driver extends uvm_driver#(apb_transaction);

   virtual tvip_apb_if vapb;
   //virtual tvip_axi_if vaxi;
   virtual tvip_ini_if vini;

   `uvm_component_utils(apb_driver)
   function new(string name = "apb_driver", uvm_component parent = null);
      super.new(name, parent);
      `uvm_info("apb_driver", "new is called", UVM_HIGH);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info("apb_driver", "build_phase is called", UVM_HIGH);
      if(!uvm_config_db#(virtual tvip_apb_if)::get(this, "", "vapb", vapb))
         `uvm_fatal("apb_driver", "virtual interface must be set for vapb!!!")
      //if(!uvm_config_db#(virtual tvip_axi_if)::get(this, "", "vaxi", vaxi))
      //   `uvm_fatal("apb_driver", "virtual interface must be set for vaxi!!!")
      if(!uvm_config_db#(virtual tvip_ini_if)::get(this, "", "vini", vini))
         `uvm_fatal("apb_driver", "virtual interface must be set for vini!!!")
   endfunction

   extern virtual task main_phase(uvm_phase phase);
   extern task drive_wrapb_one(apb_transaction tr);
   extern task drive_wrapb_all(apb_transaction tr);
   extern task drive_wapb_all(apb_transaction tr);
   extern task drive_rapb_all(apb_transaction tr);

endclass

task apb_driver::main_phase(uvm_phase phase);
   //apb_transaction tr;	
   //phase.raise_objection(this);
   `uvm_info("apb_driver", "main_phase is called", UVM_LOW);
   vapb.apb_sel <= 1'b0; 
   vapb.apb_enable <= 1'b0;
   vapb.apb_addr <= 'd0;
   vapb.apb_write <= 'd0;
   vapb.apb_wdata <= 'd0;
   //while(!vini.ini_pll_lock)
   //while(!vini.ini_done)
   //while(!vini.ini_phy_lock)
   while(!vini.ini_done)
      @(posedge vapb.aclk);
   `uvm_info("apb_driver", "ddr3_ini_done", UVM_LOW);

   //for(int i = 0; i < 1000; i++) begin 
   //   @(posedge vapb.aclk);
   //   vapb.apb_sel <= 1'b1; 
   //   req = new("req");
   //   assert(req.randomize() );
   //   req.print();
   //   if(req.apb_enable)  drive_wrapb_one(req);
   //   @(posedge vapb.aclk);
   //   vapb.apb_sel <= 1'b0; 
   //end
    while(1) begin
    	seq_item_port.get_next_item(req);
        `uvm_info("apb_driver", "get_next_item", UVM_HIGH);	    	
	`ifdef UVM_HIGH
    		req.print();
        `endif
	if(req.apb_enable)  begin 
		if      (req.apb_rd_wr==apb_transaction::APB_RALL)  drive_rapb_all(req);
                else if (req.apb_rd_wr==apb_transaction::APB_WALL)  drive_wapb_all(req);
                else if (req.apb_rd_wr==apb_transaction::APB_WRALL) drive_wrapb_all(req);
                else                                               drive_wrapb_one(req);
	end
    	seq_item_port.item_done();
    end
    //phase.drop_objection(this);
endtask


task apb_driver::drive_wapb_all(apb_transaction tr);
   `uvm_info("apb_driver", "Transaction From APB Master Driver..", UVM_MEDIUM)
   `uvm_info("apb_driver", "begin to WAPB_ALL", UVM_HIGH);
   @(posedge vapb.aclk);
   vapb.apb_sel    <= 1'b1;     
   vapb.apb_write  <= 1;
   vapb.apb_wdata  <= $random;
   vapb.apb_enable <= 1;
   vapb.apb_addr   <= 'd0 ;
          
          while(1) begin
             @(posedge vapb.aclk);	   
	     if(vapb.apb_enable && vapb.apb_ready) begin
			if (vapb.apb_addr=='d4) begin
				vapb.apb_enable <= 0;
                 		vapb.apb_write <= 0;
				break;
			end
			else begin
				vapb.apb_addr   <= vapb.apb_addr  + 'd1 ;
				vapb.apb_wdata  <= $random;
			end
             end
	   end
          @(posedge vapb.aclk);
    	  vapb.apb_sel <= 1'b0;  
   `uvm_info("apb_driver", "end WAPB_ALL", UVM_HIGH);
endtask


task apb_driver::drive_rapb_all(apb_transaction tr);
   `uvm_info("apb_driver", "Transaction From APB Master Driver..", UVM_MEDIUM)
   `uvm_info("apb_driver", "begin to RAPB_ALL", UVM_HIGH);
    @(posedge vapb.aclk);
    vapb.apb_sel    <= 1'b1;     
    vapb.apb_write  <= 'd0;
    //vapb.apb_wdata  <= $random;
    vapb.apb_enable <= 1;
    vapb.apb_addr   <= 'd0 ;
          
    while(1) begin
       @(posedge vapb.aclk);	   
       if(vapb.apb_enable && vapb.apb_ready) begin
	       if (vapb.apb_addr=='d5) begin
		       break ;
	       end
               else    vapb.apb_addr   <= vapb.apb_addr + 1'd1 ;
       end
     end
    @(posedge vapb.aclk);
    vapb.apb_sel <= 1'b0;  
    vapb.apb_enable <= 1'b0;  
   `uvm_info("apb_driver", "end RAPB_ALL", UVM_HIGH);
endtask


task apb_driver::drive_wrapb_all(apb_transaction tr);
   `uvm_info("apb_driver", "Transaction From APB Master Driver..", UVM_MEDIUM)
   `uvm_info("apb_driver", "begin to WRAPB_ALL", UVM_HIGH);
   @(posedge vapb.aclk);
   vapb.apb_sel    <= 1'b1;     
   vapb.apb_write  <= 1;
   vapb.apb_wdata  <= $random;
   vapb.apb_enable <= 1;
   vapb.apb_addr   <= 'd0 ;
          
   while(1) begin
      @(posedge vapb.aclk);	   
      if(vapb.apb_enable && vapb.apb_ready) begin
         	if (vapb.apb_addr=='d4) begin
         		vapb.apb_enable <= 0;
          		vapb.apb_write <= 0;
         		break;
         	end
         	else begin
         		vapb.apb_addr   <= vapb.apb_addr  + 'd1 ;
			vapb.apb_wdata  <= $random;
         	end
      end
    end
   @(posedge vapb.aclk);
   vapb.apb_sel <= 1'b0;  
    @(posedge vapb.aclk);
    vapb.apb_sel    <= 1'b1;     
    vapb.apb_write  <= 'd0;
    //vapb.apb_wdata  <= $random;
    vapb.apb_enable <= 1;
    vapb.apb_addr   <= 'd0 ;
          
    while(1) begin
       @(posedge vapb.aclk);	   
       if(vapb.apb_enable && vapb.apb_ready) begin
	       if (vapb.apb_addr=='d4) begin
		       break ;
	       end
               else    vapb.apb_addr   <= vapb.apb_addr + 1'd1 ;
       end
     end
    @(posedge vapb.aclk);
    vapb.apb_sel <= 1'b0;  
    vapb.apb_enable <= 1'b0;  
   `uvm_info("apb_driver", "end WRAPB_ALL", UVM_HIGH);
endtask



task apb_driver::drive_wrapb_one(apb_transaction tr);
   `uvm_info("apb_driver", "Transaction From APB Master Driver..", UVM_MEDIUM)
   `uvm_info("apb_driver", "begin to drive one apb", UVM_HIGH);
    @(posedge vapb.aclk);
    vapb.apb_sel <= 1'b1;     
    if(tr.apb_rd_wr == apb_transaction::APB_READ)
        vapb.apb_write <= 0;
    else
    begin
        vapb.apb_write <= 1;
        vapb.apb_wdata <=  tr.apb_wdata; //$random;
    end

    vapb.apb_enable <= 1;
    vapb.apb_addr <=  tr.apb_addr ;//(tr.apb_addr%5);
    
    @(posedge vapb.aclk);	   
    wait(vapb.apb_enable && vapb.apb_ready);
    vapb.apb_enable <= 0;
    vapb.apb_write <= 0;
    @(posedge vapb.aclk);
    @(posedge vapb.aclk);
    vapb.apb_sel <= 1'b0;  
   `uvm_info("apb_driver", "end drive one apb", UVM_HIGH);
endtask





`endif
