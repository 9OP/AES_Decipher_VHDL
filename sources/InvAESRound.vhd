-- Martin GRD 19dec. 2018
-- Inv AES Round 

--Include Library
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library AESLibrary;
use AESLibrary.state_definition_package.all;

library lib_sources;

--Declare entity
entity InvAESRound is 
	port (	clock_i : in std_logic;
					currentkey_i : in bit128;
					currenttext_i : in bit128;
					getCipherText_i : in std_logic;
					enableInvMixColumn_i : in std_logic;
					enableOutput_i : in std_logic;
					resetb_i : in std_logic;
					data_o : out bit128 );
end InvAESRound;


--Description of architecture
architecture InvAESRound_arch of InvAESRound is
	--Component
	component invsubbyte
		port (data_i : in type_state ; data_o : out type_state );
	end component;
	component invmixcolumn
		port (data_in : in type_state ; data_out : out type_state );
	end component;
	component addroundkey
		port (data_in : in type_state ; data_out : out type_state ; key_in : in bit128 );
	end component;
	component invshiftrow
		port (data_i : in type_state ; data_o : out type_state );
	end component;
	component registre 
		port (data_i  : in type_state; clk_i : in std_logic; resetn_i : in std_logic; data_o : out type_state);
	end component;

	signal data_in_s, registre_input, invsubbyte_output, invmixcolumn_output, invshiftrow_output, addroundkey_output : type_state ; 
	signal data_out_s, registre_output, invsubbyte_input, invmixcolumn_input, invshiftrow_input, addroundkey_input : type_state;

begin
	--conversion bit128 en type_state , currenttext_i devient data_in_s
	data_in_s(0)(0) <= currenttext_i(127 downto 120);
	data_in_s(0)(1) <= currenttext_i(119 downto 112);
	data_in_s(0)(2) <= currenttext_i(111 downto 104);
	data_in_s(0)(3) <= currenttext_i(103 downto 96);

	data_in_s(1)(0) <= currenttext_i(95 downto 88);
	data_in_s(1)(1) <= currenttext_i(87 downto 80);
	data_in_s(1)(2) <= currenttext_i(79 downto 72);
	data_in_s(1)(3) <= currenttext_i(71 downto 64);

	data_in_s(2)(0) <= currenttext_i(63 downto 56);
	data_in_s(2)(1) <= currenttext_i(55 downto 48);
	data_in_s(2)(2) <= currenttext_i(47 downto 40);
	data_in_s(2)(3) <= currenttext_i(39 downto 32);

	data_in_s(3)(0) <= currenttext_i(31 downto 24);
	data_in_s(3)(1) <= currenttext_i(23 downto 16);
	data_in_s(3)(2) <= currenttext_i(15 downto  8);
	data_in_s(3)(3) <= currenttext_i(7  downto  0);--when (clock_i'event and clock_i = '1');

	--Rootage des ginaux et instanciation
	addroundkey_input <= data_in_s when (getCipherText_i = '1') else invsubbyte_output;

	addroundkey_entity : addroundkey
	port map (data_in => addroundkey_input, data_out => addroundkey_output, key_in => currentkey_i);

	invmixcolumn_input <= addroundkey_output;

	invmixcolumn_entity : invmixcolumn
	port map (data_in => invmixcolumn_input, data_out => invmixcolumn_output);

	registre_input <= invmixcolumn_output when (enableInvMixColumn_i = '1') else 	addroundkey_output;

	registre_entity : registre
	port map (data_i => registre_input, clk_i => clock_i, resetn_i => resetb_i, data_o => registre_output);

	data_out_s <= registre_output when (enableOutput_i = '1') else ((x"00",x"00", x"00", x"00"), (x"00",x"00", x"00", x"00"), (x"00",x"00", x"00", x"00"), (x"00",x"00", x"00", x"00"));

	invshiftrow_input <= registre_output;

	invshiftrow_entity : invshiftrow
	port map (data_i => invshiftrow_input, data_o => invshiftrow_output);

	invsubbyte_input <= invshiftrow_output;

	invsubbyte_entity : invsubbyte
	port map (data_i => invsubbyte_input, data_o => invsubbyte_output);


	--Conversion de type_state en bit128, data_out_s devient data_o
	data_o(127 downto 120) <= data_out_s(0)(0);--when (resetb_i = '1') else x"00";
	data_o(119 downto 112) <= data_out_s(0)(1);
	data_o(111 downto 104) <= data_out_s(0)(2);
	data_o(103 downto 96)  <= data_out_s(0)(3);

	data_o(95 downto 88) <= data_out_s(1)(0);
	data_o(87 downto 80) <= data_out_s(1)(1);
	data_o(79 downto 72) <= data_out_s(1)(2);
	data_o(71 downto 64) <= data_out_s(1)(3);

	data_o(63 downto 56) <= data_out_s(2)(0);
	data_o(55 downto 48) <= data_out_s(2)(1);
	data_o(47 downto 40) <= data_out_s(2)(2);
	data_o(39 downto 32) <= data_out_s(2)(3);

	data_o(31 downto 24) <= data_out_s(3)(0);
	data_o(23 downto 16) <= data_out_s(3)(1);
	data_o(15 downto  8) <= data_out_s(3)(2);
	data_o(7  downto  0) <= data_out_s(3)(3);

end architecture InvAESRound_arch;


--Configuration of architecture
configuration InvAESRound_conf of InvAESRound is
	for InvAESRound_arch
		for addroundkey_entity : addroundkey
			use entity lib_sources . addroundkey ( addroundkey_arch );
		end for;
		for invshiftrow_entity : invshiftrow
			use entity lib_sources . invshiftrow ( invshiftrow_arch ) ; 
		end for;
		for invsubbyte_entity : invsubbyte
			use entity lib_sources . invsubbyte ( invsubbyte_arch );
		end for;
		for invmixcolumn_entity : invmixcolumn
			use entity lib_sources . invmixcolumn ( invmixcolumn_arch );
		end for;
		for registre_entity : registre
			use entity lib_sources . registre ( registre_arch );
		end for;
	end for;
end InvAESRound_conf;	


