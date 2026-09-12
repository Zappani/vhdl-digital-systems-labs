library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ssd_driver is
    generic (
        CLK_FREQ_HZ : integer := 50000000;
        REFRESH_HZ  : integer := 1000;
        SCROLL_HZ   : integer := 2
    );
    port (
        clk          : in  std_logic;
        rst          : in  std_logic;
        game_started : in  std_logic;
        round_num    : in  std_logic_vector(5 downto 0);
        last_num     : in  std_logic_vector(4 downto 0);
        AN           : out std_logic_vector(3 downto 0);
        seg          : out std_logic_vector(6 downto 0)
    );
end ssd_driver;

architecture Behavioral of ssd_driver is

    constant REFRESH_MAX : integer := CLK_FREQ_HZ / (REFRESH_HZ * 4);
    constant SCROLL_MAX  : integer := CLK_FREQ_HZ / SCROLL_HZ;

    signal refresh_cnt : integer := 0;
    signal scroll_cnt  : integer := 0;
    signal mux         : std_logic_vector(1 downto 0) := "00";
    signal scroll_pos  : integer range 0 to 18 := 0;

    function to_7seg(d : integer) return std_logic_vector is
    begin
        case d is
            when 0  => return "1000000"; -- 0
            when 1  => return "1111001"; -- 1
            when 2  => return "0100100"; -- 2
            when 3  => return "0110000"; -- 3
            when 4  => return "0011001"; -- 4
            when 5  => return "0010010"; -- 5
            when 6  => return "0000010"; -- 6
            when 7  => return "1111000"; -- 7
            when 8  => return "0000000"; -- 8
            when 9  => return "0010000"; -- 9
            when 10 => return "1111111"; -- espaço
            when 11 => return "0001001"; -- M (H)
            when 12 => return "1111001"; -- I (1)
            when 13 => return "0101011"; -- N
            when 14 => return "0000011"; -- B
            when 15 => return "0000010"; -- G
            when 16 => return "1000000"; -- O
            when others => return "1111111";
        end case;
    end function;

    function message_char(pos : integer) return integer is
    begin
        case pos is
            when 0  => return 10; -- _
            when 1  => return 11; -- M
            when 2  => return 12; -- I
            when 3  => return 13; -- N
            when 4  => return 12; -- I
            when 5  => return 10; -- _
            when 6  => return 14; -- B
            when 7  => return 12; -- I
            when 8  => return 13; -- N
            when 9  => return 15; -- G
            when 10 => return 16; -- O
            when 11 => return 10; -- _
            when 12 => return 2;  -- 2
            when 13 => return 0;  -- 0
            when 14 => return 2;  -- 2
            when 15 => return 6;  -- 6
            when 16 => return 10; -- _
            when 17 => return 10; -- _
            when 18 => return 10; -- _
            when others => return 10;
        end case;
    end function;

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                refresh_cnt <= 0;
                scroll_cnt  <= 0;
                mux         <= "00";
                scroll_pos  <= 0;
            else
                if refresh_cnt >= REFRESH_MAX then
                    refresh_cnt <= 0;
                    mux         <= std_logic_vector(unsigned(mux) + 1);
                else
                    refresh_cnt <= refresh_cnt + 1;
                end if;

                if game_started = '0' then
                    if scroll_cnt >= SCROLL_MAX then
                        scroll_cnt <= 0;
                        if scroll_pos = 18 then
                            scroll_pos <= 0;
                        else
                            scroll_pos <= scroll_pos + 1;
                        end if;
                    else
                        scroll_cnt <= scroll_cnt + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

    process(mux, game_started, round_num, last_num, scroll_pos)
        variable ch : integer;
        variable r  : integer;
        variable n  : integer;
        variable p  : integer;
    begin
       r := to_integer(unsigned(round_num));
       n := to_integer(unsigned(last_num));

        case mux is
            when "00"   => AN <= "1110";
            when "01"   => AN <= "1101";
            when "10"   => AN <= "1011";
            when others => AN <= "0111";
        end case;

        if game_started = '0' then
            case mux is
                when "00" => 
                    p := scroll_pos + 3;
                    if p > 18 then p := p - 19; end if;
                    ch := message_char(p);
                when "01" => 
                    p := scroll_pos + 2;
                    if p > 18 then p := p - 19; end if;
                    ch := message_char(p);
                when "10" => 
                    p := scroll_pos + 1;
                    if p > 18 then p := p - 19; end if;
                    ch := message_char(p);
                when others => 
                    ch := message_char(scroll_pos);
            end case;

        else
            case mux is
                when "00" => 
                    if n < 10 then    ch := n;
                    elsif n < 20 then ch := n - 10;
                    else              ch := n - 20;
                    end if;
                when "01" => 
                    if n < 10 then    ch := 0;
                    elsif n < 20 then ch := 1;
                    else              ch := 2;
                    end if;
                when "10" => 
                    if r < 10 then    ch := r;
                    elsif r < 20 then ch := r - 10;
                    else              ch := r - 20;
                    end if;
                when others => 
                    if r < 10 then    ch := 0;
                    elsif r < 20 then ch := 1;
                    else              ch := 2;
                    end if;
            end case;
        end if;

        seg <= to_7seg(ch);
    end process;

end Behavioral;