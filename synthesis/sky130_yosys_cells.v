module sky130_fd_sc_hd__and2_1(output X, input A, input B);
assign X = A & B;
endmodule

module sky130_fd_sc_hd__or2_1(output X, input A, input B);
assign X = A | B;
endmodule

module sky130_fd_sc_hd__xor2_1(output X, input A, input B);
assign X = A ^ B;
endmodule

module sky130_fd_sc_hd__inv_1(output Y, input A);
assign Y = ~A;
endmodule

module sky130_fd_sc_hd__mux2_1(output X, input A0, input A1, input S);
assign X = S ? A1 : A0;
endmodule

module sky130_fd_sc_hd__dfxtp_1(output reg Q, input CLK, input D);
always @(posedge CLK)
    Q <= D;
endmodule

module sky130_fd_sc_hd__dfrtp_1(
    output reg Q,
    input CLK,
    input D,
    input RESET_B
);
always @(posedge CLK or negedge RESET_B) begin
    if (!RESET_B)
        Q <= 1'b0;
    else
        Q <= D;
end
endmodule
