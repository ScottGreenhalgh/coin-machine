library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.DigEng.ALL;

entity register_bank is
    generic( REG_SIZE : natural := 8; --register size
             NUM_REG : natural := 3); -- 2**REG_SIZE 
                                
 PORT ( 
    --LOG_NUM_REG : out UNSIGNED (log2(NUM_REG) -1 downto 0); 
    
    Clock : in STD_LOGIC;
    Reset : in STD_LOGIC;           
    WEN : in STD_LOGIC;                              --write enable
    Din : in STD_LOGIC_VECTOR (REG_SIZE -1 downto 0);--data in
    RA : in STD_LOGIC_VECTOR (2 downto 0);           --decoder A in
    RB : in STD_LOGIC_VECTOR (2 downto 0);           --decoder B in
    WA : in STD_LOGIC_VECTOR (2 downto 0);           --write decoder in
    DoutA : out STD_LOGIC_VECTOR (REG_SIZE -1 downto 0);--Output A
    DoutB : out STD_LOGIC_VECTOR (REG_SIZE -1 downto 0) --Output B
       );
end entity;

architecture arch of register_bank is
                                				-- internal signals                       
    signal RAout : STD_LOGIC_VECTOR (REG_SIZE -1 downto 0);
    signal RBout : STD_LOGIC_VECTOR (REG_SIZE -1 downto 0);
    signal WAout : STD_LOGIC_VECTOR (REG_SIZE -1 downto 0);
    signal RegAout : STD_LOGIC_VECTOR (REG_SIZE -1 downto 0);
    signal RegBout : STD_LOGIC_VECTOR (REG_SIZE -1 downto 0);
    
    begin
    DECODER_RA : entity work.decoder       -- decoder A
        port map ( Iout => RAout,
                   I => RA
                 );
    DECODER_RB : entity work.decoder       -- decoder B
        port map ( Iout => RBout,
                    I => RB
                 );
    DECODER_WR : entity work.write_decoder -- write decoder
        port map ( WIout => WAout,
                    WI => WA,
                    EN => WEN
                    );                      --and gates
    GATE_RA : entity work.gate              -- found on diagram
        port map ( Dec_out => RAout,        -- decoder A output 
                   Reg_out => RegAout,      -- register output
                   D_out => DoutA           -- data output 
                    );
    Gate_RB : entity work.gate
        port map ( Dec_out => RBout,        -- decoder B output
                   Reg_out => RegBout,      -- register output
                   D_out => DoutB           -- data output B
                   );
               
    REGISTER_FILE : 
        process(Clock, Reset) begin
            if rising_edge(Clock) then         -- rising clock edge input
                if (Reset = '1') then          -- if reset is true
                    RegAout <= (OTHERS => '0');-- set reg outputA zero
                elsif (WAout(0) = '1') then    -- else
                    RegAout <= Din;            -- set dig in to output
                else    
                    RegAout <= (OTHERS => '0');-- failsafe if WAout no 1
                end if;
                if (Reset = '1') then          -- identical to above
                    RegBout <= (OTHERS => '0');
                elsif (WAout(0) = '1') then
                    RegBout <= Din;
                else 
                    RegBout <= (OTHERS => '0');
                end if;
                
             end if;
        end process; 
          
    end architecture;
