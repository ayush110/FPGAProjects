library ieee;
use ieee.std_logic_1164.all;	--lib for std logic circuits
use ieee.numeric_std.all;   --lib for unsigned numbers


entity Random_number_generator is
port (CLOCK_50_B5B: in std_logic;
		KEY: in std_logic_vector(3 downto 0);	--Push buttons
		HEX0, HEX1, HEX2, HEX3: out std_logic_vector(6 downto 0)
	  );
end Random_number_generator;


architecture Behavioral of Random_number_generator is

	signal rndm : unsigned (7 downto 0);
	signal h0, h1, h2, h3 : std_logic_vector(3 downto 0);
	signal clock_1_Hz : std_logic :='0';	--logical datatype (on/off, 1/0 datatype)
	
component seven_segment is
	port(
		data_in: in std_logic_vector(3 downto 0); -- The 4 bit data to be displayed
		blanking: in std_logic; -- Blank the output if this is input is set to HIGH
		segments_out: out std_logic_vector(6 downto 0) ); -- 7 bits out to a 7-segment display
end component;

begin

rndm <= rndm + 1 when rising_edge(CLOCK_50_B5B);


h2 <= h0 when rising_edge(KEY(0));
h3 <= h1 when rising_edge(KEY(0));


h0 <= std_logic_vector(rndm(3 downto 0)) when rising_edge(KEY(0)) ;
h1 <= std_logic_vector(rndm(7 downto 4)) when rising_edge(KEY(0));


hex0_inst: entity work.seven_segment(behavioural) port map(h0, '0', hex0);
hex1_inst: entity work.seven_segment(behavioural) port map(h1, '0', hex1);
hex2_inst: entity work.seven_segment(behavioural) port map(h2, '0', hex2);
hex3_inst: entity work.seven_segment(behavioural) port map(h3, '0', hex3);


End;
