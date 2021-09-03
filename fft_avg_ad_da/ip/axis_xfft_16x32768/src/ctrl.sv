module ctrl 
	(
		// Reset and clock.
		clk				,
		rstn			,

		// m_axis for config.
		m_axis_tdata	,
		m_axis_tvalid	,
		m_axis_tready	,

		// Registers.
		SCALE_REG		,
		WE_REG
	);

/*********/
/* Ports */
/*********/
input			clk;
input			rstn;

output	[23:0]	m_axis_tdata;
output			m_axis_tvalid;
input			m_axis_tready;

input	[31:0]	SCALE_REG;
input			WE_REG;

/********************/
/* Internal signals */
/********************/
// States.
typedef enum	{	INIT_ST	,
					REG_ST	,
					CFG_ST	,
					END_ST
				} state_t;

// State register.
(* fsm_encoding = "one_hot" *) state_t state;

reg				reg_state;
reg				valid_i;

// Registers.
reg		[31:0]	SCALE_REG_r;
wire			WE_REG_resync;


/**********************/
/* Begin Architecture */
/**********************/

// WE_REG_resync.
synchronizer_n WE_REG_resync_i
	(
		.rstn	    (rstn			),
		.clk 		(clk			),
		.data_in	(WE_REG			),
		.data_out	(WE_REG_resync	)
	);

// Registers.
always @(posedge clk) begin
	if (~rstn) begin
		// State register.
		state 			<= INIT_ST;

		// Registers.
		SCALE_REG_r		<= 0;
	end
	else begin
		// State register.
		case (state)
			INIT_ST:
				if (WE_REG_resync == 1'b1)
					state <= REG_ST;

			REG_ST:
				state <= CFG_ST;

			CFG_ST:
				if ( m_axis_tready )
					state <= END_ST;

			END_ST:
				if (WE_REG_resync == 1'b0)
					state <= INIT_ST;
		endcase

		// Registers.
		if (reg_state == 1'b1)
			SCALE_REG_r		<= SCALE_REG;

	end
end 

// FSM outputs.
always_comb	begin
	// Default.
	reg_state	= 0;
	valid_i 	= 0;

	case (state)
		//INIT_ST:

		REG_ST:
			reg_state	= 1;

		CFG_ST:
			valid_i 	= 1;

		//END_ST:
	endcase
end

// Assign outputs.
assign	m_axis_tdata	= {SCALE_REG_r[22:0],1'b1};	// Scale FFT, Forward FFT.
assign	m_axis_tvalid	= valid_i;

endmodule

