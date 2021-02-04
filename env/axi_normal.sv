`ifndef AXI_NORMAL__SV
`define AXI_NORMAL__SV
class axi_normal_sequence extends uvm_sequence #(axi_transaction);
   axi_transaction m_trans;

   function  new(string name= "axi_normal_sequence");
      super.new(name);
   endfunction 
   
   virtual task body();
      if(starting_phase != null) 
         starting_phase.raise_objection(this);
      repeat (20) begin
         //`uvm_do(m_trans);
         `uvm_do_with(m_trans,{axi_enable == 1'b1;axi_write==1'b1;axi_len=='d15;}  )
      end
      #100;
      if(starting_phase != null) 
         starting_phase.drop_objection(this);
   endtask

   `uvm_object_utils(axi_normal_sequence)
endclass


class axi_normal extends base_test;

   function new(string name = "axi_normal", uvm_component parent = null);
      super.new(name,parent);
   endfunction 
   extern virtual function void build_phase(uvm_phase phase); 
   `uvm_component_utils(axi_normal)
endclass


function void axi_normal::build_phase(uvm_phase phase);
   super.build_phase(phase);

   uvm_config_db#(uvm_object_wrapper)::set(this, 
                                           "env.axi_sqr.main_phase", 
                                           "default_sequence", 
                                           axi_normal_sequence::type_id::get());
endfunction

`endif
