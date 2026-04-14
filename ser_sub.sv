//====================================================
//					SER_SUBSCRIBER
//====================================================

class ser_sub extends uvm_subscriber#(ser_tx);
	`uvm_component_utils(ser_sub)
	ser_tx tx;

  // -----------------------------------------
  // COVERGROUP
  // -----------------------------------------
  covergroup ser_cg;

    // Load signal coverage
    load_cp : coverpoint tx.load {
      bins load_0 = {0};
      bins load_1 = {1};
    }

    // Shift enable coverage
    shift_cp : coverpoint tx.shift_en {
      bins shift_0 = {0};
      bins shift_1 = {1};
    }

    // Data coverage
    data_cp : coverpoint tx.data_in {
      bins low  = {[0:50]};
      bins mid  = {[51:150]};
      bins high = {[151:255]};
    }

    // Busy signal
    busy_cp : coverpoint tx.busy {
      bins busy_0 = {0};
      bins busy_1 = {1};
    }

    // Done signal
    done_cp : coverpoint tx.done {
      bins done_0 = {0};
      bins done_1 = {1};
    }

    // SDA output
    sda_cp : coverpoint tx.sda_out {
      bins zero = {0};
      bins one  = {1};
    }

    // -----------------------------------------
    // CROSS COVERAGE
    // -----------------------------------------
    load_shift_cross : cross load_cp, shift_cp;

    data_done_cross  : cross data_cp, done_cp;

  endgroup

  // -----------------------------------------
  // CONSTRUCTOR
  // -----------------------------------------
  function new(string name="ser_cov", uvm_component parent=null);
    super.new(name, parent);
    ser_cg = new();
  endfunction

  // -----------------------------------------
  // WRITE METHOD (IMPORTANT)
  // -----------------------------------------
  virtual function void write(ser_tx t);
    $cast(tx,t);
    ser_cg.sample();
  endfunction

endclass
