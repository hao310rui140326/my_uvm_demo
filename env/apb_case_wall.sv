`ifndef APB_CASE_WALL__SV
`define APB_CASE_WALL__SV
class apb_case_wall_sequence extends uvm_sequence #(apb_transaction);
   apb_transaction m_trans;

   function  new(string name= "apb_case_wall_sequence");
      super.new(name);
   endfunction 
   
   virtual task body();
      if(starting_phase != null) 
         starting_phase.raise_objection(this);
      repeat (5) begin
         //`uvm_do(m_trans);
         `uvm_do_with(m_trans,{apb_enable == 1'b1;apb_rd_wr == apb_transaction::APB_RALL;}  )
      end
      #100;
      if(starting_phase != null) 
         starting_phase.drop_objection(this);
   endtask

   `uvm_object_utils(apb_case_wall_sequence)
endclass


class apb_case_wall extends base_test;

   function new(string name = "apb_case_wall", uvm_component parent = null);
      super.new(name,parent);
   endfunction 
   extern virtual function void build_phase(uvm_phase phase); 
   `uvm_component_utils(apb_case_wall)
endclass


function void apb_case_wall::build_phase(uvm_phase phase);
   super.build_phase(phase);

   uvm_config_db#(uvm_object_wrapper)::set(this, 
                                           "env.apb_sqr.main_phase", 
                                           "default_sequence", 
                                           apb_case_wall_sequence::type_id::get());
endfunction

`endif
