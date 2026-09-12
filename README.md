# Microeletrônica — Laboratórios de VHDL

Projetos de VHDL desenvolvidos na disciplina, implementados no Xilinx ISE para a FPGA
**Spartan-3E `xc3s1200e`** (placa Nexys 2). Cada `LAB*/` contém um ou mais projetos ISE
(`.xise`) com os fontes (`.vhd`), o testbench (`*_tb.vhd` / `tb_*.vhd`) e o arquivo de
pinos (`.ucf`).

## LAB1 — Registrador com multiplexador

`reg_mux.vhd`: mux 4×1 selecionado por `sel(1:0)` com duas saídas — `x` combinacional
(direto do mux) e `y` registrada na borda de subida do `clk`. Serve para comparar
lógica combinacional × sequencial na mesma estrutura.

- `envio/` — pacotes entregues (`project1`/`project2`) e `relatorio1.pdf`
- `imagens/` — esquemáticos, simulações e uso de recursos

## LAB2 — Blocos combinacionais

Três projetos independentes:

| Projeto | Módulo | O que faz |
|---|---|---|
| `project1` | `decod_bcd` | Decodificador BCD → display de 7 segmentos (ativo em nível baixo), com seleção de anodo |
| `project2` | `decod_priorid` | Codificador/decodificador de prioridade genérico (`N` bits): mantém apenas o bit ativo mais significativo |
| `project3` | `ula` | ULA genérica de `N` bits com `opcode(2:0)`: soma, subtração, AND, OR, XOR, NOT, incremento e decremento, com `enable`, `cout` e `overflow` |

## LAB3 — Contadores e tratamento de botão

- `project1` — `module_conector`: integra `temporizador` (divisor de clock + contador
  0–9) com o `decod_bcd` do LAB2, exibindo a contagem no display.
- `debouncer` — `debouncer.vhd`: filtro de ruído mecânico de botão por contagem de
  estabilidade (`MAX_COUNT` ciclos).
- `project2` — `contador` / `top_placa`: contador 0–9 no display comandado por botão
  já com debounce integrado, com `rst`, `ena` e controle de sentido (`up_down`) pelas
  chaves.

## LAB4 — Relógio digital

`relogio_top.vhd` (descrição estrutural) monta um relógio hora:minuto:segundo:

- `clock_div` — gera o tick de 1 Hz e o tick de varredura do display
- `contador_seg`, `contador_min`, `contador_hora` — contagem em cascata (60/60/24)
- `controle_display` — escolhe o que mostrar: min:seg (normal) ou hora:min (`conf = '1'`)
- `driver_ssd` — multiplexação dos 4 dígitos no display de 7 segmentos

Entradas: `rst`, `pausa` e `conf`.

## LAB5 — Máquina de estados: máquina de café

`maquina_cafe.vhd`: FSM que acumula crédito a partir de duas notas (`nota1`, `nota2`)
passando pelos estados `espera → v1..v4 → entrega / entrega_troco`. A entrada `sel`
escolhe o produto (preço diferente), e as saídas sinalizam `pronto` e `troco`.
`maquina_cafe_top.vhd` adiciona `debouncer` (pulso único por aperto) e `timer_5s`
(temporização da entrega) para uso real na placa.

## LAB_EXTRA — Subprogramas em VHDL (package)

- `projeto1` — função `maior_sequencia_0s`: recebe 32 bits e retorna, em 6 bits, o
  comprimento da maior sequência consecutiva de zeros.
- `projeto2` — procedimento `ordenador_decrescente`: ordena 8 valores de 4 bits em
  ordem decrescente.

Ambos exercitam `package` / `package body` com função e procedimento.

## LAB_FINAL — Mini Bingo (projeto aplicativo)

`mini_bingo_top` integra o sistema completo:

- `controle_bingo` — FSM do sorteio (`ESPERA → PROCURA_NUMERO → VALIDA →
  ESPERA_SOLTAR → FIM_JOGO`), com registro dos 25 números já sorteados, contador de
  rodadas e último número sorteado
- `gerador` (`gerador_vga`) — controlador VGA 800×600 que desenha a cartela 5×5,
  destacando as casas já sorteadas
- `ssd_driver` — display de 7 segmentos multiplexado com rolagem, mostrando rodada e
  último número
- debounce do botão `sorteio` feito no próprio top

Saídas: display de 7 segmentos (`seg`, `an_out`) e VGA (`vga_r/g/b`, `vga_hs`, `vga_vs`).
