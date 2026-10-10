module mac_execution_unit (
    input  logic        clk,
    input  logic        reset,
    input  logic        start,

    // Register values
    input  logic [31:0] rs1_data,
    input  logic [31:0] rs2_data,
    input  logic [31:0] rs3_data,

    // MAC result
    output logic [63:0] result,
    output logic        done,
    output logic        busy
);

    logic        mac_enable;

    logic [31:0] mac_a;
    logic [31:0] mac_b;
    logic [31:0] mac_c;

    logic [63:0] mac_result;
    logic        mac_done;


    // MAC controller
    mac_controller controller (
        .clk(clk),
        .reset(reset),

        .start(start),

        .a(rs1_data),
        .b(rs2_data),
        .c(rs3_data),

        .mac_enable(mac_enable),

        .mac_a(mac_a),
        .mac_b(mac_b),
        .mac_c(mac_c),

        .mac_result(mac_result),
        .mac_done(mac_done),

        .result(result),
        .done(done),
        .busy(busy)
    );


    // Hardware MAC
    mac_unit mac (
        .clk(clk),
        .reset(reset),

        .enable(mac_enable),

        .a(mac_a),
        .b(mac_b),
        .c(mac_c),

        .result(mac_result),
        .done(mac_done)
    );

endmodule
