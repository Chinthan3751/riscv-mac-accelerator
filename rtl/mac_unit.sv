module mac_unit (
    input  logic        clk,
    input  logic        reset,
    input  logic        enable,

    input  logic [31:0] a,
    input  logic [31:0] b,
    input  logic [31:0] c,

    output logic [63:0] result,
    output logic        done
);

    always_ff @(posedge clk or posedge reset) begin

        if (reset) begin
            result <= 64'd0;
            done   <= 1'b0;
        end

        else begin

            done <= 1'b0;

            if (enable) begin
                result <= (a * b) + c;
                done   <= 1'b1;
            end

        end
    end

endmodule
