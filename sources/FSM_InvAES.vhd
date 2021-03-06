-- Martin GRD 20dec. 2018
-- FSM Moore inverse AES

--Include Library
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library AESLibrary;
use AESLibrary.state_definition_package.all;


--Declare entity
entity FSM_InvAES is 
	port ( 	
		resetb_i : in std_logic;
		start_i : in std_logic;
		clock_i : in std_logic;
		round_i : in bit4;
		resetCounter_o : out std_logic;
		enableCounter_o : out std_logic;
		enableInvMixColumn_o : out std_logic;
		getCiphertext_o : out std_logic;
		enableOutput_o : out std_logic;
		AESon_o : out std_logic );
end FSM_InvAES;


--Description of architecture
architecture FSM_InvAES_arch of FSM_InvAES is
	type state is (etat0, etat1, etat2, etat3);
	signal etat_present : state;
	signal etat_futur : state;

begin --Moore Arch
	seq_0 : process (clock_i, resetb_i)
	begin -- process seq_0
		if resetb_i = '0' then
			etat_present <= etat0 ;
			resetCounter_o <= '0';
			enableCounter_o <= '0';
			enableInvMixColumn_o <= '0'; 
			getCiphertext_o <= '0';
			enableOutput_o <= '0';
			AESon_o <= '0';
		elsif clock_i'event and clock_i = '1' then
			etat_present <= etat_futur ;
		end if;
	end process seq_0 ;

	comb_0 : process (etat_present, start_i, round_i)
	begin --process comb0
	case etat_present is
		when etat0 =>
			if start_i = '1' then
				etat_futur <= etat1 ;
				resetCounter_o <= '1';
				enableCounter_o <= '1';
				enableInvMixColumn_o <= '0'; 
				getCiphertext_o <= '1';
				enableOutput_o <= '0';
				AESon_o <= '1';		
			else
				etat_futur <= etat0 ;
			end if;

		when etat1 =>
			if round_i = std_logic_vector(to_unsigned(9,4)) then
				etat_futur <= etat2;				
			else
				etat_futur <= etat1;
				resetCounter_o <= '1';
				enableCounter_o <= '1';
				enableInvMixColumn_o <= '1'; 
				getCiphertext_o <= '0';
				enableOutput_o <= '0';
				AESon_o <= '1';		
			end if;

		when etat2 =>
			etat_futur<= etat3;
			resetCounter_o <= '1';
			enableCounter_o <= '1';
			enableInvMixColumn_o <= '0'; 
			getCiphertext_o <= '0';
			enableOutput_o <= '0';
			AESon_o <= '1';		

		when etat3 =>
			etat_futur <= etat0;
			resetCounter_o <= '0';
			enableCounter_o <= '0';
			enableInvMixColumn_o <= '0'; 
			getCiphertext_o <= '0';
			enableOutput_o <= '1';
			AESon_o <= '0';		
	
	end case;
	end process comb_0;

end architecture FSM_InvAES_arch;


