--Martin GRD 22dec. 2018
--Test bench for FSM Moore inv AES

--Include Library
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library AESLibrary;
use AESLibrary.state_definition_package.all;

library lib_sources;

--Declaration of entity
entity FSM_InvAES_tb is
end FSM_InvAES_tb;


--Description of architecture
architecture FSM_InvAES_tb_arch of FSM_InvAES_tb is
	component FSM_InvAES
		port ( 	resetb_i : in std_logic;
						start_i : in std_logic;
						clock_i : in std_logic;
						round_i : in bit4;
						resetCounter_o : out std_logic;
						enableCounter_o : out std_logic;
						enableInvMixColumn_o : out std_logic;
						getCiphertext_o : out std_logic;
						enableOutput_o : out std_logic;
						AESon_o : out std_logic );
	end component;

	signal clock_i_s, resetb_i_s : std_logic := '0';
	signal start_i_s : std_logic;
	signal resetCounter_o_s, enableCounter_o_s, enableInvMixColumn_o_s, getCiphertext_o_s, enableOutput_o_s, AESon_o_s : std_logic;
	signal round_i_s : bit4;

begin
	DUT : FSM_InvAES
	port map ( resetb_i => resetb_i_s,
						start_i => start_i_s,
						clock_i => clock_i_s,
						round_i => round_i_s,
						resetCounter_o => resetCounter_o_s,
						enableCounter_o => enableCounter_o_s,
						enableInvMixColumn_o => enableInvMixColumn_o_s,
						getCiphertext_o => getCiphertext_o_s,
						enableOutput_o => enableOutput_o_s,
						AESon_o => AESon_o_s );

	-- Stimuli ...
	start_i_s <= '1'after 50 ns;
	clock_i_s <= not (clock_i_s) after 25 ns;
	round_i_s <= std_logic_vector(to_unsigned(1,4));
	--round_i_s <=  std_logic_vector(to_unsigned(0,4)), std_logic_vector(to_unsigned(1,4)) after 25 ns, std_logic_vector(to_unsigned(2,4)) after 75 ns, 
	--std_logic_vector(to_unsigned(3,4)) after 125 ns, std_logic_vector(to_unsigned(4,4)) after 175 ns, std_logic_vector(to_unsigned(5,4)) after 225 ns, 
	--std_logic_vector(to_unsigned(6,4)) after 275 ns, std_logic_vector(to_unsigned(7,4)) after 325 ns, std_logic_vector(to_unsigned(8,4)) after 375 ns, 
	--std_logic_vector(to_unsigned(9,4)) after 425 ns;
	resetb_i_s <= '1' after 30 ns, '0' after 40 ns;

end architecture FSM_InvAES_tb_arch;


--Configuration of architecture
configuration FSM_InvAES_tb_conf of FSM_InvAES_tb is
	for FSM_InvAES_tb_arch
		for DUT : FSM_InvAES
			use entity lib_sources . FSM_InvAES ( FSM_InvAES_arch ); 
		end for;
	end for;
end configuration;


