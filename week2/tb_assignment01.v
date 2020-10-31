module tb_as01		;
//-------------------------------------
// instances
//-------------------------------------

reg	[3:0]	d	; //input
reg	[1:0]	s	; //select

wire		y	; //output

mux4_inst	dut_1	(	.y ( y ),
				.d ( d ),
				.s ( s ));

//-----------------------------------------
// stimulus
//-----------------------------------------

initial begin
	$display("4:1MUX output : y")						;
	$display("==========================================================")	;
	$display("	d0	d1	d2	d3	s[0]	s[1]	y")	;
	$display("==========================================================")	;
	#(50) {s, d} = $random(); #(50)	$display("	%d\t%d\t%d\t%d\t%d\t%d\t%d",d[0],d[1],d[2],d[3],s[0],s[1],y);
	#(50) {s, d} = $random(); #(50)	$display("	%d\t%d\t%d\t%d\t%d\t%d\t%d",d[0],d[1],d[2],d[3],s[0],s[1],y);
	#(50) {s, d} = $random(); #(50)	$display("	%d\t%d\t%d\t%d\t%d\t%d\t%d",d[0],d[1],d[2],d[3],s[0],s[1],y);
	#(50) {s, d} = $random(); #(50)	$display("	%d\t%d\t%d\t%d\t%d\t%d\t%d",d[0],d[1],d[2],d[3],s[0],s[1],y);
	#(50) {s, d} = $random(); #(50)	$display("	%d\t%d\t%d\t%d\t%d\t%d\t%d",d[0],d[1],d[2],d[3],s[0],s[1],y);
	#(50) {s, d} = $random(); #(50)	$display("	%d\t%d\t%d\t%d\t%d\t%d\t%d",d[0],d[1],d[2],d[3],s[0],s[1],y);
	#(50) {s, d} = $random(); #(50)	$display("	%d\t%d\t%d\t%d\t%d\t%d\t%d",d[0],d[1],d[2],d[3],s[0],s[1],y);
	#(50) {s, d} = $random(); #(50)	$display("	%d\t%d\t%d\t%d\t%d\t%d\t%d",d[0],d[1],d[2],d[3],s[0],s[1],y);
	#(50) {s, d} = $random(); #(50)	$display("	%d\t%d\t%d\t%d\t%d\t%d\t%d",d[0],d[1],d[2],d[3],s[0],s[1],y);
	#(50) {s, d} = $random(); #(50)	$display("	%d\t%d\t%d\t%d\t%d\t%d\t%d",d[0],d[1],d[2],d[3],s[0],s[1],y);
	#(50) {s, d} = $random(); #(50)	$display("	%d\t%d\t%d\t%d\t%d\t%d\t%d",d[0],d[1],d[2],d[3],s[0],s[1],y);
	#(50)	$finish	;
end

endmodule

