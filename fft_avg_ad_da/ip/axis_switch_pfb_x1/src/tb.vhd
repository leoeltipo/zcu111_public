library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb is
end entity;

architecture rtl of tb is

-- DUT.
component axis_switch_pfb_x1 is
	Generic
	(
		-- Number of bits.
		B	: Integer := 16;
		-- Number of Lanes.
		L	: Integer := 4
	);
	Port
	(
		-- Reset and clock.
		aclk			: in std_logic;
		aresetn			: in std_logic;

		-- AXIS Slave I/F.
		s_axis_tdata	: in std_logic_vector(2*B*2*L-1 downto 0);
		s_axis_tvalid	: in std_logic;
		s_axis_tready	: out std_logic;

		-- AXIS Master I/F.
		m_axis_tdata	: out std_logic_vector(2*B*2*L-1 downto 0);
		m_axis_tvalid	: out std_logic
	);
end component;

constant B	: Integer := 4;
constant L	: Integer := 4;

signal aclk				: std_logic;
signal aresetn			: std_logic;

signal s_axis_tdata		: std_logic_vector(2*B*2*L-1 downto 0) := (others => '0');
signal s_axis_tvalid	: std_logic := '0';
signal s_axis_tready	: std_logic;

signal m_axis_tdata		: std_logic_vector(2*B*2*L-1 downto 0);
signal m_axis_tvalid	: std_logic;

begin

-- DUT.
DUT : axis_switch_pfb_x1
	Generic map
	(
		-- Number of bits.
		B	=> B	,
		-- Number of Lanes.
		L	=> L
	)
	Port map
	(
		-- Reset and clock.
		aclk			=> aclk				,
		aresetn			=> aresetn			,

		-- AXIS Slave I/F.
		s_axis_tdata	=> s_axis_tdata		,
		s_axis_tvalid	=> s_axis_tvalid	,
		s_axis_tready	=> s_axis_tready	,

		-- AXIS Master I/F.
		m_axis_tdata	=> m_axis_tdata		,
		m_axis_tvalid	=> m_axis_tvalid
	);

-- Main TB.
process
begin
	aresetn <= '0';
	wait for 250 ns;
	aresetn <= '1';

	wait for 300 ns;

	wait until rising_edge(aclk);
	s_axis_tvalid <= '1';
	s_axis_tdata <= x"0706" & x"0504" & x"0302" & x"0100";
	wait until rising_edge(aclk);
	s_axis_tdata <= x"2726" & x"2524" & x"2322" & x"2120";
	wait until rising_edge(aclk);
	s_axis_tdata <= x"3736" & x"3534" & x"3332" & x"3130";
	wait until rising_edge(aclk);
	s_axis_tdata <= x"4746" & x"4544" & x"4342" & x"4140";
	wait until rising_edge(aclk);
	s_axis_tdata <= x"6766" & x"6564" & x"6362" & x"6160";

	wait until rising_edge(aclk);
	s_axis_tvalid <= '0';
	wait until rising_edge(aclk);
	wait until rising_edge(aclk);
	wait until rising_edge(aclk);
	wait until rising_edge(aclk);
	wait until rising_edge(aclk);
	s_axis_tvalid <= '1';
	s_axis_tdata <= x"2726" & x"2524" & x"2322" & x"2120";
	wait until rising_edge(aclk);
	s_axis_tdata <= x"3736" & x"3534" & x"3332" & x"3130";
	
	wait for 10 us;
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

