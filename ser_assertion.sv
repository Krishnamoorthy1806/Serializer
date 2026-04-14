interface ser_if(input bit clk);

  logic rst_n;
  logic load;
  logic shift_en;
  logic [7:0] data_in;

  logic sda_out;
  logic busy;
  logic done;

  // -----------------------------------------
  // ASSERTION 1: BUSY MUST BE HIGH AFTER LOAD
  // -----------------------------------------
  property p_busy_after_load;
    @(posedge clk)
    disable iff (!rst_n)
    load |-> ##1 busy;
  endproperty

  assert_busy_after_load : assert property(p_busy_after_load)
    else $error("ASSERT FAIL: busy not asserted after load");

  // -----------------------------------------
  // ASSERTION 2: DONE IS 1 CYCLE PULSE
  // -----------------------------------------
  property p_done_pulse;
    @(posedge clk)
    disable iff (!rst_n)
    done |-> ##1 !done;
  endproperty

  assert_done_pulse : assert property(p_done_pulse)
    else $error("ASSERT FAIL: done not 1-cycle pulse");

  // -----------------------------------------
  // ASSERTION 3: BUSY LOW AFTER DONE
  // -----------------------------------------
  property p_busy_after_done;
    @(posedge clk)
    disable iff (!rst_n)
    done |-> ##1 !busy;
  endproperty

  assert_busy_after_done : assert property(p_busy_after_done)
    else $error("ASSERT FAIL: busy did not go low after done");

  // -----------------------------------------
  // ASSERTION 4: SHIFT ONLY WHEN SHIFT_EN = 1
  // -----------------------------------------
  property p_shift_control;
    @(posedge clk)
    disable iff (!rst_n)
    shift_en |-> busy;
  endproperty

  assert_shift_control : assert property(p_shift_control)
    else $error("ASSERT FAIL: shift without busy");

endinterface
