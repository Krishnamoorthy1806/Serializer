//====================================================
//					SER_DRIVER
//====================================================
class ser_drv extends uvm_driver #(ser_tx);

  `uvm_component_utils(ser_drv)
  `NEW_COMP

  virtual ser_intrf.DRV vif;   //  modport used

  // -----------------------------------------
  // BUILD PHASE
  // -----------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db #(virtual ser_intrf.DRV)::get(this, "", "vif", vif)) begin
      `uvm_fatal("DRV", "Virtual interface not found")
    end
  endfunction

  // -----------------------------------------
  // RUN PHASE
  // -----------------------------------------
  task run_phase(uvm_phase phase);

    //ser_tx tx;

    forever begin
      seq_item_port.get_next_item(req);

      drive_item(req);

      seq_item_port.item_done();
    end

  endtask

  // -----------------------------------------
  // DRIVE TASK (USING CLOCKING BLOCK)
  // -----------------------------------------
  task drive_item(ser_tx tx);

    @(vif.drv_cb);   //  synchronized with clocking block

    vif.drv_cb.load     <= tx.load;
    vif.drv_cb.shift_en <= tx.shift_en;
    vif.drv_cb.data_in  <= tx.data_in;

    `uvm_info("DRV", $sformatf(
      "DRIVE: load=%0d shift_en=%0d data=%0h",
       tx.load, tx.shift_en, tx.data_in), UVM_MEDIUM)

  endtask

endclass
