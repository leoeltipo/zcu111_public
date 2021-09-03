library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

-- Simplified Switch Block for the case in which there is one transaction
-- per FFT.
--
-- The block is "always ready", so no back-pressure is possible.
--
-- NOTE: Number of lanes could be confusing in this case. The PFB
-- is L lanes. However, due to overlap implementation, the number of
-- FIR blocks doubles to account for the overlap. As a result, after
-- the FIRs, there is going to be 2*L parallel samples per transaction.
--
-- Example: 8 lanes, 16 channels.
-- There is going to be 16 FIR cores, each of them implementing a single
-- filter coefficient set. 16 parallel output samples every clock, which
-- gives 2*L samples per transcaction to this switch (before the FFT).

entity axis_switch_pfb_x1 is
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
end axis_switch_pfb_x1;

architecture rtl of axis_switch_pfb_x1 is

constant BIQ			: Integer := 2*B;
constant BIN			: Integer := s_axis_tdata'length;

-- Vector for I,Q.
-- 2*L samples per transaction. Each lane comes from combining two FIR cores.
type data_v is array (2*L-1 downto 0) of std_logic_vector (B-1 downto 0);
signal din_i	: data_v;
signal din_q	: data_v;
signal din_i_sw	: data_v;
signal din_q_sw	: data_v;

-- Re-ordered data.
signal dout				: std_logic_vector (BIN-1 downto 0);

-- Registers.
signal din_r	: std_logic_vector (BIN-1 downto 0);
signal dout_r	: std_logic_vector (BIN-1 downto 0);
signal valid_r	: std_logic;
signal valid_rr	: std_logic;

begin

-- Registers.
process (aclk)
begin
	if ( rising_edge(aclk) ) then
		if ( aresetn = '0' ) then
			din_r		<= (others => '0');
			dout_r		<= (others => '0');
			valid_r		<= '0';
			valid_rr	<= '0';
		else
			din_r		<= s_axis_tdata;
			dout_r		<= dout;
			valid_r		<= s_axis_tvalid;
			valid_rr	<= valid_r;

		end if;
	end if;	
end process;

-- Slice input.
GEN_SLICE: for I in 0 to 2*L-1 generate
	-- Even (I part).
	din_i(I)	<= din_r (I*BIQ+B-1 downto I*BIQ);
	-- Odd (Q part).
	din_q(I)	<= din_r (I*BIQ+2*B-1 downto I*BIQ+B);

	-- Re-assembled output.
	dout(		(I+1)*B-1 downto 		I*B)	<= din_i_sw(I);
	dout(BIN/2+	(I+1)*B-1 downto BIN/2+	I*B)	<= din_q_sw(I);
end generate GEN_SLICE;

-- Re-ordered data (fir 0 of each lane first, then fir 1).
GEN_REORDER: for I in 0 to L-1 generate
	-- I part.
	din_i_sw(I)		<= din_i(2*I);
	din_i_sw(I+L)	<= din_i(2*I+1);

	-- Q part.
	din_q_sw(I)		<= din_q(2*I);
	din_q_sw(I+L)	<= din_q(2*I+1);
end generate GEN_REORDER;

-- Assign outputs.
s_axis_tready	<= '1';

m_axis_tdata	<= dout_r;
m_axis_tvalid	<= valid_rr;

end rtl;

