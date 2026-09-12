library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package my_package is

    procedure ordenador_decrescente(

        signal a0,a1,a2,a3,a4,a5,a6,a7 : in std_logic_vector(3 downto 0);

        signal s0,s1,s2,s3,s4,s5,s6,s7 : out std_logic_vector(3 downto 0)

    );

end package;

package body my_package is

procedure ordenador_decrescente(

    signal a0,a1,a2,a3,a4,a5,a6,a7 : in std_logic_vector(3 downto 0);

    signal s0,s1,s2,s3,s4,s5,s6,s7 : out std_logic_vector(3 downto 0)

) is

    type vetor_t is array(0 to 7) of integer;

    variable v   : vetor_t;
    variable tmp : integer;

begin

    v(0) := to_integer(unsigned(a0));
    v(1) := to_integer(unsigned(a1));
    v(2) := to_integer(unsigned(a2));
    v(3) := to_integer(unsigned(a3));
    v(4) := to_integer(unsigned(a4));
    v(5) := to_integer(unsigned(a5));
    v(6) := to_integer(unsigned(a6));
    v(7) := to_integer(unsigned(a7));

    for i in 0 to 6 loop
        for j in 0 to 6-i loop

            if v(j) < v(j+1) then

                tmp := v(j);
                v(j) := v(j+1);
                v(j+1) := tmp;

            end if;

        end loop;
    end loop;

    s0 <= std_logic_vector(to_unsigned(v(0),4));
    s1 <= std_logic_vector(to_unsigned(v(1),4));
    s2 <= std_logic_vector(to_unsigned(v(2),4));
    s3 <= std_logic_vector(to_unsigned(v(3),4));
    s4 <= std_logic_vector(to_unsigned(v(4),4));
    s5 <= std_logic_vector(to_unsigned(v(5),4));
    s6 <= std_logic_vector(to_unsigned(v(6),4));
    s7 <= std_logic_vector(to_unsigned(v(7),4));

end procedure;

end package body;