------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decod_priorid is
    generic ( N : integer := 8);
    Port (
        x : in  std_logic_vector(N-1 downto 0);
        y : out std_logic_vector(N-1 downto 0)
    );
end decod_priorid;

architecture Behavioral of decod_priorid is

    signal higher : std_logic_vector(N-1 downto 0);

begin

    higher(N-1) <= '0';

    gen_h: for i in N-2 downto 0 generate
        higher(i) <= x(i+1) or higher(i+1);
    end generate;

    gen_y: for i in 0 to N-1 generate
        y(i) <= x(i) when higher(i) = '0' else '0';
    end generate;

end Behavioral;