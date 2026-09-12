library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_gerador_vga is
end tb_gerador_vga;

architecture Behavioral of tb_gerador_vga is

    component gerador_vga
        port (
            clk_50mhz : in  std_logic;
            rst       : in  std_logic;
            drawn     : in  std_logic_vector(24 downto 0);
            last_num  : in  std_logic_vector(4 downto 0);

            h_sync : out std_logic;
            v_sync : out std_logic;

            r : out std_logic_vector(2 downto 0);
            g : out std_logic_vector(2 downto 0);
            b : out std_logic_vector(1 downto 0)
        );
    end component;

    signal clk_50mhz : std_logic := '0';
    signal rst       : std_logic := '1';

    signal drawn     : std_logic_vector(24 downto 0) := (others => '0');
    signal last_num  : std_logic_vector(4 downto 0) := (others => '0');

    signal h_sync    : std_logic;
    signal v_sync    : std_logic;

    signal r         : std_logic_vector(2 downto 0);
    signal g         : std_logic_vector(2 downto 0);
    signal b         : std_logic_vector(1 downto 0);

    constant CLK_PERIOD : time := 20 ns;

begin

    ------------------------------------------------------------------
    -- DUT
    ------------------------------------------------------------------

    DUT : gerador_vga
    port map (
        clk_50mhz => clk_50mhz,
        rst       => rst,
        drawn     => drawn,
        last_num  => last_num,
        h_sync    => h_sync,
        v_sync    => v_sync,
        r         => r,
        g         => g,
        b         => b
    );

    ------------------------------------------------------------------
    -- Clock 50 MHz
    ------------------------------------------------------------------

    clk_process : process
    begin
        while true loop
            clk_50mhz <= '0';
            wait for CLK_PERIOD/2;
            clk_50mhz <= '1';
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

        -- Nenhuma célula sorteada
        drawn <= (others => '0');
        last_num <= std_logic_vector(to_unsigned(5,5));
        wait for 240 ns;

        -- Marca algumas células
        drawn(0)  <= '1';
        drawn(4)  <= '1';
        drawn(10) <= '1';
        drawn(24) <= '1';
        last_num <= std_logic_vector(to_unsigned(1,5));
        wait for 240 ns;

        -- Novo último número
        last_num <= std_logic_vector(to_unsigned(25,5));
        wait for 240 ns;

        -- Todas as células sorteadas
        drawn <= (others => '1');
        last_num <= std_logic_vector(to_unsigned(13,5));
        wait for 240 ns;

        wait;

    end process;

end Behavioral;