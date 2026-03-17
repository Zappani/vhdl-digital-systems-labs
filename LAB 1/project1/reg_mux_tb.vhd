LIBRARY ieee;
USE ieee.std_logic_1164.ALL; 

ENTITY reg_mux_tb IS
END ENTITY;
 
ARCHITECTURE behavior OF reg_mux_tb IS 
    COMPONENT reg_mux is
    PORT(
         a : IN  std_logic_vector(3 downto 0);
         b : IN  std_logic_vector(3 downto 0);
         c : IN  std_logic_vector(3 downto 0);
         d : IN  std_logic_vector(3 downto 0);
         sel : IN  std_logic_vector(1 downto 0);
         clk : IN  std_logic;
         x : OUT  std_logic_vector(3 downto 0);
         y : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    
   signal a_tb : std_logic_vector(3 downto 0) := "0010";
   signal b_tb : std_logic_vector(3 downto 0) := "0100";
   signal c_tb : std_logic_vector(3 downto 0) := "0110";
   signal d_tb : std_logic_vector(3 downto 0) := "1000";
   signal sel_tb : std_logic_vector(1 downto 0) := "00";
   signal clk_tb : std_logic := '0';
   signal x_tb : std_logic_vector(3 downto 0);
   signal y_tb : std_logic_vector(3 downto 0);

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

    clk_tb <= not clk_tb after 40ns;

    a_tb <= "0011" after 80ns, "0000" after 640ns;
    b_tb <= "0101" after 240ns;
    c_tb <= "0111" after 400ns;
    d_tb <= "1001" after 560ns;

    sel_tb <= "01" after 160ns,
              "10" after 320ns,
              "11" after 480ns,
              "00" after 640ns;

END architecture;