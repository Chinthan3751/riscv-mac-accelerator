`timescale 1ns/1ps

module alu_tb;

    logic [31:0] a;
    logic [31:0] b;
    logic [3:0] alu_control;

    logic [31:0] result;
    logic zero;

    alu dut (
        .a(a),
        .b(b),
        .alu_control(alu_control),
        .result(result),
        .zero(zero)
    );

    initial begin

        $dumpfile("alu.vcd");
        $dumpvars(0, alu_tb);

        // ADD
        a = 32'd10;
        b = 32'd5;
        alu_control = 4'b0000;
        #10;
        $display("ADD: %0d + %0d = %0d", a, b, result);

        // SUB
        a = 32'd10;
        b = 32'd5;
        alu_control = 4'b0001;
        #10;
        $display("SUB: %0d - %0d = %0d", a, b, result);

        // AND
        a = 32'hFF00FF00;
        b = 32'h0F0F0F0F;
        alu_control = 4'b0010;
        #10;
        $display("AND: %h & %h = %h", a, b, result);

        // OR
        a = 32'hFF00FF00;
        b = 32'h0F0F0F0F;
        alu_control = 4'b0011;
        #10;
        $display("OR: %h | %h = %h", a, b, result);

        // XOR
        a = 32'hFF00FF00;
        b = 32'h0F0F0F0F;
        alu_control = 4'b0100;
        #10;
        $display("XOR: %h ^ %h = %h", a, b, result);

        // SLT
        a = 32'd5;
        b = 32'd10;
        alu_control = 4'b0101;
        #10;
        $display("SLT: %0d < %0d = %0d", a, b, result);

        $finish;

    end

endmodule
