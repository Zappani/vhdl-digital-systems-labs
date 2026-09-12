library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity module_conector is
    Port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        ena   : in  std_logic;
        seg   : out std_logic_vector(6 downto 0);
        anodo : out std_logic_vector(3 downto 0)
    );
end module_conector;

architecture Behavioral of module_conector is

    signal bcd_sig : std_logic_vector(3 downto 0);

begin

    u1: entity work.temporizador
        port map (
            clk => clk,
            rst => rst,
            ena => ena,
            bcd => bcd_sig
        );

    u2: entity work.decod_bcd
        port map (
            x => bcd_sig,
            y => seg,
            anodo => anodo
        );

end Behavioral;