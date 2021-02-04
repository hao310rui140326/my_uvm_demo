module ddr3_model(/*AUTOARG*/
   // Inouts
   mem_dqs, mem_dqs_n, mem_dq,
   // Inputs
   mem_rst_n, mem_ck, mem_ck_n, mem_cke, mem_cs_n, mem_ras_n,
   mem_cas_n, mem_we_n, mem_odt, mem_a, mem_ba, mem_dm
   );

`include "ddr3_parameters.vh"

   parameter MEM_ROW_ADDR_WIDTH   = 15          ; 
   parameter MEM_COL_ADDR_WIDTH   = 10          ; 
   parameter MEM_BADDR_WIDTH      = 3           ; 
   parameter MEM_DQ_WIDTH         =  32         ; 
   parameter MEM_DM_WIDTH         =  32/8       ; 
   parameter MEM_DQS_WIDTH        =  32/8       ; 
   parameter CTRL_ADDR_WIDTH     = MEM_ROW_ADDR_WIDTH + MEM_COL_ADDR_WIDTH + MEM_BADDR_WIDTH    ;    

   parameter MEM_ADDR_WIDTH = MEM_ROW_ADDR_WIDTH ;

   input                             mem_rst_n            ;                       
   input                             mem_ck               ;
   input                             mem_ck_n             ;
   input                             mem_cke              ;
   input                             mem_cs_n             ;
   input                             mem_ras_n            ;
   input                             mem_cas_n            ;
   input                             mem_we_n             ; 
   input                             mem_odt              ;
   input [MEM_ROW_ADDR_WIDTH-1:0]    mem_a                ;   
   input [MEM_BADDR_WIDTH-1:0]       mem_ba               ;   
   inout [MEM_DQS_WIDTH-1:0]         mem_dqs              ;
   inout [MEM_DQS_WIDTH-1:0]         mem_dqs_n            ;
   inout [MEM_DQ_WIDTH-1:0]          mem_dq               ;
   input [MEM_DM_WIDTH-1:0]          mem_dm               ;

reg [MEM_DQS_WIDTH:0] mem_ck_dly;
reg [MEM_DQS_WIDTH:0] mem_ck_n_dly;

wire [ADDR_BITS-1:0] mem_addr;

always @ (*) begin
    mem_ck_dly[0] <=  mem_ck;
    mem_ck_n_dly[0] <=  mem_ck_n;
end

assign mem_addr = {{(ADDR_BITS-MEM_ADDR_WIDTH){1'b0}},{mem_a}};

genvar gen_mem;                                                    
generate                                                         
	for(gen_mem=0; gen_mem<MEM_DQS_WIDTH; gen_mem=gen_mem+1) begin   : i_mem 
		always @ (*) begin
		    mem_ck_dly[gen_mem+1] <= #0.05 mem_ck_dly[gen_mem];
		    mem_ck_n_dly[gen_mem+1] <= #0.05 mem_ck_n_dly[gen_mem];
		end
		
		ddr3_m     mem_core (
		
		    .rst_n                           (mem_rst_n  ),
		    .ck                              (mem_ck_dly[gen_mem+1] ),
		    .ck_n                            (mem_ck_n_dly[gen_mem+1] ),
		    .cs_n                            (mem_cs_n  ),
		//    .addr                            (pad_addr_ch0[ADDR_BITS-1:0]  ),
		    .addr                            (mem_addr  ),
		    .dq                              (mem_dq[8*gen_mem+7:8*gen_mem]),
		    .dqs                             (mem_dqs[gen_mem]  ),
		    .dqs_n                           (mem_dqs_n[gen_mem] ),
		    .dm_tdqs                         (mem_dm[gen_mem]  ),
		    .tdqs_n                          (  ),
		    .cke                             (mem_cke  ),
		    .odt                             (mem_odt  ),
		    .ras_n                           (mem_ras_n  ),
		    .cas_n                           (mem_cas_n  ),
		    .we_n                            (mem_we_n  ),
		    .ba                              (mem_ba  )
		);
	end     
endgenerate







endmodule



