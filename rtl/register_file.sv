module register_file (
    input logic clk,
    input logic reset,

    input logic [4:0] rs1,
    input logic [4:0] rs2,
    input logic [4:0] rs3,
    input logic [4:0] rd,

    input logic [31:0] write_data,
    input logic reg_write,

    output logic [31:0] read_data1,
    output logic [31:0] read_data2,
    output logic [31:0] read_data3
);

    logic [31:0] registers [0:31];
    integer i;

    always_ff @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'd0;
        end
        else if (reg_write && (rd != 5'd0)) begin
            registers[rd] <= write_data;
        end
    end

    always_comb begin

        if (rs1 == 5'd0)
            read_data1 = 32'd0;
        else
            read_data1 = registers[rs1];

        if (rs2 == 5'd0)
            read_data2 = 32'd0;
        else
            read_data2 = registers[rs2];

        if (rs3 == 5'd0)
            read_data3 = 32'd0;
        else
            read_data3 = registers[rs3];

    end

endmodule
