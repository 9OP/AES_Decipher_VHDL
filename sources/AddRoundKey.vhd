--Martin GRD 7dec. 2018
--add round key 

--Include Library
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library AESLibrary;
use AESLibrary.state_definition_package.all;


--Declaration of entity
entity addroundkey is 
	port ( 	data_in : in type_state ;
					data_out : out type_state ;
					key_in : in bit128 );
end addroundkey;


--Description of architecture
architecture addroundkey_arch of addroundkey is
begin
	data_out(0)(0) <= data_in(0)(0) XOR key_in(127 downto 120);
	data_out(0)(1) <= data_in(0)(1) XOR key_in(119 downto 112);
	data_out(0)(2) <= data_in(0)(2) XOR key_in(111 downto 104);
	data_out(0)(3) <= data_in(0)(3) XOR key_in(103 downto 96);

	data_out(1)(0) <= data_in(1)(0) XOR key_in(95 downto 88);
	data_out(1)(1) <= data_in(1)(1) XOR key_in(87 downto 80);
	data_out(1)(2) <= data_in(1)(2) XOR key_in(79 downto 72);
	data_out(1)(3) <= data_in(1)(3) XOR key_in(71 downto 64);

	data_out(2)(0) <= data_in(2)(0) XOR key_in(63 downto 56);
	data_out(2)(1) <= data_in(2)(1) XOR key_in(55 downto 48);
	data_out(2)(2) <= data_in(2)(2) XOR key_in(47 downto 40);
	data_out(2)(3) <= data_in(2)(3) XOR key_in(39 downto 32);

	data_out(3)(0) <= data_in(3)(0) XOR key_in(31 downto 24);
	data_out(3)(1) <= data_in(3)(1) XOR key_in(23 downto 16);
	data_out(3)(2) <= data_in(3)(2) XOR key_in(15 downto  8);
	data_out(3)(3) <= data_in(3)(3) XOR key_in(7  downto  0);

end addroundkey_arch;

