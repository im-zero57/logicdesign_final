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
			.i_nco_num	( 32'd5000	),
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


//-------------------------------------------
// hms_cnt
//-------------------------------------------

module	hms_cnt	(
			o_hms_cnt,
			o_max_hit,
			i_max_cnt,
			clk,
			rst_n);

output	[5:0]		o_hms_cnt	;
output			o_max_hit	;

input	[5:0]		i_max_cnt	;
input			clk		;
input			rst_n		;

reg	[5:0]		o_hms_cnt	;
reg			o_max_hit	;

always @(posedge clk or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		o_hms_cnt <= 6'd0;
		o_max_hit <= 1'b1;
	end else begin
		if(o_hms_cnt >= i_max_cnt) begin
			o_hms_cnt <= 6'd0;
			o_max_hit <= 1'b1;
		end else begin
			o_hms_cnt <= o_hms_cnt + 1'b1	;
			o_max_hit <= 1'b0		;
		end
	end
end

endmodule

//---------------------------------------
//minsec
//---------------------------------------

module	minsec( o_sec,
		o_min,
		o_max_hit_sec,
		o_max_hit_min,
		o_alarm,
		i_sec_clk,
		i_min_clk,
		i_alarm_sec_clk,
		i_alarm_min_clk,
		clk,
		rst_n);

output	[5:0]	o_sec		;
output	[5:0]	o_min		;
output		o_max_hit_sec	;
output		o_max_hit_min	;
output		o_alarm		;

input		i_sec_clk	;
input		i_min_clk	;
input		i_alarm_min_clk	;
input		i_alarm_sec_clk	;

input		clk		;
input		rst_n		;

parameter	MODE_CLOCK	= 2'b00	;
parameter	MODE_SETUP	= 2'b01	;
parameter	MODE_ALARM	= 2'b10	;
parameter	POS_SEC		= 1'b0	;
parameter	POS_MIN		= 1'b1	;

// MODE_CLOCK
wire	[5:0]	sec		;
wire		max_hit_cnt	;

has_cnt		u_hms_cnt_sec(
		.o_hms_cnt	( sec		),
		.o_max_hit	( o_max_hit_sec	),
		.i_max_cnt	( 6'd59		),
		.clk		( i_sec_clk	),
		.rst_n		( rst_n		));

wire	[5:0]	min		;
wire		max_hit_min	;

hms_cnt		u_hms_cnt_min(
		.o_hms_cnt	( min		),
		.o_max_hit	( o_max_hit_min	),
		.i_max_cnt	( 6'd59		),
		.clk		( o_min_clk	),
		.rst_n		( rst_n		));

wire	[5:0]	alarm_sec	;

//	MODE_ALARM
hms_cnt		u_hms_cnt_alarm_sec(
		.o_hms_cnt	( alarm_sec		),
		.o_max_hit	(			),
		.i_max_cnt	( 6'd59			),
		.clk		( i_alarm_sec_clk	),
		.rst_n		( rst_n			));

wire	[5:0]	alarm_min	;

hms_cnt		u_hms_cnt_alarm_min( 
		.o_hms_cnt	( alarm_min		),
		.o_max_hit	( 			),
		.i_max_cnt	( 6'd59			),
		.clk		( i_alarm_min_clk	),
		.rst_n		( rst_n			));

//MUX
reg	[5:0]	o_sec		;
reg	[5:0]	o_min		;
always @(*) begin
	case(i_mode)
		MODE_CLOCK:	begin
			o_sec	= sec ;
			o_min	= min ;
		end
		MODE_SETUP:	begin
			o_sec	= sec ;
			o_min	= min ;
		end
		MODE_ALARM:	begin
			o_sec	= alarm_sec ;
			o_min	= alarm_min ;
		end
	endcase
end

//Alarm
reg		o_alarm		;
always @( posedge clk or negedge rst_n)	begin
	if( rst_n==1'b0) begin
		o_alarm <=1'b0;
	end else begin
		if((sec == alarm_sec)&&(min == alarm_min)) begin
			o_alarm <= 1'b1 & i_alarm_en	;
		end else begin
			o_alarm <= o_alarm & i_alarm_en	;
		end
	end
end

endmodule

//-----------------------------
// debounce
//----------------------------
module debounce(
			o_sw,
			i_sw,
			clk);

output			o_sw		;

input			i_sw		;
input			clk		;

reg			dly1_sw		;
always @(posedge clk) begin
	dly1_sw <= i_sw			;
end

reg			dly2_sw		;
always @(posedge clk) begin
	dly2_sw <= dly1_sw		;
end

assign		o_sw = dly1_sw | ~dly2_sw;

endmodule

//------------------------------
//controller
//------------------------------

module	controller(	o_mode,
			o_position,
			o_min_clk,
			o_sec_clk,
			o_alarm_sec_clk;
			o_alarm_min_clk;
			i_sw0,
			i_sw1,
			i_sw2,
			i_sw3,
			i_max_hit_sec,
			i_max_hit_min,
			clk,
			rst_n);

output	[1:0]	o_mode		;
output		o_position	;
output		o_min_clk	;
output		o_sec_clk	;
output		o_alarm_sec_clk	;
output		o_alarm_min_clk	;

input		i_sw0		;
input		i_sw1		;
input		i_sw2		;
input		i_sw3		;
input		i_max_hit_sec	;
input 		i_max_hit_min	;
input		clk		;
input		rst_n		;

wire		clk_1hz		;
wire		clk_slow	;

wire		o_sw0		;
wire		o_sw1		;
wire		o_sw2		;
wire		o_sw3		;

nco		u1_nco( .o_gen_clk	( clk_slow	),
			.i_nco_num	( 32'd500000	),
			.clk		( clk		),
			.rst_n		( rst_n		));

nco		u2_nco(	.o_gen_clk	( clk_1hz	),
			.i_nco_num	( 32'd50000000	),
			.clk		( clk		),
			.rst_n		( rst_n		));

debounce	u0_deb(	.o_sw		( o_sw0		),
			.i_sw		( i_sw0		),
			.clk		( clk_slow	));

debounce	u1_deb(	.o_sw		( o_sw1		),
			.i_sw		( i_sw1		),
			.clk		( clk_slow	));

debounce	u2_deb(	.o_sw		( o_sw2		),
			.i_sw		( i_sw2		),
			.clk		( clk_slow	));

debounce	u3_deb( .o_sw		( o_sw3		),
			.i_sw		( i_sw3		),
			.clk		( clk_slow	));

parameter	MODE_CLOCK = 2'b00	;
parameter	MODE_SETUP = 2'b01	;
parameter	MODE_ALARM = 2'b10	;

parameter	POS_SEC	= 1'b0		;
parameter	POS_MIN	= 1'b1		;

reg	[1:0]	o_mode			;

always @(posedge o_sw0 or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		o_mode <= MODE_CLOCK	;
	end else begin
		if(o_mode >= MODE_ALARM) begin
			o_mode >= MODE_CLOCK	;
		end else begin
			o_mode <= o_mode +1'b1	;
		end
	end
end

reg		o_position		;

always @(posedge o_sw1 or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		o_position <= POS_SEC	;
	end else begin
		if(o_position >= POS_MIN) begin
			o_position <= POS_SEC ;
		end else begin
			o_position <= o_position + 1'b1	;
		end
	end
end

wire		clk_1hz		;
nco		u_nco(
		.o_gen_clk	( clk_1hz	),
		.i_nco_num	( 32'd50000000	),
		.clk		( clk		),
		.rst_n		( rst_n		));


reg		o_alarm_en		;
always @( posedge o_sw3 or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		o_alarm_en <= 1'b0;
	end else begin
		o_alarm_en <= o_alarm_en + 1'b1;
	end
end

reg		o_sec_clk		;
reg		o_min_clk		;
reg		o_alarm_sec_clk		;
reg		o_alarm_min_clk		;

always @(*) begin
	case(o_mode)
		MODE_CLOCK : begin
			o_sec_clk = clk_1hz		;
			o_min_clk = i_max_hit_sec	;
			o_alarm_sec_clk	= 1'b0		;
			o_alarm_min_clk = 1'b0		;
		end
		MODE_SETUP : begin
			case(o_position)
				POS_SEC : begin
					o_sec_clk = ~o_sw2	;
					o_min_clk = 1'b0	;
					o_alarm_sec_clk	= 1'b0	;
					o_alarm_min_clk	= 1'b0 	;
				end
				POS_MIN : begin
					o_sec_clk = 1'b0	;
					o_min_clk = ~o_sw2	;
					o_alarm_sec_clk	= 1'b0	;
					o_alarm_min_clk = 1'b0	;
				end
			endcase
		end
		MODE_ALARM : begin
			case(o_position)
				POS_SEC : begin
					o_sec_clk = clk_1hz	;
					o_min_clk = i_mix_hit_sec;
					o_alarm_sec_clk	= ~o_sw2;
					o_alarm_min_clk = 1'b0;
				end
				POS_MIN : begin
					o_sec_clk = clk_1hz	;
					o_min_clk = i_max_hit_sec;
					o_alarm_min_clk = ~o_sw2;
					o_alarm_sec_clk = 1'b0	;
				end
			endcase
		end
	endcase
end

endmodule

//-----------------------------------
// top_hms_clock
//-----------------------------------

module	top_hms_clock(	o_seg,
			o_seg_dp,
			o_seg_enb,
			i_sw0,
			i_sw1,
			i_sw2,
			clk,
			rst_n);

output	[6:0]		o_seg		;
output			o_seg_dp	;
output	[5:0]		o_seg_enb	;

input			i_sw0		;
input			i_sw1		;
input			i_sw2		;

input			clk		;
input			rst_n		;

wire			o_min_clk	;
wire			o_sec_clk	;
wire			mode		;
wire			position	;
wire			o_max_hit_min	;
wire			o_max_hit_sec	;

controller	u0_ctrl(	.o_mode		( mode	),
				.o_position	( position	) ,
				.o_min_clk	( o_min_clk	),
				.o_sec_clk	( o_sec_clk	),
				.i_sw0		( i_sw0		),
				.i_sw1		( i_sw1		),	
				.i_sw2		( i_sw2		),
				.i_max_hit_sec	( o_max_hit_sec	),
				.i_max_hit_min	( o_max_hit_min),
				.clk		( clk		),
				.rst_n		( rst_n		));

wire	[5:0]		o_min		;
wire	[5:0]		o_sec		;

minsec		u1_mins( 	.o_sec		( o_sec		),
				.o_min		( o_min		),
				.o_max_hit_sec	( o_max_hit_sec	),
				.o_max_hit_min	( o_max_hit_min	),
				.i_sec_clk	( o_sec_clk	),
				.i_min_clk	( o_min_clk	),
				.clk		( clk		),
				.rst_n		( rst_n		));

wire	[3:0]		o_left_sec	;
wire	[3:0]		o_right_sec	;

double_fig_sep		u0_dfs(
					.o_left		( o_left_sec	),
					.o_right	( o_right_sec	),
					.i_double_fig	( o_sec		));

wire	[3:0]		o_left_min	;
wire	[3:0]		o_right_min	;

double_fig_sep		d1_dfs(
					.o_left		( o_left_min	),
					.o_right	( o_right_min	),
					.i_double_fig	( o_min		));

wire	[6:0]		o_seg_leftsec	;

fnd_dec			u0_fnd_dec(	.o_seg	(o_seg_leftsec	),
					.i_num	(o_left_sec	));

wire	[6:0]		o_seg_rightsec	;

fnd_dec			u1_fnd_dec(	.o_seg	(o_seg_rightsec	),
					.i_num	(o_right_sec	));

wire	[6:0]		o_seg_leftmin	;

fnd_dec			u2_fnd_dec(	.o_seg	(o_seg_leftmin	),
					.i_num	(o_left_min	));

wire	[6:0]		o_seg_rightmin	;

fnd_dec			u3_fnd_dec(	.o_seg	(o_seg_rightmin	),
					.i_num	(o_right_min	));

wire	[41:0]		six_digit_seg	;
assign		six_digit_seg = {{4{7'b0000000}}, o_seg_leftmin, o_seg_rightmin, o_seg_leftsec, o_seg_rightsec};

led_disp		u0_led_disp(	.o_seg		( o_seg		),
					.o_seg_dp	( o_seg_dp	),
					.o_seg_enb	( o_seg_enb	),
					.i_six_digit_seg( six_digit_seg	),
					.i_six_dp	( 6'd0		),
					.clk		( clk		),
					.rst_n		( rst_n		));

endmodule
