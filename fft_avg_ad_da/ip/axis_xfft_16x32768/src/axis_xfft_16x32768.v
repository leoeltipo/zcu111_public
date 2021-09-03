// This block integrates 16 XFFT blocks, 32768 points each.
// Scaling and forward/inverse FFT are all controlled together.
module axis_xfft_16x32768
	(
		// AXI Slave I/F for configuration.
		s_axi_aclk		,
		s_axi_aresetn	,

		s_axi_awaddr	,
		s_axi_awprot	,
		s_axi_awvalid	,
		s_axi_awready	,

		s_axi_wdata		,
		s_axi_wstrb		,
		s_axi_wvalid	,
		s_axi_wready	,

		s_axi_bresp		,
		s_axi_bvalid	,
		s_axi_bready	,

		s_axi_araddr	,
		s_axi_arprot	,
		s_axi_arvalid	,
		s_axi_arready	,

		s_axi_rdata		,
		s_axi_rresp		,
		s_axi_rvalid	,
		s_axi_rready	,

		// s_axis_* and m_axis_* reset and clock.
		aclk			,
		aresetn			,

		// s_axis for input.
  		s_axis_tdata	,
  		s_axis_tvalid	,
  		s_axis_tready	,

		// m_axis for output.
  		m_axis_tdata	,
		m_axis_tuser	,
  		m_axis_tvalid	,
  		m_axis_tlast
	);

/**************/
/* Parameters */
/**************/
// Number of parallel inputs.
localparam N = 16;

// Number of bits of I/Q parts.
localparam B = 16;

/*********/
/* Ports */
/*********/
input					s_axi_aclk;
input					s_axi_aresetn;

input	[5:0]			s_axi_awaddr;
input	[2:0]			s_axi_awprot;
input					s_axi_awvalid;
output					s_axi_awready;

input	[31:0]			s_axi_wdata;
input	[3:0]			s_axi_wstrb;
input					s_axi_wvalid;
output					s_axi_wready;

output	[1:0]			s_axi_bresp;
output					s_axi_bvalid;
input					s_axi_bready;

input	[5:0]			s_axi_araddr;
input	[2:0]			s_axi_arprot;
input					s_axi_arvalid;
output					s_axi_arready;

output	[31:0]			s_axi_rdata;
output	[1:0]			s_axi_rresp;
output					s_axi_rvalid;
input					s_axi_rready;

input					aclk;
input					aresetn;

input	[32*16-1:0]		s_axis_tdata;
input					s_axis_tvalid;
output					s_axis_tready;

output	[32*16-1:0]		m_axis_tdata;
output	[15:0]			m_axis_tuser;
output					m_axis_tvalid;
output					m_axis_tlast;

/********************/
/* Internal signals */
/********************/
// Registers.
wire	[31:0]	SCALE_REG;
wire			WE_REG;

// xfft configuration interface.
wire	[23:0]	axis_cfg_tdata;
wire			axis_cfg_tvalid;
wire	[N-1:0]	axis_cfg_tready;

// Vectors for input/output.
wire	[31:0]	din_v 	[N-1:0];
wire	[31:0]	dout_v	[N-1:0];
wire	[15:0]	tuser_v	[N-1:0];

// Valid/last.
wire	[N-1:0]	valid_i;
wire	[N-1:0]	last_i;

/**********************/
/* Begin Architecture */
/**********************/
// AXI Slave.
axi_slv axi_slv_i
	(
		.aclk			(s_axi_aclk	 	),
		.aresetn		(s_axi_aresetn	),

		// Write Address Channel.
		.awaddr			(s_axi_awaddr 	),
		.awprot			(s_axi_awprot 	),
		.awvalid		(s_axi_awvalid	),
		.awready		(s_axi_awready	),

		// Write Data Channel.
		.wdata			(s_axi_wdata	),
		.wstrb			(s_axi_wstrb	),
		.wvalid			(s_axi_wvalid   ),
		.wready			(s_axi_wready	),

		// Write Response Channel.
		.bresp			(s_axi_bresp	),
		.bvalid			(s_axi_bvalid	),
		.bready			(s_axi_bready	),

		// Read Address Channel.
		.araddr			(s_axi_araddr 	),
		.arprot			(s_axi_arprot 	),
		.arvalid		(s_axi_arvalid	),
		.arready		(s_axi_arready	),

		// Read Data Channel.
		.rdata			(s_axi_rdata	),
		.rresp			(s_axi_rresp	),
		.rvalid			(s_axi_rvalid	),
		.rready			(s_axi_rready	),

		// Registers.
		.SCALE_REG		(SCALE_REG		),
		.WE_REG			(WE_REG	 		)
	);

ctrl ctrl_i
	(
		// Reset and clock.
		.clk			(aclk				),
		.rstn			(aresetn			),

		// m_axis for config.
		.m_axis_tdata	(axis_cfg_tdata		),
		.m_axis_tvalid	(axis_cfg_tvalid	),
		.m_axis_tready	(axis_cfg_tready[0]	),

		// Registers.
		.SCALE_REG		(SCALE_REG			),
		.WE_REG			(WE_REG				)
	);


genvar i;
generate
	for (i=0; i<N; i=i+1) begin
		// Slice input.
		assign din_v[i][15:0]	= s_axis_tdata	[i*B		+: B];
		assign din_v[i][31:16] 	= s_axis_tdata	[i*B+N*B	+: B];

		// Instantiate XFFT blocks.
		xfft_0 fft_i 
			(
				.aclk							(aclk				),
		  		.s_axis_config_tdata			(axis_cfg_tdata		),
		  		.s_axis_config_tvalid			(axis_cfg_tvalid	),
		  		.s_axis_config_tready			(axis_cfg_tready[i]	),
		  		.s_axis_data_tdata				(din_v[i]			),
		  		.s_axis_data_tvalid				(s_axis_tvalid		),
		  		.s_axis_data_tready				(					),
		  		.s_axis_data_tlast				(1'b0				),
		  		.m_axis_data_tdata				(dout_v[i]			),
				.m_axis_data_tuser				(tuser_v[i]			),
		  		.m_axis_data_tvalid				(valid_i[i]			),
		  		.m_axis_data_tready				(1'b1				),
		  		.m_axis_data_tlast				(last_i[i]			),
		  		.event_frame_started			(					),
		  		.event_tlast_unexpected			(					),
		  		.event_tlast_missing			(					),
		  		.event_status_channel_halt		(					),
		  		.event_data_in_channel_halt		(					),
		  		.event_data_out_channel_halt	(					)
			);

		// Build output.
		assign m_axis_tdata	[i*B 		+: B]	= dout_v[i][15:0];
		assign m_axis_tdata	[i*B+N*B 	+: B] 	= dout_v[i][31:16];
	
	end
endgenerate

// Assign outputs.
assign s_axis_tready 	= 1'b1;
assign m_axis_tuser		= tuser_v[0];
assign m_axis_tvalid 	= valid_i[0];
assign m_axis_tlast		= last_i[0];

endmodule

