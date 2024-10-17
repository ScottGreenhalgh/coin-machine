library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.DigEng.ALL;

entity decoder is
    Port (  I : in STD_LOGIC_VECTOR(2 downto 0);      –- 3bit in
            Iout : out STD_LOGIC_VECTOR(7 downto 0)); –- 8bit out           
end decoder;

architecture decode of decoder is

begin 					          –- a 3bit to 8bit multiplexer
    Iout(0) <= not I(2) and not I(1) and not I(0);
    Iout(1) <= not I(2) and not I(1) and I(0);
    Iout(2) <= not I(2) and I(1) and not I(0);
    Iout(3) <= not I(2) and I(1) and I(0);
    Iout(4) <= I(2) and not I(1) and not I(0);
    Iout(5) <= I(2) and not I(1) and I(0);
    Iout(6) <= I(2) and I(1) and not I(0);
    Iout(7) <= I(2) and I(1) and I(0);
    
end decode;
