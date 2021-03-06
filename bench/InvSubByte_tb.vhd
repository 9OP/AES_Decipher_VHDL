--Martin GRD 6dec. 2018
--Test Bench InvSubByte

--Library
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library AESLibrary;
use AESLibrary.state_definition_package.all;

library lib_sources;


--Declaration of entity
entity InvSubByte_tb is
end InvSubByte_tb;


--Descriotion of architecture
architecture InvSubByte_tb_arch of InvSubByte_tb is
	component InvSubByte
	port (	data_i : in type_state;
		data_o : out type_state);
	end component;
	
	signal data_in_s : type_state;
	signal data_out_s : type_state;

begin
	DUT : InvSubByte
	port map ( data_i => data_in_s,
		data_o => data_out_s);
	
	--stimulis ..
	data_in_s <= ((x"06", x"09", x"99", x"5b"), (x"85", x"fb", x"c1", x"8e"), (x"a6", x"06", x"5f", x"56"), (x"61", x"54", x"ca", x"74"));

end architecture InvSubByte_tb_arch;


--Configuration of architecture
configuration InvSubByte_tb_conf of InvSubByte_tb is
	for InvSubByte_tb_arch
		for DUT : InvSubByte
			use entity lib_sources . invsubbyte ( invsubbyte_arch );
		end for;
	end for;
end InvSubByte_tb_conf;

