`ifndef AXI_SEQUENCER__SV
`define AXI_SEQUENCER__SV

class axi_sequencer extends uvm_sequencer #(axi_transaction);
   
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction 
   
   `uvm_component_utils(axi_sequencer)
endclass

`endif
