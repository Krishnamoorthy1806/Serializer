//====================================================
//					SER_SBD
//====================================================
class ser_sbd extends uvm_scoreboard;
	`uvm_component_utils(ser_sbd)
	ser_tx tx;

	virtual function void write(ser_tx t);
		$cast(tx,t);
	endfunction

  // -----------------------------------------
  // Analysis exports
  // -----------------------------------------
  uvm_analysis_export #(ser_tx) exp;

  // FIFO for transactions
  mailbox #(ser_tx) mbox;

  // -----------------------------------------
  // Internal model
  // -----------------------------------------
  bit [7:0] expected_data;
  bit [7:0] shift_reg;
  int bit_count;

  function new(string name="ser_sbd", uvm_component parent=null);
    super.new(name, parent);
    exp = new("exp", this);
    mbox = new();
  endfunction

  // -----------------------------------------
  // CONNECT
  // -----------------------------------------
  function void connect_phase(uvm_phase phase);
    exp.connect(mbox.put_export);
  endfunction

  // -----------------------------------------
  // RUN PHASE
  // -----------------------------------------
  task run_phase(uvm_phase phase);

    ser_tx tx;

    forever begin
      mbox.get(tx);
      compare(tx);
    end

  endtask

  // -----------------------------------------
  // COMPARISON LOGIC
  // -----------------------------------------
  task compare(ser_tx tx);

    // -----------------------------
    // LOAD PHASE
    // -----------------------------
    if (tx.load) begin
      expected_data = tx.data_in;
      shift_reg     = tx.data_in;
      bit_count     = 8;

      `uvm_info("SBD", $sformatf(
        "LOAD detected: data=%0h", tx.data_in), UVM_MEDIUM)
    end

    // -----------------------------
    // SHIFT PHASE
    // -----------------------------
    else if (tx.shift_en) begin

      // Expected MSB-first check
      bit expected_bit;
      expected_bit = shift_reg[7];

      if (tx.sda_out !== expected_bit) begin
        `uvm_error("SBD", $sformatf(
          "Mismatch! Expected=%0b Got=%0b",
          expected_bit, tx.sda_out))
      end
      else begin
        `uvm_info("SBD", "Bit matched ✔", UVM_LOW)
      end

      // Shift reference model
      shift_reg = {shift_reg[6:0], 1'b0};
      bit_count--;

    end

    // -----------------------------
    // DONE CHECK
    // -----------------------------
    if (tx.done) begin
      if (bit_count != 0) begin
        `uvm_error("SBD", "DONE too early!")
      end
      else begin
        `uvm_info("SBD", "Transfer completed ✔", UVM_MEDIUM)
      end
    end

    // -----------------------------
    // BUSY CHECK
    // -----------------------------
    if (!tx.busy && bit_count != 0) begin
      `uvm_error("SBD", "BUSY dropped early!")
    end

  endtask

endclass
