`timescale 1ns/1ps

module instruction_decoder_tb;

    logic [31:0] instruction;

    logic [6:0] opcode;
    logic [4:0] rd;
    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [2:0] funct3;
    logic [6:0] funct7;

    instruction_decoder dut (
        .instruction(instruction),
        .opcode(opcode),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2),
        .funct3(funct3),
        .funct7(funct7)
    );

    initial begin

        $dumpfile("instruction_decoder.vcd");
        $dumpvars(0, instruction_decoder_tb);

        // --------------------------------
        // ADD x1, x2, x3
        // --------------------------------
        instruction = 32'h003100B3;
        #10;

        $display("ADD instruction:");
        $display("opcode = %07b", opcode);
        $display("rd     = x%0d", rd);
        $display("rs1    = x%0d", rs1);
        $display("rs2    = x%0d", rs2);
        $display("funct3 = %03b", funct3);
        $display("funct7 = %07b", funct7);

        // --------------------------------
        // ADDI x5, x6, 10
        // --------------------------------
        instruction = 32'h00A30293;
        #10;

        $display("");
        $display("ADDI instruction:");
        $display("opcode = %07b", opcode);
        $display("rd     = x%0d", rd);
        $display("rs1    = x%0d", rs1);
        $display("rs2    = x%0d", rs2);
        $display("funct3 = %03b", funct3);
        $display("funct7 = %07b", funct7);

        $finish;

    end

endmodule
