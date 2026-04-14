//================================================
//					SER_TRANSACTION
//================================================

class ser_tx extends uvm_sequence_item;
	`NEW_OBJ
	//--------------------------
	//stimulus(inputs to dut)
	//--------------------------
	rand bit load;
	rand bit shift_en;
	rand bit [7:0]data_in;  

	//-----------------------------------
	//Responce (outputs from dut)
	//-----------------------------------
	bit sda_out;
	bit busy;
	bit done;
	
	// ---------------------------------------
	// Factory Registration
	// ---------------------------------------
  `uvm_object_utils_begin(ser_tx)
    `uvm_field_int(load,      UVM_ALL_ON)
    `uvm_field_int(shift_en,  UVM_ALL_ON)
    `uvm_field_int(data_in,   UVM_ALL_ON)
    `uvm_field_int(sda_out,   UVM_ALL_ON)
    `uvm_field_int(busy,      UVM_ALL_ON)
    `uvm_field_int(done,      UVM_ALL_ON)
  `uvm_object_utils_end

  // ---------------------------------------
  // Optional: Constraints
  // ---------------------------------------
  constraint valid_ctrl {
    // Example: avoid both being 1 randomly (optional)
    !(load && shift_en);
  }

endclass
