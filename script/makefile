DUMP=NONE
LONG=NONE
CASE=apb_case0
UVM_INFO=UVM_LOW
FORCE=NONE
MODE=NORMAL
TMODE=SEQ
SIM_LEN=128
AXI_LEN=15
AXI_ADDR=0

verdi_path = /usr/synopsys/Verdi3_L-2016.06-1

default :
	rm -rf $(CASE) ; mkdir case_$(MODE)_$(TMODE)_$(CASE); cd case_$(MODE)_$(TMODE)_$(CASE);echo "\`define  $(DUMP)       "  >    define.v ; echo "\`define  $(LONG)       "  >>   define.v ;echo "\`define  $(UVM_INFO)       "  >>   define.v ;echo "\`define  $(FORCE)       "  >>   define.v ;echo "\`define  $(MODE)       "  >>   define.v ;echo "\`define  $(TMODE)       "  >>   define.v ;echo "\`define  AXI_LEN  $(AXI_LEN)       "  >>   define.v ;echo "\`define  AXI_ADDR  $(AXI_ADDR)       "  >>   define.v ;echo "\`define  SIM_LEN  $(SIM_LEN)       "  >>   define.v ; cp ../../env/ddr3_parameters.vh  ../../env/vip/tvip_axi_defines.svh  ../../env/reg_define.v        ./  ; vcs -full64 -cpp g++-4.8 -cc gcc-4.8  -lca -timescale=1ns/1ps  -P  $(verdi_path)/share/PLI/VCS/LINUX64/novas.tab   $(verdi_path)/share/PLI/VCS/LINUX64/pli.a +vcs+lic+wait +vcd+vcdpluson  -sverilog +verilog2001ext+.v  +lint=TFIPC-L  -ntb_opts uvm  +define+UVM_NO_DEPRECATED+UVM_OBJECT_MUST_HAVE_CONSTRUCTO  -debug_all   -f ../tb.vc -top  tb_top     -cm line+cond+fsm+tgl -cm_dir ./cov_info      -l vcs_com.log ; ./simv    +UVM_TESTNAME=${CASE} +UVM_VERBOSITY=${UVM_INFO}   -cm line+cond+fsm+tgl -cm_dir  ./cov_info         -l vcs_sim_$(MODE)_$(TMODE)_${CASE}.log 

verdi:
	rm -rf  my_verdi  ; mkdir my_verdi; cd my_verdi;  cp ../define.v   ../../env/ddr3_parameters.vh  ../../env/vip/tvip_axi_defines.svh  ../../env/reg_define.v     ./;  verdi -sv  -f ../tb.vc  -top tb_top &

clean:
	rm -rf *simv*  *csrc   *~ verdiLog  novas*  ucli.key  *.vpd  *.fsdb  vc_hdrs.h  *.log *case*   my_verdi   cov_report 
	

cov:
	urg   -full64  -dir     ./*case*/cov_info.vdb    -metric line+cond+fsm+tgl -report   ./cov_report   -format both
	/home/software/firefox/firefox  ./cov_report/hierarchy.html  &

grep:
	grep "CASE"  ./*case*/vcs*.log


gen_v:
	perl my_cat.pl vp.vc   all_vp.sv  vp
	perl my_cat.pl v.vc all.sv v
	cat  ../../../example_design/bench/mem/ddr3.sv   >> all.sv
	##vcs -full64 +sv  -protect128 all.sv

