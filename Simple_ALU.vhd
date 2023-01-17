library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Simple_ALU is
	port( SW: in std_logic_vector(8 downto 0);
			KEY: in std_logic_vector(3 downto 0);
			--LEDR: out std_logic_vector(9 downto 0);
			--LEDG: out std_logic_vector(9 downto 0);
			HEX0, HEX1, HEX2, HEX3: out std_logic_vector(6 downto 0));
end entity Simple_ALU;


architecture RTL of Simple_ALU is
signal x0, x1, x2, x3, y0, y1, y2, y3, t: std_logic;
signal r0, r1, r2, r3, r4, r5, r6, r7: std_logic;
signal p0, p1, p2, p3, p4:  std_logic;

signal r: std_logic_vector(7 downto 0);

component Four_bit_multiplier is
	port( A: in std_logic_vector(8 downto 5);
			B: in std_logic_vector(3 downto 0);
			T: in std_logic;
			--KEY: in std_logic_vector(3 downto 0);
			--LEDR: out std_logic_vector(9 downto 0);
			--LEDG: out std_logic_vector(9 downto 0);
			p0, p1, p2, p3, p4, p5, p6, p7: out std_logic);

			--HEX0, HEX1, HEX2, HEX3: out std_logic_vector(6 downto 0));
end component;

component Four_bit_adder is
	port (A: 		in 	std_logic_vector(3 downto 0);
			B: 		in 	std_logic_vector(7 downto 4);
			p0, p1, p2, p3, p4: out std_logic);
end component;

component seven_segment is
	port(
		data_in: in std_logic_vector(3 downto 0); -- The 4 bit data to be displayed
		blanking: in std_logic; -- Blank the output if this is input is set to HIGH
		segments_out: out std_logic_vector(6 downto 0) ); -- 7 bits out to a 7-segment display
end component;

begin

x0<=SW(8);
x1<=SW(7);
x2<=SW(6);
x3<=SW(5);
y0<=SW(3);
y1<=SW(2);
y2<=SW(1);
y3<=SW(0);
t<= SW(4);


component_1: entity work.Four_bit_adder(RTL) port map(x0 & x1 & x2 & x3, y0 & y1 & y2 & y3, p0, p1, p2, p3, p4);

component_2: entity work.Four_bit_multiplier(RTL) port map(SW(8 downto 5), SW(3 downto 0), r0, r1, r2, r3, r4, r5, r6, r7);

r <= "000" & p4 & p3 & p2 & p1 & p0 when t = '0' else r7 & r6 & r5 & r4 & r3 & r2 & r1 & r0;

hex0_inst: entity work.seven_segment(behavioural) port map((SW(3 downto 0)), '0', hex0);
hex1_inst: entity work.seven_segment(behavioural) port map((SW(8 downto 5)), '0', hex1);
hex2_inst: entity work.seven_segment(behavioural) port map((r(3 downto 0)), '0', hex2);
hex3_inst: entity work.seven_segment(behavioural) port map((r(7 downto 4)), '0', hex3);


end architecture; 