//--------------------------------
// practice 01
//--------------------------------

module tb_pr1;

wire	[7:0]	out1		;
wire	[7:0]	out2		;

reg	[2:0]	in		;
reg		en		;

dec3to8_shift	dut1(	.out	( out1	),
			.in	( in	),
			.en	( en	));

dec3to8_case	dut2(	.out	( out2	),
			.in	( in	),
			.en	( en	));

initial begin
#(0)	en = 1'b0	;
	in = 3'b000	;
#(10)	en = 1'b1	;
	in = 3'b000	;
#(10)	in = 3'b001	;
#(10)	in = 3'b010	;
#(10)	in = 3'b011	;
#(10)	in = 3'b100	;
#(10)	in = 3'b101	;
#(10)	in = 3'b110	;
#(10)	in = 3'b111	;

#(10) $finish		;

end

endmodule
//--------------------------------
// practice 02
//--------------------------------

module	tb_sequential	;

wire	q_latch		;
wire	q_dff_asyn	;
wire	q_dff_syn	;

reg	d		;
reg	clk		;
reg	rst_n		;

initial		clk = 1'b0	;
always	#(100)	clk = ~clk	;

//------------------
// instances
//------------------
d_latch		dut0(	.q	( q_latch	),
			.d	( d		),
			.clk	( clk		),
			.rst_n	( rst_n		));

dff_asyn	dut1(	.q	( q_dff_asyn	),
			.d	( d		),
			.clk	( clk		),
			.rst_n	( rst_n		));

dff_syn		dut2(	.q	( q_dff_syn	),
			.d	( d		),
			.clk	( clk		),
			.rst_n	( rst_n		));

//----------
//stimulus
//----------

initial begin
$display("===========================================")	;
$display("	rst_n	d	q0	q1	q2")	;
$display("===========================================")	;
#(0)	{rst_n, d} = 2'b00;
#(50)	{rst_n, d} = 2'b00;	#(50)	$display("	%d	%d	%d	%d	%d", rst_n,d,q_latch,q_dff_asyn,q_dff_syn);
#(50)	{rst_n, d} = 2'b10;	#(50)	$display("	%d	%d	%d	%d	%d", rst_n,d,q_latch,q_dff_asyn,q_dff_syn);
#(50)	{rst_n, d} = 2'b11;	#(50)	$display("	%d	%d	%d	%d	%d", rst_n,d,q_latch,q_dff_asyn,q_dff_syn);
#(50)	{rst_n, d} = 2'b10;	#(50)	$display("	%d	%d	%d	%d	%d", rst_n,d,q_latch,q_dff_asyn,q_dff_syn);
#(50)	{rst_n, d} = 2'b11;	#(50)	$display("	%d	%d	%d	%d	%d", rst_n,d,q_latch,q_dff_asyn,q_dff_syn);
#(50)	{rst_n, d} = 2'b10;	#(50)	$display("	%d	%d	%d	%d	%d", rst_n,d,q_latch,q_dff_asyn,q_dff_syn);
#(50)	$finish;	
end

endmodule