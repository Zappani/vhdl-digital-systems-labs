library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_mini_bingo_top is
end tb_mini_bingo_top;

architecture sim of tb_mini_bingo_top is

    component mini_bingo_top
		Port (
				  clk      : in  STD_LOGIC;
				  rst      : in  STD_LOGIC;
				  sorteio  : in  STD_LOGIC;
				  seg      : out STD_LOGIC_VECTOR(6 downto 0);
				  an_out   : out STD_LOGIC_VECTOR(3 downto 0);
				  vga_r    : out STD_LOGIC_VECTOR(2 downto 0);
				  vga_g    : out STD_LOGIC_VECTOR(2 downto 0);
				  vga_b    : out STD_LOGIC_VECTOR(1 downto 0);
				  vga_hs   : out STD_LOGIC;
				  vga_vs   : out STD_LOGIC
			 );
		end component;

    --Entradas
		signal clk     : STD_LOGIC := '0';
		signal rst     : STD_LOGIC := '1';
		signal sorteio : STD_LOGIC := '0';

    --Saídas
      signal seg    : STD_LOGIC_VECTOR(6 downto 0);
		signal an_out : STD_LOGIC_VECTOR(3 downto 0);

		signal vga_r  : STD_LOGIC_VECTOR(2 downto 0);
		signal vga_g  : STD_LOGIC_VECTOR(2 downto 0);
		signal vga_b  : STD_LOGIC_VECTOR(1 downto 0);

		signal vga_hs : STD_LOGIC;
		signal vga_vs : STD_LOGIC;

    constant CLK_PERIOD : time := 20 ns;

begin

    uut: mini_bingo_top
		 port map (
			  clk      => clk,
			  rst      => rst,
			  sorteio  => sorteio,
			  seg      => seg,
			  an_out   => an_out,
			  vga_r    => vga_r,
			  vga_g    => vga_g,
			  vga_b    => vga_b,
			  vga_hs   => vga_hs,
			  vga_vs   => vga_vs
		 );

    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- Processo de Estímulo
	 tim_proc: process
		begin
			 rst <= '1';
			 sorteio <= '0';

			 wait for 60 ns;

			 rst <= '0';

			 wait for 40 ns;

			 -- PRIMEIRO SORTEIO

			 sorteio <= '1';
			 wait for 240 ns;   

			 sorteio <= '0';
			 wait for 40 ns;

			 -- SEGUNDO SORTEIO

			 sorteio <= '1';
			 wait for 240 ns;

			 sorteio <= '0';
			 wait for 40 ns;

			 -- TERCEIRO SORTEIO
			 sorteio <= '1';
			 wait for 240 ns;

			 sorteio <= '0';
			 
			 wait for 100 ns;
		end process;

end sim;