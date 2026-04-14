//================================================
//					TEST_BENCH
//================================================

module top;
  // -----------------------------------------
  // Clock Generation
  // -----------------------------------------
  bit clk;

  initial clk = 0;
  always #5 clk = ~clk;   // 10ns clock

  // -----------------------------------------
  // Interface Instance
  // -----------------------------------------
  ser_intrf pif(clk);

  // -----------------------------------------
  // DUT Instantiation
  // -----------------------------------------
  i2c_serializer #(.DATA_WIDTH(8)) dut (
    .clk      (clk),
    .rst_n    (pif.rst_n),
    .load     (pif.load),
    .shift_en (pif.shift_en),
    .data_in  (pif.data_in),
    .sda_out  (pif.sda_out),
    .busy     (pif.busy),
    .done     (pif.done)
  );

  // -----------------------------------------
  // Reset Logic
  // -----------------------------------------

  initial begin
    pif.rst_n = 0;
    repeat (5) @(posedge clk);
    pif.rst_n = 1;
  end

  // -----------------------------------------
  // UVM Configuration
  // -----------------------------------------

  initial begin
    uvm_config_db #(virtual ser_intrf)::set(null, "*", "vif", pif);
  end

  // -----------------------------------------
  // Run Test
  // -----------------------------------------
  initial begin
    run_test("basic_test");  // or "advance_test"
  end

endmodule
