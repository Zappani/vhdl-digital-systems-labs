library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg_mux is
    Port ( a, b, c, d: IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
           sel : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
           clk : in  STD_LOGIC;
           x, y :OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
end entity;

architecture reg_mux of reg_mux is
    signal mux: STD_LOGIC_VECTOR(3 DOWNTO 0);

begin
    mux <= a when sel="00" else
           b when sel="01" else
           c when sel="10" else
           d;
    
    x <= mux;

    process (clk)
    begin 
        if (clk'EVENT and clk='1') then 
            y <= mux;
        end if;
    end process;
end architecture;