`ifndef AXI_SCOREBOARD__SV
`define AXI_SCOREBOARD__SV

typedef struct packed {
    logic [ 27:0]   raddr                  ; 
    logic [255:0]   rdata                  ; 
} r_winfo;

class axi_scoreboard extends uvm_scoreboard;
   
   uvm_blocking_get_port #(axi_transaction)  exp_port;
   uvm_blocking_get_port #(axi_transaction)  act_port;
   `uvm_component_utils(axi_scoreboard)

   extern function new(string name, uvm_component parent = null);
   extern virtual function void build_phase(uvm_phase phase);
   extern virtual task main_phase(uvm_phase phase);
endclass 

function axi_scoreboard::new(string name, uvm_component parent = null);
   super.new(name, parent);
endfunction 

function void axi_scoreboard::build_phase(uvm_phase phase);
   super.build_phase(phase);
   exp_port = new("exp_port", this);
   act_port = new("act_port", this);
endfunction 

task axi_scoreboard::main_phase(uvm_phase phase);
   axi_transaction  get_expect,  get_actual, tmp_tran , tmp_actual;
   bit result;
   //axi_transaction  expect_queue[$];
   //axi_transaction  actual_queue[$];
   
   r_winfo  expect_queue[$];
   r_winfo  actual_queue[$];

   r_winfo s_einfo  ;
   r_winfo s_ainfo  ;
   r_winfo r_einfo  ;
   r_winfo r_ainfo  ;

   get_expect = new("get_expect");
   get_actual = new("get_actual");
   tmp_tran   = new("tmp_tran  ");
   tmp_actual = new("tmp_actual");

   super.main_phase(phase);
   fork 
      while (1) begin
         exp_port.get(get_expect);
         `uvm_info("axi_scoreboard", "get_expect print", UVM_HIGH);
         //expect_queue.push_front(get_expect);
	 `ifdef UVM_HIGH
	 	get_expect.print();
 	 `endif
	 //foreach (expect_queue[i])
	 // 	expect_queue[i].print();

	 r_einfo.raddr = get_expect.axi_raddr;
	 r_einfo.rdata = get_expect.axi_rdata;
         expect_queue.push_front(r_einfo);
	 //foreach (expect_queue[i])
	 //	$display("expect_queue : %h , %h /n",expect_queue[i].raddr,expect_queue[i].rdata);

         
	//if ((expect_queue.size() > 0) && (actual_queue.size() > 0))begin
	if (actual_queue.size() > 0) begin
            s_einfo   = expect_queue.pop_back();
            s_ainfo   = actual_queue.pop_back();
	    
	    tmp_tran.axi_raddr = s_einfo.raddr  ;
            tmp_tran.axi_rdata = s_einfo.rdata  ;

	    tmp_actual.axi_raddr = s_ainfo.raddr  ;
            tmp_actual.axi_rdata = s_ainfo.rdata  ;


            result = tmp_actual.compare(tmp_tran);
            `uvm_info("axi_scoreboard", "expect_queue print", UVM_HIGH);
	    `ifdef UVM_HIGH
            	tmp_tran.print();
    	     `endif
            `uvm_info("axi_scoreboard", "actual_queue print", UVM_HIGH);
	    `ifdef UVM_HIGH
            	tmp_actual.print();
	    `endif 
            if(result) begin 
               `uvm_info("axi_scoreboard", "Compare SUCCESSFULLY", UVM_LOW);
		//$display("the expect pkt is");
               //tmp_tran.print();
               //$display("the actual pkt is");
               //tmp_actual.print();
            end
            else begin
               `uvm_error("axi_scoreboard", "Compare FAILED");
               $display("the expect pkt is");
               tmp_tran.print();
               $display("the actual pkt is");
               tmp_actual.print();
            end
         end
      end
      while (1) begin
         act_port.get(get_actual);
        // actual_queue.push_front(get_actual);
        `uvm_info("axi_scoreboard", "get_actual print", UVM_HIGH);
	`ifdef UVM_HIGH
            get_actual.print();
         `endif
	// foreach (actual_queue[i])
	//	actual_queue[i].print();

	 r_ainfo.raddr = get_actual.axi_raddr;
	 r_ainfo.rdata = get_actual.axi_rdata;
         actual_queue.push_front(r_ainfo);
	 //foreach (actual_queue[i])
	 //	$display("actual_queue  :  %h , %h  /n",actual_queue[i].raddr,actual_queue[i].rdata);	

      end

     //while (1) begin
     //    exp_port.get(tmp_tran);
     //    `uvm_info("axi_scoreboard", "get_expect print", UVM_LOW);
     //    tmp_tran.print();
     //    act_port.get(tmp_actual);
     //    `uvm_info("axi_scoreboard", "get_actual print", UVM_LOW);
     //    tmp_actual.print();
     //       result = tmp_actual.compare(tmp_tran);
     //       if(result) begin 
     //          `uvm_info("axi_scoreboard", "Compare SUCCESSFULLY", UVM_LOW);
     //       end
     //       else begin
     //          `uvm_error("axi_scoreboard", "Compare FAILED");
     //          $display("the expect pkt is");
     //          tmp_tran.print();
     //          $display("the actual pkt is");
     //          tmp_actual.print();
     //       end
     // end
   join
endtask
`endif
