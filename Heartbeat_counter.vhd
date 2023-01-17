library ieee;
use ieee.std_logic_1164.all;	--lib for std logic circuits
use ieee.numeric_std.all;   --lib for unsigned numbers


entity Heartbeat_counter is
port (CLOCK_50_B5B: in std_logic;
		KEY: in std_logic_vector(3 downto 0);	--Push buttons
		LEDG: out std_logic_vector(4 downto 0); -- Green LED's
		HEX0, HEX1: out std_logic_vector(6 downto 0)
	  );
end Heartbeat_counter;


architecture Behavioral of Heartbeat_counter is

	signal a: unsigned(4 downto 0);
	signal h0, h1, h2, h3 : std_logic_vector(3 downto 0);
	signal blank : std_logic :='1';	--logical datatype (on/off, \1/0 datatype)
	
component seven_segment is
	port(
		data_in: in std_logic_vector(3 downto 0); -- The 4 bit data to be displayed
		blanking: in std_logic; -- Blank the output if this is input is set to HIGH
		segments_out: out std_logic_vector(6 downto 0) ); -- 7 bits out to a 7-segment display
end component;

begin

a <= a + 1 when rising_edge(KEY(0)); -- a is of unsigned typ

LEDG(4 downto 0) <= std_logic_vector(a);

blank <= '1' when (a > 01111) else'0';

h0 <= std_logic_vector(a(3 downto 0));
h1 <= ("000" & std_logic(a(4)));

hex0_inst: entity work.seven_segment(behavioural) port map(h0, '0', hex0);
hex1_inst: entity work.seven_segment(behavioural) port map(h1, blank, hex1);


End;
