library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ula is
    generic ( N : integer := 2);
    Port (
        a       : in  std_logic_vector(N-1 downto 0);
        b       : in  std_logic_vector(N-1 downto 0);
        opcode  : in  std_logic_vector(2 downto 0);
        enable  : in  std_logic;
        y       : out std_logic_vector(N-1 downto 0);
        cout    : out std_logic;
        overflow: out std_logic
    );
end ula;

architecture Behavioral of ula is

    signal a_s, b_s : signed(N-1 downto 0);
    signal res      : signed(N downto 0);
    signal logic_res: std_logic_vector(N-1 downto 0);
    signal y_int    : std_logic_vector(N-1 downto 0);

begin

    -- Conversão
    a_s <= signed(a);
    b_s <= signed(b);

    with opcode select
    logic_res <=
        (a and b) when "010",
        (a or  b) when "011",
        (a xor b) when "100",
        (not a)   when "101",
        (others => '0') when others;

    with opcode select
    res <=
        resize(a_s, N+1) + resize(b_s, N+1) when "000",
        resize(a_s, N+1) - resize(b_s, N+1) when "001",
        resize(a_s, N+1) + 1                when "110",
        resize(a_s, N+1) - 1                when "111",
        resize(signed(logic_res), N+1)      when others;

    -- Enable
    y_int <= std_logic_vector(res(N-1 downto 0)) when enable = '1'
             else (others => '0');

    y <= y_int;

    -- Flags
    cout <= res(N) when enable = '1' else '0';
	 overflow <= (res(N) xor res(N-1)) when enable = '1' else '0';

end Behavioral;