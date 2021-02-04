module clk_gen(ref_clk);

localparam real CLKIN_FREQ  =  50.000   ; 
parameter PLL_REFCLK_IN_PERIOD = 1000 / CLKIN_FREQ;

output   ref_clk  ;

reg      ref_clk  ;

initial begin
  ref_clk = 0;
  forever  #(PLL_REFCLK_IN_PERIOD/2)  ref_clk =~ref_clk ;  
end

endmodule




