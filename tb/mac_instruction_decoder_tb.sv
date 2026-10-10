`timescale 1ns/1ps

module mac_instruction_decoder_tb;

    logic [31:0] instruction;

    logic        is_mac;
    logic [4:0]  rd;
    logic [4:0]  rs1;
    logic [4:0]  rs2;
    logic [4:0]  rs3;


    mac_instruction_decoder dut (
        .instruction(instruction),

        .is_mac(is_mac),

        .rd(rd),
        .rs1(rs1),
        .rs2(rs2),
        .rs3(rs3)
    );


    initial begin

        $dumpfile("mac_instruction_decoder.vcd");
        $dumpvars(0, mac_instruction_decoder_tb);


        // =================================================
        // TEST 1
        // MAC x10, x1, x2, x3
        //
        // rs3 = x3
        // rs2 = x2
        // rs1 = x1
        // rd  = x10
        // =================================================

        instruction = 32'd0;

        instruction[31:27] = 5'd3;     // rs3
        instruction[24:20] = 5'd2;     // rs2
        instruction[19:15] = 5'd1;     // rs1
        instruction[11:7]  = 5'd10;    // rd
        instruction[6:0]   = 7'b0001011;

        #10;


        $display("");
        $display("========================================");
        $display("       MAC INSTRUCTION DECODER");
        $display("========================================");

        $display("Instruction = %h", instruction);

        $display("is_mac = %b", is_mac);
        $display("rd  = x%0d", rd);
        $display("rs1 = x%0d", rs1);
        $display("rs2 = x%0d", rs2);
        $display("rs3 = x%0d", rs3);


        if (is_mac == 1'b1)
            $display("PASS: MAC instruction detected");
        else
            $display("FAIL: MAC instruction not detected");


        if (rd == 5'd10)
            $display("PASS: rd decoded correctly");
        else
            $display("FAIL: rd incorrect");


        if (rs1 == 5'd1)
            $display("PASS: rs1 decoded correctly");
        else
            $display("FAIL: rs1 incorrect");


        if (rs2 == 5'd2)
            $display("PASS: rs2 decoded correctly");
        else
            $display("FAIL: rs2 incorrect");


        if (rs3 == 5'd3)
            $display("PASS: rs3 decoded correctly");
        else
            $display("FAIL: rs3 incorrect");


        // =================================================
        // TEST 2
        // Normal ADD instruction
        //
        // Should NOT be detected as MAC
        // =================================================

        instruction = 32'h002082B3;

        #10;


        $display("");
        $display("Test 2: Normal RISC-V instruction");

        $display("Instruction = %h", instruction);
        $display("is_mac = %b", is_mac);


        if (is_mac == 1'b0)
            $display("PASS: Normal instruction rejected");
        else
            $display("FAIL: Normal instruction incorrectly detected");


        // =================================================
        // FINAL RESULT
        // =================================================

        $display("");
        $display("========================================");

        if ((is_mac == 1'b0))
            $display("MAC DECODER TEST: PASS");
        else
            $display("MAC DECODER TEST: FAIL");

        $display("========================================");
        $display("");

        $finish;

    end

endmodule
