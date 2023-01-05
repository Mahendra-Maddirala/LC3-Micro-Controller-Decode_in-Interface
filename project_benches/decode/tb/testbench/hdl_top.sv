module hdl_top();
  import uvm_pkg::*;

//declaration 
  logic clk= 1'b0, reset;
  wire enable_decode;	
  wire [15:0] dout, npc_in;
  wire [3:0] psr;
  bit en_view_seq = 1'b1;
  bit is_active_flag = 1'b1; 
 

//clk generator
  initial begin: clk_gen
    forever #5 clk =~clk;
  end

//reset generator
  initial begin: rst_gen
    reset = 1'b1;
    #30;
    reset = 1'b0;
  end

//passing signals and handles to interfacenpc_in_w = 16,
  decode_in_if #( .npc_in_w(16), .instr_dout_w(16), .PSR_WIDTH(3) )decode_in_bus(.clock(clk), .reset(reset), .enable_decode(enable_decode), .instr_dout(dout), .npc_in(npc_in), .psr(psr));
  decode_in_monitor_bfm bfm_monitor(decode_in_bus);
  decode_in_driver_bfm 	bfm_driver(decode_in_bus);

  initial begin
  uvm_config_db#(bit)::set(null, "uvm_test_top.configuration", "wave", en_view_seq);
  uvm_config_db#(bit)::set(null, "uvm_test_top.configuration", "active", is_active_flag);
  uvm_config_db#(virtual decode_in_monitor_bfm)::set(null, "uvm_test_top.configuration", "decode_in", bfm_monitor);
  uvm_config_db#(virtual decode_in_driver_bfm)::set(null, "uvm_test_top.configuration", "decode_in", bfm_driver);
  end


endmodule
