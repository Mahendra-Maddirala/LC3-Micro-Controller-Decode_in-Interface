//decode in monitor bfm
interface decode_in_monitor_bfm(decode_in_if if_bus_dec);

//defining the signals
  logic input_clock, input_reset, dec_en_input;
  logic [15:0] input_npc_in, input_instr_dout;
  event go;

  decode_in_pkg::decode_in_monitor proxy;

//assigning all the signlas from interface
  assign input_clock = if_bus_dec.clock;
  assign input_reset = if_bus_dec.reset;
  assign dec_en_input = if_bus_dec.enable_decode;
  assign input_npc_in = if_bus_dec.npc_in;
  assign input_instr_dout = if_bus_dec.instr_dout;

//waits until the reset task is done 
  task wait_for_reset();
    @(posedge input_clock);
    wait(input_reset==0);
  endtask: wait_for_reset

//waits for num clocks for last monitor transaction 
  task wait_for_num_clocks(input int unsigned counter);
    @(posedge input_clock);
    repeat(counter-1) @(posedge input_clock);
  endtask: wait_for_num_clocks

//task do monitor
  task do_monitor(output bit [15:0] npc, Instr_d);
    npc = input_npc_in;
    Instr_d = input_instr_dout;
  endtask: do_monitor


  initial begin
    @go;
    forever begin
      logic [15:0] dout, npc_in;
      @(posedge input_clock);
      if(dec_en_input == 1'b1)
      begin
        do_monitor(npc_in, dout);
        proxy.notify_transaction(dout, npc_in);
      end
    end
  end

endinterface
