//test_top class
class test_top extends uvm_test;
    decode_in_agent dec_agent;
    decode_in_configuration configuration;

    `uvm_component_utils(test_top)
    function new(string name = "test_top", uvm_component parent = null);
      super.new(name, parent); 
    endfunction: new

//build phase function
    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      configuration = decode_in_configuration::type_id::create("configuration", this);
      dec_agent = decode_in_agent::type_id::create("dec_agent", this);

      if(!uvm_config_db#(bit)::get(this, "configuration", "wave", configuration.en_view_seq))
      `uvm_fatal("test_top","handle_not found for test_top.configuration")

      if(!uvm_config_db#(bit)::get(this, "configuration", "active", configuration.is_active_flag))
      `uvm_fatal("test_top","handle_not found for test_top.configuration ")

      if(!uvm_config_db#(virtual decode_in_monitor_bfm)::get(this, "configuration", "decode_in", configuration.bfm_mntr))
      `uvm_fatal("test_top","handle_not found for test_top.configuration ")

      if(!uvm_config_db#(virtual decode_in_driver_bfm)::get(this, "configuration", "decode_in", configuration.bfm_drvr))
      `uvm_fatal("test_top","handle_not found for test_top.configuration")
       configuration.initialize("configuration", 1, "uvm_test_top.dec_agent");
       `uvm_info("INFO","Hey I'm  Build", UVM_LOW);
    endfunction: build_phase

//run phase task
    virtual task run_phase(uvm_phase phase);
      decode_in_random_sequence seq;
      phase.raise_objection(this);
      dec_agent.decode_mntr.bfm.wait_for_reset();
      seq = decode_in_random_sequence::type_id::create("seq",this);
      if(configuration.is_active_flag)
        seq.start(dec_agent.decode_sqcnr);
	dec_agent.decode_mntr.bfm.wait_for_num_clocks(1);
      phase.drop_objection(this);
      `uvm_info("INFO","Hi I'm test_top runner", UVM_LOW);
    endtask: run_phase
endclass: test_top
