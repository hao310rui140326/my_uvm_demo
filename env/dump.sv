module dump();

parameter   DUMP_ST = 10;//870_000_000;//50_000_000;
parameter   DUMP_ED = 1_000_000;

`ifdef  DUMP
	`ifndef  NOFSDB
		initial begin
			#100
			#DUMP_ST ; 
			//wait ( tb.u_tx_sys.tcp_frame_cnt[63:0]==32'd224000 );  //53287
			$fsdbAutoSwitchDumpfile(1000,"tb_top.fsdb",100);
			$fsdbDumpoff;
			$fsdbDumpvars(0,tb_top);
			$fsdbDumpon;
			#DUMP_ED ;
			$finish ;
		end
	`endif

	initial begin
		#DUMP_ST; 
		//wait ( tb.u_tx_sys.tcp_frame_cnt[63:0]==32'd224000 );  //53287
		$vcdpluson;
		$vcdplusmemon;
      		$vcdplusglitchon;
      		$vcdplusflush;
	end
`endif

endmodule



