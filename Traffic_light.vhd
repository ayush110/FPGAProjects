library ieee;
use ieee.std_logic_1164.all;	--lib for std logic circuits
use ieee.numeric_std.all;   --lib for unsigned numbers


entity Traffic_light is
port (CLOCK_50_B5B: in std_logic;
		KEY: in std_logic_vector(3 downto 0);	--Push buttons
		LEDG: out std_logic_vector(7 downto 0); -- Green LED's
		LEDR: out std_logic_vector(7 downto 0); -- Red LED's
		HEX0, HEX1, HEX2, HEX3: out std_logic_vector(6 downto 0)
	  );
end Traffic_light;


architecture Behavioural of Traffic_light is

	type state_names is (flashinggreen1, green1, amber1, green2, amber2, red1, red2, flashinggreen2);
	signal State, next_state: state_names ;
	
	signal counter_10_hz: unsigned (24 downto 0);
	signal clock_10_hz: std_logic;
	
	signal counter_1_hz: unsigned(2 downto 0);
	signal clock_1_hz : std_logic :='0';
	
	signal counter: unsigned (5 downto 0);
	
	signal hex_counter: unsigned (5 downto 0);
	signal state_num: unsigned (3 downto 0);
	
component seven_segment is
	port(
		data_in: in std_logic_vector(3 downto 0); -- The 4 bit data to be displayed
		blanking: in std_logic; -- Blank the output if this is input is set to HIGH
		segments_out: out std_logic_vector(6 downto 0) ); -- 7 bits out to a 7-segment display
end component;

begin


--counter <= (counter + 1) when rising_edge(CLOCK_50_B5B); 


P1: process (counter_10_hz, clock_10_hz)-- 10 HZ Clock
begin
	if rising_edge(CLOCK_50_B5B) then
		if counter_10_hz = to_unsigned(2499999, 25) then
			counter_10_hz <= to_unsigned(0, 25);
			clock_10_hz <= not clock_10_hz;
			--counter <= to_unsigned(0, 6);
		else
			counter_10_hz <= counter_10_hz + 1;
		
		end if;
	end if;

end process P1;

P2: process (clock_1_hz, counter_1_hz) -- 1 HZ Clock
begin
	if rising_edge(clock_10_hz) then
		if counter_1_hz = to_unsigned(5, 3) then
			counter_1_hz <= to_unsigned(0, 3);
			clock_1_hz <= not clock_1_hz;
		else
			counter_1_hz <= counter_1_hz + 1;
		end if;
	end if;

end process P2;

tlc_counter: process (clock_1_hz, counter_1_hz) -- 1 HZ Clock
begin
	if rising_edge(clock_1_hz) then
		if counter = to_unsigned(21, 5) then
			counter <= to_unsigned(0, 6);
		else
			counter <= counter + 1;
		end if;
	end if;

end process tlc_counter;



P3: process (clock_10_hz, clock_1_hz, State, next_state, counter_1_hz, counter) --figuring out next state
begin

	case State is
	  -- Flashing green in NS Side
	  when flashinggreen1 =>
			LEDG(7) <= clock_10_hz;
			LEDR(0) <= '0';
			
			LEDG(4) <= '0';
			LEDR(4) <= '1';
			
			state_num <= to_unsigned(0,4);
			hex_counter <= counter + 1;
			-- If 5 seconds have passed
			if counter >= 1 then
				 next_state  <= green1;

			else
				 next_state <= flashinggreen1;
				 
			end if;

	  -- Green in NS Side
	  when green1 =>
			LEDG(7) <= '1';
			LEDR(0) <= '0';
			
			LEDG(4) <= '0';
			LEDR(4) <= '1';
			state_num <= to_unsigned(1,4);
			hex_counter <= counter - 1;
			
			-- If 5 seconds have passed
			if counter >= 6 then
				 --counter_1_hz <= to_unsigned(0, 3);
				 next_state   <= amber1;
			else
				 next_state <= green1;
			end if;
			
			

	  -- Green light in north/south directions
	  when amber1 =>
			LEDG(7) <= '0';
			LEDR(0)    <= clock_10_hz;
			
			LEDG(4) <= '0';
			LEDR(4) <= '1';
			state_num <= to_unsigned(2,4);
			hex_counter <= counter - 6;
			-- If 3 seconds have passed
			if counter >= 9 then
				 --counter_1_hz <= to_unsigned(0, 3);
				 next_state   <= red1;
			else
				 next_state <= amber1;
			end if;

	  -- Red and yellow light in north/south direction
	  when red1 =>
			LEDG(7) <= '0';
			LEDR(0) <= '1';
			
			LEDG(4) <= '0';
			LEDR(4) <= '1';
			state_num <= to_unsigned(3,4);
			hex_counter <= counter - 9;

			-- If 5 seconds have passed
			if counter >= 10 then
				-- counter_1_hz <= to_unsigned(0, 3);
				 next_state   <= flashinggreen2;
			else
				 next_state <= red1;
			end if;

	  -- Red light in all directions
	  when flashinggreen2 =>
			LEDG(4) <= clock_10_hz;
			LEDR(4) <= '0';
			
			LEDG(7) <= '0';
			LEDR(0) <= '1';
			state_num <= to_unsigned(4,4);
			hex_counter <= counter - 10;

			-- If 5 seconds have passedf
			if counter >= 12 then
				-- counter_1_hz <= to_unsigned(0, 3);
				 next_state   <= green2;
			else
				 next_state <= flashinggreen2;
			end if;

	  -- Yellow light in west/east direction
	  when green2 =>
			LEDG(4) <= '1';
			LEDR(4) <= '0';
			
			LEDG(7) <= '0';
			LEDR(0) <= '1';
			state_num <= to_unsigned(5,4);
			hex_counter <= counter - 12;

			
			-- If 5 seconds have passed
			if counter >= 17 then
				-- counter_1_hz <= to_unsigned(0, 3);
				 next_state   <= amber2;
			else
				 next_state <= green2;
			end if;

	  -- Green light in west/east direction
	  when amber2 =>
			LEDG(4) <= '0';
			LEDR(4) <= clock_10_hz;
			
			LEDG(7) <= '0';
			LEDR(0) <= '1';
			state_num <= to_unsigned(6,4);
			hex_counter <= counter - 17;

			-- If 1 minute has passed
			if counter >= 20 then
				-- counter_1_hz <= to_unsigned(0, 3);
				 next_state   <= red2;
			else
				 next_state <= amber2;
			
			end if;

	  -- Red and yellow light in west/east direction
	  when red2 =>
			LEDG(4) <= '0';
			LEDR(4) <= '1';
			
			LEDG(7) <= '0';
			LEDR(0) <= '1';
			state_num <= to_unsigned(7,4);
			hex_counter <= counter - 20;

			-- If 5 seconds have passed
			if counter >= 21 then
			  --  counter_1_hz <= to_unsigned(0, 3);
				 next_state <= flashinggreen1;
			else
				 next_state <= red2;
					
			end if;

	end case;
		

end process P3;


P4: process (clock_1_hz) -- Sequential process/circuit (a.k.a Clocked process) setting next state
begin
if rising_edge(clock_1_hz) then

	State <= next_state;

end if;
end process P4;

hex0_inst: entity work.seven_segment(behavioural) port map(std_logic_vector(hex_counter(3 downto 0)), '0', hex0);
hex3_inst: entity work.seven_segment(behavioural) port map(std_logic_vector(state_num), '0', hex3);


end architecture;



