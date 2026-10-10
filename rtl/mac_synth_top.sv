module mac_synth_top (
    input  logic        clk,
    input  logic        reset,
    input  logic        enable,
    input  logic [31:0] a,
    input  logic [31:0] b,
    input  logic [31:0] c,
    output logic [63:0] result,
    output logic        done
);

    mac_execution_unit mac_exec (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .a(a),
        .b(b),
        .c(c),
        .result(result),
        .busy(),
        .done(done)
    );

endmodule
