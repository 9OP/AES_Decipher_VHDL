--Martin GRD 27 nov. 2018
--testbench for counter for AES FSM moore

--Include Library
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library AESLibrary;
use AESLibrary.state_definition_package.all;

library lib_sources;

--Declaration of entity
entity counter_tb is
end counter_tb;

--Description of architecture
architecture counter_tb_arch of counter_tb is
	component counter 
		port (	resetb_i : in std_logic;
			enable_i : in std_logic;
			clock_i : in std_logic;
			count_o : out bit4 );
	end component;

	signal resetb_is : std_logic;
	signal enable_is : std_logic;
	signal clock_is : std_logic:='0';
	signal count_os : bit4;

begin
	DUT : counter
	port map (	resetb_i => resetb_is, 
		       	enable_i => enable_is,
		       	clock_i => clock_is,
		       	count_o => count_os);

	resetb_is <= '0', '1' after 10 ns, '0' after 1500 ns;
	enable_is <= '0', '1' after 10 ns, '0' after 2000 ns;
	clock_is <= not(clock_is) after 25 ns;

end architecture counter_tb_arch; 


--Configuration of architecture
configuration counter_tb_conf of counter_tb is
	for counter_tb_arch
		for DUT : counter
			use entity  lib_sources . counter ( counter_arch );
		end for;
	end for;
end counter_tb_conf;

