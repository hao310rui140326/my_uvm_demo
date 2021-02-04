module assoc_mem(
clk  ,
rst_n,
wen  ,
wdin ,
wb   ,
ren  ,
waddr ,
raddr ,
rvld  ,
rdout
);

 parameter MEM_ROW_ADDR_WIDTH   = 15         ;
 parameter MEM_COL_ADDR_WIDTH   = 10         ;
 parameter MEM_BADDR_WIDTH      = 3          ;
 parameter MEM_DQ_WIDTH         =  32        ;
 parameter MEM_DM_WIDTH         =  32/8      ;
 parameter MEM_DQS_WIDTH        =  32/8      ;
 parameter CTRL_ADDR_WIDTH     = MEM_ROW_ADDR_WIDTH + MEM_COL_ADDR_WIDTH + MEM_BADDR_WIDTH        ;

input         clk   ;
input         rst_n ;

input         wen   ;
input         ren   ;
input  [  MEM_DQ_WIDTH*8-1:0] wdin   ;
input  [MEM_DQ_WIDTH*8/8-1:0] wb     ;
input  [ CTRL_ADDR_WIDTH-1:0] waddr  ;
input  [ CTRL_ADDR_WIDTH-1:0] raddr  ;
output [  MEM_DQ_WIDTH*8-1:0] rdout  ;
output                        rvld   ;
////////////////////////////////////////////////////
reg    [  MEM_DQ_WIDTH*8-1:0] rdout  ;
reg                           rvld   ;
reg    [31:0]                 rvld_cnt   ;
////////////////////////////////////////////////////

//bit [ MEM_DQ_WIDTH*8-1:0]  assoc[bit[63:0]],idx=1;
bit [ MEM_DQ_WIDTH*8-1:0]  assoc[bit[CTRL_ADDR_WIDTH-1:0]];
//bit [ MEM_DQ_WIDTH*8-1:0]  assoc[4096];

bit [ MEM_DQ_WIDTH*8-1:0]  assoc_mem;

always @(*)
begin
	assoc_mem = assoc[waddr];
	for (int i=0;i<MEM_DQ_WIDTH*8/8;i++) begin
		if (wen&&wb[i])	assoc_mem[i*8+:8] = wdin[i*8+:8];
	end
end


always @ (posedge clk or negedge rst_n)
begin
	if (wen) begin
		//assoc[waddr]<=wdin;
		//$display("The array now has %0d elements",assoc.num);
		//for (int i=0;i<MEM_DQ_WIDTH*8/8;i++) begin
			//if (wb[i])	assoc[waddr][i*8+:8]<=wdin[i*8+:8];
		//end
		assoc[waddr]<=assoc_mem;
		//$display("The array now has  welements: %h-----%h",waddr,assoc_mem);

		//if (waddr>1024)    $finish;		
	end
end

always @ (posedge clk or negedge rst_n)
begin
	if (ren) begin
		rdout<=assoc[raddr];
		//$display("The array now has relements: %h-----%h",raddr,assoc[raddr]);						
	end
end


always @ (posedge clk or negedge rst_n)
begin
	rvld <= ren ; 
end

//rvld_cnt
always @ (posedge clk or negedge rst_n)
begin
	if (~rst_n) begin
		rvld_cnt <= 'd0 ;
	end
	else if (rvld) begin
		rvld_cnt <= rvld_cnt + 'd1 ;
	end
end


endmodule



