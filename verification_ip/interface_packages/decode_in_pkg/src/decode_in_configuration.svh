//decode in configuration
class decode_in_configuration extends uvm_object;

//calling uvm_macros
  `uvm_object_utils(decode_in_configuration)

  virtual decode_in_monitor_bfm bfm_mntr;
  virtual decode_in_driver_bfm 	bfm_drvr;

//varaible declaration used for config for active and passive components
  bit en_view_seq, is_active_flag, enable_coverage_flag;

//calling constructor
  function new(string name="decode_in_configuration",uvm_component parent=null);
    super.new(name);
  endfunction: new

  virtual function string convert2string();
    return {super.convert2string};
  endfunction: convert2string

//function intialization
  virtual function void initialize(string name, bit is_active_flag, string path_to_agent);
    uvm_config_db#(decode_in_configuration)::set(null, path_to_agent,"decode_cfgrn",this);
  endfunction: initialize

endclass: decode_in_configuration
