library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity axis_combiner_nb is
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
		s00_axis_tdata	: in std_logic_vector(DATA_WIDTH-1 downto 0);
		s00_axis_tstrb	: in std_logic_vector(DATA_WIDTH/8-1 downto 0);
		s00_axis_tlast	: in std_logic;
		s00_axis_tvalid	: in std_logic;
		s00_axis_tready	: out std_logic;

		-- AXIS Slave I/F.
		s01_axis_tdata	: in std_logic_vector(DATA_WIDTH-1 downto 0);
		s01_axis_tstrb	: in std_logic_vector(DATA_WIDTH/8-1 downto 0);
		s01_axis_tlast	: in std_logic;
		s01_axis_tvalid	: in std_logic;
		s01_axis_tready	: out std_logic;

		-- AXIS Slave I/F.
		s02_axis_tdata	: in std_logic_vector(DATA_WIDTH-1 downto 0);
		s02_axis_tstrb	: in std_logic_vector(DATA_WIDTH/8-1 downto 0);
		s02_axis_tlast	: in std_logic;
		s02_axis_tvalid	: in std_logic;
		s02_axis_tready	: out std_logic;

		-- AXIS Slave I/F.
		s03_axis_tdata	: in std_logic_vector(DATA_WIDTH-1 downto 0);
		s03_axis_tstrb	: in std_logic_vector(DATA_WIDTH/8-1 downto 0);
		s03_axis_tlast	: in std_logic;
		s03_axis_tvalid	: in std_logic;
		s03_axis_tready	: out std_logic;

		-- AXIS Slave I/F.
		s04_axis_tdata	: in std_logic_vector(DATA_WIDTH-1 downto 0);
		s04_axis_tstrb	: in std_logic_vector(DATA_WIDTH/8-1 downto 0);
		s04_axis_tlast	: in std_logic;
		s04_axis_tvalid	: in std_logic;
		s04_axis_tready	: out std_logic;

		-- AXIS Slave I/F.
		s05_axis_tdata	: in std_logic_vector(DATA_WIDTH-1 downto 0);
		s05_axis_tstrb	: in std_logic_vector(DATA_WIDTH/8-1 downto 0);
		s05_axis_tlast	: in std_logic;
		s05_axis_tvalid	: in std_logic;
		s05_axis_tready	: out std_logic;

		-- AXIS Slave I/F.
		s06_axis_tdata	: in std_logic_vector(DATA_WIDTH-1 downto 0);
		s06_axis_tstrb	: in std_logic_vector(DATA_WIDTH/8-1 downto 0);
		s06_axis_tlast	: in std_logic;
		s06_axis_tvalid	: in std_logic;
		s06_axis_tready	: out std_logic;

		-- AXIS Slave I/F.
		s07_axis_tdata	: in std_logic_vector(DATA_WIDTH-1 downto 0);
		s07_axis_tstrb	: in std_logic_vector(DATA_WIDTH/8-1 downto 0);
		s07_axis_tlast	: in std_logic;
		s07_axis_tvalid	: in std_logic;
		s07_axis_tready	: out std_logic;

		-- AXIS Slave I/F.
		s08_axis_tdata	: in std_logic_vector(DATA_WIDTH-1 downto 0);
		s08_axis_tstrb	: in std_logic_vector(DATA_WIDTH/8-1 downto 0);
		s08_axis_tlast	: in std_logic;
		s08_axis_tvalid	: in std_logic;
		s08_axis_tready	: out std_logic;

		-- AXIS Slave I/F.
		s09_axis_tdata	: in std_logic_vector(DATA_WIDTH-1 downto 0);
		s09_axis_tstrb	: in std_logic_vector(DATA_WIDTH/8-1 downto 0);
		s09_axis_tlast	: in std_logic;
		s09_axis_tvalid	: in std_logic;
		s09_axis_tready	: out std_logic;

		-- AXIS Slave I/F.
		s10_axis_tdata	: in std_logic_vector(DATA_WIDTH-1 downto 0);
		s10_axis_tstrb	: in std_logic_vector(DATA_WIDTH/8-1 downto 0);
		s10_axis_tlast	: in std_logic;
		s10_axis_tvalid	: in std_logic;
		s10_axis_tready	: out std_logic;

		-- AXIS Slave I/F.
		s11_axis_tdata	: in std_logic_vector(DATA_WIDTH-1 downto 0);
		s11_axis_tstrb	: in std_logic_vector(DATA_WIDTH/8-1 downto 0);
		s11_axis_tlast	: in std_logic;
		s11_axis_tvalid	: in std_logic;
		s11_axis_tready	: out std_logic;

		-- AXIS Slave I/F.
		s12_axis_tdata	: in std_logic_vector(DATA_WIDTH-1 downto 0);
		s12_axis_tstrb	: in std_logic_vector(DATA_WIDTH/8-1 downto 0);
		s12_axis_tlast	: in std_logic;
		s12_axis_tvalid	: in std_logic;
		s12_axis_tready	: out std_logic;

		-- AXIS Slave I/F.
		s13_axis_tdata	: in std_logic_vector(DATA_WIDTH-1 downto 0);
		s13_axis_tstrb	: in std_logic_vector(DATA_WIDTH/8-1 downto 0);
		s13_axis_tlast	: in std_logic;
		s13_axis_tvalid	: in std_logic;
		s13_axis_tready	: out std_logic;

		-- AXIS Slave I/F.
		s14_axis_tdata	: in std_logic_vector(DATA_WIDTH-1 downto 0);
		s14_axis_tstrb	: in std_logic_vector(DATA_WIDTH/8-1 downto 0);
		s14_axis_tlast	: in std_logic;
		s14_axis_tvalid	: in std_logic;
		s14_axis_tready	: out std_logic;

		-- AXIS Slave I/F.
		s15_axis_tdata	: in std_logic_vector(DATA_WIDTH-1 downto 0);
		s15_axis_tstrb	: in std_logic_vector(DATA_WIDTH/8-1 downto 0);
		s15_axis_tlast	: in std_logic;
		s15_axis_tvalid	: in std_logic;
		s15_axis_tready	: out std_logic

	);
end axis_combiner_nb;

architecture rtl of axis_combiner_nb is

-- Concatenated inputs.
signal tdata_i		: std_logic_vector(N*DATA_WIDTH-1 downto 0);

-- Registers.
signal tdata_r		: std_logic_vector(N*DATA_WIDTH-1 downto 0);
signal tdata_rr		: std_logic_vector(N*DATA_WIDTH-1 downto 0);
signal tlast_r		: std_logic;
signal tlast_rr		: std_logic;
signal tvalid_r		: std_logic;
signal tvalid_rr	: std_logic;

begin

-- Registers.
process(aclk)
begin
	if ( rising_edge(aclk) ) then
		if ( aresetn = '0' ) then
			tdata_r		<= (others => '0');
			tdata_rr	<= (others => '0');
			tlast_r		<= '0';
			tlast_rr	<= '0';
			tvalid_r	<= '0';
			tvalid_rr	<= '0';
		else
			-- Registers must be enabled with tready on master.
			if ( m_axis_tready = '1' ) then
				tdata_r		<= tdata_i;
				tdata_rr	<= tdata_r;
				tlast_r		<= s00_axis_tlast;
				tlast_rr	<= tlast_r;
				tvalid_r	<= s00_axis_tvalid;
				tvalid_rr	<= tvalid_r;
			end if;
		end if;
	end if;
end process;

-- Concatenate inputs.
GEN_0 : if (N <= 0) generate
	tdata_i	<= (others => '0');
end generate GEN_0;

GEN_1 : if (N = 1) generate
	tdata_i	<= s00_axis_tdata;
end generate GEN_1;

GEN_2 : if (N = 2) generate
	tdata_i	<= s01_axis_tdata & s00_axis_tdata;
end generate GEN_2;

GEN_3 : if (N = 3) generate
	tdata_i	<= s02_axis_tdata & s01_axis_tdata & s00_axis_tdata;
end generate GEN_3;

GEN_4 : if (N = 4) generate
	tdata_i	<= s03_axis_tdata & s02_axis_tdata & s01_axis_tdata & s00_axis_tdata;
end generate GEN_4;

GEN_5 : if (N = 5) generate
	tdata_i	<= 	s04_axis_tdata & 
				s03_axis_tdata & s02_axis_tdata & s01_axis_tdata & s00_axis_tdata;
end generate GEN_5;

GEN_6 : if (N = 6) generate
	tdata_i	<= 	s05_axis_tdata & s04_axis_tdata & 
				s03_axis_tdata & s02_axis_tdata & s01_axis_tdata & s00_axis_tdata;
end generate GEN_6;

GEN_7 : if (N = 7) generate
	tdata_i	<= 	s06_axis_tdata & s05_axis_tdata & s04_axis_tdata & 
				s03_axis_tdata & s02_axis_tdata & s01_axis_tdata & s00_axis_tdata;
end generate GEN_7;

GEN_8 : if (N = 8) generate
	tdata_i	<= 	s07_axis_tdata & s06_axis_tdata & s05_axis_tdata & s04_axis_tdata & 
				s03_axis_tdata & s02_axis_tdata & s01_axis_tdata & s00_axis_tdata;
end generate GEN_8;

GEN_9 : if (N = 9) generate
	tdata_i	<= 	s08_axis_tdata & 
				s07_axis_tdata & s06_axis_tdata & s05_axis_tdata & s04_axis_tdata & 
				s03_axis_tdata & s02_axis_tdata & s01_axis_tdata & s00_axis_tdata;
end generate GEN_9;

GEN_10 : if (N = 10) generate
	tdata_i	<= 	s09_axis_tdata & s08_axis_tdata & 
				s07_axis_tdata & s06_axis_tdata & s05_axis_tdata & s04_axis_tdata & 
				s03_axis_tdata & s02_axis_tdata & s01_axis_tdata & s00_axis_tdata;
end generate GEN_10;

GEN_11 : if (N = 11) generate
	tdata_i	<= 	s10_axis_tdata & s09_axis_tdata & s08_axis_tdata & 
				s07_axis_tdata & s06_axis_tdata & s05_axis_tdata & s04_axis_tdata & 
				s03_axis_tdata & s02_axis_tdata & s01_axis_tdata & s00_axis_tdata;
end generate GEN_11;

GEN_12 : if (N = 12) generate
	tdata_i	<= 	s11_axis_tdata & s10_axis_tdata & s09_axis_tdata & s08_axis_tdata & 
				s07_axis_tdata & s06_axis_tdata & s05_axis_tdata & s04_axis_tdata & 
				s03_axis_tdata & s02_axis_tdata & s01_axis_tdata & s00_axis_tdata;
end generate GEN_12;

GEN_13 : if (N = 13) generate
	tdata_i	<= 	s12_axis_tdata & 
				s11_axis_tdata & s10_axis_tdata & s09_axis_tdata & s08_axis_tdata & 
				s07_axis_tdata & s06_axis_tdata & s05_axis_tdata & s04_axis_tdata & 
				s03_axis_tdata & s02_axis_tdata & s01_axis_tdata & s00_axis_tdata;
end generate GEN_13;

GEN_14 : if (N = 14) generate
	tdata_i	<= 	s13_axis_tdata & s12_axis_tdata & 
				s11_axis_tdata & s10_axis_tdata & s09_axis_tdata & s08_axis_tdata & 
				s07_axis_tdata & s06_axis_tdata & s05_axis_tdata & s04_axis_tdata & 
				s03_axis_tdata & s02_axis_tdata & s01_axis_tdata & s00_axis_tdata;
end generate GEN_14;

GEN_15 : if (N = 15) generate
	tdata_i	<= 	s14_axis_tdata & s13_axis_tdata & s12_axis_tdata & 
				s11_axis_tdata & s10_axis_tdata & s09_axis_tdata & s08_axis_tdata & 
				s07_axis_tdata & s06_axis_tdata & s05_axis_tdata & s04_axis_tdata & 
				s03_axis_tdata & s02_axis_tdata & s01_axis_tdata & s00_axis_tdata;
end generate GEN_15;

GEN_16 : if (N >= 16) generate
	tdata_i	<= 	s15_axis_tdata & s14_axis_tdata & s13_axis_tdata & s12_axis_tdata & 
				s11_axis_tdata & s10_axis_tdata & s09_axis_tdata & s08_axis_tdata & 
				s07_axis_tdata & s06_axis_tdata & s05_axis_tdata & s04_axis_tdata & 
				s03_axis_tdata & s02_axis_tdata & s01_axis_tdata & s00_axis_tdata;
end generate GEN_16;

-- Assign outputs.
m_axis_tdata	<= tdata_rr;
m_axis_tstrb	<= (others => '1');
m_axis_tlast	<= tlast_rr;
m_axis_tvalid	<= tvalid_rr;

s00_axis_tready	<= m_axis_tready;
s01_axis_tready	<= m_axis_tready;
s02_axis_tready	<= m_axis_tready;
s03_axis_tready	<= m_axis_tready;
s04_axis_tready	<= m_axis_tready;
s05_axis_tready	<= m_axis_tready;
s06_axis_tready	<= m_axis_tready;
s07_axis_tready	<= m_axis_tready;
s08_axis_tready	<= m_axis_tready;
s09_axis_tready	<= m_axis_tready;
s10_axis_tready	<= m_axis_tready;
s11_axis_tready	<= m_axis_tready;
s12_axis_tready	<= m_axis_tready;
s13_axis_tready	<= m_axis_tready;
s14_axis_tready	<= m_axis_tready;
s15_axis_tready	<= m_axis_tready;

end rtl;

