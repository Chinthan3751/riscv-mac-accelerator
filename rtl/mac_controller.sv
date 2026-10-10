module mac_controller (
    input  logic        clk,
    input  logic        reset,

    // Control
    input  logic        start,

    // Operands
    input  logic [31:0] a,
    input  logic [31:0] b,
    input  logic [31:0] c,

    // MAC interface
    output logic        mac_enable,
    output logic [31:0] mac_a,
    output logic [31:0] mac_b,
    output logic [31:0] mac_c,

    input  logic [63:0] mac_result,
    input  logic        mac_done,

    // Controller outputs
    output logic [63:0] result,
    output logic        done,
    output logic        busy
);

    typedef enum logic [1:0] {
        IDLE,
        EXECUTE,
        COMPLETE
    } state_t;

    state_t state;

    always_ff @(posedge clk or posedge reset) begin

        if (reset) begin

            state      <= IDLE;

            mac_enable <= 1'b0;

            mac_a      <= 32'd0;
            mac_b      <= 32'd0;
            mac_c      <= 32'd0;

            result     <= 64'd0;
            done       <= 1'b0;
            busy       <= 1'b0;

        end

        else begin

            // Default values
            mac_enable <= 1'b0;
            done       <= 1'b0;

            case (state)

                // --------------------------------
                // IDLE
                // --------------------------------
                IDLE: begin

                    busy <= 1'b0;

                    if (start) begin

                        // Store operands
                        mac_a <= a;
                        mac_b <= b;
                        mac_c <= c;

                        busy  <= 1'b1;

                        state <= EXECUTE;

                    end

                end


                // --------------------------------
                // EXECUTE
                // --------------------------------
                EXECUTE: begin

                    busy       <= 1'b1;

                    mac_enable <= 1'b1;

                    if (mac_done) begin

                        result <= mac_result;

                        state <= COMPLETE;

                    end

                end


                // --------------------------------
                // COMPLETE
                // --------------------------------
                COMPLETE: begin

                    busy <= 1'b0;
                    done <= 1'b1;

                    state <= IDLE;

                end


                default: begin

                    state <= IDLE;
                    busy  <= 1'b0;
                    done  <= 1'b0;

                end

            endcase

        end

    end

endmodule
