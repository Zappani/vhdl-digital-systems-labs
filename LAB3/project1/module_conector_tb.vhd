library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity module_conector_tb is
end module_conector_tb;

architecture behavior of module_conector_tb is

    signal clk   : std_logic := '0';
    signal rst   : std_logic := '0';
    signal ena   : std_logic := '0';
    signal seg   : std_logic_vector(6 downto 0);
    signal anodo : std_logic_vector(3 downto 0);

begin

    uut: entity work.module_conector
        port map (
            clk => clk,
            rst => rst,
            ena => ena,
            seg => seg,
            anodo => anodo
        );

    clk_process : process
    begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;

    stim_proc: process
    begin
        rst <= '1';
        ena <= '0';
        wait for 100 ns;

        rst <= '0';
        ena <= '1';

        wait;
    end process;

end behavior;