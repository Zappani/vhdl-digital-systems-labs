library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity controle_bingo is
    Port (
        clk           : in  STD_LOGIC;
        rst           : in  STD_LOGIC;
        cmd_sorteio   : in  STD_LOGIC;
        reg_sorteados : out STD_LOGIC_VECTOR(24 downto 0);
        num_rodada    : out unsigned(5 downto 0);
        u_sorteado    : out unsigned(4 downto 0)
    );
end controle_bingo;

architecture Behavioral of controle_bingo is

    type estado_tipo is (
        ESPERA,
        PROCURA_NUMERO,
        VALIDA,
        ESPERA_SOLTAR,
        FIM_JOGO
    );

    signal estado_atual : estado_tipo := ESPERA;

    signal tabela_historico : STD_LOGIC_VECTOR(24 downto 0) := (others => '0');
    signal rodadas_cnt      : unsigned(5 downto 0) := (others => '0');
    signal ultimo_reg       : unsigned(4 downto 0) := (others => '0');

    signal r_gerador     : integer range 1 to 25 := 1;
    signal num_candidato : integer range 1 to 25 := 1;

begin

    ------------------------------------------------------------------
    -- Gerador circular 1..25
    ------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then
            if r_gerador = 25 then
                r_gerador <= 1;
            else
                r_gerador <= r_gerador + 1;
            end if;
        end if;
    end process;

    ------------------------------------------------------------------
    -- Máquina de estados principal
    ------------------------------------------------------------------
    process(clk, rst)
    begin
        if rst = '1' then

            estado_atual     <= ESPERA;
            tabela_historico <= (others => '0');
            rodadas_cnt      <= (others => '0');
            ultimo_reg       <= (others => '0');
            num_candidato    <= 1;

        elsif rising_edge(clk) then

            case estado_atual is

                ------------------------------------------------------
                when ESPERA =>
                ------------------------------------------------------
                    if rodadas_cnt = 25 then
                        estado_atual <= FIM_JOGO;

                    elsif cmd_sorteio = '1' then
                        num_candidato <= r_gerador;
                        estado_atual  <= PROCURA_NUMERO;
                    end if;

                ------------------------------------------------------
                when PROCURA_NUMERO =>
                ------------------------------------------------------
                    if tabela_historico(num_candidato - 1) = '0' then
                        estado_atual <= VALIDA;

                    else
                        if num_candidato = 25 then
                            num_candidato <= 1;
                        else
                            num_candidato <= num_candidato + 1;
                        end if;
                    end if;

                ------------------------------------------------------
                when VALIDA =>
                ------------------------------------------------------
                    tabela_historico(num_candidato - 1) <= '1';
                    rodadas_cnt <= rodadas_cnt + 1;
                    ultimo_reg  <= to_unsigned(num_candidato, 5);

                    estado_atual <= ESPERA_SOLTAR;

                ------------------------------------------------------
                when ESPERA_SOLTAR =>
                ------------------------------------------------------
                    if cmd_sorteio = '0' then
                        estado_atual <= ESPERA;
                    end if;

                ------------------------------------------------------
                when FIM_JOGO =>
                ------------------------------------------------------
                    estado_atual <= FIM_JOGO;

                ------------------------------------------------------
                when others =>
                ------------------------------------------------------
                    estado_atual <= ESPERA;

            end case;
        end if;
    end process;

    ------------------------------------------------------------------
    -- Saídas
    ------------------------------------------------------------------
    reg_sorteados <= tabela_historico;
    num_rodada    <= rodadas_cnt;
    u_sorteado    <= ultimo_reg;

end Behavioral;