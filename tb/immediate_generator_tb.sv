`timescale 1ns/1ps

module immediate_generator_tb;

    logic [31:0] instruction;
    logic [1:0]  imm_type;
    logic [31:0] immediate;

    immediate_generator dut (
        .instruction(instruction),
        .imm_type(imm_type),
        .immediate(immediate)
    );

    initial begin

        $dumpfile("immediate_generator.vcd");
        $dumpvars(0, immediate_generator_tb);

        // --------------------------------
        // I-TYPE: ADDI +10
        // --------------------------------
        imm_type = 2'b00;
        instruction = 32'h00A10113;
        #10;

        $display("I-TYPE +10 : immediate = %0d (0x%08h)",
                 $signed(immediate), immediate);


        // --------------------------------
        // I-TYPE: ADDI -5
        // --------------------------------
        instruction = 32'hFFB10113;
        #10;

        $display("I-TYPE -5  : immediate = %0d (0x%08h)",
                 $signed(immediate), immediate);


        // --------------------------------
        // S-TYPE: SW +20
        // --------------------------------
        imm_type = 2'b01;
        instruction = 32'h00112A23;
        #10;

        $display("S-TYPE +20 : immediate = %0d (0x%08h)",
                 $signed(immediate), immediate);


        // --------------------------------
        // B-TYPE: BEQ +16
        // --------------------------------
        imm_type = 2'b10;
        instruction = 32'h00208863;
        #10;

        $display("B-TYPE +16 : immediate = %0d (0x%08h)",
                 $signed(immediate), immediate);


        // --------------------------------
        // DEFAULT
        // --------------------------------
        imm_type = 2'b11;
        #10;

        $display("DEFAULT    : immediate = %0d (0x%08h)",
                 $signed(immediate), immediate);


        $finish;

    end

endmodule
