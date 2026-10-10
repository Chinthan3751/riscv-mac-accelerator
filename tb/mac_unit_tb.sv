`timescale 1ns/1ps

module mac_unit_tb;

    logic        clk;
    logic        reset;
    logic        enable;

    logic [31:0] a;
    logic [31:0] b;
    logic [31:0] c;

    logic [63:0] result;
    logic        done;

    mac_unit dut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .a(a),
        .b(b),
        .c(c),
        .result(result),
        .done(done)
    );

    always #5 clk = ~clk;

    initial begin

        $dumpfile("mac_unit.vcd");
        $dumpvars(0, mac_unit_tb);

        clk    = 1'b0;
        reset  = 1'b1;
        enable = 1'b0;

        a = 32'd0;
        b = 32'd0;
        c = 32'd0;

        #12;

        reset = 1'b0;

        // Test 1
        // 6 * 7 + 10 = 52
        @(negedge clk);

        a      = 32'd6;
        b      = 32'd7;
        c      = 32'd10;
        enable = 1'b1;

        @(posedge clk);
        #1;

        $display("Test 1:");
        $display("A = %0d, B = %0d, C = %0d", a, b, c);
        $display("MAC Result = %0d", result);

        if (result == 64'd52)
            $display("PASS: 6 * 7 + 10 = 52");
        else
            $display("FAIL");


        // Test 2
        // 10 * 20 + 30 = 230
        @(negedge clk);

        a      = 32'd10;
        b      = 32'd20;
        c      = 32'd30;
        enable = 1'b1;

        @(posedge clk);
        #1;

        $display("");
        $display("Test 2:");
        $display("A = %0d, B = %0d, C = %0d", a, b, c);
        $display("MAC Result = %0d", result);

        if (result == 64'd230)
            $display("PASS: 10 * 20 + 30 = 230");
        else
            $display("FAIL");


        // Test 3
        // 100 * 5 + 25 = 525
        @(negedge clk);

        a      = 32'd100;
        b      = 32'd5;
        c      = 32'd25;
        enable = 1'b1;

        @(posedge clk);
        #1;

        $display("");
        $display("Test 3:");
        $display("A = %0d, B = %0d, C = %0d", a, b, c);
        $display("MAC Result = %0d", result);

        if (result == 64'd525)
            $display("PASS: 100 * 5 + 25 = 525");
        else
            $display("FAIL");


        $display("");
        $display("========================================");
        $display("       MAC ACCELERATOR TEST");
        $display("========================================");

        if ((result == 64'd525) && (done == 1'b1))
            $display("MAC TEST: PASS");
        else
            $display("MAC TEST: FAIL");

        $display("========================================");
        $display("");

        $finish;

    end

endmodule
