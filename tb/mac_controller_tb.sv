`timescale 1ns/1ps

module mac_controller_tb;

    logic        clk;
    logic        reset;
    logic        start;

    logic [31:0] a;
    logic [31:0] b;
    logic [31:0] c;

    logic        mac_enable;
    logic [31:0] mac_a;
    logic [31:0] mac_b;
    logic [31:0] mac_c;

    logic [63:0] mac_result;
    logic        mac_done;

    logic [63:0] result;
    logic        done;
    logic        busy;


    // Controller
    mac_controller controller (

        .clk(clk),
        .reset(reset),

        .start(start),

        .a(a),
        .b(b),
        .c(c),

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


    // MAC Unit
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


    // Clock
    always #5 clk = ~clk;


    initial begin

        $dumpfile("mac_controller.vcd");
        $dumpvars(0, mac_controller_tb);


        clk       = 1'b0;
        reset     = 1'b1;
        start     = 1'b0;

        a         = 32'd0;
        b         = 32'd0;
        c         = 32'd0;

        #12;

        reset = 1'b0;


        // =====================================
        // TEST 1
        // 6 * 7 + 10 = 52
        // =====================================

        @(negedge clk);

        a     = 32'd6;
        b     = 32'd7;
        c     = 32'd10;

        start = 1'b1;

        @(negedge clk);

        start = 1'b0;


        wait(done);

        #1;

        $display("");
        $display("========================================");
        $display("          MAC CONTROLLER TEST");
        $display("========================================");

        $display("A = %0d", a);
        $display("B = %0d", b);
        $display("C = %0d", c);
        $display("Result = %0d", result);
        $display("Done = %b", done);


        if (result == 64'd52)
            $display("PASS: Controller calculated 6 * 7 + 10 = 52");
        else
            $display("FAIL: Incorrect MAC result");


        // =====================================
        // TEST 2
        // 10 * 20 + 30 = 230
        // =====================================

        @(negedge clk);

        a     = 32'd10;
        b     = 32'd20;
        c     = 32'd30;

        start = 1'b1;

        @(negedge clk);

        start = 1'b0;


        wait(done);

        #1;

        $display("");
        $display("Test 2");
        $display("A = %0d", a);
        $display("B = %0d", b);
        $display("C = %0d", c);
        $display("Result = %0d", result);


        if (result == 64'd230)
            $display("PASS: Controller calculated 10 * 20 + 30 = 230");
        else
            $display("FAIL: Incorrect MAC result");


        // =====================================
        // FINAL RESULT
        // =====================================

        $display("");
        $display("========================================");

        if (result == 64'd230)
            $display("MAC CONTROLLER TEST: PASS");
        else
            $display("MAC CONTROLLER TEST: FAIL");

        $display("========================================");
        $display("");

        $finish;

    end

endmodule
