//decode_in_driver_bfm
interface decode_in_driver_bfm(decode_in_if if_bus_dec);

//defining the signals 
  logic input_clk, input_reset, dec_en_input = 1'b0; 
  logic [15:0] input_instr_dout, output_instr_dout, input_npc_in, output_npc_in;

//assign all signals to interface
  assign input_clk = if_bus_dec.clock, input_reset = if_bus_dec.reset, if_bus_dec.enable_decode = dec_en_input, input_instr_dout = if_bus_dec.instr_dout, input_npc_in = if_bus_dec.npc_in, if_bus_dec.instr_dout = output_instr_dout, if_bus_dec.npc_in = output_npc_in;
  
//access task npc_in instruction d_out
  task access(input logic [15:0] instr_dout,  npc_in);
    @(posedge input_clk);
    output_instr_dout=instr_dout;
    output_npc_in=npc_in;
    dec_en_input = 1'b1; 
  endtask: access
endinterface: decode_in_driver_bfm
