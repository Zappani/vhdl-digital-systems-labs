library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity debouncer is
    generic(
        MAX_COUNT : integer := 500000
    );
    Port (
        clk : in  STD_LOGIC;
        x   : in  STD_LOGIC;
        y   : out STD_LOGIC
    );
end debouncer;

architecture Behavioral of debouncer is
    signal count : unsigned(18 downto 0) := (others => '0');
    signal state : std_logic := '0';
begin

    process(clk)
    begin
        if rising_edge(clk) then

            if x /= state then
                if count = MAX_COUNT then
                    state <= x;
                    count <= (others => '0');
                else
                    count <= count + 1;
                end if;
            else
                count <= (others => '0');
            end if;

        end if;
    end process;

    y <= state;

end Behavioral;