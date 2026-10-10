module immediate_generator (
    input  logic [31:0] instruction,
    input  logic [1:0]  imm_type,
    output logic [31:0] immediate
);

    always @(*) begin

        case (imm_type)

            // I-type immediate
            2'b00: begin
                immediate = {{20{instruction[31]}},
                             instruction[31:20]};
            end

            // S-type immediate
            2'b01: begin
                immediate = {{20{instruction[31]}},
                             instruction[31:25],
                             instruction[11:7]};
            end

            // B-type immediate
            2'b10: begin
                immediate = {{19{instruction[31]}},
                             instruction[31],
                             instruction[7],
                             instruction[30:25],
                             instruction[11:8],
                             1'b0};
            end

            // J-type immediate for JAL
            2'b11: begin
                immediate = {{11{instruction[31]}},
                             instruction[31],
                             instruction[19:12],
                             instruction[20],
                             instruction[30:21],
                             1'b0};
            end

            default: begin
                immediate = 32'd0;
            end

        endcase

    end

endmodule
