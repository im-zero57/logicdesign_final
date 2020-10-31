//---------------------------------
// MUX (Dataflow)
//---------------------------------

module 	mux2(	y,
		d0,
		d1,
		s)	;

parameter	N = 1	;

output	[N-1:0]	y	;	//output
input	[N-1:0]	d0	;	//input d0
input	[N-1:0]	d1	;	//input d1
input		s	;	//select

assign		y= s? d1:d0	;

endmodule

//---------------------------------
// 4:1 MUX
//---------------------------------

module mux4_inst(	y,
			d,
			s)	;

output		y	;	//output
input	[3:0]	d	;	//input d0,d1,d2,d3
input	[1:0]	s	;	//select which input can be the result

wire	[1:0]	convey	;	//convey output from first 2:1mux to last 2:1mux

mux2	mux_u0	(	.y( convey[0]	),
			.d0( d[0]	),
			.d1( d[1]	),
			.s ( s[0]	));

mux2	mux_u1	(	.y( convey[1]	),
			.d0( d[2]	),
			.d1( d[3]	),
			.s( s[0]	));

mux2	mux_u2	(	.y( y		),
			.d0( convey[0]	),
			.d1( convey[1]	),
			.s( s[1]	));

endmodule

