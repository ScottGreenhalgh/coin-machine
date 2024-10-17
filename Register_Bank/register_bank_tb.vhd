library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity register_bank_tb is
end entity;
architecture Behavioral of register_bank_tb is

constant clock_period : time := 10ns; 
                                         --setting clock to 10 nano seconds

    signal Clock_TB : STD_LOGIC;                         -- defined signals
    signal Reset_TB : STD_LOGIC;
    signal WriteEnable_TB : STD_LOGIC;
    signal DataIn_TB : STD_LOGIC_VECTOR(7 downto 0);
    signal DecoderAin_TB, DecoderBin_TB, DecoderWritein_TB : STD_LOGIC_VECTOR(3 downto 0);

    signal DataOutA_TB, DataOutB_TB  : STD_LOGIC_VECTOR(7 downto 0);

begin

    UUT: entity work.register_bank port map(  --map ports to TB counterpart
         Clock => Clock_TB,
         Reset => Reset_TB,
         WEN => WriteEnable_TB,
         Din => DataIn_TB,
         RA => DecoderAin_TB,
         RB => DecoderBin_TB,
         WA => DecoderWritein_TB,
         DoutA => DataOutA_TB,
         DoutB => DataOutA_TB);
    
    CLOCK_STIM : process
        begin
            Clock_TB <= '0'; wait for clock_period/2;
            Clock_TB <= '1'; wait for clock_period/2;
        end process;                          -- continue loop clock
                
    TEST_STIM : process
        begin
            Reset_TB <= '0'; wait for clock_period;           
            DataIn_TB <= "10111010"; Wait for clock_period;   --set 8bit in
            DecoderAin_TB <= "111"; Wait for clock_period;    --decoderA in
            DecoderBin_TB <= "111"; Wait for clock_period;    --decoderB in
            WriteEnable_TB <= '1'; Wait for clock_period;     -- decode en
            DecoderWritein_TB <= "000"; Wait for clock_period;--decode in
            
            Reset_TB <= '1'; Wait for clock_period;           --reset
            Reset_TB <= '0'; Wait for clock_period;
            DataIn_TB <= "01000101"; Wait for clock_period;
            DecoderAin_TB <= "000"; Wait for clock_period;
            DecoderBin_TB <= "000"; Wait for clock_period;
            WriteEnable_TB <= '1'; Wait for clock_period;
            DecoderWritein_TB <= "111"; Wait for clock_period;
            
            Reset_TB <= '1'; Wait for clock_period;
            Reset_TB <= '0'; Wait for clock_period;
            DataIn_TB <= "11111111"; Wait for clock_period;
            DecoderAin_TB <= "101"; Wait for clock_period;
            DecoderBin_TB <= "010"; Wait for clock_period;
            WriteEnable_TB <= '0'; Wait for clock_period;
            DecoderWritein_TB <= "001"; Wait;
        end process;        
            
end Behavioral;
