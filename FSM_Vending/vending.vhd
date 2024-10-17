library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vending is
    Port ( Clock : in STD_LOGIC;
           Insert5 : in STD_LOGIC;
           Insert10 : in STD_LOGIC;
           Insert20 : in STD_LOGIC;
           Cancel : in STD_LOGIC;
           Vend : out STD_LOGIC); -- define inputs and outputs
end vending;

architecture arch of vending is

    type State_Type is (idle, fivep, tenp, fifteenp, twentyp); 
-- define states
    signal current_state, next_state : State_Type;             
-- define state types 
    
begin

    STATE_MEMORY : process (Clock, Cancel) 
        begin                               -- with cancel inverted
        if (Cancel = '0') then              -- when cancel is zero
            current_state <= idle;          -- resert back to idle state
        elsif (falling_edge(Clock)) then    -- at the falling edge of clock
            if(current_state = fivep) then  -- print the current state
                        report "fivep";     --observes when fivep occurs
                    elsif(current_state = tenp) then
                        report "tenp";      
                    elsif(current_state = twentyp) then
                        report "twentyp";
                    elsif(current_state = idle) then
                        report "idle";
                    else                   -- if unknown state is achieved
                        report "unknown state";
                    end if;
            current_state <= next_state; 
        end if;
    end process;
    
    NEXT_STATE_LOGIC : process (current_state, Insert5, Insert10, Insert20)
        begin
            case (current_state) is
                when idle => if (Insert5 = '1') then      -- idle 5p check
                                next_state <= fivep;      -- counts 5p 
                             elsif (Insert10 = '1') then  -- checks for 10p
                                next_state <= tenp;       -- counts 10p
                             elsif (Insert20 = '1') then  -- checks for 20p
                                next_state <= twentyp;    -- counts 20p
                             else                         -- if no coin 
                                next_state <= idle;       --remain current 
                             end if;
                             
                when fivep => if (Insert5 = '1') then    -- At 5p checks 5p 
                                next_state <= tenp;      -- adds 5p 
                                report "insert5";        -- log Inser5
                              elsif (Insert10 = '1') then-- checks for 10p
                                next_state <= fifteenp;  -- adds 10p 
                                report "insert10";       -- log Inser10
                              elsif (Insert20 = '1') then-- checks for 20p
                                next_state <= idle;      -- 25p so vend 
                                report "insert20";       -- log Inser20
                              else                       -- if no coin 
                                next_state <= fivep;     -- remain current 
                                report "no change";	   -- log no change
                              end if;
                              
                when tenp => if (Insert5 = '1') then      --at 10p check 5p 
                                next_state <= fifteenp;   -- adds 5p
                             elsif (Insert10 = '1') then  -- check for 10p
                                next_state <= twentyp;    -- adds 10p to 
                             elsif (Insert20 = '1') then  -- check for 20p
                                next_state <= idle;       -- vend & reset
                             else                         -- if no coin 
                                next_state <= tenp;       -- remain current 
                             end if;
                                
                when fifteenp => if (Insert5 = '1') then    --15p check 5p
                                    next_state <= twentyp;  -- add 5p 
                                 elsif (Insert10 = '1') then--check for 10p
                                    next_state <= idle;     -- vend & reset 
                                 elsif (Insert20 = '1') then--check for 20p
                                    next_state <= idle;     --vend & reset
                                 else                       -- if no coin 
                                    next_state <= fifteenp; -- remain 
                                 end if;
                                    
                when twentyp => if (Insert5 = '1') then   --At 20p check 5p
                                    next_state <= idle;   -- vend & reset
                                elsif (Insert10 = '1') then --check for 10p 
                                    next_state <= idle;     --vend & reset
                                elsif (Insert20 = '1') then --check for 20p
                                    next_state <= idle;     --vend & reset
                                else                        -- if no coin  
                                    next_state <= twentyp;  -- remain 
                                end if;
                                    
                 when others => next_state <= idle; 
    -- failsafe if somehow a different state occurs
             end case; 
          end process;
          
    OUTPUT_LOGIC : process (current_state, Insert5, Insert10, Insert20) 
        begin 
            case (current_state) is
                when idle => if (Insert5 = '1') then    --5p insert at idle
                                Vend <= '0';            -- no vend
                             elsif (Insert10 = '1') then-- 10p at idle
                                Vend <= '0';            -- no vend
                             elsif (Insert20 = '1') then-- 20p at idle
                                Vend <= '0';            -- no vend
                             else                       -- no coin  
                                Vend <= '0';            -- no vend
                             end if;
                             
                 when fivep => if (Insert5 = '1') then    --5p at fivep
                                Vend <= '0';              -- no vend 
                                report "insert5 no vend";
                               elsif (Insert10 = '1') then-- 10p at fivep
                                Vend <= '0';              -- no vend
                                report "insert10 no vend";
                               elsif (Insert20 = '1') then-- 20p at fivep
                                Vend <= '1';              -- vend
                                report "insert20 no vend";
                               else                       -- no coin
                                Vend <= '0';              -- no vend 
                                report "no insert no vend";
                               end if;
                                
                 when tenp => if (Insert5 = '1') then     -- 5p at tenp 
                                Vend <= '0';              -- no vend
                              elsif (Insert10 = '1') then --10p at tenp
                                Vend <= '0';              -- no vend
                              elsif (Insert20 = '1') then -- 20p at tenp
                                Vend <= '1';              -- vend
                              else                        -- no coin
                                Vend <= '0';              -- no vend
                              end if;
                              
                 when fifteenp => if (Insert5 = '1') then    -- 5p fifteenp 
                                    Vend <= '0';             -- no vend
                                  elsif (Insert10 = '1') then--10p fifteenp
                                    Vend <= '1';             -- vend
                                  elsif (Insert20 = '1') then--20p fifteenp
                                    Vend <= '1';             -- vend
                                  else                       -- no coin  
                                    Vend <= '0';             -- no vend
                                  end if;
                                  
                 when twentyp => if (Insert5 = '1') then -- 5p at twentyp
                                    Vend <= '1';            -- vend
                                 elsif (Insert10 = '1') then-- 10p twentyp
                                    Vend <= '1';            -- vend
                                 elsif (Insert20 = '1') then-- 20p twentyp
                                    Vend <= '1';            -- vend
                                 else                       -- no coin
                                    Vend <= '0';            -- no vend
                                 end if;
                                 
                  when others => Vend <= '0';           --failsafe if other
                end case;
            end process;                                                                                  
end architecture;
