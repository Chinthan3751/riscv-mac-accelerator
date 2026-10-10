`timescale 1ns/1ps

module mac_execution_unit_tb;

    logic        clk;
    logic        reset;
    logic        start;

    logic [31:0] rs1_data;
    logic [31:0] rs2_data;
    logic [31:0] rs3_data;

    logic [63:0] result;
    logic        done;
    logic        busy;


    mac_execution_unit dut (
        .clk(clk),
        .reset(reset),
        .start(start),

        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .rs3_data(rs3_data),

        .result(result),
        .done(done),
        .busy(busy)
    );


    always #5 clk = ~clk;


    initial begin

        $dumpfile("mac_execution_unit.vcd");
        $dumpvars(0, mac_execution_unit_tb);


        clk      = 1'b0;
        reset    = 1'b1;
        start    = 1'b0;

        rs1_data = 32'd0;
        rs2_data = 32'd0;
        rs3_data = 32'd0;


        #12;

        reset = 1'b0;


        // =========================================
        // TEST 1
        // x1 = 6
        // x2 = 7
        // x3 = 10
        //
        // Result = 6 * 7 + 10 = 52
        // =========================================

        @(negedge clk);

        rs1_data = 32'd6;
        rs2_data = 32'd7;
        rs3_data = 32'd10;

        start = 1'b1;

        @(negedge clk);

        start = 1'b0;


        wait(done);

        #1;

        $display("");
        $display("========================================");
        $display("       MAC EXECUTION UNIT TEST");
        $display("========================================");

        $display("RS1 = %0d", rs1_data);
        $display("RS2 = %0d", rs2_data);
        $display("RS3 = %0d", rs3_data);

        $display("Result = %0d", result);

        $display("Done = %b", done);
        $display("Busy = %b", busy);


        if (result == 64'd52)
            $display("PASS: 6 * 7 + 10 = 52");
        else
            $display("FAIL: Incorrect result");


        // =========================================
        // TEST 2
        // 15 * 4 + 20 = 80
        // =========================================

        @(negedge clk);

        rs1_data = 32'd15;
        rs2_data = 32'd4;
        rs3_data = 32'd20;

        start = 1'b1;

        @(negedge clk);

        start = 1'b0;


        wait(done);

        #1;

        $display("");
        $display("Test 2:");

        $display("RS1 = %0d", rs1_data);
        $display("RS2 = %0d", rs2_data);
        $display("RS3 = %0d", rs3_data);

        $display("Result = %0d", result);


        if (result == 64'd80)
            $display("PASS: 15 * 4 + 20 = 80");
        else
            $display("FAIL: Incorrect result");


        // =========================================
        // FINAL TEST
        // =========================================

        $display("");
        $display("========================================");

        if (result == 64'd80)
            $display("MAC EXECUTION UNIT TEST: PASS");
        else
            $display("MAC EXECUTION UNIT TEST: FAIL");

        $display("========================================");
        $display("");

        $finish;

    end

endmodule
