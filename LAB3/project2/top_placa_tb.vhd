library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_placa_tb is
end top_placa_tb ;

architecture sim of top_placa_tb is

    signal clk     : std_logic := '0';
    signal rst     : std_logic := '0';
    signal ena     : std_logic := '0';
    signal bt      : std_logic := '0';
    signal up_down : std_logic := '0';
    signal seg     : std_logic_vector(6 downto 0);
    signal an      : std_logic_vector(3 downto 0);

begin

    uut: entity work.contador
        generic map (
            fclk => 1,
            janela => 1
        )
        port map (
            clk => clk,
            rst => rst,
            ena => ena,
            bt => bt,
            up_down => up_down,
            seg => seg,
            an => an
        );

    clk <= not clk after 5 ns;

    process
    begin
        rst <= '1';
        ena <= '0';
        bt  <= '0';
        up_down <= '1';
        wait for 20 ns;

        rst <= '0';
        ena <= '1';

        wait for 20 ns;

        bt <= '1'; wait for 20 ns;
        bt <= '0'; wait for 100 ns;

        bt <= '1'; wait for 20 ns;
        bt <= '0'; wait for 100 ns;

        bt <= '1'; wait for 20 ns;
        bt <= '0'; wait for 100 ns;

        up_down <= '0';

        bt <= '1'; wait for 20 ns;
        bt <= '0'; wait for 100 ns;

        bt <= '1'; wait for 20 ns;
        bt <= '0'; wait for 100 ns;

        ena <= '0';

        bt <= '1'; wait for 20 ns;
        bt <= '0'; wait for 100 ns;

        ena <= '1';

        bt <= '1'; wait for 20 ns;
        bt <= '0'; wait for 100 ns;

        rst <= '1'; wait for 20 ns;
        rst <= '0';

        wait for 200 ns;

        wait;
    end process;

end sim;