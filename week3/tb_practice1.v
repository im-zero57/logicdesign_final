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