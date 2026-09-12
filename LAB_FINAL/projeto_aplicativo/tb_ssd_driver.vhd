library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_ssd_driver is
end tb_ssd_driver;

architecture Behavioral of tb_ssd_driver is

    --------------------------------------------------------------------
    -- Component Declaration
    --------------------------------------------------------------------
    component ssd_driver
        generic (
            CLK_FREQ_HZ : integer := 50000000;
            REFRESH_HZ  : integer := 1000;
            SCROLL_HZ   : integer := 2
        );
        port (
            clk          : in  std_logic;
            rst          : in  std_logic;
            game_started : in  std_logic;
            round_num    : in  std_logic_vector(5 downto 0);
            last_num     : in  std_logic_vector(4 downto 0);
            AN           : out std_logic_vector(3 downto 0);
            seg          : out std_logic_vector(6 downto 0)
        );
    end component;

    --------------------------------------------------------------------
    -- Signals
    --------------------------------------------------------------------
    signal clk          : std_logic := '0';
    signal rst          : std_logic := '1';
    signal game_started : std_logic := '0';
    signal round_num    : std_logic_vector(5 downto 0) := (others => '0');
    signal last_num     : std_logic_vector(4 downto 0) := (others => '0');

    signal AN  : std_logic_vector(3 downto 0);
    signal seg : std_logic_vector(6 downto 0);

    constant CLK_PERIOD : time := 20 ns;

begin

    --------------------------------------------------------------------
    -- DUT
    --------------------------------------------------------------------
    DUT : ssd_driver
		generic map (
			 CLK_FREQ_HZ => 100,
			 REFRESH_HZ  => 25,    -- REFRESH_MAX = 1
			 SCROLL_HZ   => 50     -- SCROLL_MAX = 2
		)
		port map (
			 clk          => clk,
			 rst          => rst,
			 game_started => game_started,
			 round_num    => round_num,
			 last_num     => last_num,
			 AN           => AN,
			 seg          => seg
		);

    --------------------------------------------------------------------
    -- Clock
    --------------------------------------------------------------------
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process;

    --------------------------------------------------------------------
    -- Stimulus
    --------------------------------------------------------------------
    stim_proc : process
		begin

			 -- Reset
			 rst <= '1';
			 wait for 20 ns;
			 rst <= '0';

			 -- Mensagem em scroll
			 game_started <= '0';
			 wait for 120 ns;

			 -- Rodada 3 - Número 7
			 game_started <= '1';
			 round_num <= std_logic_vector(to_unsigned(3,6));
			 last_num  <= std_logic_vector(to_unsigned(7,5));
			 wait for 120 ns;

			 -- Rodada 12 - Número 18
			 round_num <= std_logic_vector(to_unsigned(12,6));
			 last_num  <= std_logic_vector(to_unsigned(18,5));
			 wait for 120 ns;

			 -- Rodada 24 - Número 29
			 round_num <= std_logic_vector(to_unsigned(24,6));
			 last_num  <= std_logic_vector(to_unsigned(29,5));
			 wait for 120 ns;

			 wait;

end process;

end Behavioral;