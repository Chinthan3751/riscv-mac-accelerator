`timescale 1ns/1ps

module riscv_cpu_tb;

    logic clk;
    logic reset;

    riscv_cpu dut (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;


    initial begin

        $dumpfile("riscv_cpu.vcd");
        $dumpvars(0, riscv_cpu_tb);

        clk = 1'b0;
        reset = 1'b1;

        #12;
        reset = 1'b0;


        // Wait for all three MAC operations
        repeat (35) begin
            @(posedge clk);
            #1;
        end


        $display("");
        $display("========================================");
        $display("       MULTIPLE MAC TEST RESULTS");
        $display("========================================");

        $display("x10 = %0d  Expected = 52",
                 dut.datapath.regs.registers[10]);

        $display("x11 = %0d  Expected = 230",
                 dut.datapath.regs.registers[11]);

        $display("x12 = %0d  Expected = 525",
                 dut.datapath.regs.registers[12]);

        $display("");
        $display("========================================");


        if (dut.datapath.regs.registers[10] == 52)
            $display("PASS: MAC 1 = 6 * 7 + 10 = 52");
        else
            $display("FAIL: MAC 1");


        if (dut.datapath.regs.registers[11] == 230)
            $display("PASS: MAC 2 = 10 * 20 + 30 = 230");
        else
            $display("FAIL: MAC 2");


        if (dut.datapath.regs.registers[12] == 525)
            $display("PASS: MAC 3 = 100 * 5 + 25 = 525");
        else
            $display("FAIL: MAC 3");


        $display("");
        $display("========================================");


        if ((dut.datapath.regs.registers[10] == 52) &&
            (dut.datapath.regs.registers[11] == 230) &&
            (dut.datapath.regs.registers[12] == 525)) begin

            $display("");
            $display("       MULTIPLE MAC TEST: PASS");
            $display("");
            $display("All three MAC instructions");
            $display("executed correctly.");
            $display("");

        end
        else begin

            $display("");
            $display("       MULTIPLE MAC TEST: FAIL");
            $display("");

        end


        $display("========================================");
        $display("");

        $finish;

    end

endmodule
