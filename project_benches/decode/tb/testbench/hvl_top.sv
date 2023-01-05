//hvl top
module hvl_top;
	import uvm_pkg::*;
	import decode_in_pkg::*;
	import decode_test_pkg::*;

  	initial begin 
    	 run_test("test_top");
  	end
endmodule: hvl_top
