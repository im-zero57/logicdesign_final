//--------------------------------------------------
// practice 03 Flexible Numeric Display Decoder
//--------------------------------------------------

module	fnd_dec	(	o_seg,
			i_num);

output	[6:0]		o_seg	;
input	[3:0]		i_num	;

reg	[6:0]		o_seg	;

always @(*) begin
	case (i_num)
		4'b0000 : o_seg = 7'b1111110	;
		4'b0001 : o_seg = 7'b0110000	;
		4'b0010	: o_seg = 7'b1101101	;
		4'b0011 : o_seg = 7'b1111001	;
		4'b0100 : o_seg = 7'b0110011	;
		4'b0101	: o_seg = 7'b1011011	;
		4'b0110	: o_seg = 7'b1011111	;
		4'b0111	: o_seg = 7'b1110000	;
		4'b1000	: o_seg = 7'b1111111	;
		4'b1001	: o_seg = 7'b1110011	;
		4'b1010	: o_seg = 7'b1110111	;
		4'b1011	: o_seg = 7'b1111111	;
		4'b1100	: o_seg = 7'b1001110	;
		4'b1101	: o_seg = 7'b1111110	;
		4'b1110 : o_seg = 7'b1001111	;
		4'b1111	: o_seg = 7'b1000110	;
	endcase
end

endmodule
		
		
module	fnd_dec_fpga(	o_com,
			o_seg);

output	[5:0]		o_com		;
output	[6:0]		o_seg		;

assign		o_com = 6'b010_101	;
fnd_dec		u_fmd_dec(	.o_seg	(o_seg	),
				.i_num	(3	));

endmodule
