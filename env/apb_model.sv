`ifndef APB_MODEL__SV
`define APB_MODEL__SV

class apb_model extends uvm_component;
  
   virtual tvip_reg_if vreg;

//   uvm_blocking_get_port #(apb_transaction)  port;
   uvm_analysis_port #(apb_transaction)  ap;

   extern function new(string name, uvm_component parent);
   extern function void build_phase(uvm_phase phase);
   extern virtual  task main_phase(uvm_phase phase);

   `uvm_component_utils(apb_model)
endclass 

function apb_model::new(string name, uvm_component parent);
   super.new(name, parent);
endfunction 

function void apb_model::build_phase(uvm_phase phase);
   super.build_phase(phase);
   //port = new("port", this);
   ap = new("ap", this);
   if(!uvm_config_db#(virtual tvip_reg_if)::get(this, "", "vreg", vreg))
         `uvm_fatal("apb_model", "virtual interface must be set for vreg!!!")
endfunction

task apb_model::main_phase(uvm_phase phase);
   //apb_transaction tr;
   apb_transaction new_tr;
   super.main_phase(phase);
   new_tr = new("new_tr");   
   while(1) begin
      //port.get(tr);
      //new_tr = new("new_tr");
      //new_tr.copy(tr);
      @( posedge vreg.aclk)
      if (vreg.reg_vld) begin
	new_tr.apb_enable = 1;
	new_tr.apb_addr   = vreg.reg_raddr; 
	new_tr.apb_rdata  = vreg.reg_rdata;
        new_tr.apb_rd_wr  =  apb_transaction::APB_READ ;	
         //`uvm_info("apb_model", "get one transaction, copy and print it:", UVM_HIGH)
         `uvm_info("apb_model", "get one transaction from apb model, print it:", UVM_HIGH)
         `ifdef UVM_HIGH
         	new_tr.print();
         `endif
         ap.write(new_tr);
      end
   end
endtask
`endif
