//----------------------------------
// nco
//----------------------------------

module	nco(	o_gen_clk,
		i_nco_num,
		clk,
		rst_n);

output		o_gen_clk	;

input	[31:0]	i_nco_num	;
input		clk		;
input		rst_n		;

reg	[31:0]	cnt		;
reg		o_gen_clk	;

always @(posedge clk or negedge rst_n)	begin
	if(rst_n == 1'b0) begin
		cnt		<= 32'd0	;
		o_gen_clk	<= 1'd0		;
	end else begin
		if(cnt >=i_nco_num/2-1) begin
			cnt		<= 32'd0	;
			o_gen_clk	<= ~o_gen_clk	;
		end else begin
			cnt <= cnt + 1'b1	;
		end
	end
end

endmodule

//-----------------------------
//counter
//----------------------------

module	cnt60(	out,
		clk,
		rst_n);

output	[5:0]	out		;
input		clk		;
input		rst_n		;

reg	[5:0]	out		;
always @(posedge clk or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		out <= 6'd0	;
	end else begin
		if(out >= 6'd59) begin
			out <= 6'd0	;
		end else begin
			out <= out+1'b1	;
		end
	end
end

endmodule

//----------------------------
// nco_cnt
//----------------------------

module	nco_cnt(	o_nco_cnt,
			i_nco_num,
			clk,
			rst_n);

output	[5:0]		o_nco_cnt	;
input	[31:0]		i_nco_num	;
input			clk		;
input			rst_n		;

wire			clk_gen	;	//output of nco

nco		nco_u0(	.o_gen_clk	( clk_gen	),
			.i_nco_num	( i_nco_num	),
			.clk		( clk		),
			.rst_n		( rst_n		));

cnt60		cnt_u1(	.out	( o_nco_cnt	),
			.clk	( clk_gen	),
			.rst_n	( rst_n		));

endmodule


//-----------------------------
//double figure separate
//-----------------------------

module double_fig_sep(
			o_left,
			o_right,
			i_double_fig);

output	[3:0]		o_left		;
output	[3:0]		o_right		;

input	[5:0]		i_double_fig	;

assign	o_left	=	i_double_fig/10	;
assign	o_right	=	i_double_fig%10	;

endmodule

//-----------------------------
//fnd_dec
//-----------------------------

module	fnd_dec(	o_seg,
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
	endcase
end

endmodule
		
		
//---------------------------------
//led_disp
//---------------------------------

module	led_disp(	o_seg,
			o_seg_dp,
			o_seg_enb,
			i_six_digit_seg,
			i_six_dp,
			clk,
			rst_n);

output	[5:0]		o_seg_enb		;
output			o_seg_dp		;
output	[6:0]		o_seg			;

input	[41:0]		i_six_digit_seg		;
input	[5:0]		i_six_dp		;
input			clk			;
input			rst_n			;

wire			gen_clk			;

nco		u_nco(	.o_gen_clk	( gen_clk	),
			.i_nco_num	( 32'd1000	),
			.clk		( clk		),
			.rst_n		( rst_n		));

reg	[3:0]		cnt_common_node		;

always @(posedge gen_clk or negedge rst_n )begin
	if(rst_n == 1'b0) begin
		cnt_common_node	<= 4'd0		;
	end else begin
		if(cnt_common_node >= 4'd5) begin
			cnt_common_node <= 4'd0;
		end else begin
			cnt_common_node	<= cnt_common_node +1'b1	;
		end
	end
end

reg	[5:0]		o_seg_enb		;

always @(cnt_common_node) begin
	case (cnt_common_node)
		4'd0	: o_seg_enb = 6'b111110;
		4'd1	: o_seg_enb = 6'b111101;
		4'd2	: o_seg_enb = 6'b111011;
		4'd3	: o_seg_enb = 6'b110111;
		4'd4	: o_seg_enb = 6'b101111;
		4'd5	: o_seg_enb = 6'b011111;
	endcase
end

reg			o_seg_dp		;

always @(cnt_common_node) begin
	case(cnt_common_node)
		4'd0	: o_seg_dp = i_six_dp[0];
		4'd1	: o_seg_dp = i_six_dp[1];
		4'd2	: o_seg_dp = i_six_dp[2];
		4'd3	: o_seg_dp = i_six_dp[3];
		4'd4	: o_seg_dp = i_six_dp[4];
		4'd5	: o_seg_dp = i_six_dp[5];
	endcase
end

reg	[6:0]		o_seg			;

always @(cnt_common_node) begin
	case(cnt_common_node)
		4'd0	: o_seg = i_six_digit_seg[6:0]	;
		4'd1	: o_seg = i_six_digit_seg[13:7]	;
		4'd2	: o_seg = i_six_digit_seg[20:14];
		4'd3	: o_seg	= i_six_digit_seg[27:21];
		4'd4	: o_seg = i_six_digit_seg[34:28];
		4'd5	: o_seg = i_six_digit_seg[41:35];
	endcase
end

endmodule

//-----------------------------
//top_nco_cnt_disp
//-----------------------------

module	top_nco_cnt_disp(	o_seg,
				o_seg_dp,
				o_seg_enb,
				clk,
				rst_n);

output	[6:0]		o_seg		;
output			o_seg_dp	;
output	[5:0]		o_seg_enb	;

input			clk		;
input			rst_n		;

wire	[5:0]		number		;	//all number 0~59

nco_cnt		u_nco_cnt(	.o_nco_cnt	( number	),
				.i_nco_num	( 32'd50000000	),
				.clk		( clk		),
				.rst_n		( rst_n		));

wire	[3:0]		ten		;	//for left seg
wire	[3:0]		one		;	//for right seg

double_fig_sep		u_double_Fig_sep(	.o_left	( ten		),
						.o_right( one		),
						.i_double_fig( number	));

wire	[6:0]		seg_left	;	//for left seg 
wire	[6:0]		seg_right	;	//for right seg

fnd_dec			u_0_fnd_dec(	.o_seg( seg_left),
					.i_num(	ten	));

fnd_dec			u_1_fnd_dec(	.o_seg( seg_right	),
					.i_num( one		));

wire	[41:0]		six_digit_seg	;
//assign			six_digit_seg = { {4{7'b0000000}}, seg_left, seg_right};
//assign			six_digit_seg = { {4{7'b1110111}}, seg_left, seg_right};
assign			six_digit_seg = {3{seg_left, seg_right}};



led_disp		u_0_led_disp(	.o_seg		( o_seg		),
					.o_seg_dp	( o_seg_dp	),
					.o_seg_enb	( o_seg_enb	),
					.i_six_digit_seg( six_digit_seg	),
					.i_six_dp	( 6'd0		),
					.clk		( clk		),
					.rst_n		( rst_n		));

endmodule
