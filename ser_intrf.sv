interface ser_intrf(input bit clk);

  // -----------------------------------------
  // DUT Signals
  // -----------------------------------------
  logic rst_n;

  logic load;
  logic shift_en;
  logic [7:0] data_in;

  logic sda_out;
  logic busy;
  logic done;

  // -----------------------------------------
  // DRIVER CLOCKING BLOCK
  // -----------------------------------------
  clocking drv_cb @(posedge clk);
    default input #1 output #1;

    output load;
    output shift_en;
    output data_in;
  endclocking

  // -----------------------------------------
  // MONITOR CLOCKING BLOCK
  // -----------------------------------------
  clocking mon_cb @(posedge clk);
    default input #1;

    input load;
    input shift_en;
    input data_in;
    input sda_out;
    input busy;
    input done;
  endclocking

  // -----------------------------------------
  // MODPORTS
  // -----------------------------------------
  modport DRV (clocking drv_cb, input rst_n);
  modport MON (clocking mon_cb, input rst_n);

endinterface
