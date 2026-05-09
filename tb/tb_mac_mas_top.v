`timescale 1ns/1ps

module tb_mac_mas_top;

// ========================================
// TESTBENCH SIGNALS
// ========================================

reg clk;
reg rst;
reg en;

reg [3:0] opcode;

reg [15:0] a;
reg [15:0] b;

wire [15:0] acc_out;
wire ready;


// ========================================
// DUT
// ========================================

mac_mas_top dut(
    .clk(clk),
    .rst(rst),
    .en(en),
    .opcode(opcode),
    .a(a),
    .b(b),
    .acc_out(acc_out),
    .ready(ready)
);


// ========================================
// CLOCK
// ========================================

always #5 clk = ~clk;


// ========================================
// TEST SEQUENCE
// ========================================

initial begin

    // ====================================
    // VCD DUMP
    // ====================================

    $dumpfile("sim/mac_mas.vcd");
    $dumpvars(0, tb_mac_mas_top);

    // ====================================
    // INITIAL VALUES
    // ====================================

    clk = 0;
    rst = 1;
    en = 0;

    opcode = 4'b0000;

    a = 16'd0;
    b = 16'd0;

    // ====================================
    // RESET
    // ====================================

    #20;
    rst = 0;

    // ====================================
    // TEST 1 : MAC
    // ACC = ACC + A*B
    // ====================================

    #10;

    opcode = 4'b0011; // MAC

    // 1.0 * 1.0 in bfloat16
    a = 16'h3F80;
    b = 16'h3F80;

    en = 1;

    #10;
    en = 0;

    // Wait until pipeline finishes
    @(posedge ready);

    // Wait one more clock for ACC update
    @(posedge clk);

    $display("MAC RESULT = %h", acc_out);

    // ====================================
    // TEST 2 : MAS
    // ACC = ACC - A*B
    // ====================================

    #20;

    opcode = 4'b1011; // MAS

    // 1.0 * 1.0 in bfloat16
    a = 16'h3F80;
    b = 16'h3F80;

    en = 1;

    #10;
    en = 0;

    // Wait until pipeline finishes
    @(posedge ready);

    // Wait one more clock for ACC update
    @(posedge clk);

    $display("MAS RESULT = %h", acc_out);

    // ====================================
    // END SIMULATION
    // ====================================

    #50;

    $finish;

end

endmodule