library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_ula is
end tb_ula;

architecture test of tb_ula is

    signal a, b : std_logic_vector(1 downto 0);
    signal opcode : std_logic_vector(2 downto 0);
    signal enable : std_logic;
    signal y : std_logic_vector(1 downto 0);
    signal cout, overflow : std_logic;

begin

    uut: entity work.ula
        generic map (N => 2)
        port map (
            a => a,
            b => b,
            opcode => opcode,
            enable => enable,
            y => y,
            cout => cout,
            overflow => overflow
        );

    process
    begin
        enable <= '1';

        a <= "01"; b <= "01"; opcode <= "000"; wait for 200 ns; -- soma
        a <= "01"; b <= "01"; opcode <= "001"; wait for 200 ns; -- sub
        a <= "01"; b <= "10"; opcode <= "010"; wait for 200 ns; -- and
        a <= "01"; b <= "10"; opcode <= "011"; wait for 200 ns; -- or
        a <= "01"; b <= "10"; opcode <= "100"; wait for 200 ns; -- xor
        a <= "01"; opcode <= "101"; wait for 200 ns; -- not
        a <= "01"; opcode <= "110"; wait for 200 ns; -- +1
        a <= "01"; opcode <= "111"; wait for 200 ns; -- -1

        enable <= '0'; wait for 10 ns;

        wait;
    end process;

end test;