library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_maquina_cafe is
end tb_maquina_cafe;

architecture Behavioral of tb_maquina_cafe is

    component maquina_cafe_top
        Port (
            clk     : in  STD_LOGIC;
            rst     : in  STD_LOGIC;
            sel     : in  STD_LOGIC;
            nota1   : in  STD_LOGIC;
            nota2   : in  STD_LOGIC;
            pronto  : out STD_LOGIC;
            troco   : out STD_LOGIC
        );
    end component;

    ----------------------------------------------------------------
    -- SINAIS

    signal clk      : STD_LOGIC := '0';
    signal rst      : STD_LOGIC := '0';

    signal sel      : STD_LOGIC := '0';

    signal nota1    : STD_LOGIC := '0';
    signal nota2    : STD_LOGIC := '0';

    signal pronto   : STD_LOGIC;
    signal troco    : STD_LOGIC;

    ----------------------------------------------------------------
    -- CLOCK
	 
    constant clk_period : time := 20 ns;

begin

    ----------------------------------------------------------------
    -- INSTÂNCIA DUT
    ----------------------------------------------------------------

    DUT : maquina_cafe_top
        port map(
            clk     => clk,
            rst     => rst,
            sel     => sel,
            nota1   => nota1,
            nota2   => nota2,
            pronto  => pronto,
            troco   => troco
        );

    ----------------------------------------------------------------
    -- GERAÇÃO CLOCK

    clk_process : process
    begin

        clk <= '0';
        wait for clk_period/2;

        clk <= '1';
        wait for clk_period/2;

    end process;

	--------------------------------------------------------------------------------------------------------------------------------
	-- ESTÍMULOS

	stim_proc : process
	begin

		 ------------------------------------------------------------
		 -- RESET

		 rst <= '1';

		 wait for 40 ns;

		 rst <= '0';

		 wait for 40 ns;

		 ------------------------------------------------------------
		 -- TESTE 1
		 -- CAFÉ COADO SEM TROCO
		 -- 1 + 2 = 3

		 sel <= '0';

		 nota1 <= '1';
		 wait for 20 ns;
		 nota1 <= '0';

		 wait for 20 ns;

		 nota2 <= '1';
		 wait for 20 ns;
		 nota2 <= '0';

		 wait for 140 ns;

		 ------------------------------------------------------------
		 -- TESTE 2
		 -- CAFÉ COADO COM TROCO
		 -- 2 + 2 = 4

		 sel <= '0';

		 nota2 <= '1';
		 wait for 20 ns;
		 nota2 <= '0';

		 wait for 20 ns;

		 nota2 <= '1';
		 wait for 20 ns;
		 nota2 <= '0';

		 wait for 180 ns;

		 ------------------------------------------------------------
		 -- TESTE 3
		 -- CAPPUCCINO SEM TROCO
		 -- 2 + 2 + 1 = 5

		 sel <= '1';

		 nota2 <= '1';
		 wait for 20 ns;
		 nota2 <= '0';

		 wait for 20 ns;

		 nota2 <= '1';
		 wait for 20 ns;
		 nota2 <= '0';

		 wait for 20 ns;

		 nota1 <= '1';
		 wait for 20 ns;
		 nota1 <= '0';

		 wait for 180 ns;

		 ------------------------------------------------------------
		 -- TESTE 4
		 -- CAPPUCCINO COM TROCO
		 -- 2 + 2 + 2 = 6

		 sel <= '1';

		 nota2 <= '1';
		 wait for 20 ns;
		 nota2 <= '0';

		 wait for 20 ns;

		 nota2 <= '1';
		 wait for 20 ns;
		 nota2 <= '0';

		 wait for 20 ns;

		 nota2 <= '1';
		 wait for 20 ns;
		 nota2 <= '0';

		 wait for 180 ns;

		 ------------------------------------------------------------
		 -- TESTE 5
		 -- ENTRADA INVÁLIDA

		 sel <= '0';

		 nota1 <= '1';
		 nota2 <= '1';

		 wait for 20 ns;

		 nota1 <= '0';
		 nota2 <= '0';

		 wait for 180 ns;

		 wait;

	end process;

end Behavioral;