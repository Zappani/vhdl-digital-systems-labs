library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity temporizador is
    generic (
        --- DIV_MAX : integer := 24999999 --- TROCAR PARA COLOCAR NA PLACA
		  DIV_MAX : integer := 10 --- PARA SIMULAR
    );
    Port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        ena   : in  std_logic;
        bcd   : out std_logic_vector(3 downto 0)
    );
end temporizador;

architecture Behavioral of temporizador is

    signal count_div : unsigned(24 downto 0) := (others => '0');
    signal tick      : std_logic := '0';
    signal count     : unsigned(3 downto 0) := (others => '0');

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if count_div = DIV_MAX then
                count_div <= (others => '0');
                tick <= '1';
            else
                count_div <= count_div + 1;
                tick <= '0';
            end if;
        end if;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                count <= (others => '0');

            elsif ena = '1' and tick = '1' then
                if count = 9 then
                    count <= (others => '0');
                else
                    count <= count + 1;
                end if;
            end if;
        end if;
    end process;

    bcd <= std_logic_vector(count);

end Behavioral;
