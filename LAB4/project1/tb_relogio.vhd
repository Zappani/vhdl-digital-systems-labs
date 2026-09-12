library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_relogio is
end entity;

architecture sim of tb_relogio is

    signal clk   : std_logic := '0';
    signal rst   : std_logic := '0';
    signal pausa : std_logic := '0';
    signal conf  : std_logic := '0';

    signal seg : std_logic_vector(6 downto 0);
    signal an  : std_logic_vector(3 downto 0);

begin

    uut: entity work.relogio_top
        port map (
            clk   => clk,
            rst   => rst,
            pausa => pausa,
            conf  => conf,
            seg   => seg,
            an    => an
        );

    -- Clock: 10 ns período
    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
    end process;

    -- Estímulos
    stim_proc: process
    begin

        -- =========================
        -- RESET
        -- =========================
        conf <= '0';
        rst <= '1';
        wait for 100 ns;
        rst <= '0';

        -- =========================
        -- EXECUÇÃO NORMAL
        -- =========================
        wait for 300 ns;

        -- =========================
        -- MUDANÇA DE MODO
        -- =========================
        conf <= '1';
        wait for 100 ns;

        -- =========================
        -- TESTE DE PAUSA
        -- =========================
        pausa <= '1';
        wait for 100 ns;
        -- Valor deve permanecer constante
        pausa <= '0';

        -- =========================
        -- RESET DURANTE EXECUÇÃO
        -- =========================
        rst <= '1';
        wait for 100 ns;
        rst <= '0';

        wait for 300 ns;

        -- =========================
        -- FIM
        -- =========================
        wait;

    end process;

end architecture;