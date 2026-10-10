`timescale 1ns/1ps

module cpu_datapath_tb;

    logic        clk;
    logic        reset;

    logic [31:0] instruction;

    logic        reg_write;
    logic        alu_src;
    logic        mem_read;
    logic        mem_write;
    logic        mem_to_reg;

    logic [31:0] data_mem_address;
    logic [31:0] data_mem_write_data;
    logic [31:0] data_mem_read_data;

    logic [31:0] write_back_data;


    // =========================================================
    // CPU DATAPATH
    // =========================================================

    cpu_datapath dut (
        .clk(clk),
        .reset(reset),
        .instruction(instruction),

        .reg_write(reg_write),
        .alu_src(alu_src),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),

        .data_mem_address(data_mem_address),
        .data_mem_write_data(data_mem_write_data),
        .data_mem_read_data(data_mem_read_data),

        .write_back_data(write_back_data)
    );


    // =========================================================
    // CLOCK
    // =========================================================

    always #5 clk = ~clk;


    // =========================================================
    // TEST
    // =========================================================

    initial begin

        $dumpfile("cpu_datapath.vcd");
        $dumpvars(0, cpu_datapath_tb);

        clk = 1'b0;
        reset = 1'b1;

        instruction = 32'd0;

        reg_write = 1'b0;
        alu_src = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b0;
        mem_to_reg = 1'b0;

        data_mem_read_data = 32'd0;


        // =====================================================
        // RESET
        // =====================================================

        @(posedge clk);

        reset = 1'b0;

        @(negedge clk);


        // =====================================================
        // TEST 1: ADDI
        //
        // ADDI x1, x0, 10
        //
        // x1 = 0 + 10
        // =====================================================

        $display("");
        $display("========================================");
        $display("TEST 1: ADDI");
        $display("========================================");

        instruction = 32'h00A00093;

        reg_write = 1'b1;
        alu_src = 1'b1;
        mem_read = 1'b0;
        mem_write = 1'b0;
        mem_to_reg = 1'b0;

        @(posedge clk);
        #1;

        $display("ADDI result = %0d (0x%08h)",
                 write_back_data,
                 write_back_data);

        if (write_back_data == 32'd10)
            $display("PASS");
        else
            $display("FAIL");

        @(negedge clk);


        // =====================================================
        // TEST 2: ADD
        //
        // ADD x3, x1, x1
        //
        // x3 = 10 + 10
        // Expected = 20
        // =====================================================

        $display("");
        $display("========================================");
        $display("TEST 2: ADD");
        $display("========================================");

        instruction = 32'h001081B3;

        reg_write = 1'b1;
        alu_src = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b0;
        mem_to_reg = 1'b0;

        @(posedge clk);
        #1;

        $display("ADD result = %0d (0x%08h)",
                 write_back_data,
                 write_back_data);

        if (write_back_data == 32'd20)
            $display("PASS");
        else
            $display("FAIL");

        @(negedge clk);


        // =====================================================
        // TEST 3: SUB
        //
        // SUB x4, x3, x1
        //
        // x4 = 20 - 10
        // Expected = 10
        // =====================================================

        $display("");
        $display("========================================");
        $display("TEST 3: SUB");
        $display("========================================");

        instruction = 32'h40118233;

        reg_write = 1'b1;
        alu_src = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b0;
        mem_to_reg = 1'b0;

        @(posedge clk);
        #1;

        $display("SUB result = %0d (0x%08h)",
                 write_back_data,
                 write_back_data);

        if (write_back_data == 32'd10)
            $display("PASS");
        else
            $display("FAIL");

        @(negedge clk);


        // =====================================================
        // TEST 4: AND
        //
        // AND x5, x1, x3
        //
        // 10 & 20 = 0
        // =====================================================

        $display("");
        $display("========================================");
        $display("TEST 4: AND");
        $display("========================================");

        instruction = 32'h0030F2B3;

        reg_write = 1'b1;
        alu_src = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b0;
        mem_to_reg = 1'b0;

        @(posedge clk);
        #1;

        $display("AND result = %0d (0x%08h)",
                 write_back_data,
                 write_back_data);

        if (write_back_data == 32'd0)
            $display("PASS");
        else
            $display("FAIL");

        @(negedge clk);


        // =====================================================
        // TEST 5: OR
        //
        // OR x6, x1, x3
        //
        // 10 | 20 = 30
        // =====================================================

        $display("");
        $display("========================================");
        $display("TEST 5: OR");
        $display("========================================");

        instruction = 32'h0030E333;

        reg_write = 1'b1;
        alu_src = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b0;
        mem_to_reg = 1'b0;

        @(posedge clk);
        #1;

        $display("OR result = %0d (0x%08h)",
                 write_back_data,
                 write_back_data);

        if (write_back_data == 32'd30)
            $display("PASS");
        else
            $display("FAIL");

        @(negedge clk);


        // =====================================================
        // TEST 6: XOR
        //
        // XOR x7, x1, x3
        //
        // 10 ^ 20 = 30
        // =====================================================

        $display("");
        $display("========================================");
        $display("TEST 6: XOR");
        $display("========================================");

        instruction = 32'h0030C3B3;

        reg_write = 1'b1;
        alu_src = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b0;
        mem_to_reg = 1'b0;

        @(posedge clk);
        #1;

        $display("XOR result = %0d (0x%08h)",
                 write_back_data,
                 write_back_data);

        if (write_back_data == 32'd30)
            $display("PASS");
        else
            $display("FAIL");

        @(negedge clk);


        // =====================================================
        // TEST 7: SLT
        //
        // SLT x8, x1, x3
        //
        // 10 < 20 = 1
        // =====================================================

        $display("");
        $display("========================================");
        $display("TEST 7: SLT");
        $display("========================================");

        instruction = 32'h0030A433;

        reg_write = 1'b1;
        alu_src = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b0;
        mem_to_reg = 1'b0;

        @(posedge clk);
        #1;

        $display("SLT result = %0d (0x%08h)",
                 write_back_data,
                 write_back_data);

        if (write_back_data == 32'd1)
            $display("PASS");
        else
            $display("FAIL");

        @(negedge clk);


        // =====================================================
        // TEST 8: SW
        //
        // SW x3, 8(x1)
        //
        // Address = x1 + 8
        //         = 10 + 8
        //         = 18
        //
        // Write data = x3 = 20
        // =====================================================

        $display("");
        $display("========================================");
        $display("TEST 8: SW");
        $display("========================================");

        instruction = 32'h0030A423;

        reg_write = 1'b0;
        alu_src = 1'b1;
        mem_read = 1'b0;
        mem_write = 1'b1;
        mem_to_reg = 1'b0;

        @(negedge clk);
        #1;

        $display("SW address    = %0d (0x%08h)",
                 data_mem_address,
                 data_mem_address);

        $display("SW write data = %0d (0x%08h)",
                 data_mem_write_data,
                 data_mem_write_data);

        if ((data_mem_address == 32'd18) &&
            (data_mem_write_data == 32'd20))
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // TEST 9: LW
        //
        // LW x9, 8(x1)
        //
        // Address = x1 + 8
        //         = 18
        //
        // Memory returns 100
        // =====================================================

        $display("");
        $display("========================================");
        $display("TEST 9: LW");
        $display("========================================");

        instruction = 32'h0080A483;

        reg_write = 1'b1;
        alu_src = 1'b1;
        mem_read = 1'b1;
        mem_write = 1'b0;
        mem_to_reg = 1'b1;

        data_mem_read_data = 32'd100;

        @(negedge clk);
        #1;

        $display("LW address    = %0d (0x%08h)",
                 data_mem_address,
                 data_mem_address);

        $display("LW write-back = %0d (0x%08h)",
                 write_back_data,
                 write_back_data);

        if ((data_mem_address == 32'd18) &&
            (write_back_data == 32'd100))
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // FINISH
        // =====================================================

        $display("");
        $display("========================================");
        $display("CPU DATAPATH TEST COMPLETE");
        $display("========================================");

        $finish;

    end

endmodule
