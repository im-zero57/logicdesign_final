module	tb_as02	;
//-------------------------------
// instances
//-------------------------------


reg			clk	;
reg			rst_n	;

wire	[3:0]		cnt	;

counter		dut_1(	.cnt	( cnt	),
			.clk	( clk	),
			.rst_n	( rst_n	));

//------------------------------
// stimulus
//------------------------------

initial begin
	clk = 1'b0;
end

always begin
	#(10) clk = ~clk	;
end

initial begin
	rst_n = 1'b0;
#(10)
	rst_n = 1'b1;
#(1000)	$finish;
end

endmodule

