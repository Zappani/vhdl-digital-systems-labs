library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity relogio_top is
    Port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        pausa : in  std_logic;
        conf  : in  std_logic;

        seg : out std_logic_vector(6 downto 0);
        an  : out std_logic_vector(3 downto 0)
    );
end entity;

architecture Structural of relogio_top is

    -- Clock
    signal tick_1Hz     : std_logic;
    signal tick_refresh : std_logic;

    -- Segundos
    signal seg_u  : std_logic_vector(3 downto 0);
    signal seg_d  : std_logic_vector(2 downto 0);
    signal carry_sec : std_logic;

    -- Minutos
    signal min_u  : std_logic_vector(3 downto 0);
    signal min_d  : std_logic_vector(2 downto 0);
    signal carry_min : std_logic;

    -- Horas
    signal hora_u : std_logic_vector(3 downto 0);
    signal hora_d : std_logic_vector(1 downto 0);

    -- Display
    signal dig0, dig1, dig2, dig3 : std_logic_vector(3 downto 0);

begin

    -- 1) Divisor de clock
    u_clk: entity work.clock_div
        port map (
            clk          => clk,
            rst          => rst,
            tick_1Hz     => tick_1Hz,
            tick_refresh => tick_refresh
        );

    -- 2) Contador de segundos
    u_seg: entity work.contador_seg
        port map (
            clk       => clk,
            rst       => rst,
            pausa     => pausa,
            tick_1Hz  => tick_1Hz,
            seg_u     => seg_u,
            seg_d     => seg_d,
            carry_sec => carry_sec
        );

    -- 3) Contador de minutos
    u_min: entity work.contador_min
        port map (
            clk       => clk,
            rst       => rst,
            pausa     => pausa,
            carry_sec => carry_sec,
            min_u     => min_u,
            min_d     => min_d,
            carry_min => carry_min
        );

    -- 4) Contador de horas
    u_hora: entity work.contador_hora
        port map (
            clk        => clk,
            rst        => rst,
            pausa      => pausa,
            carry_min  => carry_min,
            hora_u     => hora_u,
            hora_d     => hora_d,
            carry_hora => open
        );

    -- 5) Controle de exibição
    u_ctrl: entity work.controle_display
        port map (
            conf   => conf,

            seg_u  => seg_u,
            seg_d  => seg_d,
            min_u  => min_u,
            min_d  => min_d,
            hora_u => hora_u,
            hora_d => hora_d,

            dig0   => dig0,
            dig1   => dig1,
            dig2   => dig2,
            dig3   => dig3
        );

    -- 6) Driver de display
    u_disp: entity work.driver_ssd
        port map (
            clk          => clk,
            rst          => rst,
            tick_refresh => tick_refresh,

            dig0 => dig0,
            dig1 => dig1,
            dig2 => dig2,
            dig3 => dig3,

            seg => seg,
            an  => an
        );

end architecture;