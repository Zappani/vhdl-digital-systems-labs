library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_div is
    Port (
        clk          : in  std_logic;
        rst          : in  std_logic;
        tick_1Hz     : out std_logic;
        tick_refresh : out std_logic
    );
end entity;

 architecture Behavioral of clock_div is

    ---constant MAX_1HZ : integer := 50000000;
    ---constant MAX_REFRESH : integer := 50000;
	 
	 --- Para SIMULAÇÃO--------------
	 constant MAX_1HZ : integer := 5;
	 constant MAX_REFRESH : integer := 10;

    signal count_1Hz     : integer := 0;
    signal count_refresh : integer := 0;

begin

	process(clk)
	begin

		 if rst = '1' then
			  count_1Hz      <= 0;
			  count_refresh  <= 0;
			  tick_1Hz       <= '0';
			  tick_refresh   <= '0';

		 elsif rising_edge(clk) then

			  -- Tick 1 Hz
			  if count_1Hz = MAX_1HZ - 1 then
					tick_1Hz <= '1';
					count_1Hz <= 0;
			  else
					tick_1Hz <= '0';
					count_1Hz <= count_1Hz + 1;
			  end if;

			  -- Tick refresh
			  if count_refresh = MAX_REFRESH - 1 then
					tick_refresh <= '1';
					count_refresh <= 0;
			  else
					tick_refresh <= '0';
					count_refresh <= count_refresh + 1;
			  end if;

		 end if;

	end process;

end architecture;