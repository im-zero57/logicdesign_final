
//-------------------------------
// practice 1 nco tb
//-------------------------------

`timescale 1ns/1ns

module	tb_pr1	;

wire		clk_gen		;

reg	[31:0]	num		;
reg		clk		;
reg		rst_n		;

parameter	tCK = 1000/1	;

initial
	clk = 1'b0		;

always
	#(tCK/2) clk = ~clk	;

nco	dut(	.clk_gen	( clk_gen	),
		.num		( 32'd1000000	),
		.clk		( clk		),
		.rst_n		( rst_n		));

initial begin
	#(00*tCK)	rst_n = 1'b0	;
	#(10*tCK)	rst_n = 1'b1	;
	#(2000000*tCK)
		$finish;

end

endmodule

//-----------------------------------
// practice 02 counter tb
//-----------------------------------

module	tb_cnt	;

parameter	tCK = 1000/50	; //50MHz clock

reg		clk		;
reg		rst_n		;

wire	[5:0]	out		;

initial
		clk = 1'b0	;
always
	#(tCK/2)clk = ~clk	;

cnt60	dut1(	.out	( out	),
		.clk	( clk	),
		.rst_n	( rst_n	));

initial begin
#(0*tCK)	rst_n	= 1'b0	;
#(1*tCK)	rst_n	= 1'b1	;
#(100*tCK)	$finish		;

end

endmodule
