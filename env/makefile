DUMP=NONE
LONG=NONE
CASE=apb_case0



emacs:
	cp ../../../example_design/bench/mem/ddr3_parameters.vh   ./	
	cp  ../../../ddr3.v ./
	emacs   --batch   ddr3_model.sv           -f verilog-auto     -f save-buffer
	emacs   --batch   ddr_wrapper.sv          -f verilog-auto     -f save-buffer
	emacs   --batch   tb_top.sv               -f verilog-auto     -f save-buffer
	rm ddr3.v ddr3_parameters.vh   
verdi:
	verdi -sv  -f tb.vc  -top tb_top &

clean:
	rm -rf *simv*  *csrc   *~ verdiLog  novas*  ucli.key  *.vpd  *.fsdb  vc_hdrs.h  *.log *case*
	

