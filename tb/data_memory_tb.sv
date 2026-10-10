`timescale 1ns/1ps

module data_memory_tb;

    logic        clk;
    logic        reset;
    logic        mem_read;
    logic        mem_write;
    logic [31:0] address;
    logic [31:0] write_data;
    logic [31:0] read_data;

    data_memory dut (
        .clk(clk),
        .reset(reset),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .address(address),
        .write_data(write_data),
        .read_data(read_data)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin

        $dumpfile("data_memory.vcd");
        $dumpvars(0, data_memory_tb);

        clk = 0;
        reset = 1;
        mem_read = 0;
        mem_write = 0;
        address = 32'd0;
        write_data = 32'd0;

        // --------------------------------
        // Reset memory
        // --------------------------------
        #10;
        reset = 0;

        // --------------------------------
        // Write 1234 to address 0
        // --------------------------------
        address = 32'd0;
        write_data = 32'd1234;
        mem_write = 1;

        #10;

        mem_write = 0;

        // --------------------------------
        // Read address 0
        // --------------------------------
        mem_read = 1;

        #5;

        $display("Address = %0d : Read Data = %0d (0x%08h)",
                 address, read_data, read_data);

        // --------------------------------
        // Write 5678 to address 4
        // --------------------------------
        mem_read = 0;
        address = 32'd4;
        write_data = 32'd5678;
        mem_write = 1;

        #10;

        mem_write = 0;

        // --------------------------------
        // Read address 4
        // --------------------------------
        mem_read = 1;

        #5;

        $display("Address = %0d : Read Data = %0d (0x%08h)",
                 address, read_data, read_data);

        // --------------------------------
        // Test read disabled
        // --------------------------------
        mem_read = 0;

        #5;

        $display("Read disabled : Read Data = %0d (0x%08h)",
                 read_data, read_data);

        // --------------------------------
        // End simulation
        // --------------------------------
        $finish;

    end

endmodule
