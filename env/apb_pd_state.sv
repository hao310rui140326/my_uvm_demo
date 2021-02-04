`ifndef APB_PD_STATE__SV
`define APB_PD_STATE__SV
class apb_pd_state_sequence extends uvm_sequence #(apb_transaction);
   apb_transaction m_trans;

   function  new(string name= "apb_pd_state_sequence");
      super.new(name);
   endfunction 
   
   virtual task body();
      if(starting_phase != null) 
         starting_phase.raise_objection(this);

         `uvm_do_with(m_trans,{apb_enable == 1'b1;apb_addr==4;apb_wdata=='hc001;apb_rd_wr==apb_transaction::APB_WRITE;}  )	 
 	
      repeat (128) begin
         //`uvm_do(m_trans);
         `uvm_do_with(m_trans,{apb_enable == 1'b1;apb_addr==5;apb_wdata=='hc000;apb_rd_wr==apb_transaction::APB_READ;}  )	 
      end
      #100;
      if(starting_phase != null) 
         starting_phase.drop_objection(this);
   endtask

   `uvm_object_utils(apb_pd_state_sequence)
endclass


class apb_pd_state extends base_test;

   function new(string name = "apb_pd_state", uvm_component parent = null);
      super.new(name,parent);
   endfunction 
   extern virtual function void build_phase(uvm_phase phase); 
   `uvm_component_utils(apb_pd_state)
endclass


function void apb_pd_state::build_phase(uvm_phase phase);
   super.build_phase(phase);

   uvm_config_db#(uvm_object_wrapper)::set(this, 
                                           "env.apb_sqr.main_phase", 
                                           "default_sequence", 
                                           apb_pd_state_sequence::type_id::get());
endfunction

`endif
