module riscv_synth_top (
    input  logic        clk,
    input  logic        reset,

    output logic [31:0] pc_out,
    output logic [31:0] instruction_out,
    output logic [31:0] mac_result_out,
    output logic        mac_busy_out,
    output logic        mac_done_out
);

    riscv_cpu cpu (
        .clk(clk),
        .reset(reset),

        .pc_out(pc_out),
        .instruction_out(instruction_out),
        .mac_result_out(mac_result_out),
        .mac_busy_out(mac_busy_out),
        .mac_done_out(mac_done_out)
    );

endmodule
