LIBRARY ieee;
USE ieee.std_logic_1164.ALL; 

ENTITY reg_mux_tb IS
END ENTITY;
 
ARCHITECTURE behavior OF reg_mux_tb IS 

    COMPONENT reg_mux
    PORT(
         a : IN  std_logic;
         b : IN  std_logic;
         c : IN  std_logic;
         d : IN  std_logic;
         sel : IN  std_logic_vector(1 downto 0);
         clk : IN  std_logic;
         x : OUT std_logic;
         y : OUT std_logic
        );
    END COMPONENT;
    
   signal a_tb : std_logic := '0';
   signal b_tb : std_logic := '0';
   signal c_tb : std_logic := '0';
   signal d_tb : std_logic := '0';
   signal sel_tb : std_logic_vector(1 downto 0) := "00";
   signal clk_tb : std_logic := '0';
   signal x_tb : std_logic;
   signal y_tb : std_logic;

BEGIN
 
   uut: reg_mux PORT MAP (
          a => a_tb,
          b => b_tb,
          c => c_tb,
          d => d_tb,
          sel => sel_tb,
          clk => clk_tb,
          x => x_tb,
          y => y_tb);

    clk_tb <= not clk_tb after 40 ns;

    a_tb <= '1' after 80 ns, '0' after 640 ns;
    b_tb <= '1' after 240 ns;
    c_tb <= '1' after 400 ns;
    d_tb <= '1' after 560 ns;

    sel_tb <= "01" after 160 ns,
              "10" after 320 ns,
              "11" after 480 ns,
              "00" after 640 ns;

END architecture;