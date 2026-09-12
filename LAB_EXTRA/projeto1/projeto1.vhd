library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.my_package.all;

entity projeto1 is

    Port(
        entrada : in  std_logic_vector(31 downto 0);
        saida   : out std_logic_vector(5 downto 0)
    );

end projeto1;

architecture Behavioral of projeto1 is

begin

    saida <= std_logic_vector(
                 to_unsigned(
                    maior_sequencia_0s(entrada),
                    6
                 )
             );

end Behavioral;