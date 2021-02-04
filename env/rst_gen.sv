module rst_gen(/*AUTOARG*/
   // Outputs
   rst_n
   );

output   rst_n    ;
reg      rst_n  ;

initial begin
  rst_n = 1'b0 ;
  #1000
  rst_n = 1'b1 ;  
end



endmodule


