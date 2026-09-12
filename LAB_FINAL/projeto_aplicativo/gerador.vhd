library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity gerador_vga is
    port (
        clk_50mhz : in  std_logic;
        rst       : in  std_logic;
        drawn     : in  std_logic_vector(24 downto 0);
        last_num  : in  std_logic_vector(4 downto 0);

        h_sync : out std_logic;
        v_sync : out std_logic;

        r      : out std_logic_vector(2 downto 0);
        g      : out std_logic_vector(2 downto 0);
        b      : out std_logic_vector(1 downto 0)
    );
end entity;

architecture Behavioral of gerador_vga is
    constant HD : integer := 800;
    constant HF : integer := 56;
    constant HR : integer := 64;
    constant HB : integer := 120;

    constant VD : integer := 600;
    constant VF : integer := 37;
    constant VR : integer := 23;
    constant VB : integer := 6;

    constant H_TOTAL : integer := HD + HF + HR + HB;
    constant V_TOTAL : integer := VD + VF + VR + VB;
    constant GRID_X0 : integer := 100;
    constant GRID_Y0 : integer := 100;
    constant CELL_W  : integer := 120;
    constant CELL_H  : integer := 80;

    signal h_count  : integer range 0 to H_TOTAL-1 := 0;
    signal v_count  : integer range 0 to V_TOTAL-1 := 0;
    signal video_on : std_logic;

    signal num_linha  : integer range 0 to 4;
    signal num_coluna : integer range 0 to 4;
    signal num_atual  : integer range 1 to 25;

    subtype seg7 is std_logic_vector(6 downto 0);
    function digit_segments(d : integer) return seg7 is

 begin
        case d is
            when 0 => return "0111111";
            when 1 => return "0000110";
            when 2 => return "1011011";
            when 3 => return "1001111";
            when 4 => return "1100110";
            when 5 => return "1101101";
            when 6 => return "1111101";
            when 7 => return "0000111";
            when 8 => return "1111111";
            when 9 => return "1101111";
            when others => return "0000000";
        end case;
    end function;

    function tens_digit(n : integer) return integer is
		begin
        if n >= 20 then return 2;
        elsif n >= 10 then return 1;
        else return 0;
        end if;
    end function;

    function ones_digit(n : integer) return integer is
		begin
        case n is
            when 10 | 20 => return 0;
            when 1 | 11 | 21 => return 1;
            when 2 | 12 | 22 => return 2;
            when 3 | 13 | 23 => return 3;
            when 4 | 14 | 24 => return 4;
            when 5 | 15 | 25 => return 5;
            when 6 | 16      => return 6;
            when 7 | 17      => return 7;
            when 8 | 18      => return 8;
            when 9 | 19      => return 9;
            when others => return 0;
        end case;
    end function;

    function digit_pixel(d : integer; x : integer; y : integer) return std_logic is
        variable s      : std_logic_vector(6 downto 0);
        variable pix_on : std_logic := '0';
    begin
        if d < 0 then
            return '0';
        end if;

        s := digit_segments(d);
        if x >= 1 and x <= 28 and y >= 1 and y <= 49 then
            if s(0) = '1' and x >= 6 and x <= 23 and y >= 0 and y <= 4 then pix_on := '1'; end if; -- a
            if s(1) = '1' and x >= 25 and x <= 28 and y >= 6 and y <= 23 then pix_on := '1'; end if; -- b
            if s(2) = '1' and x >= 25 and x <= 28 and y >= 26 and y <= 43 then pix_on := '1'; end if; -- c
            if s(3) = '1' and x >= 6 and x <= 23 and y >= 45 and y <= 49 then pix_on := '1'; end if; -- d
            if s(4) = '1' and x >= 1 and x <= 4 and y >= 26 and y <= 43 then pix_on := '1'; end if; -- e
            if s(5) = '1' and x >= 1 and x <= 4 and y >= 6 and y <= 23 then pix_on := '1'; end if; -- f
            if s(6) = '1' and x >= 6 and x <= 23 and y >= 23 and y <= 27 then pix_on := '1'; end if; -- g
        end if;

        return pix_on;
    end function;

begin
    process(clk_50mhz)
    begin
        if rising_edge(clk_50mhz) then
            if rst = '1' then
                h_count <= 0;
                v_count <= 0;
            else
                if h_count = H_TOTAL - 1 then
                    h_count <= 0;
                    if v_count = V_TOTAL - 1 then
                        v_count <= 0;
                    else
                        v_count <= v_count + 1;
                    end if;
                else
                    h_count <= h_count + 1;
                end if;
            end if;
        end if;
    end process;

    h_sync <= '1' when (h_count >= HD + HF and h_count < HD + HF + HR) else '0';
    v_sync <= '1' when (v_count >= VD + VF and v_count < VD + VF + VR) else '0';

    video_on <= '1' when (h_count < HD and v_count < VD) else '0';

process(h_count, v_count)
begin
    if h_count >= 100 and h_count < 220 then
        num_coluna <= 0;
    elsif h_count >= 220 and h_count < 340 then
        num_coluna <= 1;
    elsif h_count >= 340 and h_count < 460 then
        num_coluna <= 2;
    elsif h_count >= 460 and h_count < 580 then
        num_coluna <= 3;
    elsif h_count >= 580 and h_count < 700 then
        num_coluna <= 4;
    else
        num_coluna <= 0;
    end if;

    if v_count >= 100 and v_count < 180 then
        num_linha <= 0;
    elsif v_count >= 180 and v_count < 260 then
        num_linha <= 1;
    elsif v_count >= 260 and v_count < 340 then
        num_linha <= 2;
    elsif v_count >= 340 and v_count < 420 then
        num_linha <= 3;
    elsif v_count >= 420 and v_count < 500 then
        num_linha <= 4;
    else
        num_linha <= 0;
    end if;
end process;

num_atual <= (num_linha * 5) + num_coluna + 1;

process(video_on, h_count, v_count, num_atual, drawn, last_num, num_coluna, num_linha)
    variable offset_h   : integer range 0 to 600;
    variable offset_v   : integer range 0 to 400;
    variable local_h    : integer range -1024 to 1024;
    variable local_v    : integer range -1024 to 1024;
    variable tens       : integer;
    variable ones       : integer;
    variable draw_pixel : std_logic;
    variable c_r, c_g   : std_logic_vector(2 downto 0);
    variable c_b        : std_logic_vector(1 downto 0);
begin

    r <= "000"; g <= "000"; b <= "00";

    case num_coluna is
        when 1      => offset_h := 120;
        when 2      => offset_h := 240;
        when 3      => offset_h := 360;
        when 4      => offset_h := 480;
        when others => offset_h := 0;
    end case;

    case num_linha is
        when 1      => offset_v := 80;
        when 2      => offset_v := 160;
        when 3      => offset_v := 240;
        when 4      => offset_v := 320;
        when others => offset_v := 0;
    end case;

    local_h := h_count - (GRID_X0 + offset_h);
    local_v := v_count - (GRID_Y0 + offset_v);

    if video_on = '1' then

        if (h_count >= 100 and h_count < 700 and v_count >= 100 and v_count < 500) then

            if drawn(num_atual - 1) = '1' then
					 if num_atual = to_integer(unsigned(last_num)) then
						  c_r := "111";
						  c_g := "000";
						  c_b := "00";

					 else
						  c_r := "000";
						  c_g := "000";
						  c_b := "11";

					 end if;

				else
					 c_r := "010";
					 c_g := "111";
					 c_b := "01";

				end if;

            if (local_h > 0 and local_h < 119 and local_v > 0 and local_v < 79) then

                tens := tens_digit(num_atual);
                ones := ones_digit(num_atual);
                draw_pixel := '0';

                if digit_pixel(tens, local_h - 27, local_v - 15) = '1' then
                    draw_pixel := '1';
                end if;

                if digit_pixel(ones, local_h - 63, local_v - 15) = '1' then
                    draw_pixel := '1';
                end if;

                if draw_pixel = '1' then
						 r <= c_r;
						 g <= c_g;
						 b <= c_b;
					 else
						 r <= "000";
						 g <= "000";
						 b <= "00";
					 end if;

            else
                r <= c_r; g <= c_g; b <= c_b;

            end if;
        else
            if h_count = 0 or h_count = HD-1 or v_count = 0 or v_count = VD-1 then
                r <= "000"; g <= "000"; b <= "00";
            else
                r <= "000"; g <= "000"; b <= "00";
            end if;
        end if;
    else
        r <= "000"; g <= "000"; b <= "00";
    end if;

end process;

end Behavioral;