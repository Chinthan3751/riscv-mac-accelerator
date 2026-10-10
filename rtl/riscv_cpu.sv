    module riscv_cpu (
    input logic clk,
    input logic reset,

    output logic [31:0] pc_out,
    output logic [31:0] instruction_out,
    output logic [31:0] mac_result_out,
    output logic        mac_busy_out,
    output logic        mac_done_out
    );
    // ========================================
    // PROGRAM COUNTER
    // ========================================

    logic [31:0] pc;
    logic [31:0] pc_next;

    logic [31:0] instruction;


    // ========================================
    // CONTROL SIGNALS
    // ========================================

    logic reg_write;
    logic alu_src;
    logic mem_read;
    logic mem_write;
    logic mem_to_reg;

    logic branch;
    logic jump;
    logic jalr;

    logic [3:0] alu_control;


    // ========================================
    // DATA MEMORY
    // ========================================

    logic [31:0] data_mem_address;
    logic [31:0] data_mem_write_data;
    logic [31:0] data_mem_read_data;


    // ========================================
    // WRITE BACK
    // ========================================

    logic [31:0] write_back_data;


    // ========================================
    // INSTRUCTION FIELDS
    // ========================================

    logic [6:0] opcode;

    logic [4:0] rd;
    logic [4:0] rs1;
    logic [4:0] rs2;

    logic [2:0] funct3;
    logic [6:0] funct7;


    // ========================================
    // BRANCH / JUMP
    // ========================================

    logic [31:0] branch_immediate;
    logic [31:0] jump_immediate;

    logic [31:0] jalr_target;

    logic branch_taken;


    // ========================================
    // MAC SIGNALS
    // ========================================

    logic is_mac;

    logic [4:0] mac_rd;
    logic [4:0] mac_rs1;
    logic [4:0] mac_rs2;
    logic [4:0] mac_rs3;

    logic mac_start;
    logic mac_done;
    logic mac_busy;

    logic [63:0] mac_result;

    logic mac_writeback;

    logic [31:0] mac_writeback_data;


    // ========================================
    // INSTRUCTION DECODING
    // ========================================

    assign opcode = instruction[6:0];

    assign rd = instruction[11:7];

    assign funct3 = instruction[14:12];

    assign rs1 = instruction[19:15];

    assign rs2 = instruction[24:20];

    assign funct7 = instruction[31:25];


    // ========================================
    // PROGRAM COUNTER WRITE
    // ========================================

    // Normal instructions:
    // PC advances every cycle.
    //
    // MAC instruction:
    // PC stays still while MAC is busy.
    // PC advances when MAC completes.

    logic pc_write;

    assign pc_write =
        !is_mac ||
        mac_done;


    // ========================================
    // PROGRAM COUNTER
    // ========================================

    program_counter pc_unit (

        .clk(clk),

        .reset(reset),

        .pc_write(pc_write),

        .pc_next(pc_next),

        .pc(pc)

    );


    // ========================================
    // INSTRUCTION MEMORY
    // ========================================

    instruction_memory instruction_mem (

        .address(pc),

        .instruction(instruction)

    );


    // ========================================
    // CONTROL UNIT
    // ========================================

    control_unit control (

        .opcode(opcode),

        .funct3(funct3),

        .funct7_bit5(funct7[5]),

        .reg_write(reg_write),

        .alu_src(alu_src),

        .mem_read(mem_read),

        .mem_write(mem_write),

        .mem_to_reg(mem_to_reg),

        .branch(branch),

        .jump(jump),

        .jalr(jalr),

        .alu_control(alu_control)

    );


    // ========================================
    // MAC INSTRUCTION DECODER
    // ========================================

    mac_instruction_decoder mac_decoder (

        .instruction(instruction),

        .is_mac(is_mac),

        .rd(mac_rd),

        .rs1(mac_rs1),

        .rs2(mac_rs2),

        .rs3(mac_rs3)

    );


    // ========================================
    // MAC START
    // ========================================

    // Start MAC only once for the instruction.

    assign mac_start =
        is_mac &&
        !mac_busy &&
        !mac_done;


    // ========================================
    // MAC WRITE BACK
    // ========================================

    assign mac_writeback =
        is_mac &&
        mac_done;


    // MAC accelerator produces 64-bit result.
    // RV32 register file is 32-bit.
    //
    // Therefore lower 32 bits are written to rd.

    assign mac_writeback_data =
        mac_result[31:0];


    // ========================================
    // CPU DATAPATH
    // ========================================

    cpu_datapath datapath (

        .clk(clk),

        .reset(reset),

        .instruction(instruction),

        // Normal register write OR MAC write
        .reg_write(
            reg_write || mac_writeback
        ),

        .alu_src(alu_src),

        .mem_read(mem_read),

        .mem_write(mem_write),

        .mem_to_reg(mem_to_reg),

        .jump(jump),

        .jalr(jalr),

        // MAC write-back
        .mac_writeback(mac_writeback),

        .mac_writeback_data(
            mac_writeback_data
        ),

        .pc_plus_4(
            pc + 32'd4
        ),

        .data_mem_read_data(
            data_mem_read_data
        ),

        .data_mem_address(
            data_mem_address
        ),

        .data_mem_write_data(
            data_mem_write_data
        ),

        .write_back_data(
            write_back_data
        ),

        .jalr_target(
            jalr_target
        )

    );


    // ========================================
    // MAC EXECUTION UNIT
    // ========================================

    mac_execution_unit mac_unit (

        .clk(clk),

        .reset(reset),

        .start(mac_start),

        // Register values from CPU
        .rs1_data(
            datapath.register_data1
        ),

        .rs2_data(
            datapath.register_data2
        ),

        .rs3_data(
            datapath.register_data3
        ),

        .result(mac_result),

        .done(mac_done),

        .busy(mac_busy)

    );


    // ========================================
    // DATA MEMORY
    // ========================================

    data_memory data_mem (

        .clk(clk),

        .reset(reset),

        .mem_read(mem_read),

        .mem_write(mem_write),

        .address(data_mem_address),

        .write_data(data_mem_write_data),

        .read_data(data_mem_read_data)

    );


    // ========================================
    // BRANCH IMMEDIATE
    // ========================================

    assign branch_immediate =

        {{19{instruction[31]}},

         instruction[31],

         instruction[7],

         instruction[30:25],

         instruction[11:8],

         1'b0};


    // ========================================
    // JUMP IMMEDIATE
    // ========================================

    assign jump_immediate =

        {{11{instruction[31]}},

         instruction[31],

         instruction[19:12],

         instruction[20],

         instruction[30:21],

         1'b0};


    // ========================================
    // BRANCH REGISTER DATA
    // ========================================

    logic [31:0] branch_rs1_data;
    logic [31:0] branch_rs2_data;


    assign branch_rs1_data =
        datapath.register_data1;


    assign branch_rs2_data =
        datapath.register_data2;


    // ========================================
    // BEQ
    // ========================================

    assign branch_taken =

        branch &&

        (funct3 == 3'b000) &&

        (branch_rs1_data == branch_rs2_data);


    // ========================================
    // NEXT PC LOGIC
    // ========================================

    always @(*) begin

        // Default:
        // move to next instruction

        pc_next = pc + 32'd4;


        // ------------------------------------
        // MAC
        // ------------------------------------

        if (is_mac) begin

            // MAC still running
            if (!mac_done)

                pc_next = pc;

            // MAC completed
            else

                pc_next = pc + 32'd4;
           pc_next[1:0] = 2'b00;
        end


        // ------------------------------------
        // JALR
        // ------------------------------------

        else if (jalr) begin

            pc_next = jalr_target;

        end


        // ------------------------------------
        // JAL
        // ------------------------------------

        else if (jump) begin

            pc_next =
                pc + jump_immediate;

        end


        // ------------------------------------
        // BEQ
        // ------------------------------------

        else if (branch_taken) begin

            pc_next =
                pc + branch_immediate;

        end

    end
    assign pc_out          = pc;
    assign instruction_out = instruction;
    assign mac_result_out  = mac_result[31:0];
    assign mac_busy_out    = mac_busy;
    assign mac_done_out    = mac_done;
endmodule
