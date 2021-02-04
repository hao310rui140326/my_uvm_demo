`ifndef APB_TRANSACTION__SV
`define APB_TRANSACTION__SV

class apb_transaction extends uvm_sequence_item;

   rand bit                                apb_enable    ; 
   rand bit   [7:0]                        apb_addr      ; 
   rand bit   [15:0]                       apb_wdata     ; 
   rand bit   [15:0]                       apb_rdata     ; 

    typedef enum{APB_READ, APB_WRITE,APB_RALL, APB_WALL,APB_WRALL} apb_rd_wr_e;
    rand apb_rd_wr_e apb_rd_wr ;
    int unsigned apb_en_delay;
    `uvm_object_utils_begin(apb_transaction)
        `uvm_field_int(apb_addr, UVM_DEFAULT)
        `uvm_field_int(apb_wdata, UVM_DEFAULT)
        `uvm_field_int(apb_rdata, UVM_DEFAULT)
        `uvm_field_int(apb_enable, UVM_DEFAULT)
        //`uvm_field_int(apb_ready, UVM_DEFAULT)
        `uvm_field_enum(apb_rd_wr_e, apb_rd_wr, UVM_DEFAULT)
        //`uvm_field_enum(apb_rd_wr_e, UVM_DEFAULT)

    `uvm_object_utils_end

   function new(string name = "apb_transaction");
      super.new();
   endfunction
endclass
`endif
