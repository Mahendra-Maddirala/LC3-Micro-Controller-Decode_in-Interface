//decode in sequence item

typedef enum bit [2:0] {BRZ=3'b010, BRNP=3'b101, BRP=3'b001, BRZP=3'b011, BRN=3'b100, BRNZ=3'b110, BRNZP=3'b111} NZP_tdef;
typedef enum bit [3:0] {ADD=4'b0001, AND=4'b0101, NOT=4'b1001, LD=4'b0010, LDR=4'b0110,LDI=4'b1010,LEA=4'b1110, ST=4'b0011,STR=4'b0111, STI=4'b1011, BR=4'b0000, JMP=4'b1100} op_tdef;

class decode_in_seq_item extends uvm_sequence_item;

	  rand NZP_tdef NZP;
	  rand op_tdef opcode;
	  rand bit [2:0] BaseR,DR, SR1, SR2, SR;
	  rand bit [4:0] imm5;
	  rand bit [8:0] PCoffset9;
	  rand bit [5:0] PCoffset6;
	  rand bit ADD_m;
	  rand bit AND_m;
	  rand bit [15:0] npc_in;
	  logic [15:0] instr_dout;
	  time start_time; 
	  time end_time;
	
	  `uvm_object_utils_begin(decode_in_seq_item)
	  `uvm_field_int(instr_dout, UVM_ALL_ON)
	  `uvm_field_int(npc_in, UVM_ALL_ON)
	  `uvm_field_int(start_time, UVM_ALL_ON)
	  `uvm_field_int(end_time, UVM_ALL_ON)
	  `uvm_object_utils_end
	
	  function void post_randomize();
	
	    case(opcode)
	    ADD: begin
	          if(ADD_m) instr_dout = {ADD, DR, SR1, ADD_m, imm5};
	          else instr_dout = {ADD, DR, SR1, ADD_m, 2'b00, SR2};
	
	        end
	
	  	AND: begin
	          if(AND_m) instr_dout = {AND, DR, SR1, AND_m, imm5};
	          else instr_dout = {AND, DR, SR1, AND_m, 2'b00, SR2};

    		end

    		LDR: begin
        	instr_dout = {LDR, DR, BaseR, PCoffset6};
    		end
    		LD: begin
        	instr_dout = {LD, DR, PCoffset9};
    		end

    		LDI: begin
        	instr_dout = {LDI, DR, PCoffset9};
    		end

    		STI: begin
        	instr_dout = {STI, SR, PCoffset9};
    		end

    		STR: begin
      		instr_dout = {STR, SR, BaseR, PCoffset6};
    		end

    		NOT: begin
        	instr_dout = {NOT, DR, SR1, 6'b111111};
    		end

    		JMP: begin
        	instr_dout = {JMP, 3'b000, BaseR, 6'b000000};
    		end

    		LEA: begin
        	instr_dout = {LEA, DR, PCoffset9};
    		end

    		BR: begin
        	instr_dout = {BR, NZP, PCoffset9};
    		end

    		ST: begin
        	instr_dout = {ST, SR, PCoffset9};
    		end


    		endcase

  	endfunction: post_randomize

  	function new(string name="decode_in_seq_item",uvm_component parent=null);
    	 super.new(name);
  	endfunction: new

  	virtual function string convert2string();
   	 return $sformatf("Instr_dout:0x%x npc_in:0x%x", instr_dout, npc_in);
  	endfunction: convert2string

	virtual function void add_to_wave(int transaction_viewing_stream_h);
    	 int transaction_view_h;
    	 transaction_view_h=$begin_transaction(transaction_viewing_stream_h, "decode_in_seq_item", start_time);
    	 $add_attribute(transaction_view_h, instr_dout, "instr_dout");
    	 $add_attribute(transaction_view_h, npc_in, "npc_in");
    	 $end_transaction(transaction_view_h, end_time);
    	 $free_transaction(transaction_view_h);
  	endfunction: add_to_wave


endclass: decode_in_seq_item
