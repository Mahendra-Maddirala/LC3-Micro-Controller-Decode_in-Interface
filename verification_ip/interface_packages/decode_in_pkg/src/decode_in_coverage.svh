//decode in coverage

class decode_in_coverage extends uvm_subscriber #(decode_in_seq_item);
  
  decode_in_seq_item rq;  
  op_tdef opcode;
  logic [15:0] npc_in;
  `uvm_component_utils(decode_in_coverage);

//covergroups  
    covergroup decode_in_seq_item_cg;
    option.per_instance = 1;
    option.name         = get_full_name();
//coverpoints
    cover_npc_in:coverpoint npc_in;
    cover_DR    :coverpoint rq.DR;
    cover_SR1   :coverpoint rq.SR1;
    cover_SR2   :coverpoint rq.SR2;	
    
      opcode_type: coverpoint opcode
	{
	    bins ADD = {ADD};
	    bins AND = {AND};
	    bins BR  = {BR};
	    bins JMP = {JMP};
	    bins LD  = {LD};
	    bins LDR = {LDR};
	    bins LDI = {LDI};
	    bins LEA = {LEA};
	    bins NOT = {NOT};
	    bins ST  = {ST};
	    bins STI = {STI};
	    bins STR = {STR};
	}
  endgroup

//calling constructor
  function new(string name="decode_in_coverage", uvm_component parent = null);
    super.new(name, parent);
    decode_in_seq_item_cg = new;
  endfunction: new

//write funtion
  virtual function void write(decode_in_seq_item t);
    opcode = op_tdef'(t.instr_dout[15:12]);
    npc_in = t.npc_in;
    decode_in_seq_item_cg.sample();
  endfunction: write

//build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("INFO", "Message from decode coverage build_phase", UVM_LOW);
  endfunction: build_phase


endclass: decode_in_coverage
