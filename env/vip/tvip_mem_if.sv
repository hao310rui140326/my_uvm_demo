`ifndef TVIP_MEM_IF_SV
`define TVIP_MEM_IF_SV
interface tvip_mem_if (
  input bit aclk,
  input bit areset_n
);
  parameter MEM_ROW_ADDR_WIDTH   = 15         ;
  parameter MEM_COL_ADDR_WIDTH   = 10         ;
  parameter MEM_BADDR_WIDTH      = 3          ;
  parameter MEM_DQ_WIDTH         =  32        ;
  parameter MEM_DQS_WIDTH        =  32/8      ;
  parameter CTRL_ADDR_WIDTH = MEM_ROW_ADDR_WIDTH + MEM_BADDR_WIDTH + MEM_COL_ADDR_WIDTH;

bit            we   ;
bit            re   ;
bit     [  MEM_DQ_WIDTH*8-1:0] wdata  ;
bit     [MEM_DQ_WIDTH*8/8-1:0] wb     ;
bit     [ CTRL_ADDR_WIDTH-1:0] waddr  ;
bit     [ CTRL_ADDR_WIDTH-1:0] raddr  ;
bit                            rvld   ;
bit     [  MEM_DQ_WIDTH*8-1:0] rdout  ;

endinterface
`endif
