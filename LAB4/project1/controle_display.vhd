library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity controle_display is
    Port (
        conf   : in  std_logic;

        seg_u  : in  std_logic_vector(3 downto 0);
        seg_d  : in  std_logic_vector(2 downto 0);
        min_u  : in  std_logic_vector(3 downto 0);
        min_d  : in  std_logic_vector(2 downto 0);
        hora_u : in  std_logic_vector(3 downto 0);
        hora_d : in  std_logic_vector(1 downto 0);

        dig0   : out std_logic_vector(3 downto 0);
        dig1   : out std_logic_vector(3 downto 0);
        dig2   : out std_logic_vector(3 downto 0);
        dig3   : out std_logic_vector(3 downto 0)
    );
end entity;

architecture Behavioral of controle_display is
begin

    process(conf, seg_u, seg_d, min_u, min_d, hora_u, hora_d)
    begin

        if conf = '0' then
            -- MM:SS
            dig0 <= seg_u;
            dig1 <= "0" & seg_d; -- ajusta para 4 bits
            dig2 <= min_u;
            dig3 <= "0" & min_d;

        else
            -- HH:MM
            dig0 <= min_u;
            dig1 <= "0" & min_d;
            dig2 <= hora_u;
            dig3 <= "00" & hora_d;

        end if;

    end process;

end architecture;