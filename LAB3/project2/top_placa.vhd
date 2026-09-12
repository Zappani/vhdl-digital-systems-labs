library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_placa is
    Port (
        clk : in  STD_LOGIC;
        sw  : in  STD_LOGIC_VECTOR(2 downto 0);
        btn : in  STD_LOGIC;
        seg : out STD_LOGIC_VECTOR(6 downto 0);
        an  : out STD_LOGIC_VECTOR(3 downto 0)
    );
end top_placa;

architecture Behavioral of top_placa is

begin

    uut: entity work.contador
        generic map (
            fclk   => 50000, -- 50 MHz
            janela => 10     -- 10 ms debounce
        )
        port map (
            clk     => clk,
            rst     => sw(0),
            ena     => sw(1),
            bt      => btn,
            up_down => sw(2),
            seg     => seg,
            an      => an
        );

end Behavioral;