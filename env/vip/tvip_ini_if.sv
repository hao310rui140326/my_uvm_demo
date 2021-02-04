`ifndef TVIP_INI_IF_SV
`define TVIP_INI_IF_SV
interface tvip_ini_if (
  input bit aclk,
  input bit areset_n
);

   bit                                ini_done         ; 
   bit                                ini_phy_lock     ; 
   bit                                ini_pll_lock     ; 
endinterface
`endif
