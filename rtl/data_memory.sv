module data_memory (
    input  logic        clk,
    input  logic        reset,
    input  logic        mem_read,
    input  logic        mem_write,
    input  logic [31:0] address,
    input  logic [31:0] write_data,
    output logic [31:0] read_data
);

    logic [31:0] memory [0:255];

    integer i;

    // Reset memory
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 256; i = i + 1)
                memory[i] <= 32'd0;
        end
        else if (mem_write) begin
            memory[address[9:2]] <= write_data;
        end
    end

    // Read operation
    always @(*) begin
        if (mem_read)
            read_data = memory[address[9:2]];
        else
            read_data = 32'd0;
    end

endmodule
