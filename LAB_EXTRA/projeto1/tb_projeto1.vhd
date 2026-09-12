library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_projeto1 is
end tb_projeto1;

architecture sim of tb_projeto1 is

    signal entrada : std_logic_vector(31 downto 0);
    signal saida   : std_logic_vector(5 downto 0);

begin

    uut : entity work.projeto1
    port map(
        entrada => entrada,
        saida   => saida
    );

    process
    begin

        entrada <= x"FFFFFFFF";
        wait for 250 ns;

        entrada <= x"00000000";
        wait for 250 ns;

        entrada <= "11110000110000000011110000001111";
        wait for 250 ns;

        entrada <= "10101010101010101010101010101010";
        wait for 250 ns;

        wait;

    end process;

end sim;