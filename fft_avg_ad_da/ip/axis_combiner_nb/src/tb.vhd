library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb is
end entity;

architecture rtl of tb is

-- DUT.
component axis_combiner_nb is
	Generic
	(
		-- Input data width.
		DATA_WIDTH 	: Integer := 16;

		-- Number of slaves.
		N			: Integer := 2
	);
	Port
	(
		-- Reset and clock.
		aclk	 		: in std_logic;
		aresetn	 		: in std_logic;

		-- AXIS Master I/F.
		m_axis_tdata	: out std_logic_vector(N*DATA_WIDTH-1 downto 0);
		m_axis_tstrb	: out std_logic_vector(N*DATA_WIDTH/8-1 downto 0);
		m_axis_tlast	: out std_logic;
		m_axis_tvalid	: out std_logic;
		m_axis_tready	: in std_logic;

		-- AXIS Slave I/F.
		s0_axis_tdata	: in std_logic_vector(DATA_WIDTH-1 downto 0);
		s0_axis_tstrb	: in std_logic_vector(DATA_WIDTH/8-1 downto 0);
		s0_axis_tlast	: in std_logic;
		s0_axis_tvalid	: in std_logic;
		s0_axis_tready	: out std_logic;

		-- AXIS Slave I/F.
		s1_axis_tdata	: in std_logic_vector(DATA_WIDTH-1 downto 0);
		s1_axis_tstrb	: in std_logic_vector(DATA_WIDTH/8-1 downto 0);
		s1_axis_tlast	: in std_logic;
		s1_axis_tvalid	: in std_logic;
		s1_axis_tready	: out std_logic;

		-- AXIS Slave I/F.
		s2_axis_tdata	: in std_logic_vector(DATA_WIDTH-1 downto 0);
		s2_axis_tstrb	: in std_logic_vector(DATA_WIDTH/8-1 downto 0);
		s2_axis_tlast	: in std_logic;
		s2_axis_tvalid	: in std_logic;
		s2_axis_tready	: out std_logic;

		-- AXIS Slave I/F.
		s3_axis_tdata	: in std_logic_vector(DATA_WIDTH-1 downto 0);
		s3_axis_tstrb	: in std_logic_vector(DATA_WIDTH/8-1 downto 0);
		s3_axis_tlast	: in std_logic;
		s3_axis_tvalid	: in std_logic;
		s3_axis_tready	: out std_logic;

		-- AXIS Slave I/F.
		s4_axis_tdata	: in std_logic_vector(DATA_WIDTH-1 downto 0);
		s4_axis_tstrb	: in std_logic_vector(DATA_WIDTH/8-1 downto 0);
		s4_axis_tlast	: in std_logic;
		s4_axis_tvalid	: in std_logic;
		s4_axis_tready	: out std_logic;

		-- AXIS Slave I/F.
		s5_axis_tdata	: in std_logic_vector(DATA_WIDTH-1 downto 0);
		s5_axis_tstrb	: in std_logic_vector(DATA_WIDTH/8-1 downto 0);
		s5_axis_tlast	: in std_logic;
		s5_axis_tvalid	: in std_logic;
		s5_axis_tready	: out std_logic;

		-- AXIS Slave I/F.
		s6_axis_tdata	: in std_logic_vector(DATA_WIDTH-1 downto 0);
		s6_axis_tstrb	: in std_logic_vector(DATA_WIDTH/8-1 downto 0);
		s6_axis_tlast	: in std_logic;
		s6_axis_tvalid	: in std_logic;
		s6_axis_tready	: out std_logic;

		-- AXIS Slave I/F.
		s7_axis_tdata	: in std_logic_vector(DATA_WIDTH-1 downto 0);
		s7_axis_tstrb	: in std_logic_vector(DATA_WIDTH/8-1 downto 0);
		s7_axis_tlast	: in std_logic;
		s7_axis_tvalid	: in std_logic;
		s7_axis_tready	: out std_logic

	);
end component;

constant DATA_WIDTH		: Integer := 16;
constant N				: Integer := 3;

signal aclk	 			: std_logic;
signal aresetn	 		: std_logic;

signal m_axis_tdata		: std_logic_vector(N*DATA_WIDTH-1 downto 0);
signal m_axis_tstrb		: std_logic_vector(N*DATA_WIDTH/8-1 downto 0);
signal m_axis_tlast		: std_logic;
signal m_axis_tvalid	: std_logic;
signal m_axis_tready	: std_logic := '0';

signal s0_axis_tdata	: std_logic_vector(DATA_WIDTH-1 downto 0);
signal s0_axis_tstrb	: std_logic_vector(DATA_WIDTH/8-1 downto 0);
signal s0_axis_tlast	: std_logic;
signal s0_axis_tvalid	: std_logic;
signal s0_axis_tready	: std_logic;

signal s1_axis_tdata	: std_logic_vector(DATA_WIDTH-1 downto 0);
signal s1_axis_tstrb	: std_logic_vector(DATA_WIDTH/8-1 downto 0);
signal s1_axis_tlast	: std_logic;
signal s1_axis_tvalid	: std_logic;
signal s1_axis_tready	: std_logic;

signal s2_axis_tdata	: std_logic_vector(DATA_WIDTH-1 downto 0);
signal s2_axis_tstrb	: std_logic_vector(DATA_WIDTH/8-1 downto 0);
signal s2_axis_tlast	: std_logic;
signal s2_axis_tvalid	: std_logic;
signal s2_axis_tready	: std_logic;

signal s3_axis_tdata	: std_logic_vector(DATA_WIDTH-1 downto 0);
signal s3_axis_tstrb	: std_logic_vector(DATA_WIDTH/8-1 downto 0);
signal s3_axis_tlast	: std_logic;
signal s3_axis_tvalid	: std_logic;
signal s3_axis_tready	: std_logic;

signal s4_axis_tdata	: std_logic_vector(DATA_WIDTH-1 downto 0);
signal s4_axis_tstrb	: std_logic_vector(DATA_WIDTH/8-1 downto 0);
signal s4_axis_tlast	: std_logic;
signal s4_axis_tvalid	: std_logic;
signal s4_axis_tready	: std_logic;

signal s5_axis_tdata	: std_logic_vector(DATA_WIDTH-1 downto 0);
signal s5_axis_tstrb	: std_logic_vector(DATA_WIDTH/8-1 downto 0);
signal s5_axis_tlast	: std_logic;
signal s5_axis_tvalid	: std_logic;
signal s5_axis_tready	: std_logic;

signal s6_axis_tdata	: std_logic_vector(DATA_WIDTH-1 downto 0);
signal s6_axis_tstrb	: std_logic_vector(DATA_WIDTH/8-1 downto 0);
signal s6_axis_tlast	: std_logic;
signal s6_axis_tvalid	: std_logic;
signal s6_axis_tready	: std_logic;

signal s7_axis_tdata	: std_logic_vector(DATA_WIDTH-1 downto 0);
signal s7_axis_tstrb	: std_logic_vector(DATA_WIDTH/8-1 downto 0);
signal s7_axis_tlast	: std_logic;
signal s7_axis_tvalid	: std_logic;
signal s7_axis_tready	: std_logic;

begin

-- DUT.
DUT : axis_combiner_nb
	Generic map
	(
		-- Input data width.
		DATA_WIDTH 	=> DATA_WIDTH	,

		-- Number of slaves.
		N			=> N
	)
	Port map
	(
		-- Reset and clock.
		aclk	 		=> aclk   			,
		aresetn	 		=> aresetn			,

		-- AXIS Master I/F.
		m_axis_tdata	=> m_axis_tdata 	,
		m_axis_tstrb	=> m_axis_tstrb 	,
		m_axis_tlast	=> m_axis_tlast 	,
		m_axis_tvalid	=> m_axis_tvalid	,
		m_axis_tready	=> m_axis_tready	,

		-- AXIS Slave I/F.
		s0_axis_tdata	=> s0_axis_tdata 	,
		s0_axis_tstrb	=> s0_axis_tstrb 	,
		s0_axis_tlast	=> s0_axis_tlast 	,
		s0_axis_tvalid	=> s0_axis_tvalid	,
		s0_axis_tready	=> s0_axis_tready	,

		-- AXIS Slave I/F.
		s1_axis_tdata	=> s1_axis_tdata 	,
		s1_axis_tstrb	=> s1_axis_tstrb 	,
		s1_axis_tlast	=> s1_axis_tlast 	,
		s1_axis_tvalid	=> s1_axis_tvalid	,
		s1_axis_tready	=> s1_axis_tready	,

		-- AXIS Slave I/F.
		s2_axis_tdata	=> s2_axis_tdata 	,
		s2_axis_tstrb	=> s2_axis_tstrb 	,
		s2_axis_tlast	=> s2_axis_tlast 	,
		s2_axis_tvalid	=> s2_axis_tvalid	,
		s2_axis_tready	=> s2_axis_tready	,

		-- AXIS Slave I/F.
		s3_axis_tdata	=> s3_axis_tdata 	,
		s3_axis_tstrb	=> s3_axis_tstrb 	,
		s3_axis_tlast	=> s3_axis_tlast 	,
		s3_axis_tvalid	=> s3_axis_tvalid	,
		s3_axis_tready	=> s3_axis_tready	,

		-- AXIS Slave I/F.
		s4_axis_tdata	=> s4_axis_tdata 	,
		s4_axis_tstrb	=> s4_axis_tstrb 	,
		s4_axis_tlast	=> s4_axis_tlast 	,
		s4_axis_tvalid	=> s4_axis_tvalid	,
		s4_axis_tready	=> s4_axis_tready	,

		-- AXIS Slave I/F.
		s5_axis_tdata	=> s5_axis_tdata 	,
		s5_axis_tstrb	=> s5_axis_tstrb 	,
		s5_axis_tlast	=> s5_axis_tlast 	,
		s5_axis_tvalid	=> s5_axis_tvalid	,
		s5_axis_tready	=> s5_axis_tready	,

		-- AXIS Slave I/F.
		s6_axis_tdata	=> s6_axis_tdata 	,
		s6_axis_tstrb	=> s6_axis_tstrb 	,
		s6_axis_tlast	=> s6_axis_tlast 	,
		s6_axis_tvalid	=> s6_axis_tvalid	,
		s6_axis_tready	=> s6_axis_tready	,

		-- AXIS Slave I/F.
		s7_axis_tdata	=> s7_axis_tdata 	,
		s7_axis_tstrb	=> s7_axis_tstrb 	,
		s7_axis_tlast	=> s7_axis_tlast 	,
		s7_axis_tvalid	=> s7_axis_tvalid	,
		s7_axis_tready	=> s7_axis_tready
	);

-- Main tb.
process
begin
	aresetn <= '0';
	wait for 250 ns;
	aresetn <= '1';

	wait until rising_edge(aclk);
	s0_axis_tdata 	<= x"1234";
	s1_axis_tdata 	<= x"abcd";
	s2_axis_tdata 	<= x"2222";
	s0_axis_tlast	<= '0';
	s0_axis_tvalid	<= '1';

	wait until rising_edge(aclk);
	s0_axis_tdata 	<= x"1111";
	s1_axis_tdata 	<= x"2222";
	s2_axis_tdata 	<= x"3333";
	s0_axis_tlast	<= '0';
	s0_axis_tvalid	<= '1';

	wait for 100 ns;
	
	wait until rising_edge(aclk);
	m_axis_tready	<= '1';

	wait for 1 us;
end process;

-- aclk.
process
begin
	aclk <= '0';
	wait for 5 ns;
	aclk <= '1';
	wait for 5 ns;
end process;

end rtl;

