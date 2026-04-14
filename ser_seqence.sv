//====================================================
//					SER_SEQUENCE
//====================================================
class ser_sequence extends uvm_sequence#(ser_tx);
	`uvm_object_utils(ser_sequence)
	`NEW_OBJ
endclass

//===========================================
//			BASIC_SEQUENCE
//===========================================
class basic_sequence extends ser_sequence;

  `uvm_object_utils(basic_sequence)
  `NEW_OBJ

   task body();

    ser_tx tx;

    // -----------------------------------------
    // STEP 1: LOAD DATA
    // -----------------------------------------
    tx = ser_tx::type_id::create("tx");

    start_item(tx);
      tx.load     = 1;
      tx.shift_en = 0;
      tx.data_in  = $urandom_range(0, 255); // random 8-bit data
    finish_item(tx);

    // -----------------------------------------
    // STEP 2: SHIFT DATA (8 cycles)
    // -----------------------------------------
    repeat (8) begin
      tx = ser_tx::type_id::create("tx");

      start_item(tx);
        tx.load     = 0;
        tx.shift_en = 1;
        tx.data_in  = 0; // not used during shift
      finish_item(tx);
    end

  endtask

endclass

//=========================================
//				ADVANCE_SEQ
//=========================================
class advance_sequence extends ser_sequence;

  `uvm_object_utils(advance_sequence)
  `NEW_OBJ

 	 virtual task body();

 	 repeat (5) begin  // send 5 packets

 	   ser_tx tx;

 	   // LOAD
 	   tx = ser_tx::type_id::create("tx");
 	   start_item(tx);
 	     tx.load     = 1;
 	     tx.shift_en = 0;
 	     tx.data_in  = $urandom_range(0, 255);
 	   finish_item(tx);

 	   // SHIFT
 	   repeat (8) begin
 	     tx = ser_tx::type_id::create("tx");
 	     start_item(tx);
 	       tx.load     = 0;
 	       tx.shift_en = 1;
 	     finish_item(tx);
 	   end

 	 end

	endtask
 
endclass


