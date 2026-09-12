library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_controle_bingo is
end tb_controle_bingo;

architecture Behavioral of tb_controle_bingo is

    component controle_bingo
        Port (
            clk           : in  STD_LOGIC;
            rst           : in  STD_LOGIC;
            cmd_sorteio   : in  STD_LOGIC;
            reg_sorteados : out STD_LOGIC_VECTOR(24 downto 0);
            num_rodada    : out unsigned(5 downto 0);
            u_sorteado    : out unsigned(4 downto 0)
        );
    end component;

    signal clk           : STD_LOGIC := '0';
    signal rst           : STD_LOGIC := '1';
    signal cmd_sorteio   : STD_LOGIC := '0';

    signal reg_sorteados : STD_LOGIC_VECTOR(24 downto 0);
    signal num_rodada    : unsigned(5 downto 0);
    signal u_sorteado    : unsigned(4 downto 0);

    constant CLK_PERIOD : time := 20 ns;

begin

    ------------------------------------------------------------------
    -- DUT
    ------------------------------------------------------------------

    DUT : controle_bingo
    port map (
        clk           => clk,
        rst           => rst,
        cmd_sorteio   => cmd_sorteio,
        reg_sorteados => reg_sorteados,
        num_rodada    => num_rodada,
        u_sorteado    => u_sorteado
    );

    ------------------------------------------------------------------
    -- Clock 50 MHz
    ------------------------------------------------------------------

    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process;

    ------------------------------------------------------------------
    -- Estímulos
    ------------------------------------------------------------------

    stim_proc : process
    begin

        -- Reset
        rst <= '1';
        wait for 40 ns;
        rst <= '0';

        --------------------------------------------------------------
        -- Primeiro sorteio
        --------------------------------------------------------------
        wait for 40 ns;
        cmd_sorteio <= '1';
        wait for 60 ns;
        cmd_sorteio <= '0';

        --------------------------------------------------------------
        -- Segundo sorteio
        --------------------------------------------------------------
        wait for 120 ns;
        cmd_sorteio <= '1';
        wait for 60 ns;
        cmd_sorteio <= '0';

        --------------------------------------------------------------
        -- Mantém botão pressionado
        --------------------------------------------------------------
        wait for 120 ns;
        cmd_sorteio <= '1';
        wait for 120 ns;
        cmd_sorteio <= '0';

        --------------------------------------------------------------
        -- Quarto sorteio
        --------------------------------------------------------------
        wait for 120 ns;
        cmd_sorteio <= '1';
        wait for 60 ns;
        cmd_sorteio <= '0';

        --------------------------------------------------------------
        -- Final (~740 ns)
        --------------------------------------------------------------
        wait for 200 ns;

        wait;

    end process;

end Behavioral;