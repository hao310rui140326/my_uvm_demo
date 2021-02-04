`ifndef MY_ENV__SV
`define MY_ENV__SV

class my_env extends uvm_env;
   apb_sequencer  apb_sqr;
   axi_sequencer  axi_sqr;
   apb_driver apb_drv;
   axi_driver axi_drv;
   apb_monitor apb_mon;
   axi_monitor axi_mon;
   //my_monitor o_mon;

   apb_model  apb_mdl;
   axi_model  axi_mdl;
   apb_scoreboard apb_scb;
   axi_scoreboard axi_scb;

//   uvm_tlm_analysis_fifo #(apb_transaction) apbmon_apbmdl_fifo;
   uvm_tlm_analysis_fifo #(apb_transaction) apbmon_apbscb_fifo;
   uvm_tlm_analysis_fifo #(apb_transaction) apbmdl_apbscb_fifo;

   uvm_tlm_analysis_fifo #(axi_transaction) aximon_axiscb_fifo;
   uvm_tlm_analysis_fifo #(axi_transaction) aximdl_axiscb_fifo;

   uvm_tlm_analysis_fifo #(axi_transaction) axidrv_aximon_fifo;
   uvm_tlm_analysis_fifo #(axi_transaction) axidrv_aximdl_fifo;

   function new(string name = "my_env", uvm_component parent);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      apb_sqr = apb_sequencer::type_id::create("apb_sqr", this);
      axi_sqr = axi_sequencer::type_id::create("axi_sqr", this);
      apb_drv = apb_driver::type_id::create("apb_drv", this); 
      axi_drv = axi_driver::type_id::create("axi_drv", this); 
      apb_mon = apb_monitor::type_id::create("apb_mon", this);
      axi_mon = axi_monitor::type_id::create("axi_mon", this);
      //o_mon = my_monitor::type_id::create("o_mon", this);
      apb_mdl = apb_model::type_id::create("apb_mdl", this);
      axi_mdl = axi_model::type_id::create("axi_mdl", this);
      apb_scb = apb_scoreboard::type_id::create("apb_scb", this);
      axi_scb = axi_scoreboard::type_id::create("axi_scb", this);
      //apbmon_apbmdl_fifo = new("apbmon_apbmdl_fifo", this);
      apbmon_apbscb_fifo = new("apbmon_apbscb_fifo", this);
      apbmdl_apbscb_fifo = new("apbmdl_apbscb_fifo", this);
      aximon_axiscb_fifo = new("aximon_axiscb_fifo", this);
      aximdl_axiscb_fifo = new("aximdl_axiscb_fifo", this);

      axidrv_aximon_fifo = new("axidrv_aximon_fifo", this);
      axidrv_aximdl_fifo = new("axidrv_aximdl_fifo", this);

   endfunction

   extern virtual function void connect_phase(uvm_phase phase);
   //extern virtual task main_phase(uvm_phase phase);

   `uvm_component_utils(my_env)
endclass


function void my_env::connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   //apb_mon.ap.connect(apbmon_apbmdl_fifo.analysis_export);
   //apb_mdl.port.connect(apbmon_apbmdl_fifo.blocking_get_export);

   apb_mdl.ap.connect(apbmdl_apbscb_fifo.analysis_export);
   apb_scb.exp_port.connect(apbmdl_apbscb_fifo.blocking_get_export);

   apb_mon.ap.connect(apbmon_apbscb_fifo.analysis_export);
   apb_scb.act_port.connect(apbmon_apbscb_fifo.blocking_get_export);


   axi_mdl.ap.connect(aximdl_axiscb_fifo.analysis_export);
   axi_scb.exp_port.connect(aximdl_axiscb_fifo.blocking_get_export);

   axi_mon.ap.connect(aximon_axiscb_fifo.analysis_export);
   axi_scb.act_port.connect(aximon_axiscb_fifo.blocking_get_export);

    apb_drv.seq_item_port.connect(apb_sqr.seq_item_export);
    axi_drv.seq_item_port.connect(axi_sqr.seq_item_export);

    axi_drv.ap.connect(axidrv_aximon_fifo.analysis_export);
    axi_mon.port.connect(axidrv_aximon_fifo.blocking_get_export);

    axi_drv.ap_mdl.connect(axidrv_aximdl_fifo.analysis_export);
    axi_mdl.port.connect(axidrv_aximdl_fifo.blocking_get_export);

endfunction


//task my_env::main_phase(uvm_phase phase);
//   my_sequence apb_seq;
//   phase.raise_objection(this);
//   apb_seq = my_sequence::type_id::create("apb_seq");
//   apb_seq.start(apb_sqr); 
//   phase.drop_objection(this);
//endtask
//


`endif
