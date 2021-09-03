library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb is
end entity;

architecture rtl of tb is

-- DUT.
component axis_pimod_pfb_x1 is
	Generic
	(
		-- Number of bits.
		B		: Integer := 16;
		-- FFT size.
		N		: Integer := 4
	);
	Port
	(
		-- Reset and clock.
		aresetn			: in std_logic;
		aclk			: in std_logic;

		-- AXIS Slave I/F.
		s_axis_tdata	: in std_logic_vector(2*B*N-1 downto 0);
		s_axis_tvalid	: in std_logic;
		s_axis_tready	: out std_logic;

		-- AXIS Master I/F.
		m_axis_tdata	: out std_logic_vector(2*B*N-1 downto 0);
		m_axis_tvalid	: out std_logic
	);
end component;

constant B				: Integer := 8;
constant N				: Integer := 4;

signal aresetn          : std_logic;
signal aclk             : std_logic;

signal s_axis_tdata		: std_logic_vector(2*B*N-1 downto 0) := (others => '0');
signal s_axis_tvalid	: std_logic := '0';
signal s_axis_tready	: std_logic;

signal m_axis_tdata		: std_logic_vector(2*B*N-1 downto 0);
signal m_axis_tvalid	: std_logic;


begin

-- DUT.
DUT : axis_pimod_pfb_x1
	Generic map
	(
		-- Number of bits.
		B		=> B	,
		-- FFT size.
		N		=> N
	)
	Port map
	(
		-- Reset and clock.
		aresetn			=> aresetn			,
		aclk			=> aclk				,

		-- AXIS Slave I/F.
		s_axis_tdata	=> s_axis_tdata 	,
		s_axis_tvalid	=> s_axis_tvalid	,
		s_axis_tready	=> s_axis_tready	,

		-- AXIS Master I/F.
		m_axis_tdata	=> m_axis_tdata 	,
		m_axis_tvalid	=> m_axis_tvalid
	);

-- Main TB.
process
begin
	aresetn <= '0';
	wait for 250 ns;
	aresetn <= '1';

	wait for 300 ns;
	
	for I in 0 to 10 loop
		wait until rising_edge(aclk);
		s_axis_tvalid <= '1';
	end loop;
	
	for J in 0 to 50 loop
		for I in 0 to 7 loop
			wait until rising_edge(aclk);
			s_axis_tvalid <= '1';
			s_axis_tdata (1*B-1 downto 0*B)	<= std_logic_vector(to_signed(7,B));
			s_axis_tdata (2*B-1 downto 1*B)	<= std_logic_vector(to_signed(88,B));
			s_axis_tdata (3*B-1 downto 2*B)	<= std_logic_vector(to_signed(120,B));
			s_axis_tdata (4*B-1 downto 3*B)	<= std_logic_vector(to_signed(-73,B));
			s_axis_tdata (5*B-1 downto 4*B)	<= std_logic_vector(to_signed(90,B));
			s_axis_tdata (6*B-1 downto 5*B)	<= std_logic_vector(to_signed(-11,B));
			s_axis_tdata (7*B-1 downto 6*B)	<= std_logic_vector(to_signed(15,B));
			s_axis_tdata (8*B-1 downto 7*B)	<= std_logic_vector(to_signed(73,B));
		end loop;

		wait until rising_edge(aclk);
		s_axis_tvalid <= '0';
		wait until rising_edge(aclk);
		s_axis_tvalid <= '0';
	end loop;

	wait until rising_edge(aclk);
	s_axis_tvalid <= '1';
	s_axis_tdata (1*B-1 downto 0*B)	<= std_logic_vector(to_signed(7,B));
	s_axis_tdata (2*B-1 downto 1*B)	<= std_logic_vector(to_signed(88,B));
	s_axis_tdata (3*B-1 downto 2*B)	<= std_logic_vector(to_signed(120,B));
	s_axis_tdata (4*B-1 downto 3*B)	<= std_logic_vector(to_signed(-73,B));
	s_axis_tdata (5*B-1 downto 4*B)	<= std_logic_vector(to_signed(90,B));
	s_axis_tdata (6*B-1 downto 5*B)	<= std_logic_vector(to_signed(-11,B));
	s_axis_tdata (7*B-1 downto 6*B)	<= std_logic_vector(to_signed(15,B));
	s_axis_tdata (8*B-1 downto 7*B)	<= std_logic_vector(to_signed(73,B));

	wait until rising_edge(aclk);
	s_axis_tvalid <= '0';

	wait for 10 us;
end process;

-- aclk.
process
begin
	aclk <= '0';
	wait for 10 ns;
	aclk <= '1';
	wait for 10 ns;
end process;

end rtl;

