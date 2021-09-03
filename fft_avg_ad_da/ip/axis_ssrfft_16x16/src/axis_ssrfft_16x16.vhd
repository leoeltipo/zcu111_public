----------------------------------
--- Top level of 16x16 SSR FFT ---
----------------------------------
-- Block defined for the following parameters:
--
-- NFFT	= 16
-- SSR 	= 16
-- B 	= 16
--
-- Input/output width:
-- 2*SSR*B
--
-- Parameters are defined as constants with in/out width
-- hardcoded. This is to hide generics.
--
-- Registers:
-- * SCALE_REG : to scale individual FFT stages.
-- 	* 0 : do not scale stage.
-- 	* 1 : scale stage.
--
-- * QOUT_REG : to select output quantization. Indicates
-- the LSB index.
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity axis_ssrfft_16x16 is
    Port
    (
		-- AXI-Lite Slave I/F.
		s_axi_aclk		: in std_logic;
		s_axi_aresetn	: in std_logic;

		s_axi_awaddr	: in std_logic_vector(5 downto 0);
		s_axi_awprot	: in std_logic_vector(2 downto 0);
		s_axi_awvalid	: in std_logic;
		s_axi_awready	: out std_logic;

		s_axi_wdata		: in std_logic_vector(31 downto 0);
		s_axi_wstrb		: in std_logic_vector(3 downto 0);
		s_axi_wvalid	: in std_logic;
		s_axi_wready	: out std_logic;

		s_axi_bresp		: out std_logic_vector(1 downto 0);
		s_axi_bvalid	: out std_logic;
		s_axi_bready	: in std_logic;

		s_axi_araddr	: in std_logic_vector(5 downto 0);
		s_axi_arprot	: in std_logic_vector(2 downto 0);
		s_axi_arvalid	: in std_logic;
		s_axi_arready	: out std_logic;

		s_axi_rdata		: out std_logic_vector(31 downto 0);
		s_axi_rresp		: out std_logic_vector(1 downto 0);
		s_axi_rvalid	: out std_logic;
		s_axi_rready	: in std_logic;

		-- Reset and clock.
		aresetn			: in std_logic;
		aclk			: in std_logic;

		-- AXIS Slave.
		s_axis_tdata	: in std_logic_vector (2*16*16-1 downto 0);
		s_axis_tvalid	: in std_logic;
		s_axis_tready	: out std_logic;

		-- AXIS Master.
		m_axis_tdata	: out std_logic_vector (2*16*16-1 downto 0);
		m_axis_tvalid	: out std_logic
    );
end entity;

architecture rtl of axis_ssrfft_16x16 is

-- Constants.
constant NFFT 	: Integer := 16;
constant SSR 	: Integer := 16;
constant B		: Integer := 16;

-- AXI Slave.
component axi_slv is
	Generic 
	(
		DATA_WIDTH	: integer	:= 32;
		ADDR_WIDTH	: integer	:= 6
	);
	Port 
	(
		aclk		: in std_logic;
		aresetn		: in std_logic;

		-- Write Address Channel.
		awaddr		: in std_logic_vector(ADDR_WIDTH-1 downto 0);
		awprot		: in std_logic_vector(2 downto 0);
		awvalid		: in std_logic;
		awready		: out std_logic;

		-- Write Data Channel.
		wdata		: in std_logic_vector(DATA_WIDTH-1 downto 0);
		wstrb		: in std_logic_vector((DATA_WIDTH/8)-1 downto 0);
		wvalid		: in std_logic;
		wready		: out std_logic;

		-- Write Response Channel.
		bresp		: out std_logic_vector(1 downto 0);
		bvalid		: out std_logic;
		bready		: in std_logic;

		-- Read Address Channel.
		araddr		: in std_logic_vector(ADDR_WIDTH-1 downto 0);
		arprot		: in std_logic_vector(2 downto 0);
		arvalid		: in std_logic;
		arready		: out std_logic;

		-- Read Data Channel.
		rdata		: out std_logic_vector(DATA_WIDTH-1 downto 0);
		rresp		: out std_logic_vector(1 downto 0);
		rvalid		: out std_logic;
		rready		: in std_logic;

		-- Registers.
		SCALE_REG	: out std_logic_vector (31 downto 0);
		QOUT_REG	: out std_logic_vector (31 downto 0)
	);
end component;

-- SSR FFT.
component ssrfft_16x16 is
	Generic
	(
		NFFT	: Integer := 16;
		SSR		: Integer := 4;
		B		: Integer := 16
	);
    Port
    (
		-- Reset and clock.
		aresetn			: in std_logic;
		aclk			: in std_logic;

		-- AXIS Slave.
		s_axis_tdata	: in std_logic_vector (2*SSR*B-1 downto 0);
		s_axis_tvalid	: in std_logic;

		-- AXIS Master.
		m_axis_tdata	: out std_logic_vector (2*SSR*B-1 downto 0);
		m_axis_tvalid	: out std_logic;

		-- Registers.
		SCALE_REG		: in std_logic_vector (31 downto 0);
		QOUT_REG		: in std_logic_vector (31 downto 0)
    );
end component;

-- Registers.
signal SCALE_REG	: std_logic_vector (31 downto 0);
signal QOUT_REG		: std_logic_vector (31 downto 0);

begin

-- AXI Slave.
axi_slv_i : axi_slv
	Port map
	(
		aclk		=> s_axi_aclk	 	,
		aresetn		=> s_axi_aresetn	,

		-- Write Address Channel.
		awaddr		=> s_axi_awaddr 	,
		awprot		=> s_axi_awprot 	,
		awvalid		=> s_axi_awvalid	,
		awready		=> s_axi_awready	,

		-- Write Data Channel.
		wdata		=> s_axi_wdata		,
		wstrb		=> s_axi_wstrb		,
		wvalid		=> s_axi_wvalid		,
		wready		=> s_axi_wready		,

		-- Write Response Channel.
		bresp		=> s_axi_bresp		,
		bvalid		=> s_axi_bvalid		,
		bready		=> s_axi_bready		,

		-- Read Address Channel.
		araddr		=> s_axi_araddr 	,
		arprot		=> s_axi_arprot 	,
		arvalid		=> s_axi_arvalid	,
		arready		=> s_axi_arready	,

		-- Read Data Channel.
		rdata		=> s_axi_rdata		,
		rresp		=> s_axi_rresp		,
		rvalid		=> s_axi_rvalid		,
		rready		=> s_axi_rready		,

		-- Registers.
		SCALE_REG	=> SCALE_REG		,
		QOUT_REG	=> QOUT_REG
	);

-- SSR FFT.
fft_i : ssrfft_16x16
	Generic map
	(
		NFFT	=> NFFT	,
		SSR		=> SSR	,
		B		=> B
	)
    Port map
    (
		-- Reset and clock.
		aresetn			=> aresetn			,
		aclk			=> aclk				,

		-- AXIS Slave.
		s_axis_tdata	=> s_axis_tdata 	,
		s_axis_tvalid	=> s_axis_tvalid	,

		-- AXIS Master.
		m_axis_tdata	=> m_axis_tdata 	,
		m_axis_tvalid	=> m_axis_tvalid	,

		-- Registers.
		SCALE_REG		=> SCALE_REG		,
		QOUT_REG		=> QOUT_REG
    );

-- Always ready.
s_axis_tready	<= '1';

end rtl;

