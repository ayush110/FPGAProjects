library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Four_bit_multiplier is
	port( A: in std_logic_vector(8 downto 5);
			B: in std_logic_vector(3 downto 0);
			--KEY: in std_logic_vector(3 downto 0);
			--LEDR: out std_logic_vector(9 downto 0);
			--LEDG: out std_logic_vector(9 downto 0);
			p0, p1, p2, p3, p4, p5, p6, p7: out std_logic);

			--HEX0, HEX1, HEX2, HEX3: out std_logic_vector(6 downto 0));
end entity Four_bit_multiplier;


architecture RTL of Four_bit_multiplier is
signal x0, x1, x2, x3, y0, y1, y2, y3: std_logic;
--signal p0, p1, p2, p3, p4, p5, p6, p7: std_logic;
signal c0, c1, c2, c3, c4, c5, c6, c7: std_logic;

component Four_bit_adder is
	port (A: 		in 	std_logic_vector(3 downto 0);
			B: 		in 	std_logic_vector(3 downto 0);
			P:		out 	std_logic_vector(4 downto 0));
end component;

component seven_segment is
	port(
		data_in: in std_logic_vector(3 downto 0); -- The 4 bit data to be displayed
		blanking: in std_logic; -- Blank the output if this is input is set to HIGH
		segments_out: out std_logic_vector(6 downto 0) ); -- 7 bits out to a 7-segment display
end component;

begin

x0<=A(8);
x1<=A(7);
x2<=A(6);
x3<=A(5);
y0<=B(3);
y1<=B(2);
y2<=B(1);
y3<=B(0);



component_1: entity work.Four_bit_adder(RTL) port map((x0 and y1) & (x1 and y1) & (x2 and y1) & (x3 and y1), (x1 and y0) &  (x2 and y0) & (x3 and y0) & '0', p1, c0, c1, c2, c3);
component_2: entity work.Four_bit_adder(RTL) port map((x0 and y2) & (x1 and y2) & (x2 and y2) & (x3 and y2), (c0 & c1 & c2 & c3), p2, c4, c5, c6, c7);
component_3: entity work.Four_bit_adder(RTL) port map((x0 and y3) & (x1 and y3) & (x2 and y3) & (x3 and y3), (c4 & c5 & c6 & c7), p3, p4, p5, p6, p7);


p0 <= x0 and y0;

--hex0_inst: entity work.seven_segment(behavioural) port map((y3 & y2 & y1 & y0), '0', hex0);
--hex1_inst: entity work.seven_segment(behavioural) port map((x3 & x2 & x1 & x0), '0', hex1);
--hex2_inst: entity work.seven_segment(behavioural) port map((p3 & p2 & p1 & p0), '0', hex2);
--hex3_inst: entity work.seven_segment(behavioural) port map((p7 & p6 & p5 & p4), '0', hex3);


end architecture; 