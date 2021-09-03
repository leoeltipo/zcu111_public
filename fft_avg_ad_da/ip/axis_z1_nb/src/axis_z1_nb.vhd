library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

-- Unit delay, non-blocking.
--
-- Output m0 is delayed by 1 sample.
-- Output m1 is not delayed.
--
-- Valid outputs are aligned to avoid time shifts in down-stream
-- blocks.

entity axis_z1_nb is
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
end axis_z1_nb;

architecture rtl of axis_z1_nb is

-- Data.
signal data_r	: std_logic_vector (B-1 downto 0);
signal data_rr	: std_logic_vector (B-1 downto 0);

-- Valid.
signal valid_r	: std_logic;

begin

-- Registers.
process (aclk)
begin
	if ( rising_edge(aclk) ) then
		if ( aresetn = '0' ) then
			-- Data.
			data_r	<= (others => '0');
			data_rr	<= (others => '0');

			-- Valid.
			valid_r	<= '0';
		else		    
			-- Data.
			if ( s_axis_tvalid = '1' ) then
				data_r	<= s_axis_tdata;
			end if;
			data_rr	<= data_r;

			-- Valid.
			valid_r	<= s_axis_tvalid;
		end if;
	end if;	
end process;

-- Assign outputs.
s_axis_tready	<= '1';

m0_axis_tdata	<= data_rr;
m0_axis_tvalid	<= valid_r;
m1_axis_tdata	<= data_r;
m1_axis_tvalid	<= valid_r;


end rtl;

