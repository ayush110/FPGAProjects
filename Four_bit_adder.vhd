library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Four_bit_adder is
	port (A: 		in 	std_logic_vector(3 downto 0);
			B: 		in 	std_logic_vector(7 downto 4);
			p0, p1, p2, p3, p4: out std_logic);
end entity Four_bit_adder;


architecture RTL of Four_bit_adder  is
signal a0, b0,a1, b1, a2, b2,a3, b3: std_logic; 
signal c1, c2 , c3: std_logic;
signal s0, s1, s2, s3, c4: std_logic;


component Full_adder is
port 	(x, y, cin: in  std_logic;
		s, cout: out std_logic);
end component;

begin

a0 <= A(0); 
a1 <= A(1); 
a2 <= A(2); 
a3 <= A(3); 
b0 <= B(4); 
b1 <= B(5); 
b2 <= B(6); 
b3 <= B(7); 


component_1: entity work.Full_adder(RTL) port map(a0, b0, '0', s0, c1);
component_2: entity work.Full_adder(RTL) port map(a1 , b1 , c1, s1, c2);
component_3: entity work.Full_adder(RTL) port map(a2 , b2 , c2, s2, c3);
component_4: entity work.Full_adder(RTL) port map(a3 , b3 , c3, s3, c4);



p0 <= s0;
p1 <= s1;
p2 <= s2;
p3 <= s3;
p4 <= c4;

end architecture;


--PREVIOUS CODE
--library ieee;
--use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;
--
--entity Four_bit_adder is 
--	port (A: 		in 	std_logic_vector(3 downto 0);
--			B: 		in 	std_logic_vector(3 downto 0);
--			LEDG:		out 	std_logic_vector(4 downto 0)
--			);
--end entity; 
--
--architecture RTL of Four_bit_adder is 
--signal x0, y0, x1, y1, x2, y2,x3, y3, c1, c2,c3: std_logic; 
--signal s0, s1, s2, s3, c4: std_logic; 
--
--component Full_adder is 
--	port (a, b: 	in  std_logic; 
--			S, C: 	out std_logic); 
--end component; 
--
----component seven_segment is 
----	port (data_in:		in std_logic_vector(3 downto 0);	-- The 4 bit data to be displayed
----			blanking:		in std_logic;						-- Blank the output if this is input is set to HIGH
----			segments_out: 	out std_logic_vector(6 downto 0)); 
----end component; 
--
--begin 
--
--x0 <= A(0); 
--x1 <= A(1); 
--x2 <= A(2); 
--x3 <= A(3); 
--y0 <= B(4); 
--y1 <= B(5); 
--y2 <= B(6); 
--y3 <= B(7); 
--
--
--component_1: entity work.Full_adder(RTL) port map(x0, y0, '0', s0, c1); 
--component_2: entity work.Full_adder(RTL) port map(x1, y1, c1, s1, c2); 
--component_3: entity work.Full_adder(RTL) port map(x2, y2, c2, s2, c3); 
--component_4: entity work.Full_adder(RTL) port map(x3, y3, c3, s3, c4);
--
----hex0_inst: entity work.seven_segment(behavioral) port map(A(3 downto 0), '0', hex0);
----hex1_inst: entity work.seven_segment(behavioral) port map(B(7 downto 4), '0', hex1);
----hex2_inst: entity work.seven_segment(behavioral) port map((s3 & s2 & s1 & s0), '0', hex2);
----hex3_inst: entity work.seven_segment(behavioral) port map(("000"& c4), '0', hex3); 
--
--
-- 
--end architecture; 