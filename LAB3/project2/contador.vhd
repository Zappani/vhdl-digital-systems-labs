library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity contador is
    generic(
        fclk   : integer := 50000; -- kHz (50 MHz)
        janela : integer := 10     -- ms, se muito sensivel aumenta pra 20 se muito lent ocoloca 5
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
end contador;

architecture Behavioral of contador is

    -- debouncer 
    signal bt_db : std_logic := '0';
    signal temp  : std_logic := '0';
    constant max : integer := fclk * janela;

    --detector de borda
    signal bt_prev : std_logic := '0';
    signal tick    : std_logic := '0';
    -- contador
    signal cont : unsigned(3 downto 0) := (others => '0');

begin

	process(clk)
		 variable cont_db : integer range 0 to max := 0;
	begin
		 -- reset
		 if rst = '1' then
			  temp    <= '0';
			  bt_db   <= '0';
			  cont_db := 0;
			  bt_prev <= '0';
			  tick    <= '0';
			  cont    <= (others => '0');

		 elsif rising_edge(clk) then

			  -- debouncer
			  if bt /= temp then
					cont_db := cont_db + 1;
					if cont_db = max then
						 temp <= bt;
						 cont_db := 0;
					end if;
			  else
					cont_db := 0;
			  end if;

			  bt_db <= temp;

			  -- detector de borda
			  tick <= bt_db and not bt_prev;
			  bt_prev <= bt_db;

			  -- contador
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

		 end if;  -- único fechamento correto
	end process;

     --- driver 7 seg
    process(cont)
    begin
        case cont is
            when "0000" => seg <= "1000000";
            when "0001" => seg <= "1111001";
            when "0010" => seg <= "0100100";
            when "0011" => seg <= "0110000";
            when "0100" => seg <= "0011001";
            when "0101" => seg <= "0010010";
            when "0110" => seg <= "0000010";
            when "0111" => seg <= "1111000";
            when "1000" => seg <= "0000000";
            when "1001" => seg <= "0010000";
            when others => seg <= "1111111";
        end case;
    end process;

    an <= "1110";

end Behavioral;