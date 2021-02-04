`ifndef AXI_TRANSACTION__SV
`define AXI_TRANSACTION__SV

class axi_transaction extends uvm_sequence_item;

   rand bit                                 axi_enable     ; 
   rand bit                                 axi_write      ; 
   rand bit   [  3:0]                       axi_len        ; 
   rand bit   [ 27:0]                       axi_waddr      ; 
   rand bit   [ 27:0]                       axi_raddr      ; 
   rand bit   [255:0]                       axi_wdata      ; 
   rand bit   [255:0]                       axi_rdata      ; 
   rand bit   [ 15:0]                       axi_sim_cnt    ; 

    typedef enum{AXI_SEQ_ONE,AXI_RAND_ONE,AXI_SEQ_ALL,AXI_RAND_ALL} axi_rd_wr_e;
    rand axi_rd_wr_e axi_rd_wr ;
    //int unsigned axi_en_delay;
    `uvm_object_utils_begin(axi_transaction)
        `uvm_field_int(axi_enable, UVM_DEFAULT)
        `uvm_field_int(axi_write , UVM_DEFAULT)
        `uvm_field_int(axi_len   , UVM_DEFAULT)
        `uvm_field_int(axi_waddr , UVM_DEFAULT)
	`uvm_field_int(axi_raddr , UVM_DEFAULT)
        `uvm_field_int(axi_wdata , UVM_DEFAULT)
        `uvm_field_int(axi_rdata , UVM_DEFAULT)
        `uvm_field_int(axi_sim_cnt , UVM_DEFAULT)
        `uvm_field_enum(axi_rd_wr_e, axi_rd_wr, UVM_DEFAULT)	
    `uvm_object_utils_end

   function new(string name = "axi_transaction");
      super.new();
   endfunction
endclass
`endif
