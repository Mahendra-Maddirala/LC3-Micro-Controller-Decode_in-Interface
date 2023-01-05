// decode in random sequence
class decode_in_random_sequence extends uvm_sequence #(decode_in_seq_item);

  decode_in_seq_item seq;
  `uvm_object_utils(decode_in_random_sequence)

  function new(string name = "decode_in_random_sequence");
    super.new(name);    
  endfunction: new

  virtual task body();
    
    seq = new("seq");
    repeat(25) 
    begin
      start_item(seq);
     repeat(25) 
      begin		
       assert(seq.randomize());
      end	
      finish_item(seq);                  
    end

  endtask: body
endclass: decode_in_random_sequence
