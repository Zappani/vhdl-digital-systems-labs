library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity timer_5s is
    generic(
        CLK_FREQ : integer := 50000000;
        TIME_SEC : integer := 5
		  -- CLK_FREQ : integer := 2;
        -- TIME_SEC : integer := 1
    );

    Port (
        clk     : in  STD_LOGIC;
        rst     : in  STD_LOGIC;
        enable  : in  STD_LOGIC;
        done    : out STD_LOGIC
    );

end timer_5s;

architecture Behavioral of timer_5s is

    ----------------------------------------------------------------
    -- CONSTANTE

    constant MAX_COUNT : integer := CLK_FREQ * TIME_SEC;

    ----------------------------------------------------------------
    -- SINAIS

    signal counter  : integer range 0 to MAX_COUNT := 0;

    signal done_reg : STD_LOGIC := '0';

begin

    ----------------------------------------------------------------
    -- SAÍDA

    done <= done_reg;

    ----------------------------------------------------------------
    -- PROCESSO PRINCIPAL

    process(clk, rst)
    begin

        if (rst = '1') then

            counter  <= 0;
            done_reg <= '0';

        elsif rising_edge(clk) then

            --------------------------------------------------------
            -- timer desabilitado

            if (enable = '0') then

                counter  <= 0;
                done_reg <= '0';

            --------------------------------------------------------
            -- timer habilitado

            else

                if (counter < MAX_COUNT - 1) then

                    counter  <= counter + 1;
                    done_reg <= '0';

                else

                    counter  <= counter;
                    done_reg <= '1';

                end if;

            end if;

        end if;

    end process;

end Behavioral;