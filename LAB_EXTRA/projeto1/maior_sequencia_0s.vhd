library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package my_package is

    function maior_sequencia_0s(
        entrada : std_logic_vector(31 downto 0)
    ) return integer;

end package;


package body my_package is

    function maior_sequencia_0s(
        entrada : std_logic_vector(31 downto 0)
    ) return integer is

        variable contador : integer := 0;
        variable maximo   : integer := 0;

    begin

        for i in 31 downto 0 loop

            if entrada(i) = '0' then
                contador := contador + 1;

                if contador > maximo then
                    maximo := contador;
                end if;

            else
                contador := 0;
            end if;

        end loop;

        return maximo;

    end function;

end package body;