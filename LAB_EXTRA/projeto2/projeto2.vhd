library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.my_package.all;

entity projeto2 is

    Port(
        a0,a1,a2,a3,a4,a5,a6,a7 : in std_logic_vector(3 downto 0);

        s0,s1,s2,s3,s4,s5,s6,s7 : out std_logic_vector(3 downto 0)
    );

end projeto2;

architecture Behavioral of projeto2 is

begin

    process(a0,a1,a2,a3,a4,a5,a6,a7)
    begin

        ordenador_decrescente(
            a0,a1,a2,a3,a4,a5,a6,a7,
            s0,s1,s2,s3,s4,s5,s6,s7
        );

    end process;

end Behavioral;