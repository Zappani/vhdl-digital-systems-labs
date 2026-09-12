library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity contador_seg is
    Port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        pausa     : in  std_logic;
        tick_1Hz  : in  std_logic;
        seg_u     : out std_logic_vector(3 downto 0);
        seg_d     : out std_logic_vector(2 downto 0);
        carry_sec : out std_logic
    );
end entity;

architecture Behavioral of contador_seg is

    signal u : integer range 0 to 9 := 0;
    signal d : integer range 0 to 5 := 0;

begin

    process(clk)
    begin
        if rising_edge(clk) then

            if rst = '1' then
                u <= 0;
                d <= 0;
                carry_sec <= '0';

            elsif pausa = '0' and tick_1Hz = '1' then

                if u = 9 then
                    u <= 0;

                    if d = 5 then
                        d <= 0;
                        carry_sec <= '1';
                    else
                        d <= d + 1;
                        carry_sec <= '0';
                    end if;

                else
                    u <= u + 1;
                    carry_sec <= '0';
                end if;

            else
                carry_sec <= '0';
            end if;

        end if;
    end process;

    -- Conversão para saída
    seg_u <= std_logic_vector(to_unsigned(u, 4));
    seg_d <= std_logic_vector(to_unsigned(d, 3));

end architecture;