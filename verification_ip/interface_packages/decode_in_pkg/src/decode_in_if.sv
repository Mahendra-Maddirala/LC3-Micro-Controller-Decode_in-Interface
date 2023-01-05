//decode in if
interface decode_in_if   #(
      int npc_in_w = 16,
      int instr_dout_w = 16,
      int PSR_WIDTH = 3
      ) 
  (
    input tri clock, reset, enable_decode, [npc_in_w] npc_in, [instr_dout_w] instr_dout, [PSR_WIDTH - 1:0] psr 
    
  );

endinterface 

