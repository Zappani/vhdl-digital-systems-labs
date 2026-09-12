library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity driver_ssd is
    Port (
        clk          : in  std_logic;
        rst          : in  std_logic;
        tick_refresh : in  std_logic;

        dig0 : in std_logic_vector(3 downto 0);
        dig1 : in std_logic_vector(3 downto 0);
        dig2 : in std_logic_vector(3 downto 0);
        dig3 : in std_logic_vector(3 downto 0);

        seg : out std_logic_vector(6 downto 0);
        an  : out std_logic_vector(3 downto 0)
    );
end entity;

architecture Behavioral of driver_ssd is

    signal sel : unsigned(1 downto 0) := (others => '0');
    signal digit : std_logic_vector(3 downto 0);

begin

    -- Controle de multiplexação
    process(clk)
    begin
        if rising_edge(clk) then

            if rst = '1' then
                sel <= (others => '0');

            elsif tick_refresh = '1' then
                sel <= sel + 1;
            end if;

        end if;
    end process;

    -- Seleção do dígito
    process(sel, dig0, dig1, dig2, dig3)
    begin
        case sel is
            when "00" =>
                an <= "1110"; -- ativa dig0
                digit <= dig0;

            when "01" =>
                an <= "1101"; -- ativa dig1
                digit <= dig1;

            when "10" =>
                an <= "1011"; -- ativa dig2
                digit <= dig2;

            when others =>
                an <= "0111"; -- ativa dig3
                digit <= dig3;
        end case;
    end process;

    -- Decodificador BCD → 7 segmentos (ativo baixo)
    process(digit)
    begin
        case digit is
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
            when others => seg <= "1111111"; -- apagado
        end case;
    end process;

end architecture;