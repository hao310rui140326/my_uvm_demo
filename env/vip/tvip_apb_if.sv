`ifndef TVIP_APB_IF_SV
`define TVIP_APB_IF_SV
interface tvip_apb_if (
  input bit aclk,
  input bit areset_n
);

   bit                                apb_sel       ; 
   bit                                apb_enable    ; 
   logic [7:0]                        apb_addr      ; 
   bit                                apb_write     ; 
   bit                                apb_ready     ; 
   logic [15:0]                       apb_wdata     ; 
   logic [15:0]                       apb_rdata     ; 


endinterface
`endif
