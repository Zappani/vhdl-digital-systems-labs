-------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_decod_priorid is
end tb_decod_priorid;

architecture test of tb_decod_priorid is

    constant N : integer := 8;

    signal x : std_logic_vector(N-1 downto 0);
    signal y : std_logic_vector(N-1 downto 0);

begin

    uut: entity work.decod_priorid
        generic map (N => N)
        port map (
            x => x,
            y => y
        );

    stim: process
    begin

        x <= "00000000";
        wait for 200 ns;

        x <= "00010000";
        wait for 200 ns;

        x <= "00101000";
        wait for 200 ns;

        x <= "11111111";
        wait for 200 ns;

        x <= "10000001";
        wait for 200 ns;

        wait;
    end process;

end test;