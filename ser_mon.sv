//====================================================
//					SER_MONITOR
//====================================================

class ser_mon extends uvm_monitor;
	`uvm_component_utils(ser_mon)
	`NEW_COMP
	
  virtual ser_intrf.MON vif;   // modport used

  uvm_analysis_port #(ser_tx) ap;

  // -----------------------------------------
  // BUILD PHASE
  // -----------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap = new("ap", this);

    if (!uvm_config_db #(virtual ser_intrf.MON)::get(this, "", "vif", vif)) begin
      `uvm_fatal("MON", "Virtual interface not found")
    end
  endfunction

  // -----------------------------------------
  // RUN PHASE
  // -----------------------------------------
  task run_phase(uvm_phase phase);

    ser_tx tx;

    forever begin
      @(vif.mon_cb);   //  synchronized sampling

      tx = ser_tx::type_id::create("tx");

      tx.load     = vif.mon_cb.load;
      tx.shift_en = vif.mon_cb.shift_en;
      tx.data_in  = vif.mon_cb.data_in;
      tx.sda_out  = vif.mon_cb.sda_out;
      tx.busy     = vif.mon_cb.busy;
      tx.done     = vif.mon_cb.done;

      ap.write(tx);

      `uvm_info("MON", $sformatf(
        "MON: load=%0d shift_en=%0d data=%0h sda=%0d busy=%0d done=%0d",
        tx.load, tx.shift_en, tx.data_in,
        tx.sda_out, tx.busy, tx.done), UVM_MEDIUM)

    end

  endtask

endclass
