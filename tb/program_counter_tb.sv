`timescale 1ns/1ps

module program_counter_tb;

    logic        clk;
    logic        reset;
    logic        pc_write;
    logic [31:0] pc_next;
    logic [31:0] pc;

    program_counter dut (
        .clk(clk),
        .reset(reset),
        .pc_write(pc_write),
        .pc_next(pc_next),
        .pc(pc)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin

        $dumpfile("program_counter.vcd");
        $dumpvars(0, program_counter_tb);

        clk = 0;
        reset = 1;
        pc_write = 0;
        pc_next = 32'd0;

        // Reset
        #10;
        reset = 0;

        // PC = 4
        pc_write = 1;
        pc_next = 32'd4;
        #10;

        $display("PC after first update  = %0d (0x%08h)", pc, pc);

        // PC = 8
        pc_next = 32'd8;
        #10;

        $display("PC after second update = %0d (0x%08h)", pc, pc);

        // PC = 12
        pc_next = 32'd12;
        #10;

        $display("PC after third update  = %0d (0x%08h)", pc, pc);

        // Test PC hold
        pc_write = 0;
        pc_next = 32'd100;
        #10;

        $display("PC with write disabled  = %0d (0x%08h)", pc, pc);

        // Test direct jump to 100
        pc_write = 1;
        pc_next = 32'd100;
        #10;

        $display("PC after jump           = %0d (0x%08h)", pc, pc);

        $finish;

    end

endmodule
