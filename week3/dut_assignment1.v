//----------------------------------------------
// SR Latch based DFF Design(Gate Level)
//----------------------------------------------

module	la_dff	(	q,
			qbar,
			d,
			clk);

	output		q		;
	output		qbar		;

	input		d		;	//data
	input		clk		;	//clock

	wire		clkbar		;	//~clk
	wire		dbar		;	//~d
	
	wire		node1		;	//output of nandgate input d and clk
	wire		node2		;	//output of nandgate input dbar and clk

	wire		s		;	//output of nandgate input node1 and node4
	wire		r		;	//output of nandgate input node2 and node3

	wire		node5		;	//output of nandgate input node3 and clkbar
	wire		node6		;	//output of nandgate input node4 and clkbar

	not		NOT_U0(dbar, d)			;
	not		NOT_U1(clkbar, clk)		;

	nand		NAND_U0(node1, d, clk)		;
	nand		NAND_U1(node2, dbar, clk)	;

	nand		NAND_U2(s, node1, r)		;
	nand		NAND_U3(r, node2, s)		;

	nand		NAND_U4(node5, s, clkbar)	;
	nand		NAND_U5(node6, r, clkbar)	;

	nand		NAND_U6(q, node5, qbar)		;
	nand		NAND_U7(qbar, node6, q)		;

endmodule

