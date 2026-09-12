library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity contador_hora is
    Port (
        clk        : in  std_logic;
        rst        : in  std_logic;
        pausa      : in  std_logic;
        carry_min  : in  std_logic;
        hora_u     : out std_logic_vector(3 downto 0);
        hora_d     : out std_logic_vector(1 downto 0);
        carry_hora : out std_logic
    );
end entity;

architecture Behavioral of contador_hora is

    signal u : integer range 0 to 9 := 0;
    signal d : integer range 0 to 2 := 0;

begin

    process(clk)
    begin
        if rising_edge(clk) then

            if rst = '1' then
                u <= 0;
                d <= 0;
                carry_hora <= '0';

            elsif pausa = '0' and carry_min = '1' then

                -- Caso especial: 23 → 00
                if d = 2 and u = 3 then
                    u <= 0;
                    d <= 0;
                    carry_hora <= '1';

                else
                    if u = 9 then
                        u <= 0;
                        d <= d + 1;
                    else
                        u <= u + 1;
                    end if;

                    carry_hora <= '0';
                end if;

            else
                carry_hora <= '0';
            end if;

        end if;
    end process;

    -- Saídas
    hora_u <= std_logic_vector(to_unsigned(u, 4));
    hora_d <= std_logic_vector(to_unsigned(d, 2));

end architecture;