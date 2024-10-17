library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.DigEng.ALL;

entity write_decoder is
    Port (  EN : in STD_LOGIC;                        -- write enable
            WI : in STD_LOGIC_VECTOR(2 downto 0);     -- 3bit in
            WIout : out STD_LOGIC_VECTOR(7 downto 0));-- 8bit out
end write_decoder;

architecture w_decoder of write_decoder is

begin

STATE_MEMORY : process (EN)
    begin 
        if (EN = '0') then
            WIout <= (others => '0');
        end if;
    end process;
    
WRITE_DECODER : process (WI)
    Begin						–- a 3bit to 8bit multiplexer	
            WIout(0) <= not WI(2) and not WI(1) and not WI(0);
            WIout(1) <= not WI(2) and not WI(1) and WI(0);
            WIout(2) <= not WI(2) and WI(1) and not WI(0);
            WIout(3) <= not WI(2) and WI(1) and WI(0);
            WIout(4) <= WI(2) and not WI(1) and not WI(0);
            WIout(5) <= WI(2) and not WI(1) and WI(0);
            WIout(6) <= WI(2) and WI(1) and not WI(0);
            WIout(7) <= WI(2) and WI(1) and WI(0);
    end process;
end w_decoder;
