module forcelist();

initial begin
	//force tb_top.inid.ini_done = tb_top.inid.ini_phy_lock ;
	`ifdef  FORCE
		wait(tb_top.u_ddr_wrapper.u_ddr3_ctrl.u_ddrphy_top.ddrphy_calib_top.ddrphy_main_ctrl.init_done);
		force tb_top.u_ddr_wrapper.u_ddr3_ctrl.u_ddrphy_top.ddrphy_calib_top.ddrphy_main_ctrl.main_next_state[3:0] = 'd7 ;
		@(posedge tb_top.u_ddr_wrapper.u_ddr3_ctrl.u_ddrphy_top.ddrphy_calib_top.ddrphy_main_ctrl.ddrphy_sysclk)
		@(posedge tb_top.u_ddr_wrapper.u_ddr3_ctrl.u_ddrphy_top.ddrphy_calib_top.ddrphy_main_ctrl.ddrphy_sysclk)
		release tb_top.u_ddr_wrapper.u_ddr3_ctrl.u_ddrphy_top.ddrphy_calib_top.ddrphy_main_ctrl.main_next_state[3:0] ;
	`endif
end

endmodule


