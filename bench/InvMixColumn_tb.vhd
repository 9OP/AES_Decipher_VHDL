--Martin GRD 7dec. 2018
-- Test bench inv mix column

--Include library
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library AESLibrary;
use AESLibrary.state_definition_package.all;

library lib_sources;


--Declaration of entity
entity invmixcolumn_tb is
end entity invmixcolumn_tb;


--Description of architecture
architecture invmixcolumn_tb_arch of invmixcolumn_tb is
	component invmixcolumn
		port (data_in : in type_state ; data_out : out type_state);
	end component;

	signal data_in_s : type_state;
	signal data_out_s : type_state;

begin
	DUT : invmixcolumn
	port map (data_in => data_in_s , data_out => data_out_s);
	--Stimuli  ...
	data_in_s <=  ((X"09", X"37", X"9f", X"a4"), (X"7e", X"99", X"01", X"c7"), (X"ed", X"74", X"ad", X"f8"), (X"8f", X"a1", X"10", X"a4"));

end architecture invmixcolumn_tb_arch;


--Configuration of architecture
configuration invmixcolumn_tb_conf of invmixcolumn_tb is
	for invmixcolumn_tb_arch
		for DUT : invmixcolumn
			use entity lib_sources . invmixcolumn ( invmixcolumn_arch );
		end for;
	end for;
end invmixcolumn_tb_conf;


