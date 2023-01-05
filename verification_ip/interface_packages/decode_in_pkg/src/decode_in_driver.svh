//decode in driver

class decode_in_driver extends uvm_driver #(decode_in_seq_item);

  virtual decode_in_driver_bfm bfm;

  `uvm_component_utils(decode_in_driver)
//function build phase  
	function void build_phase(uvm_phase phase);
	    super.build_phase(phase);
	    `uvm_info("INFO", "Hi I'm decode driver build_phase", UVM_LOW);
  	endfunction: build_phase

	function new(string name="decode_in_driver", uvm_component parent=null);
	    super.new(name,parent);
  	endfunction: new
//run phase task
  	virtual task run_phase(uvm_phase phase);
    	 super.run_phase(phase);
   	  forever begin: forever_loop
      	   seq_item_port.get_next_item(req);
      	   access(req);
      	   seq_item_port.item_done();
    	end
//getting uvm info
        `uvm_info("INFO","Hi I'm decode driver run_phase", UVM_LOW);
 	 endtask: run_phase
//inout sequence item access task
  	virtual task access(inout decode_in_seq_item sqn);
    	 `uvm_info("DRIVER", {"transaction from the sequencer is received: ",sqn.convert2string()},UVM_MEDIUM)
    	 bfm.access(sqn.instr_dout, sqn.npc_in);
  	endtask: access

endclass: decode_in_driver
