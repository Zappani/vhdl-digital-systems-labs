library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity contador_min is
    Port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        pausa     : in  std_logic;
        carry_sec : in  std_logic;
        min_u     : out std_logic_vector(3 downto 0);
        min_d     : out std_logic_vector(2 downto 0);
        carry_min : out std_logic
    );
end entity;

architecture Behavioral of contador_min is

    signal u : integer range 0 to 9 := 0;
    signal d : integer range 0 to 5 := 0;

begin

    process(clk)
    begin
        if rising_edge(clk) then

            if rst = '1' then
                u <= 0;
                d <= 0;
                carry_min <= '0';

            elsif pausa = '0' and carry_sec = '1' then

                if u = 9 then
                    u <= 0;

                    if d = 5 then
                        d <= 0;
                        carry_min <= '1';
                    else
                        d <= d + 1;
                        carry_min <= '0';
                    end if;

                else
                    u <= u + 1;
                    carry_min <= '0';
                end if;

            else
                carry_min <= '0';
            end if;

        end if;
    end process;

    -- Saídas
    min_u <= std_logic_vector(to_unsigned(u, 4));
    min_d <= std_logic_vector(to_unsigned(d, 3));

end architecture;