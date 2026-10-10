module mac_instruction_decoder (
    input  logic [31:0] instruction,

    output logic        is_mac,
    output logic [4:0]  rd,
    output logic [4:0]  rs1,
    output logic [4:0]  rs2,
    output logic [4:0]  rs3
);

    // Custom MAC opcode
    localparam logic [6:0] MAC_OPCODE = 7'b0001011;

    // Register fields
    assign rd  = instruction[11:7];
    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];
    assign rs3 = instruction[31:27];

    // MAC instruction detection
    assign is_mac = (instruction[6:0] == MAC_OPCODE);

endmodule
