library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vending_tb is
end entity;

architecture vending_tb_arch of vending_tb is
    
    constant clock_period : time := 10 ns;              
-- setting the clock period to 10 nano seconds
    
    signal Clock_TB, Cancel_TB, Insert5_TB, Insert10_TB, Insert20_TB : STD_LOGIC;
    signal Vend_TB : STD_LOGIC;
    
    begin       
           
    UUT : entity work.vending port map(                 
-- assigning vending variables to tb counterpart
    Clock => Clock_TB, 
    Cancel => Cancel_TB, 
    Insert5 => Insert5_TB, 
    Insert10 => Insert10_TB,
    Insert20 => Insert20_TB,
    Vend => Vend_TB); 
-- all operations occur concurrently          
    CANCEL_STIM : process 
        begin
            Cancel_TB <= '0'; wait for 2 ns;            
-- cancel is inverted as in vending.vhd
            Cancel_TB <= '1'; wait for clock_period*30;
            Cancel_TB <= '0'; wait for clock_period;
            Cancel_TB <= '1'; wait;    
        end process;
        
    CLOCK_STIM : process
        begin
            Clock_TB <= '0'; wait for clock_period/2;
            Clock_TB <= '1'; wait for clock_period/2;   
                               -- by not ending with a wait statement
        end process;           -- clock will continue to loop 

     INSERT5_STIM : process
        begin 
            Insert5_TB <= '0'; wait for clock_period;
            Insert5_TB <= '1'; wait for clock_period;
            Insert5_TB <= '0'; wait for clock_period*10; 
 --large wait so other coins insert first
            Insert5_TB <= '0'; wait for clock_period;
            Insert5_TB <= '1'; wait for clock_period;
            Insert5_TB <= '0'; wait for clock_period;
            Insert5_TB <= '1'; wait for clock_period;
            Insert5_TB <= '0'; wait for clock_period;
            Insert5_TB <= '1'; wait for clock_period;
            Insert5_TB <= '0'; wait for clock_period;
            Insert5_TB <= '1'; wait for clock_period;
            Insert5_TB <= '0'; wait for clock_period;
            Insert5_TB <= '1'; wait for clock_period;
            Insert5_TB <= '0'; wait for clock_period;
            Insert5_TB <= '1'; wait for clock_period;
            Insert5_TB <= '0'; wait for clock_period;
            Insert5_TB <= '1'; wait for clock_period;
            Insert5_TB <= '0'; wait for clock_period;
            Insert5_TB <= '1'; wait for clock_period;
            Insert5_TB <= '0'; wait for clock_period;
            Insert5_TB <= '1'; wait for clock_period;
            Insert5_TB <= '0'; wait for clock_period;
            Insert5_TB <= '1'; wait for clock_period;   
-- many Insert5's to debug via report log
            Insert5_TB <= '0'; wait for clock_period;
            Insert5_TB <= '1'; wait for clock_period;
            Insert5_TB <= '0'; wait for clock_period;
            Insert5_TB <= '1'; wait for clock_period;
            Insert5_TB <= '0'; wait for clock_period;
            Insert5_TB <= '1'; wait for clock_period;
            Insert5_TB <= '0'; wait for clock_period;
            Insert5_TB <= '1'; wait for clock_period;
            Insert5_TB <= '0'; wait for clock_period;
            Insert5_TB <= '1'; wait for clock_period;
            Insert5_TB <= '0'; wait for clock_period;
            Insert5_TB <= '0'; wait;           
        end process;
        
     INSERT10_STIM : process
        begin 
            Insert10_TB <= '0'; wait for clock_period*3; 
 -- 15ns so Insert5 happens first
            Insert10_TB <= '1'; wait for clock_period;  
            Insert10_TB <= '0'; wait for clock_period;
            Insert10_TB <= '1'; wait for clock_period;  
 -- testing first vend here
            Insert10_TB <= '0'; wait;
        end process;
        
     INSERT20_STIM : process
        begin
            Insert20_TB <= '0'; wait for clock_period*7; 
 --40ns so 5p & both 10p go first
            Insert20_TB <= '1'; wait for clock_period;
            Insert20_TB <= '0'; wait for clock_period;
            Insert20_TB <= '1'; wait for clock_period;  
 -- testing second vend here
            Insert20_TB <= '0'; wait;
        end process;
end vending_tb_arch;
