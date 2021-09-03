library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb is
end tb;

architecture rtl of tb is

constant B : Integer := 8;

-- DUT.
component axis_z1_nb is
	Generic
	(
		-- Number of bits.
		B	: Integer := 16
	);
	Port
	(
		aclk	 		: in std_logic;
		aresetn			: in std_logic;

		-- AXIS Slave I/F.
		s_axis_tdata	: in std_logic_vector(B-1 downto 0);
		s_axis_tvalid	: in std_logic;
		s_axis_tready	: out std_logic;

		-- AXIS Master I/F.
		m0_axis_tdata	: out std_logic_vector(B-1 downto 0);
		m0_axis_tvalid	: out std_logic;
		m1_axis_tdata	: out std_logic_vector(B-1 downto 0);
		m1_axis_tvalid	: out std_logic
	);
end component;

signal aclk	 			: std_logic := '0';
signal aresetn			: std_logic := '0';

-- AXIS Slave I/F.
signal s_axis_tdata		: std_logic_vector(B-1 downto 0) := (others => '0');
signal s_axis_tvalid	: std_logic := '0';
signal s_axis_tready	: std_logic;

-- AXIS Master I/F.
signal m0_axis_tdata	: std_logic_vector(B-1 downto 0);
signal m0_axis_tvalid	: std_logic;
signal m1_axis_tdata	: std_logic_vector(B-1 downto 0);
signal m1_axis_tvalid	: std_logic;


begin

-- DUT.
DUT : axis_z1_nb
	Generic map
	(
		-- Number of bits.
		B	=> B
	)
	Port map
	(
		aclk	 		=> aclk	 			,
		aresetn			=> aresetn			,

		-- AXIS Slave I/F.
		s_axis_tdata	=> s_axis_tdata		,
		s_axis_tvalid	=> s_axis_tvalid	,
		s_axis_tready	=> s_axis_tready	,

		-- AXIS Master I/F.
		m0_axis_tdata	=> m0_axis_tdata	,
		m0_axis_tvalid	=> m0_axis_tvalid	,
		m1_axis_tdata	=> m1_axis_tdata	,
		m1_axis_tvalid	=> m1_axis_tvalid
	);

-- Main TB.
process
begin
	aresetn <= '0';
	wait for 300 ns;
	aresetn <= '1';

	wait until rising_edge(aclk);
	s_axis_tdata 	<= std_logic_vector(to_unsigned(23,s_axis_tdata'length));
	s_axis_tvalid	<= '1';

	wait until rising_edge(aclk);
	s_axis_tdata 	<= std_logic_vector(to_unsigned(54,s_axis_tdata'length));
	s_axis_tvalid	<= '1';

	wait until rising_edge(aclk);
	s_axis_tvalid	<= '0';
	wait until rising_edge(aclk);
	wait until rising_edge(aclk);

	wait until rising_edge(aclk);
	s_axis_tdata 	<= std_logic_vector(to_unsigned(38,s_axis_tdata'length));
	s_axis_tvalid	<= '1';

	wait until rising_edge(aclk);
	s_axis_tdata 	<= std_logic_vector(to_unsigned(3,s_axis_tdata'length));
	s_axis_tvalid	<= '1';

	wait until rising_edge(aclk);
	s_axis_tdata 	<= std_logic_vector(to_unsigned(99,s_axis_tdata'length));
	s_axis_tvalid	<= '1';

	wait until rising_edge(aclk);
	s_axis_tdata 	<= std_logic_vector(to_unsigned(23,s_axis_tdata'length));
	s_axis_tvalid	<= '0';

	wait until rising_edge(aclk);
	wait until rising_edge(aclk);
	wait until rising_edge(aclk);

	wait until rising_edge(aclk);
	s_axis_tdata 	<= std_logic_vector(to_unsigned(38,s_axis_tdata'length));
	s_axis_tvalid	<= '1';

	wait until rising_edge(aclk);
	s_axis_tdata 	<= std_logic_vector(to_unsigned(3,s_axis_tdata'length));
	s_axis_tvalid	<= '1';

	wait until rising_edge(aclk);
	s_axis_tdata 	<= std_logic_vector(to_unsigned(99,s_axis_tdata'length));
	s_axis_tvalid	<= '1';
	
	for I in 0 to 50 loop
	   wait until rising_edge(aclk);
	   s_axis_tdata 	<= std_logic_vector(to_unsigned(I,s_axis_tdata'length));
	   s_axis_tvalid	<= '1';
	end loop;
	
	wait until rising_edge(aclk);
	s_axis_tvalid	<= '0';
	
	wait for 2 us;
end process;

-- Clock.
process
begin
	aclk <= '0';
	wait for 5 ns;
	aclk <= '1';
	wait for 5 ns;
end process;


end rtl;

