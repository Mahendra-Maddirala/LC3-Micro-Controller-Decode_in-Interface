//decode in monitor
class decode_in_monitor extends uvm_monitor;

//declaring varaibles
  int viewing_transaction_stream;
  bit en_view_seq;
  virtual decode_in_monitor_bfm bfm;
  protected time time_stamp = 0;
  decode_in_seq_item seq;

//calling uvm macros
  `uvm_component_utils(decode_in_monitor)
   uvm_analysis_port #(decode_in_seq_item) analysis_port_monitor;

//calling constructor
  function new(string name ="", uvm_component parent = null);
    super.new(name, parent);
  endfunction: new

//function build phase 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    set_bfm_proxy_handle();
    analysis_port_monitor = new("analysis_port_monitor", this);
	`uvm_info("INFO","Message given by decode_in_monitor build_phase", UVM_LOW);
  endfunction: build_phase

  virtual function void set_bfm_proxy_handle();
    bfm.proxy = this;
  endfunction: set_bfm_proxy_handle

//function run phase
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    ->bfm.go;
	phase.drop_objection(this);
	`uvm_info("INFO","Message given by decode_in_monitor run_phase", UVM_LOW);
  endtask: run_phase

//simulation phase starts
  virtual function void start_of_simulation_phase(uvm_phase phase);
    if(en_view_seq)
    viewing_transaction_stream=$create_transaction_stream({"..", get_full_name(),".","txn_stream"});
    `uvm_info("INFO","Message given by decode_in_monitor start_of_simulation_phase", UVM_LOW);
  endfunction: start_of_simulation_phase

//function notify transaction
  virtual function void notify_transaction(
        input logic [15:0] dout, npc_in
      );
      seq = new("seq");
      seq.start_time = time_stamp;
      seq.end_time = $time;
      time_stamp = seq.end_time;
      seq.npc_in = npc_in;
      seq.instr_dout = dout;
      analyze(seq);
  endfunction: notify_transaction

//function analyze
  virtual function void analyze(decode_in_seq_item seq);
      if(en_view_seq)
        seq.add_to_wave(viewing_transaction_stream);
      `uvm_info("MONITOR", {"Observed signals and broadcasting transaction: ",seq.convert2string()},UVM_MEDIUM)
      analysis_port_monitor.write(seq);
  endfunction: analyze
endclass: decode_in_monitor
