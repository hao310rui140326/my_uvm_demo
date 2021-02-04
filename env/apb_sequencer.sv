`ifndef APB_SEQUENCER__SV
`define APB_SEQUENCER__SV

class apb_sequencer extends uvm_sequencer #(apb_transaction);
   
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction 
   
   `uvm_component_utils(apb_sequencer)
endclass

`endif
