
`timescale 1ns/1ps

module monitor();

reg [31:0]  time_cnt ;
initial begin
    time_cnt = 32'd0 ;
    forever  #1000  begin
    	time_cnt =time_cnt+1'd1;
    	$display("now is %0d-us !!",time_cnt);
    end
end




`ifdef LONG

`else
	initial begin 
		//wait  (time_cnt==32'd10);
		wait  (tb_top.u_ddr_wrapper.u_ddr3_ctrl.ddr_init_done);
		$display("%m------:%t dfi_init_complete is high now!", $time);
		#10_000_000;
		$finish ;
	end
`endif




endmodule




