library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.DigEng.ALL;

entity gate is
    Port (  Dec_out : in STD_LOGIC_VECTOR(7 downto 0); –- decode out
            Reg_out : in STD_LOGIC_VECTOR(7 downto 0); –- register out
            D_out : out STD_LOGIC_VECTOR(7 downto 0)); –- digital output
end gate;

architecture and_gate_connector of gate is
-- AND the register output with decoder output
begin
    D_out(0) <= Reg_out(0) and Dec_out(0);
    D_out(1) <= Reg_out(1) and Dec_out(1);
    D_out(2) <= Reg_out(2) and Dec_out(2);
    D_out(3) <= Reg_out(3) and Dec_out(3);
    D_out(4) <= Reg_out(4) and Dec_out(4);
    D_out(5) <= Reg_out(5) and Dec_out(5);
    D_out(6) <= Reg_out(6) and Dec_out(6);
    D_out(7) <= Reg_out(7) and Dec_out(7);
    

end and_gate_connector;
