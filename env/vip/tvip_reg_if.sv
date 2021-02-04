`ifndef TVIP_REG_IF_SV
`define TVIP_REG_IF_SV
interface tvip_reg_if (
  input bit aclk,
  input bit areset_n
);

 bit  [15:0]                       reg_rdata     ; 
 bit  [ 7:0]                       reg_raddr     ; 
 bit                               reg_vld       ; 

endinterface
`endif
