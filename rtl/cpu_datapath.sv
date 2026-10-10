module cpu_datapath (
    input logic clk,
    input logic reset,

    input logic [31:0] instruction,

    input logic reg_write,
    input logic alu_src,
    input logic mem_read,
    input logic mem_write,
    input logic mem_to_reg,
    input logic jump,
    input logic jalr,

    // MAC write-back signals
    input logic mac_writeback,
    input logic [31:0] mac_writeback_data,

    input logic [31:0] pc_plus_4,

    input logic [31:0] data_mem_read_data,

    output logic [31:0] data_mem_address,
    output logic [31:0] data_mem_write_data,
    output logic [31:0] write_back_data,

    output logic [31:0] jalr_target
);

    // ========================================
    // INSTRUCTION FIELDS
    // ========================================

    logic [6:0] opcode;

    logic [4:0] rd;
    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [4:0] rs3;

    logic [2:0] funct3;
    logic [6:0] funct7;


    // ========================================
    // REGISTER FILE DATA
    // ========================================

    logic [31:0] register_data1;
    logic [31:0] register_data2;
    logic [31:0] register_data3;


    // ========================================
    // IMMEDIATE
    // ========================================

    logic [31:0] immediate;
    logic [1:0] imm_type;


    // ========================================
    // ALU
    // ========================================

    logic [31:0] alu_input_b;
    logic [31:0] alu_result;
    logic alu_zero;

    logic [3:0] alu_control_internal;


    // ========================================
    // INSTRUCTION DECODING
    // ========================================

    assign opcode = instruction[6:0];

    assign rd     = instruction[11:7];

    assign funct3 = instruction[14:12];

    assign rs1    = instruction[19:15];

    assign rs2    = instruction[24:20];

    // Custom MAC instruction uses bits [31:27] as rs3
    assign rs3    = instruction[31:27];

    assign funct7 = instruction[31:25];


    // ========================================
    // IMMEDIATE TYPE
    // ========================================

    always @(*) begin

        case (opcode)

            // I-type
            7'b0010011,
            7'b0000011,
            7'b1100111:
                imm_type = 2'b00;

            // S-type
            7'b0100011:
                imm_type = 2'b01;

            // B-type
            7'b1100011:
                imm_type = 2'b10;

            // J-type
            7'b1101111:
                imm_type = 2'b11;

            default:
                imm_type = 2'b00;

        endcase

    end


    // ========================================
    // IMMEDIATE GENERATOR
    // ========================================

    immediate_generator imm_gen (

        .instruction(instruction),

        .imm_type(imm_type),

        .immediate(immediate)

    );


    // ========================================
    // REGISTER FILE
    // ========================================

    register_file regs (

        .clk(clk),

        .reset(reset),

        .rs1(rs1),

        .rs2(rs2),

        .rs3(rs3),

        .rd(rd),

        .write_data(write_back_data),

        .reg_write(reg_write),

        .read_data1(register_data1),

        .read_data2(register_data2),

        .read_data3(register_data3)

    );


    // ========================================
    // ALU INPUT B
    // ========================================

    always @(*) begin

        if (alu_src)

            alu_input_b = immediate;

        else

            alu_input_b = register_data2;

    end


    // ========================================
    // ALU CONTROL
    // ========================================

    always @(*) begin

        case (opcode)

            // R-type instructions
            7'b0110011: begin

                case (funct3)

                    // ADD / SUB
                    3'b000: begin

                        if (funct7[5])

                            alu_control_internal = 4'b0001;

                        else

                            alu_control_internal = 4'b0000;

                    end

                    // AND
                    3'b111:

                        alu_control_internal = 4'b0010;

                    // OR
                    3'b110:

                        alu_control_internal = 4'b0011;

                    // XOR
                    3'b100:

                        alu_control_internal = 4'b0100;

                    // SLT
                    3'b010:

                        alu_control_internal = 4'b0101;

                    default:

                        alu_control_internal = 4'b0000;

                endcase

            end


            // ADDI
            // LW
            // SW
            // JALR

            7'b0010011,
            7'b0000011,
            7'b0100011,
            7'b1100111:

                alu_control_internal = 4'b0000;


            // BEQ

            7'b1100011:

                alu_control_internal = 4'b0001;


            default:

                alu_control_internal = 4'b0000;

        endcase

    end


    // ========================================
    // ALU
    // ========================================

    alu main_alu (

        .a(register_data1),

        .b(alu_input_b),

        .alu_control(alu_control_internal),

        .result(alu_result),

        .zero(alu_zero)

    );


    // ========================================
    // DATA MEMORY CONNECTIONS
    // ========================================

    assign data_mem_address = alu_result;

    assign data_mem_write_data = register_data2;


    // ========================================
    // JALR TARGET
    // ========================================

    assign jalr_target =
        (register_data1 + immediate) &
        32'hFFFFFFFE;


    // ========================================
    // WRITE-BACK MUX
    // ========================================

    always @(*) begin

        // MAC result has highest priority
        if (mac_writeback)

            write_back_data = mac_writeback_data;

        // JAL / JALR
        else if (jump || jalr)

            write_back_data = pc_plus_4;

        // LOAD
        else if (mem_to_reg)

            write_back_data = data_mem_read_data;

        // Normal ALU instruction
        else

            write_back_data = alu_result;

    end

endmodule
