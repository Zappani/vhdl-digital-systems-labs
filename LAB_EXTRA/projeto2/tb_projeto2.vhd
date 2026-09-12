library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_projeto2 is
end tb_projeto2;

architecture sim of tb_projeto2 is

    signal a0,a1,a2,a3,a4,a5,a6,a7 : std_logic_vector(3 downto 0);
    signal s0,s1,s2,s3,s4,s5,s6,s7 : std_logic_vector(3 downto 0);

begin

    uut : entity work.projeto2
    port map(
        a0,a1,a2,a3,a4,a5,a6,a7,
        s0,s1,s2,s3,s4,s5,s6,s7
    );

    process
    begin

        a0 <= "0011"; --3
        a1 <= "1010"; --10
        a2 <= "0001"; --1
        a3 <= "1111"; --15
        a4 <= "0111"; --7
        a5 <= "0100"; --4
        a6 <= "1100"; --12
        a7 <= "1000"; --8

        wait for 100 ns;

        wait;

    end process;

end sim;