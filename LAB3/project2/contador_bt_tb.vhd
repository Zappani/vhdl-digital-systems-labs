library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity contador_bt_tb is
end contador_bt_tb;

architecture behavior of contador_bt_tb is

    signal clk      : std_logic := '0';
    signal rst      : std_logic := '0';
    signal ena      : std_logic := '0';
    signal up_down  : std_logic := '1';
    signal bt       : std_logic := '0';
    signal seg      : std_logic_vector(6 downto 0);
    signal anodo    : std_logic_vector(3 downto 0);

begin

    uut: entity work.contador_bt
        generic map (
            DEBOUNCE_MAX_COUNT => 50
        )
        port map (
            clk      => clk,
            rst      => rst,
            ena      => ena,
            up_down  => up_down,
            bt       => bt,
            seg      => seg,
            anodo    => anodo
        );

    -- clock 50 MHz
    clk_process : process
    begin
        while true loop
            clk <= '0'; wait for 10 ns;
            clk <= '1'; wait for 10 ns;
        end loop;
    end process;

    stim_proc: process
	 begin
		 -- reset
		 rst <= '1'; 
		 wait for 200 ns;
		 rst <= '0';
		 ena <= '1';

		 -- garantir estado estável inicial do botão
		 bt <= '0';
		 wait for 5 us;

		 -- incremento 1 (borda válida)
		 bt <= '1'; wait for 5 us;
		 bt <= '0'; wait for 5 us;

		 -- incremento 2
		 bt <= '1'; wait for 5 us;
		 bt <= '0'; wait for 5 us;

		 -- mudar direção
		 up_down <= '0';
		 wait for 5 us;

		 -- decremento
		 bt <= '1'; wait for 5 us;
		 bt <= '0'; wait for 5 us;

		 wait;
	 end process;

end behavior;