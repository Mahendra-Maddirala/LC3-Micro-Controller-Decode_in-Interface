//decod in agent
class decode_in_agent extends uvm_agent;

//declaration component in agent 
  decode_in_sequencer 		decode_sqcnr;
  decode_in_driver 		decode_drvr;
  decode_in_monitor 		decode_mntr;
  decode_in_configuration 	decode_cfgrn;
  bit is_active_flag;

//calling uvm_macros 
  `uvm_component_utils(decode_in_agent)
  uvm_analysis_port #(decode_in_seq_item) analysis_port_agent;

//calling constructor
  function new(string name = "decode_in_agent", uvm_component parent=null);
    super.new(name,parent);
  endfunction: new

//function build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!uvm_config_db#(decode_in_configuration)::get(this,"","decode_cfgrn",decode_cfgrn))
      `uvm_fatal("decode agent","virtual handle config_db is not found for decode_cfgrn config_db failed");
    is_active_flag = decode_cfgrn.is_active_flag;
    decode_mntr = decode_in_monitor::type_id::create("decode_mntr",this);
    decode_mntr.bfm = decode_cfgrn.bfm_mntr;
    decode_mntr.en_view_seq = decode_cfgrn.en_view_seq;

    if(is_active_flag) begin
      decode_sqcnr = decode_in_sequencer::type_id::create("decode_sqcnr",this);
      decode_drvr = decode_in_driver::type_id::create("decode_drvr",this);
      decode_drvr.bfm = decode_cfgrn.bfm_drvr;
    end
	`uvm_info("INFO-","Hi I'm decode agent build_phase", UVM_LOW);
  endfunction: build_phase

//function connect_phase
    virtual function void connect_phase(uvm_phase phase);
      analysis_port_agent = decode_mntr.analysis_port_monitor;

      if(is_active_flag)
        decode_drvr.seq_item_port.connect(decode_sqcnr.seq_item_export);
	`uvm_info("INFO-","Hi I'm decode agent connect_phase", UVM_LOW);
    endfunction: connect_phase
endclass: decode_in_agent
