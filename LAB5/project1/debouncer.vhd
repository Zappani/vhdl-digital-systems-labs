library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity debouncer is
    generic(
        CLK_FREQ    : integer := 50000000; -- 50 MHz
        DEBOUNCE_MS : integer := 20        -- 20 ms
		  -- CLK_FREQ    : integer := 10; 
        -- DEBOUNCE_MS : integer := 1       
    );
    
    Port (
        clk         : in  STD_LOGIC;
        rst         : in  STD_LOGIC;
        btn_in      : in  STD_LOGIC;
        btn_pulse   : out STD_LOGIC
    );
    
end debouncer;

architecture Behavioral of debouncer is

    constant MAX_COUNT : integer :=
        (CLK_FREQ / 1000) * DEBOUNCE_MS;

    signal counter      : integer range 0 to MAX_COUNT := 0;

    signal btn_sync_0   : STD_LOGIC := '0';
    signal btn_sync_1   : STD_LOGIC := '0';

    signal btn_stable   : STD_LOGIC := '0';

    signal pulse_reg    : STD_LOGIC := '0';

begin

    ----------------------------------------------------------------
    -- SAÍDA

    btn_pulse <= pulse_reg;

    ----------------------------------------------------------------
    -- PROCESSO PRINCIPAL

    process(clk, rst)
    begin

        if (rst = '1') then

            btn_sync_0 <= '0';
            btn_sync_1 <= '0';

            btn_stable <= '0';

            counter    <= 0;

            pulse_reg  <= '0';

        elsif rising_edge(clk) then

            --------------------------------------------------------
            -- sincronização

            btn_sync_0 <= btn_in;
            btn_sync_1 <= btn_sync_0;

            --------------------------------------------------------
            -- padrão

            pulse_reg <= '0';

            --------------------------------------------------------
            -- debounce

            if (btn_sync_1 = btn_stable) then

                counter <= 0;

            else

                if (counter < MAX_COUNT) then

                    counter <= counter + 1;

                else

                    ------------------------------------------------
                    -- novo estado estável confirmado

                    btn_stable <= btn_sync_1;

                    counter <= 0;

                    ------------------------------------------------
                    -- gera pulso somente na borda de subida

                    if (btn_sync_1 = '1') then
                        pulse_reg <= '1';
                    end if;

                end if;

            end if;

        end if;

    end process;

end Behavioral;