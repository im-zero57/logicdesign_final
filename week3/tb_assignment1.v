module	tb_as01;

reg		d		;
reg		clk		;

wire		q		;
wire		qbar		;

la_dff		dut(	.q	( q	),
			.qbar	( qbar	),
			.d	( d	),
			.clk	( clk	));

//----------------------------------------
// Stimulus
//----------------------------------------

	initial begin
		clk	= 1'b0		;
		d	= 1'b1		;
	end

	always begin
	#100
		clk	= 1'b1		;
		d	= 1'b1		;
	#100
		clk	= 1'b0		;
		d	= 1'b1		;
	#100
		clk	= 1'b1		;
		d	= 1'b0		;
	#100
		clk	= 1'b0		;
		d	= 1'b0		;
	#100
		clk	= 1'b1		;
		d	= 1'b0		;
	#100
		clk	= 1'b0		;
		d	= 1'b1		;
	#100
		clk	= 1'b1		;
		d	= 1'b1		;
	#100
		clk	= 1'b0		;
		d	= 1'b1		;
	#50
		clk	= 1'b0		;
		d	= 1'b0		;
	#50
		clk	= 1'b1		;
		d	= 1'b0		;
	#100
		clk	= 1'b0		;
		d	= 1'b0		;
	#100
		clk	= 1'b1		;
		d	= 1'b0		;
	#100
		$finish			;
	end

endmodule

