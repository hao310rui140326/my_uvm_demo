`ifndef APB_SCOREBOARD__SV
`define APB_SCOREBOARD__SV
class apb_scoreboard extends uvm_scoreboard;
   apb_transaction  expect_queue[$];
   apb_transaction  actual_queue[$];
   uvm_blocking_get_port #(apb_transaction)  exp_port;
   uvm_blocking_get_port #(apb_transaction)  act_port;
   `uvm_component_utils(apb_scoreboard)

   extern function new(string name, uvm_component parent = null);
   extern virtual function void build_phase(uvm_phase phase);
   extern virtual task main_phase(uvm_phase phase);
endclass 

function apb_scoreboard::new(string name, uvm_component parent = null);
   super.new(name, parent);
endfunction 

function void apb_scoreboard::build_phase(uvm_phase phase);
   super.build_phase(phase);
   exp_port = new("exp_port", this);
   act_port = new("act_port", this);
endfunction 

task apb_scoreboard::main_phase(uvm_phase phase);
   apb_transaction  get_expect,  get_actual, tmp_tran , tmp_actual;
   bit result;
 
   super.main_phase(phase);
   fork 
      while (1) begin
         exp_port.get(get_expect);
         expect_queue.push_back(get_expect);
      end
      while (1) begin
         act_port.get(get_actual);
         actual_queue.push_back(get_actual);
         if ((expect_queue.size() > 0) &&(actual_queue.size() > 0))begin
            tmp_tran   = expect_queue.pop_front();
            tmp_actual = actual_queue.pop_front();
	    //if (tmp_actual.apb_addr=='d5) begin
		//tmp_tran.apb_rdata=tmp_actual.apb_rdata;
	    //end
            result = tmp_actual.compare(tmp_tran);
            if(result) begin 
               `uvm_info("apb_scoreboard","Compare SUCCESSFULLY", UVM_LOW);
	       //`ifdef UVM_HIGH
               		tmp_actual.print();
		//`endif
	       if (tmp_actual.apb_addr=='h5) begin
		       if      (tmp_actual.apb_rdata[15]             )  begin  `uvm_info("apb_scoreboard","DDR3  CHANGE_MODE  BUSY  !!!!", UVM_LOW)   end 
		       if      (tmp_actual.apb_rdata[1:0]==2'b00     )  begin  `uvm_info("apb_scoreboard","DDR3  under normal state !!!!", UVM_LOW)   end 
		       if      (tmp_actual.apb_rdata[1:0]==2'b01     )  begin  `uvm_info("apb_scoreboard","DDR3  under mrs    state !!!!", UVM_LOW)   end 
		       if      (tmp_actual.apb_rdata[1:0]==2'b10     )  begin  `uvm_info("apb_scoreboard","DDR3  under sr     state !!!!", UVM_LOW)   end 
		       if      (tmp_actual.apb_rdata[1:0]==2'b11     )  begin  `uvm_info("apb_scoreboard","DDR3  under pd     state !!!!", UVM_LOW)   end 
	       end
            end
            else begin
		    if (tmp_actual.apb_addr=='d5) begin
                          //`uvm_info("apb_scoreboard","Bypass the compare of  mode state  reg ", UVM_LOW);
		    end
		    else begin 
                          `uvm_error("apb_scoreboard", "Compare FAILED");
                          $display("the expect pkt is");
                          tmp_tran.print();
                          $display("the actual pkt is");
                          tmp_actual.print();
       		    end
            end
         end
      end
   join
endtask
`endif
