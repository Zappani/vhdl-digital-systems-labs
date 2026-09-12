library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity maquina_cafe is
    Port (
        clk             : in  STD_LOGIC;
        rst             : in  STD_LOGIC;
        sel             : in  STD_LOGIC;
        nota1           : in  STD_LOGIC;
        nota2           : in  STD_LOGIC;
        pronto          : out STD_LOGIC;
        troco           : out STD_LOGIC
    );
end maquina_cafe;

architecture Behavioral of maquina_cafe is

    type estados is (
        espera,
        v1,
        v2,
        v3,
        v4,
        entrega,
        entrega_troco
    );

    signal estado_atual, proximo_estado : estados;

begin

--------------------------------------------------------------------
-- PROCESSO SEQUENCIAL
--------------------------------------------------------------------

process(clk, rst)
begin

    if (rst = '1') then
        estado_atual <= espera;

    elsif rising_edge(clk) then
        estado_atual <= proximo_estado;

    end if;

end process;

--------------------------------------------------------------------
-- PROCESSO COMBINACIONAL
--------------------------------------------------------------------

process(estado_atual, nota1, nota2, sel)
begin

    -- valores padrão
    pronto <= '0';
    troco  <= '0';

    case estado_atual is

    ----------------------------------------------------------------
    when espera =>

        if (nota1 = '1' and nota2 = '0') then
            proximo_estado <= v1;

        elsif (nota1 = '0' and nota2 = '1') then
            proximo_estado <= v2;

        else
            proximo_estado <= espera;

        end if;

    ----------------------------------------------------------------
    when v1 =>

        if (nota1 = '1' and nota2 = '0') then
            proximo_estado <= v2;

        elsif (nota1 = '0' and nota2 = '1') then
            proximo_estado <= v3;

        else
            proximo_estado <= v1;

        end if;

    ----------------------------------------------------------------
    when v2 =>

        if (nota1 = '1' and nota2 = '0') then
            proximo_estado <= v3;

        elsif (nota1 = '0' and nota2 = '1') then
            proximo_estado <= v4;

        else
            proximo_estado <= v2;

        end if;

    ----------------------------------------------------------------
    when v3 =>

        if (sel = '0') then

            proximo_estado <= entrega;

        else

            if (nota1 = '1' and nota2 = '0') then
                proximo_estado <= v4;

            elsif (nota1 = '0' and nota2 = '1') then
                proximo_estado <= entrega;

            else
                proximo_estado <= v3;

            end if;

        end if;

    ----------------------------------------------------------------
    when v4 =>

        if (sel = '0') then

            proximo_estado <= entrega_troco;

        else

            if (nota1 = '1' and nota2 = '0') then
                proximo_estado <= entrega;

            elsif (nota1 = '0' and nota2 = '1') then
                proximo_estado <= entrega_troco;

            else
                proximo_estado <= v4;

            end if;

        end if;

    ----------------------------------------------------------------
    when entrega =>

        pronto <= '1';
        troco  <= '0';

        proximo_estado <= espera;

    ----------------------------------------------------------------
    when entrega_troco =>

        pronto <= '1';
        troco  <= '1';

        proximo_estado <= espera;

    ----------------------------------------------------------------
    when others =>

        proximo_estado <= espera;

    end case;

end process;

end Behavioral;