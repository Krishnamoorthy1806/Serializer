`timescale 1ns / 1ps

module i2c_serializer #(
    parameter DATA_WIDTH = 8
)(
    input  wire                  clk,        // System clock
    input  wire                  rst_n,      // Active low reset

    input  wire                  load,       // Load parallel data
    input  wire                  shift_en,   // Shift enable (bit transfer control)
    input  wire [DATA_WIDTH-1:0] data_in,    // Parallel input data

    output wire                  sda_out,    // Serial data output
    output reg                   busy,       // Serializer active
    output reg                   done        // All bits transmitted
);

    // -------------------------------------------------
    // Internal signals
    // -------------------------------------------------
    reg [DATA_WIDTH-1:0] shift_reg;  // Shift register
    reg [$clog2(DATA_WIDTH):0] bit_cnt; // Bit counter

    // -------------------------------------------------
    // Main logic
    // -------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 0;
            bit_cnt   <= 0;
            busy      <= 0;
            done      <= 0;
        end
        else begin
            done <= 0; // default

            // Load data into shift register
            if (load) begin
                shift_reg <= data_in;
                bit_cnt   <= DATA_WIDTH;
                busy      <= 1;
            end

            // Shift operation
            else if (shift_en && busy) begin
                shift_reg <= {shift_reg[DATA_WIDTH-2:0], 1'b0}; // left shift
                bit_cnt   <= bit_cnt - 1;

                // Last bit transmitted
                if (bit_cnt == 1) begin
                    busy <= 0;
                    done <= 1;
                end
            end
        end
    end

    // -------------------------------------------------
  // Output MSB (  sends MSB first)
    // -------------------------------------------------
    assign sda_out = shift_reg[DATA_WIDTH-1];

endmodule

