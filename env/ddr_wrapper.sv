module ddr_wrapper(/*AUTOARG*/
   // Outputs
   pll_lock, debug_data, debug_calib_ctrl, ddrphy_cpd_lock,
   ddr_init_done, core_clk, axi_wusero_last, axi_wusero_id,
   axi_wready, axi_rvalid, axi_rlast, axi_rid, axi_rdata, axi_awready,
   axi_arready, apb_ready, apb_rdata,
   // Inputs
   resetn, ref_clk, axi_wstrb, axi_wdata, axi_awvalid, axi_awuser_id,
   axi_awuser_ap, axi_awlen, axi_awaddr, axi_arvalid, axi_aruser_id,
   axi_aruser_ap, axi_arlen, axi_araddr, apb_write, apb_wdata,
   apb_sel, apb_rst_n, apb_enable, apb_clk, apb_addr
   );

  parameter MEM_ROW_ADDR_WIDTH   = 15         ;
  parameter MEM_COL_ADDR_WIDTH   = 10         ;
  parameter MEM_BADDR_WIDTH      = 3          ;
  parameter MEM_DQ_WIDTH         =  32        ;
  parameter MEM_DQS_WIDTH        =  32/8      ;
  parameter CTRL_ADDR_WIDTH = MEM_ROW_ADDR_WIDTH + MEM_BADDR_WIDTH + MEM_COL_ADDR_WIDTH;
  parameter TH_1S = 27'd33000000;

`ifdef SIMULATION
parameter MEM_SPACE_AW = 13; //to reduce simulation time
`else
parameter MEM_SPACE_AW = CTRL_ADDR_WIDTH;
`endif

/*AUTOINPUT*/
// Beginning of automatic inputs (from unused autoinst inputs)
input [7:0]		apb_addr;		// To u_ddr3_ctrl of ddr3.v
input			apb_clk;		// To u_ddr3_ctrl of ddr3.v
input			apb_enable;		// To u_ddr3_ctrl of ddr3.v
input			apb_rst_n;		// To u_ddr3_ctrl of ddr3.v
input			apb_sel;		// To u_ddr3_ctrl of ddr3.v
input [15:0]		apb_wdata;		// To u_ddr3_ctrl of ddr3.v
input			apb_write;		// To u_ddr3_ctrl of ddr3.v
input [CTRL_ADDR_WIDTH-1:0] axi_araddr;		// To u_ddr3_ctrl of ddr3.v
input [3:0]		axi_arlen;		// To u_ddr3_ctrl of ddr3.v
input			axi_aruser_ap;		// To u_ddr3_ctrl of ddr3.v
input [3:0]		axi_aruser_id;		// To u_ddr3_ctrl of ddr3.v
input			axi_arvalid;		// To u_ddr3_ctrl of ddr3.v
input [CTRL_ADDR_WIDTH-1:0] axi_awaddr;		// To u_ddr3_ctrl of ddr3.v
input [3:0]		axi_awlen;		// To u_ddr3_ctrl of ddr3.v
input			axi_awuser_ap;		// To u_ddr3_ctrl of ddr3.v
input [3:0]		axi_awuser_id;		// To u_ddr3_ctrl of ddr3.v
input			axi_awvalid;		// To u_ddr3_ctrl of ddr3.v
input [MEM_DQ_WIDTH*8-1:0] axi_wdata;		// To u_ddr3_ctrl of ddr3.v
input [MEM_DQ_WIDTH*8/8-1:0] axi_wstrb;		// To u_ddr3_ctrl of ddr3.v
input			ref_clk;		// To u_ddr3_ctrl of ddr3.v
input			resetn;			// To u_ddr3_ctrl of ddr3.v
// End of automatics
/*AUTOOUTPUT*/
// Beginning of automatic outputs (from unused autoinst outputs)
output [15:0]		apb_rdata;		// From u_ddr3_ctrl of ddr3.v
output			apb_ready;		// From u_ddr3_ctrl of ddr3.v
output			axi_arready;		// From u_ddr3_ctrl of ddr3.v
output			axi_awready;		// From u_ddr3_ctrl of ddr3.v
output [MEM_DQ_WIDTH*8-1:0] axi_rdata;		// From u_ddr3_ctrl of ddr3.v
output [3:0]		axi_rid;		// From u_ddr3_ctrl of ddr3.v
output			axi_rlast;		// From u_ddr3_ctrl of ddr3.v
output			axi_rvalid;		// From u_ddr3_ctrl of ddr3.v
output			axi_wready;		// From u_ddr3_ctrl of ddr3.v
output [3:0]		axi_wusero_id;		// From u_ddr3_ctrl of ddr3.v
output			axi_wusero_last;	// From u_ddr3_ctrl of ddr3.v
output			core_clk;		// From u_ddr3_ctrl of ddr3.v
output			ddr_init_done;		// From u_ddr3_ctrl of ddr3.v
output			ddrphy_cpd_lock;	// From u_ddr3_ctrl of ddr3.v
output [29:0]		debug_calib_ctrl;	// From u_ddr3_ctrl of ddr3.v
output [66*MEM_DQS_WIDTH-1:0] debug_data;	// From u_ddr3_ctrl of ddr3.v
output			pll_lock;		// From u_ddr3_ctrl of ddr3.v
// End of automatics
/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
wire [MEM_ROW_ADDR_WIDTH-1:0] mem_a;		// From u_ddr3_ctrl of ddr3.v
wire [MEM_BADDR_WIDTH-1:0] mem_ba;		// From u_ddr3_ctrl of ddr3.v
wire			mem_cas_n;		// From u_ddr3_ctrl of ddr3.v
wire			mem_ck;			// From u_ddr3_ctrl of ddr3.v
wire			mem_ck_n;		// From u_ddr3_ctrl of ddr3.v
wire			mem_cke;		// From u_ddr3_ctrl of ddr3.v
wire			mem_cs_n;		// From u_ddr3_ctrl of ddr3.v
wire [MEM_DQS_WIDTH-1:0] mem_dm;		// From u_ddr3_ctrl of ddr3.v
wire [MEM_DQ_WIDTH-1:0]	mem_dq;			// To/From u_ddr3_ctrl of ddr3.v, ...
wire [MEM_DQS_WIDTH-1:0] mem_dqs;		// To/From u_ddr3_ctrl of ddr3.v, ...
wire [MEM_DQS_WIDTH-1:0] mem_dqs_n;		// To/From u_ddr3_ctrl of ddr3.v, ...
wire			mem_odt;		// From u_ddr3_ctrl of ddr3.v
wire			mem_ras_n;		// From u_ddr3_ctrl of ddr3.v
wire			mem_rst_n;		// From u_ddr3_ctrl of ddr3.v
wire			mem_we_n;		// From u_ddr3_ctrl of ddr3.v
// End of automatics

ddr3 #(
   .MEM_ROW_ADDR_WIDTH (MEM_ROW_ADDR_WIDTH),
   .MEM_COL_ADDR_WIDTH (MEM_COL_ADDR_WIDTH),
   .MEM_BADDR_WIDTH    (MEM_BADDR_WIDTH),
   .MEM_DQ_WIDTH       (MEM_DQ_WIDTH),
   .MEM_DM_WIDTH       (MEM_DQS_WIDTH),
   .MEM_DQS_WIDTH      (MEM_DQS_WIDTH),
   .CTRL_ADDR_WIDTH    (CTRL_ADDR_WIDTH)
  )u_ddr3_ctrl(
	/*AUTOINST*/
	       // Outputs
	       .ddr_init_done		(ddr_init_done),
	       .core_clk		(core_clk),
	       .pll_lock		(pll_lock),
	       .ddrphy_cpd_lock		(ddrphy_cpd_lock),
	       .axi_awready		(axi_awready),
	       .axi_wready		(axi_wready),
	       .axi_wusero_id		(axi_wusero_id[3:0]),
	       .axi_wusero_last		(axi_wusero_last),
	       .axi_arready		(axi_arready),
	       .axi_rdata		(axi_rdata[MEM_DQ_WIDTH*8-1:0]),
	       .axi_rid			(axi_rid[3:0]),
	       .axi_rlast		(axi_rlast),
	       .axi_rvalid		(axi_rvalid),
	       .apb_ready		(apb_ready),
	       .apb_rdata		(apb_rdata[15:0]),
	       .debug_calib_ctrl	(debug_calib_ctrl[29:0]),
	       .debug_data		(debug_data[66*MEM_DQS_WIDTH-1:0]),
	       .mem_rst_n		(mem_rst_n),
	       .mem_ck			(mem_ck),
	       .mem_ck_n		(mem_ck_n),
	       .mem_cke			(mem_cke),
	       .mem_cs_n		(mem_cs_n),
	       .mem_ras_n		(mem_ras_n),
	       .mem_cas_n		(mem_cas_n),
	       .mem_we_n		(mem_we_n),
	       .mem_odt			(mem_odt),
	       .mem_a			(mem_a[MEM_ROW_ADDR_WIDTH-1:0]),
	       .mem_ba			(mem_ba[MEM_BADDR_WIDTH-1:0]),
	       .mem_dm			(mem_dm[MEM_DQS_WIDTH-1:0]),
	       // Inouts
	       .mem_dqs			(mem_dqs[MEM_DQS_WIDTH-1:0]),
	       .mem_dqs_n		(mem_dqs_n[MEM_DQS_WIDTH-1:0]),
	       .mem_dq			(mem_dq[MEM_DQ_WIDTH-1:0]),
	       // Inputs
	       .ref_clk			(ref_clk),
	       .resetn			(resetn),
	       .axi_awaddr		(axi_awaddr[CTRL_ADDR_WIDTH-1:0]),
	       .axi_awuser_ap		(axi_awuser_ap),
	       .axi_awuser_id		(axi_awuser_id[3:0]),
	       .axi_awlen		(axi_awlen[3:0]),
	       .axi_awvalid		(axi_awvalid),
	       .axi_wdata		(axi_wdata[MEM_DQ_WIDTH*8-1:0]),
	       .axi_wstrb		(axi_wstrb[MEM_DQ_WIDTH*8/8-1:0]),
	       .axi_araddr		(axi_araddr[CTRL_ADDR_WIDTH-1:0]),
	       .axi_aruser_ap		(axi_aruser_ap),
	       .axi_aruser_id		(axi_aruser_id[3:0]),
	       .axi_arlen		(axi_arlen[3:0]),
	       .axi_arvalid		(axi_arvalid),
	       .apb_clk			(apb_clk),
	       .apb_rst_n		(apb_rst_n),
	       .apb_sel			(apb_sel),
	       .apb_enable		(apb_enable),
	       .apb_addr		(apb_addr[7:0]),
	       .apb_write		(apb_write),
	       .apb_wdata		(apb_wdata[15:0]));

ddr3_model #(
		.MEM_DM_WIDTH       (MEM_DQS_WIDTH)	
	)u_ddr3_model(/*AUTOINST*/
		      // Inouts
		      .mem_dqs		(mem_dqs[MEM_DQS_WIDTH-1:0]),
		      .mem_dqs_n	(mem_dqs_n[MEM_DQS_WIDTH-1:0]),
		      .mem_dq		(mem_dq[MEM_DQ_WIDTH-1:0]),
		      // Inputs
		      .mem_rst_n	(mem_rst_n),
		      .mem_ck		(mem_ck),
		      .mem_ck_n		(mem_ck_n),
		      .mem_cke		(mem_cke),
		      .mem_cs_n		(mem_cs_n),
		      .mem_ras_n	(mem_ras_n),
		      .mem_cas_n	(mem_cas_n),
		      .mem_we_n		(mem_we_n),
		      .mem_odt		(mem_odt),
		      .mem_a		(mem_a[MEM_ROW_ADDR_WIDTH-1:0]),
		      .mem_ba		(mem_ba[MEM_BADDR_WIDTH-1:0]),
		      .mem_dm		(mem_dm[MEM_DQS_WIDTH-1:0]));



// Local Variables:                                                                 
// verilog-auto-inst-param-value:t                                                  
// End:           

endmodule

