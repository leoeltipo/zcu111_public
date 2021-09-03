import axi_vip_pkg::*;
import axi_mst_0_pkg::*;

module tb;

reg					s_axi_aclk;
reg					s_axi_aresetn;
wire [5:0]			s_axi_araddr;
wire [2:0]			s_axi_arprot;
wire				s_axi_arready;
wire				s_axi_arvalid;
wire [5:0]			s_axi_awaddr;
wire [2:0]			s_axi_awprot;
wire				s_axi_awready;
wire				s_axi_awvalid;
wire				s_axi_bready;
wire [1:0]			s_axi_bresp;
wire				s_axi_bvalid;
wire [31:0]			s_axi_rdata;
wire				s_axi_rready;
wire [1:0]			s_axi_rresp;
wire				s_axi_rvalid;
wire [31:0]			s_axi_wdata;
wire				s_axi_wready;
wire [3:0]			s_axi_wstrb;
wire				s_axi_wvalid;

reg					aclk;
reg					aresetn;

wire [32*16-1:0]	s_axis_tdata;
reg					s_axis_tvalid;
wire				s_axis_tready;

wire [32*16-1:0]	m_axis_tdata;
wire [16*16-1:0]	m_axis_tuser;
wire				m_axis_tvalid;
wire				m_axis_tlast;

xil_axi_prot_t  prot        = 0;
reg[31:0]       data_wr     = 32'h12345678;
reg[31:0]       data;
xil_axi_resp_t  resp;

reg	[15:0]	din_vi	[15:0];
reg	[15:0]	din_vq	[15:0];
wire [15:0]	dout_vi [15:0];
wire [15:0]	dout_vq [15:0];

// Input data.
genvar i;
generate;
	for (i=0; i<16; i=i+1) begin
		assign s_axis_tdata[i*16 		+: 16] = din_vi[i];
		assign s_axis_tdata[i*16+16*16 	+: 16] = din_vq[i];

		assign dout_vi[i] = m_axis_tdata[i*16		+: 16];	
		assign dout_vq[i] = m_axis_tdata[i*16+16*16	+: 16];	
	end
endgenerate

axi_mst_0 axi_mst_0_i
	(
		.aclk			(s_axi_aclk		),
		.aresetn		(s_axi_aresetn	),
		.m_axi_araddr	(s_axi_araddr	),
		.m_axi_arprot	(s_axi_arprot	),
		.m_axi_arready	(s_axi_arready	),
		.m_axi_arvalid	(s_axi_arvalid	),
		.m_axi_awaddr	(s_axi_awaddr	),
		.m_axi_awprot	(s_axi_awprot	),
		.m_axi_awready	(s_axi_awready	),
		.m_axi_awvalid	(s_axi_awvalid	),
		.m_axi_bready	(s_axi_bready	),
		.m_axi_bresp	(s_axi_bresp	),
		.m_axi_bvalid	(s_axi_bvalid	),
		.m_axi_rdata	(s_axi_rdata	),
		.m_axi_rready	(s_axi_rready	),
		.m_axi_rresp	(s_axi_rresp	),
		.m_axi_rvalid	(s_axi_rvalid	),
		.m_axi_wdata	(s_axi_wdata	),
		.m_axi_wready	(s_axi_wready	),
		.m_axi_wstrb	(s_axi_wstrb	),
		.m_axi_wvalid	(s_axi_wvalid	)
	);

axis_xfft_16x32768 DUT
	(
		// AXI Slave I/F for configuration.
		.s_axi_aclk		(s_axi_aclk		),
		.s_axi_aresetn	(s_axi_aresetn	),
		.s_axi_araddr	(s_axi_araddr	),
		.s_axi_arprot	(s_axi_arprot	),
		.s_axi_arready	(s_axi_arready	),
		.s_axi_arvalid	(s_axi_arvalid	),
		.s_axi_awaddr	(s_axi_awaddr	),
		.s_axi_awprot	(s_axi_awprot	),
		.s_axi_awready	(s_axi_awready	),
		.s_axi_awvalid	(s_axi_awvalid	),
		.s_axi_bready	(s_axi_bready	),
		.s_axi_bresp	(s_axi_bresp	),
		.s_axi_bvalid	(s_axi_bvalid	),
		.s_axi_rdata	(s_axi_rdata	),
		.s_axi_rready	(s_axi_rready	),
		.s_axi_rresp	(s_axi_rresp	),
		.s_axi_rvalid	(s_axi_rvalid	),
		.s_axi_wdata	(s_axi_wdata	),
		.s_axi_wready	(s_axi_wready	),
		.s_axi_wstrb	(s_axi_wstrb	),
		.s_axi_wvalid	(s_axi_wvalid	),

		// Reset and clock.
		.aclk			(aclk			),
		.aresetn		(aresetn		),

		// s_axis for input.
  		.s_axis_tdata	(s_axis_tdata 	),
  		.s_axis_tvalid	(s_axis_tvalid	),
  		.s_axis_tready	(s_axis_tready	),

		// m_axis for output.
  		.m_axis_tdata	(m_axis_tdata	),
		.m_axis_tuser	(m_axis_tuser	),
  		.m_axis_tvalid	(m_axis_tvalid	),
  		.m_axis_tlast	(m_axis_tlast	)
	);

// VIP Agents
axi_mst_0_mst_t 	axi_mst_0_agent;

initial begin
	// Create agents.
	axi_mst_0_agent 	= new("axi_mst_0 VIP Agent",tb.axi_mst_0_i.inst.IF);

	// Set tag for agents.
	axi_mst_0_agent.set_agent_tag	("axi_mst_0 VIP");

	// Start agents.
	axi_mst_0_agent.start_master();

	s_axi_aresetn	<= 0;
	aresetn			<= 0;
	s_axis_tvalid	<= 0;
	#300;
	s_axi_aresetn	<= 1;
	aresetn			<= 1;

	#1000;

	// scaling.
	data_wr = 1234;
	axi_mst_0_agent.AXI4LITE_WRITE_BURST(0, prot, data_wr, resp);
	#10;

	// we.
	data_wr = 1;
	axi_mst_0_agent.AXI4LITE_WRITE_BURST(4, prot, data_wr, resp);
	#10;

	// we.
	data_wr = 0;
	axi_mst_0_agent.AXI4LITE_WRITE_BURST(4, prot, data_wr, resp);
	#10;

	#1000;

	// Inject data.
	for (int i=0; i<20; i=i+1) begin
		for (int j=0; j<32768; j=j+1) begin
			@(posedge aclk);
				for (int k=0; k<16; k=k+1) begin
					din_vi[k] <= j;
					din_vq[k] <= j;
					s_axis_tvalid	<= 1;
				end
		end
		@(posedge aclk);
		s_axis_tvalid	<= 0;

		#500;
	end

end

always begin
	s_axi_aclk	<= 0;
	#3;
	s_axi_aclk	<= 1;
	#3;
end

always begin
	aclk	<= 0;
	#5;
	aclk	<= 1;
	#5;
end

endmodule

