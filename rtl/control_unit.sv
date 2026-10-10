module control_unit (
    input  logic [6:0] opcode,
    input  logic [2:0] funct3,
    input  logic       funct7_bit5,

    output logic       reg_write,
    output logic       alu_src,
    output logic       mem_read,
    output logic       mem_write,
    output logic       mem_to_reg,
    output logic       branch,
    output logic       jump,
    output logic       jalr,
    output logic [3:0] alu_control
);

    always_comb begin

        reg_write   = 1'b0;
        alu_src     = 1'b0;
        mem_read    = 1'b0;
        mem_write   = 1'b0;
        mem_to_reg  = 1'b0;
        branch      = 1'b0;
        jump        = 1'b0;
        jalr        = 1'b0;
        alu_control = 4'b0000;

        case (opcode)

            // R-type instructions
            7'b0110011: begin

                reg_write = 1'b1;
                alu_src   = 1'b0;

                case (funct3)

                    // ADD / SUB
                    3'b000: begin
                        if (funct7_bit5)
                            alu_control = 4'b0001;   // SUB
                        else
                            alu_control = 4'b0000;   // ADD
                    end

                    // AND
                    3'b111:
                        alu_control = 4'b0010;

                    // OR
                    3'b110:
                        alu_control = 4'b0011;

                    // XOR
                    3'b100:
                        alu_control = 4'b0100;

                    // SLT
                    3'b010:
                        alu_control = 4'b0101;

                    default:
                        alu_control = 4'b0000;

                endcase
            end


            // ADDI
            7'b0010011: begin

                reg_write   = 1'b1;
                alu_src     = 1'b1;
                alu_control = 4'b0000;

            end


            // LW
            7'b0000011: begin

                reg_write   = 1'b1;
                alu_src     = 1'b1;
                mem_read    = 1'b1;
                mem_to_reg  = 1'b1;
                alu_control = 4'b0000;

            end


            // SW
            7'b0100011: begin

                alu_src     = 1'b1;
                mem_write   = 1'b1;
                alu_control = 4'b0000;

            end


            // BEQ
            7'b1100011: begin

                branch      = 1'b1;
                alu_src     = 1'b0;
                alu_control = 4'b0001;

            end


            // JAL
            7'b1101111: begin

                reg_write = 1'b1;
                jump      = 1'b1;

            end


            // JALR
            7'b1100111: begin

                reg_write = 1'b1;
                alu_src   = 1'b1;
                jalr      = 1'b1;

            end


            // Default
            default: begin

                reg_write   = 1'b0;
                alu_src     = 1'b0;
                mem_read    = 1'b0;
                mem_write   = 1'b0;
                mem_to_reg  = 1'b0;
                branch      = 1'b0;
                jump        = 1'b0;
                jalr        = 1'b0;
                alu_control = 4'b0000;

            end

        endcase
    end

endmodule
