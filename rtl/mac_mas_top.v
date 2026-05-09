module mac_mas_top(
    input clk,
    input rst,
    input en,

    input [3:0] opcode,

    input [15:0] a,
    input [15:0] b,

    output [15:0] acc_out,
    output ready
);

// ========================================
// OPCODES
// ========================================

localparam OP_MAC = 4'b0011;
localparam OP_MAS = 4'b1011;


// ========================================
// INTERNAL SIGNALS
// ========================================

wire [15:0] mult_out;
wire mult_ready;

wire [15:0] addsub_out;
wire addsub_ready;

reg add_sub;

reg [15:0] acc;
reg [15:0] acc_pipe;


// ========================================
// MULTIPLIER PIPELINE
// ========================================

fpmul mult_unit(
    .x1(a),
    .x2(b),
    .y(mult_out),
    .clk(clk),
    .rst(rst),
    .en(en),
    .ready(mult_ready)
);


// ========================================
// ADDER / SUBTRACTOR PIPELINE
// ========================================

fp16sum_res_pipe addsub_unit(
    .x1(acc_pipe),
    .x2(mult_out),
    .clk(clk),
    .rst(rst),
    .add_sub(add_sub),
    .en(mult_ready),
    .ready(addsub_ready),
    .y(addsub_out)
);


// ========================================
// ACCUMULATOR REGISTER
// ========================================

always @(posedge clk) begin

    if(rst) begin
        acc <= 16'd0;
        acc_pipe <= 16'd0;
        add_sub <= 1'b0;
    end

    else begin

        // Capture operation type
        if(en)
            add_sub <= (opcode == OP_MAS);

        // Capture accumulator before operation
        if(en)
            acc_pipe <= acc;

        // Update accumulator with pipeline result
        if(addsub_ready)
            acc <= addsub_out;

    end

end


// ========================================
// OUTPUTS
// ========================================

assign acc_out = acc;

assign ready = addsub_ready;

endmodule