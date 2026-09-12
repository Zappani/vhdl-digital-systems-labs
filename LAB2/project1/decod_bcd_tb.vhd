--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY decod_bcd_tb IS
END decod_bcd_tb;
 
ARCHITECTURE behavior OF decod_bcd_tb IS 

    COMPONENT decod_bcd
    PORT(
         x : IN  std_logic_vector(3 downto 0);
         y : OUT  std_logic_vector(6 downto 0)
        );
    END COMPONENT;

   signal x : std_logic_vector(3 downto 0) := (others => '0');

   signal y : std_logic_vector(6 downto 0);
 
BEGIN
 
   uut: decod_bcd PORT MAP (
          x => x,
          y => y
        );
   stim_proc: process
   begin		
      wait for 100 ns;	
		x <= "0001";
      wait for 100 ns;	
		x <= "0010";
		wait for 100 ns;	
		x <= "0011";
		wait for 100 ns;	
		x <= "0100";
		wait for 100 ns;	
		x <= "0101";
		wait for 100 ns;	
		x <= "0110";
		wait for 100 ns;	
		x <= "0111";
		wait for 100 ns;	
		x <= "1000";
		wait for 100 ns;	
		x <= "1001";
		wait for 100 ns;	
		x <= "1010";
		wait for 100 ns;	
		x <= "1011";
		wait for 100 ns;	
		x <= "1100";
		x <= "1101";
		wait for 100 ns;	
		x <= "1110";
		wait for 100 ns;	
		x <= "1111";

      wait;
   end process;

END;