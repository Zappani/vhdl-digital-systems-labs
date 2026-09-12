library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity contador_0_9 is
	generic(
				fclk   : integer := 50000000; -- Hz
				janela : integer := 10        -- ms
				);
	Port (
			clk     : in  STD_LOGIC;
			rst     : in  STD_LOGIC;
			ena     : in  STD_LOGIC;
			bt      : in  STD_LOGIC;
			up_down : in  STD_LOGIC;
			seg     : out STD_LOGIC_VECTOR (6 downto 0);
			an      : out STD_LOGIC_VECTOR (3 downto 0)
			);
end contador_0_9;

architecture Behavioral of contador_0_9 is

constant max : integer := (fclk / 1000) * janela;
signal cont_db : unsigned(18 downto 0) := (others => '0');

signal bt_db : std_logic := '0';
signal temp  : std_logic := '0';

signal bt_prev : std_logic := '0';
signal tick    : std_logic := '0';

signal cont : unsigned(3 downto 0) := (others => '0');
begin

process(clk)
begin
    if rising_edge(clk) then

        if rst = '1' then
            temp    <= '0';
            bt_db   <= '0';
            cont_db <= (others => '0');
            bt_prev <= '0';
            tick    <= '0';
            cont    <= (others => '0');

        else

            -- debounce
            if bt /= temp then
                if cont_db < max then
                    cont_db <= cont_db + 1;
                else
                    temp    <= bt;
                    cont_db <= (others => '0');
                end if;
            else
                cont_db <= (others => '0');
            end if;

            bt_db <= temp;

            -- detector de borda (subida)
            tick <= bt_db and not bt_prev;
            bt_prev <= bt_db;

            -- contador 0-9
            if tick = '1' and ena = '1' then
                if up_down = '1' then
                    if cont = 9 then
                        cont <= (others => '0');
                    else
                        cont <= cont + 1;
                    end if;
                else
                    if cont = 0 then
                        cont <= to_unsigned(9,4);
                    else
                        cont <= cont - 1;
                    end if;
                end if;
            end if;

        end if;
    end if;
end process;

process(cont)
begin
    case cont is
        when "0000" => seg <= "1000000"; -- 0
        when "0001" => seg <= "1111001"; -- 1
        when "0010" => seg <= "0100100"; -- 2
        when "0011" => seg <= "0110000"; -- 3
        when "0100" => seg <= "0011001"; -- 4
        when "0101" => seg <= "0010010"; -- 5
        when "0110" => seg <= "0000010"; -- 6
        when "0111" => seg <= "1111000"; -- 7
        when "1000" => seg <= "0000000"; -- 8
        when "1001" => seg <= "0010000"; -- 9
        when others => seg <= "1111111";
    end case;
end process;

-- apenas 1 display ativo
an <= "1110";
end Behavioral;
