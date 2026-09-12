library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity maquina_cafe_top is
    Port (
        clk     : in  STD_LOGIC;
        rst     : in  STD_LOGIC;
        sel     : in  STD_LOGIC;
        nota1   : in  STD_LOGIC;
        nota2   : in  STD_LOGIC;

        pronto  : out STD_LOGIC;
        troco   : out STD_LOGIC
    );
end maquina_cafe_top;

architecture Behavioral of maquina_cafe_top is

    ----------------------------------------------------------------
    -- FSM

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

    ----------------------------------------------------------------
    -- DEBOUNCER

    signal nota1_pulse : STD_LOGIC;
    signal nota2_pulse : STD_LOGIC;

    ----------------------------------------------------------------
    -- TIMER

    signal timer_enable : STD_LOGIC;
    signal timer_done   : STD_LOGIC;

begin

    ----------------------------------------------------------------
    -- INSTÂNCIA DEBOUNCER NOTA1

    db_nota1 : entity work.debouncer
        port map(
            clk       => clk,
            rst       => rst,
            btn_in    => nota1,
            btn_pulse => nota1_pulse
        );

    ----------------------------------------------------------------
    -- INSTÂNCIA DEBOUNCER NOTA2

    db_nota2 : entity work.debouncer
        port map(
            clk       => clk,
            rst       => rst,
            btn_in    => nota2,
            btn_pulse => nota2_pulse
        );

    ----------------------------------------------------------------
    -- INSTÂNCIA TIMER

    timer_inst : entity work.timer_5s
        port map(
            clk    => clk,
            rst    => rst,
            enable => timer_enable,
            done   => timer_done
        );

    ----------------------------------------------------------------
    -- PROCESSO SEQUENCIAL

    process(clk, rst)
    begin

        if (rst = '1') then
            estado_atual <= espera;

        elsif rising_edge(clk) then
            estado_atual <= proximo_estado;

        end if;

    end process;

    ----------------------------------------------------------------
    -- PROCESSO COMBINACIONAL

    process(
        estado_atual,
        nota1_pulse,
        nota2_pulse,
        sel,
        timer_done
    )
    begin

        ------------------------------------------------------------
        -- valores padrão

        pronto       <= '0';
        troco        <= '0';

        timer_enable <= '0';

        proximo_estado <= estado_atual;

        ------------------------------------------------------------
        -- FSM

        case estado_atual is

        ------------------------------------------------------------
        when espera =>

            if (nota1_pulse = '1' and nota2_pulse = '0') then

                proximo_estado <= v1;

            elsif (nota1_pulse = '0' and nota2_pulse = '1') then

                proximo_estado <= v2;

            else

                proximo_estado <= espera;

            end if;

        ------------------------------------------------------------
        when v1 =>

            if (nota1_pulse = '1' and nota2_pulse = '0') then

                proximo_estado <= v2;

            elsif (nota1_pulse = '0' and nota2_pulse = '1') then

                proximo_estado <= v3;

            else

                proximo_estado <= v1;

            end if;

        ------------------------------------------------------------
        when v2 =>

            if (nota1_pulse = '1' and nota2_pulse = '0') then

                proximo_estado <= v3;

            elsif (nota1_pulse = '0' and nota2_pulse = '1') then

                proximo_estado <= v4;

            else

                proximo_estado <= v2;

            end if;

        ------------------------------------------------------------
        when v3 =>

            if (sel = '0') then

                proximo_estado <= entrega;

            else

                if (nota1_pulse = '1' and nota2_pulse = '0') then

                    proximo_estado <= v4;

                elsif (nota1_pulse = '0' and nota2_pulse = '1') then

                    proximo_estado <= entrega;

                else

                    proximo_estado <= v3;

                end if;

            end if;

        ------------------------------------------------------------
        when v4 =>

            if (sel = '0') then

                proximo_estado <= entrega_troco;

            else

                if (nota1_pulse = '1' and nota2_pulse = '0') then

                    proximo_estado <= entrega;

                elsif (nota1_pulse = '0' and nota2_pulse = '1') then

                    proximo_estado <= entrega_troco;

                else

                    proximo_estado <= v4;

                end if;

            end if;

        ------------------------------------------------------------
        when entrega =>

            pronto <= '1';

            timer_enable <= '1';

            if (timer_done = '1') then
                proximo_estado <= espera;
            else
                proximo_estado <= entrega;
            end if;

        ------------------------------------------------------------
        when entrega_troco =>

            pronto <= '1';
            troco  <= '1';

            timer_enable <= '1';

            if (timer_done = '1') then
                proximo_estado <= espera;
            else
                proximo_estado <= entrega_troco;
            end if;

        ------------------------------------------------------------
        when others =>

            proximo_estado <= espera;

        end case;

    end process;

end Behavioral;