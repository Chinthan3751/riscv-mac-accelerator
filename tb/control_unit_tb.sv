`timescale 1ns/1ps

module control_unit_tb;

    logic [6:0] opcode;
    logic [2:0] funct3;
    logic       funct7_bit5;

    logic       reg_write;
    logic       alu_src;
    logic       mem_read;
    logic       mem_write;
    logic       mem_to_reg;
    logic       branch;
    logic [3:0] alu_control;

    control_unit dut (
        .opcode(opcode),
        .funct3(funct3),
        .funct7_bit5(funct7_bit5),

        .reg_write(reg_write),
        .alu_src(alu_src),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .branch(branch),
        .alu_control(alu_control)
    );

    initial begin

        $dumpfile("control_unit.vcd");
        $dumpvars(0, control_unit_tb);

        // -------------------------
        // ADD
        // opcode = 0110011
        // funct3 = 000
        // funct7 bit 5 = 0
        // -------------------------

        opcode = 7'b0110011;
        funct3 = 3'b000;
        funct7_bit5 = 1'b0;

        #10;

        $display("ADD  : RegWrite=%b ALUSrc=%b ALUControl=%b",
                 reg_write, alu_src, alu_control);


        // -------------------------
        // SUB
        // -------------------------

        opcode = 7'b0110011;
        funct3 = 3'b000;
        funct7_bit5 = 1'b1;

        #10;

        $display("SUB  : RegWrite=%b ALUSrc=%b ALUControl=%b",
                 reg_write, alu_src, alu_control);


        // -------------------------
        // AND
        // -------------------------

        opcode = 7'b0110011;
        funct3 = 3'b111;
        funct7_bit5 = 1'b0;

        #10;

        $display("AND  : RegWrite=%b ALUControl=%b",
                 reg_write, alu_control);


        // -------------------------
        // OR
        // -------------------------

        opcode = 7'b0110011;
        funct3 = 3'b110;
        funct7_bit5 = 1'b0;

        #10;

        $display("OR   : RegWrite=%b ALUControl=%b",
                 reg_write, alu_control);


        // -------------------------
        // ADDI
        // -------------------------

        opcode = 7'b0010011;
        funct3 = 3'b000;
        funct7_bit5 = 1'b0;

        #10;

        $display("ADDI : RegWrite=%b ALUSrc=%b ALUControl=%b",
                 reg_write, alu_src, alu_control);


        // -------------------------
        // LW
        // -------------------------

        opcode = 7'b0000011;
        funct3 = 3'b010;
        funct7_bit5 = 1'b0;

        #10;

        $display("LW   : RegWrite=%b MemRead=%b MemToReg=%b",
                 reg_write, mem_read, mem_to_reg);


        // -------------------------
        // SW
        // -------------------------

        opcode = 7'b0100011;
        funct3 = 3'b010;
        funct7_bit5 = 1'b0;

        #10;

        $display("SW   : MemWrite=%b ALUSrc=%b",
                 mem_write, alu_src);


        // -------------------------
        // BEQ
        // -------------------------

        opcode = 7'b1100011;
        funct3 = 3'b000;
        funct7_bit5 = 1'b0;

        #10;

        $display("BEQ  : Branch=%b ALUControl=%b",
                 branch, alu_control);


        // -------------------------
        // Invalid instruction
        // -------------------------

        opcode = 7'b1111111;
        funct3 = 3'b000;
        funct7_bit5 = 1'b0;

        #10;

        $display("INVALID: RegWrite=%b Branch=%b",
                 reg_write, branch);

        $finish;

    end

endmodule
