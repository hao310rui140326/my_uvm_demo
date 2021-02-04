`timescale 1ns/1ps 


`include  "../../env/apb_transaction.sv"
`include  "../../env/axi_transaction.sv"
`include  "../../env/apb_driver.sv"
`include  "../../env/axi_driver.sv"
`include  "../../env/apb_monitor.sv"
`include  "../../env/axi_monitor.sv"
`include  "../../env/apb_model.sv"
`include  "../../env/axi_model.sv"
`include  "../../env/apb_scoreboard.sv"
`include  "../../env/axi_scoreboard.sv"
`include  "../../env/apb_sequencer.sv"
`include  "../../env/axi_sequencer.sv"
`include  "../../env/my_env.sv"
`include  "../../env/base_test.sv"
`include  "../../env/apb_case0.sv"
`include  "../../env/apb_pd_wone.sv"
`include  "../../env/apb_pd_state.sv"
`include  "../../env/apb_mrs_state.sv"
`include  "../../env/apb_sr_state.sv"
`include  "../../env/apb_case_rall.sv"
`include  "../../env/apb_case_wall.sv"
`include  "../../env/apb_case_wrall.sv"
`include  "../../env/axi_normal.sv"
`include  "../../env/axi_test.sv"


module tb_top(/*AUTOARG*/
   // Outputs
   debug_data, debug_calib_ctrl
   );

  parameter MEM_ROW_ADDR_WIDTH   = 15         ;
  parameter MEM_COL_ADDR_WIDTH   = 10         ;
  parameter MEM_BADDR_WIDTH      = 3          ;
  parameter MEM_DQ_WIDTH         =  32        ;
  parameter MEM_DQS_WIDTH        =  32/8      ;
  parameter CTRL_ADDR_WIDTH = MEM_ROW_ADDR_WIDTH + MEM_BADDR_WIDTH + MEM_COL_ADDR_WIDTH;
  parameter TH_1S = 27'd33000000;

/*AUTOINPUT*/
/*AUTOOUTPUT*/
// Beginning of automatic outputs (from unused autoinst outputs)
output [29:0]		debug_calib_ctrl;	// From u_ddr_wrapper of ddr_wrapper.v
output [66*MEM_DQS_WIDTH-1:0] debug_data;	// From u_ddr_wrapper of ddr_wrapper.v
// End of automatics
/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
wire			core_clk;		// From u_ddr_wrapper of ddr_wrapper.v
wire			ref_clk;		// From u_clk_gen of clk_gen.v
wire			rst_n;			// From u_rst_gen of rst_gen.v
// End of automatics

`include "ddr3_parameters.vh"

 tvip_reg_if   areg(ref_clk,rst_n);
 tvip_apb_if   apbd(ref_clk,rst_n);
 tvip_axi_if   axid(core_clk,rst_n);
 tvip_ini_if   inid(ref_clk,rst_n);
 tvip_mem_if   memd(core_clk,rst_n);


/*ddr3_reg AUTO_TEMPLATE(
      .aclk          		(ref_clk),
      .areset_n      		(rst_n),
      .apb_addr			(apbd.apb_addr[7:0]),
      .apb_enable		(apbd.apb_enable),
      .apb_sel			(apbd.apb_sel),
      .apb_wdata		(apbd.apb_wdata[15:0]),
      .apb_write		(apbd.apb_write),
      .apb_rdata		(apbd.apb_rdata[15:0]),
      .apb_ready		(apbd.apb_ready),
      .reg_rdata     		(areg.rdata),
      .reg_vld       		(areg.vld  ),
      .reg_raddr       		(areg.raddr  )
);*/

/*ddr_wrapper  AUTO_TEMPLATE(
    .resetn		(rst_n), 
    .apb_clk		(ref_clk),	 
    .apb_rst_n		(rst_n),	 

    .axi_awaddr     (axid.awaddr),            
    .axi_awuser_ap  (1'd0),
    .axi_awuser_id  (axid.awid),
    .axi_awlen      (axid.awlen),
    .axi_awready    (axid.awready),
    .axi_awvalid    (axid.awvalid),

    .axi_wdata      (axid.wdata),
    .axi_wstrb      (axid.wstrb),
    .axi_wready     (axid.wready),
    .axi_wusero_id  (axid.bid),
    .axi_wusero_last(axid.wlast),

    .axi_araddr     (axid.araddr),
    .axi_aruser_ap  (1'd0),
    .axi_aruser_id  (axid.arid),
    .axi_arlen      (axid.arlen),
    .axi_arready    (axid.arready),
    .axi_arvalid    (axid.arvalid),

    .axi_rdata      (axid.rdata),
    .axi_rid        (axid.rid),
    .axi_rlast      (axid.rlast),
    .axi_rvalid     (axid.rvalid),

    .apb_addr		(apbd.apb_addr[7:0]),
    .apb_enable		(apbd.apb_enable),
    .apb_sel		(apbd.apb_sel),
    .apb_wdata		(apbd.apb_wdata[15:0]),
    .apb_write		(apbd.apb_write),
    .apb_rdata		(apbd.apb_rdata[15:0]),
    .apb_ready		(apbd.apb_ready),

    .ddr_init_done	(inid.ini_done),
    .ddrphy_cpd_lock	(inid.ini_phy_lock),
    .pll_lock		(inid.ini_pll_lock),

);*/

/*assoc_mem  AUTO_TEMPLATE(
    .rst_n		(rst_n), 
    .clk		(core_clk),
    .wen                (memd.we),
    .wdin               (memd.wdata),
    .wb                 (memd.wb),
    .ren                (memd.re),
    .waddr              (memd.waddr),
    .raddr              (memd.raddr),
    .rvld               (memd.rvld),
    .rdout              (memd.rdout),   
);*/



ddr3_reg  u_ddr3_reg(/*AUTOINST*/
      .aclk          		(ref_clk),
      .areset_n      		(rst_n),
      .apb_addr			(apbd.apb_addr[7:0]),
      .apb_enable		(apbd.apb_enable),
      .apb_sel			(apbd.apb_sel),
      .apb_wdata		(apbd.apb_wdata[15:0]),
      .apb_write		(apbd.apb_write),
      .apb_rdata		(apbd.apb_rdata[15:0]),
      .apb_ready		(apbd.apb_ready),
      .reg_rdata     		(areg.reg_rdata),
      .reg_vld       		(areg.reg_vld  ),
      .reg_raddr       		(areg.reg_raddr  )
);

assoc_mem u_assoc_mem(/*AUTOINST*/
		      // Outputs
		      .rdout		(memd.rdout),		 // Templated
		      .rvld		(memd.rvld),		 // Templated
		      // Inputs
		      .clk		(core_clk),		 // Templated
		      .rst_n		(rst_n),		 // Templated
		      .wen		(memd.we),		 // Templated
		      .ren		(memd.re),		 // Templated
		      .wdin		(memd.wdata),		 // Templated
		      .wb		(memd.wb),		 // Templated
		      .waddr		(memd.waddr),		 // Templated
		      .raddr		(memd.raddr));		 // Templated

ddr_wrapper u_ddr_wrapper(/*AUTOINST*/
			  // Outputs
			  .apb_rdata		(apbd.apb_rdata[15:0]), // Templated
			  .apb_ready		(apbd.apb_ready), // Templated
			  .axi_arready		(axid.arready),	 // Templated
			  .axi_awready		(axid.awready),	 // Templated
			  .axi_rdata		(axid.rdata),	 // Templated
			  .axi_rid		(axid.rid),	 // Templated
			  .axi_rlast		(axid.rlast),	 // Templated
			  .axi_rvalid		(axid.rvalid),	 // Templated
			  .axi_wready		(axid.wready),	 // Templated
			  .axi_wusero_id	(axid.bid),	 // Templated
			  .axi_wusero_last	(axid.wlast),	 // Templated
			  .core_clk		(core_clk),
			  .ddr_init_done	(inid.ini_done), // Templated
			  .ddrphy_cpd_lock	(inid.ini_phy_lock), // Templated
			  .debug_calib_ctrl	(debug_calib_ctrl[29:0]),
			  .debug_data		(debug_data[66*MEM_DQS_WIDTH-1:0]),
			  .pll_lock		(inid.ini_pll_lock), // Templated
			  // Inputs
			  .apb_addr		(apbd.apb_addr[7:0]), // Templated
			  .apb_clk		(ref_clk),	 // Templated
			  .apb_enable		(apbd.apb_enable), // Templated
			  .apb_rst_n		(rst_n),	 // Templated
			  .apb_sel		(apbd.apb_sel),	 // Templated
			  .apb_wdata		(apbd.apb_wdata[15:0]), // Templated
			  .apb_write		(apbd.apb_write), // Templated
			  .axi_araddr		(axid.araddr),	 // Templated
			  .axi_arlen		(axid.arlen),	 // Templated
			  .axi_aruser_ap	(1'd0),		 // Templated
			  .axi_aruser_id	(axid.arid),	 // Templated
			  .axi_arvalid		(axid.arvalid),	 // Templated
			  .axi_awaddr		(axid.awaddr),	 // Templated
			  .axi_awlen		(axid.awlen),	 // Templated
			  .axi_awuser_ap	(1'd0),		 // Templated
			  .axi_awuser_id	(axid.awid),	 // Templated
			  .axi_awvalid		(axid.awvalid),	 // Templated
			  .axi_wdata		(axid.wdata),	 // Templated
			  .axi_wstrb		(axid.wstrb),	 // Templated
			  .ref_clk		(ref_clk),
			  .resetn		(rst_n));	 // Templated
rst_gen u_rst_gen(/*AUTOINST*/
		  // Outputs
		  .rst_n		(rst_n));
clk_gen u_clk_gen(/*AUTOINST*/
		  // Outputs
		  .ref_clk		(ref_clk));
dump dump();
monitor monitor();
forcelist forcelist();

GTP_GRS GRS_INST(
		.GRS_N (rst_n)
	);

initial begin
   run_test();
end

initial begin
   uvm_config_db#(virtual tvip_apb_if)::set(null, "uvm_test_top.env.apb_drv", "vapb", apbd);
   //uvm_config_db#(virtual tvip_axi_if)::set(null, "uvm_test_top.env.drv", "vaxi", axid);
   uvm_config_db#(virtual tvip_ini_if)::set(null, "uvm_test_top.env.apb_drv", "vini", inid);
   uvm_config_db#(virtual tvip_apb_if)::set(null, "uvm_test_top.env.apb_mon", "vapb", apbd);
   uvm_config_db#(virtual tvip_ini_if)::set(null, "uvm_test_top.env.apb_mon", "vini", inid);
   uvm_config_db#(virtual tvip_reg_if)::set(null, "uvm_test_top.env.apb_mdl", "vreg", areg);

   uvm_config_db#(virtual tvip_axi_if)::set(null, "uvm_test_top.env.axi_drv", "vaxi", axid);
   uvm_config_db#(virtual tvip_axi_if)::set(null, "uvm_test_top.env.axi_mon", "vaxi", axid);
   uvm_config_db#(virtual tvip_mem_if)::set(null, "uvm_test_top.env.axi_mdl", "vmem", memd);

   uvm_config_db#(virtual tvip_ini_if)::set(null, "uvm_test_top.env.axi_drv", "vini", inid);
   uvm_config_db#(virtual tvip_ini_if)::set(null, "uvm_test_top.env.axi_mon", "vini", inid);
   uvm_config_db#(virtual tvip_mem_if)::set(null, "uvm_test_top.env.axi_drv", "vmem", memd);
   uvm_config_db#(virtual tvip_mem_if)::set(null, "uvm_test_top.env.axi_mon", "vmem", memd);

   uvm_config_db#(virtual tvip_mem_if)::set(null, "uvm_test_top.env.axi_scb", "vmem", memd);   


end

endmodule




