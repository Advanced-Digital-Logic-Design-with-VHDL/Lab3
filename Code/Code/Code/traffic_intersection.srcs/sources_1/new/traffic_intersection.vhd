----------------------------------------------------------------------------------
-- Company: University of Alberta
-- Engineer: Raza Bhatti
-- 
-- Create Date: 05/11/2018 11:22:20 AM
-- Design Name: 
-- Module Name: traffic_intersection - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
-- East/West and North/South intersection working. btn(0) used to see status of lights on respective direction of travel.
-- Red light camera on each direction of travel.
-- Night time quick green if red on direction of travel (e.g. North/South or East/West) and no vehicles on other direction of travel (e.g. North/South or East/West) 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity traffic_intersection is
    Port ( 
            clk:    in STD_LOGIC;
            btn :   in STD_LOGIC_VECTOR(3 DOWNTO 0);    -- btn(0) press to see traffic light status for North/South or East/West lights.
                                                        -- btn(3) press to emulate vehicle passing from North/South direction, btn(2) for East/West.
            --Write design line here to get inputs from switches, refer to constraints file.  
                                                        -- SW(0)='1'=>Vehicle present on East/West direction of travel, SW(1)=>'1' for North/South
                                                        -- SW(3)='1'=> Lgiht Sensor Emulation '0'=>Day '1'=>Night            
            sw:     in STD_LOGIC_VECTOR(3 DOWNTO 0);
            
            led6_r : out STD_LOGIC;     --Traffic light status as Red
            led6_g : out STD_LOGIC;     --Traffic light status as Green
            led6_b : out STD_LOGIC;     --Traffic light status as Yello=>Blue on board
            
            led: out STD_LOGIC_VECTOR(1 downto 0);        --Monitor states [ led(0), led(1) ] 
            red_led: out STD_LOGIC_VECTOR (1 downto 0) :="00";    -- Red Light Camera [red_led(0), red_led(1) ];
            CC :        out STD_LOGIC;                     --Common cathode input to select respective 7-segment digit.
            out_7seg :  out STD_LOGIC_VECTOR (6 downto 0);  -- Output  signal for selected 7 Segment display. 
             ----------------------------------------------------------------
            --Requirment #6
             KeyPad_Col: out STD_LOGIC_VECTOR (3 downto 0) :="0000";
             KeyPad_Row: in STD_LOGIC_VECTOR(3 DOWNTO 0)
              ---------------------------------------------------------------- 
            
           );
end traffic_intersection;

architecture Behavioral of traffic_intersection is
component Clock_OneHz is
    port (  clk: in STD_LOGIC;
            clk_1Hz: out STD_LOGIC
          );
end component;

signal clk_1Hz: std_logic;
signal count, Count_OneSecDelay_MSD, Count_OneSecDelay_LSD, digit_7seg_display, count_7seg : natural;
signal Count_OneSecDelay: natural:=20;       
signal states_mon: std_logic_vector(1 downto 0):="00";


TYPE STATES IS (S0,S1,S2,S3,S4,S5,S6);
signal state: STATES:=S0;

-- You can use following signals to implement design requirements or make your own.
signal NTSwitch: std_logic:='0';
signal VehiclesPresence: std_logic_vector(1 downto 0);
signal red_light_camera: std_logic_vector(1 downto 0):="00";
signal Count_RedLight: natural:=0;
signal blinking:STD_LOGIC:='0';
signal clk_out: std_logic:='0';
signal select_segment, clk_7seg_cc:std_logic:='0';

begin

    Decoder_4to7Segment: process (clk)
    begin

    -- Update following case statement to display complete range of digit_7seg_display values on 7-segments.
        case digit_7seg_display is
                       when 0 =>  
                          out_7seg<="0111111";       
            when 1 =>  
                          out_7seg<="0110000";         
            when 2 =>  
                          out_7seg<="1011011";          
            when 3 =>  
                          out_7seg<="1111001";          
            when 4 =>  
                          out_7seg<="1110100";           
            when 5 =>  
                          out_7seg<="1101101";          
            when 6 =>  
                          out_7seg<="1101111";         
            when 7 =>  
                          out_7seg<="0111000";          
            when 8 =>  
                          out_7seg<="1111111";         
            when 9 =>  
                          out_7seg<="1111101";                   

            when others =>

    end case;
   
    
    
    -- End of your design lines.
    end process;


    --Instatitiate components
    clock_1Hz: process(clk)
    begin
        if rising_edge(clk) then
            if(count<2) then   --2 for testbech, 125000000 for board
                count<=count+1;
            else
                count<=0;
                clk_out<=not clk_out;
                clk_1Hz<=clk_out;
            end if;

            if (count_7seg<10000) then
                count_7seg<=count_7seg+1;
            else
                select_segment<=not select_segment;
                count_7seg<=0;
            end if;
        end if;
    end process;

    Select_7Segment: process (clk,clk_1Hz,select_segment)
    begin
      ----------------------------------------------------------------
            --Requirment #5
         if (KeyPad_Row = "1111") then       --When no key is pressed, KeyPad_Row="1111";
            --display state on RHS of 7 seg
            Count_OneSecDelay_LSD <= Count_OneSecDelay;
          --display state on LHS on 7 seg
            case state is 
                When S0 => Count_OneSecDelay_MSD <= 0;
                When S1 => Count_OneSecDelay_MSD <= 1;
                When S2 => Count_OneSecDelay_MSD <= 2;
                When S3 => Count_OneSecDelay_MSD <= 3;
                When others =>
                
            end case;
      ----------------------------------------------------------------
      --Requirment #6 
      
        else --When key is pressed
         ---pedestrian crosswalk signal as '0' for stop and '1' for walking on the seven segments. You can use
        ---one segment for the East-West direction and other for the North-South direction pedestrian crosswalk signals.
            if (state = S0) then 
                Count_OneSecDelay_MSD <= 1;
            else
                Count_OneSecDelay_MSD <= 0;
            end if; 
             
            if (state = S2) then 
                Count_OneSecDelay_LSD <= 1;
            else
                Count_OneSecDelay_LSD <= 0;
            end if;
            
        end if;
      ----------------------------------------------------------------
                
        if select_segment='1' then
            digit_7seg_display<= Count_OneSecDelay_LSD;           
        else
            digit_7seg_display<= Count_OneSecDelay_MSD;           
        end if;

        CC<=select_segment;

    end process;

  
 TrafficIntersection: process (clk, clk_1Hz)
   begin
     ----------------------------------------------------------------  
    --Requirement #4 Night Time Operation You can write design lines here to capture vehicles presence and Night Time input (LDR).
    -- Write your design line here to update VehiclesPresence(0)
    VehiclesPresence(0) <= sw(0);
    -- Write your design line here to update VehiclesPresence(1)
    VehiclesPresence(1) <= sw(1);
    -- Write your design line here to update NTSwitch
    NTSwitch <= sw(3);
    --End of design lines.
  ----------------------------------------------------------------  

        if btn(1)='1' then
            state<=S0;
        end if;
        
        if rising_edge(clk_1Hz) then
            Count_OneSecDelay<=Count_OneSecDelay-1;     --Increment one second count. ~1.84 sec delay here

            case state is
                when S0 =>                              --East/West direction light green
                        if Count_OneSecDelay>0 then
                            if btn(0)='0' then              --Since only have one RGB light, else no need. btn(0)='0' => East/West  btn(0)='1'=> North/South
                                led6_r<='0';
                                led6_b<='0';
                                led6_g<='1';
                            else
                                led6_r<='1';
                                led6_b<='0';
                                led6_g<='0';
                            end if;
                ----------------------------------------------------------------  
                --    Requirement #4 Night Time Operation 
                            if (NTSwitch = '1' and VehiclesPresence(1) = '1' and btn(2) = '0') then
                                state<= S1;
                                Count_OneSecDelay <= 2; 
                             end if;
                ----------------------------------------------------------------        
                        else
                            state<=S1;                      
                            Count_OneSecDelay<=2;
                            if btn(0)='0' then         --Since only have one RGB light, else no need. btn(0)='0' => East/West  btn(0)='1'=> North/South
                                led6_r<='0';
                                led6_b<='1';
                                led6_g<='0';
                            else
                                led6_r<='1';
                                led6_b<='0';
                                led6_g<='0';
                            end if;
                        end if;
                    
                    states_mon<="00";
                    -- ~1.7 sec delay here

                when S1 =>                             --East/West direction light yellow=>blue on board                    
                        if Count_OneSecDelay>0 then
                            if btn(0)='0' then         --Since only have one RGB light, else no need. btn(0)='0' => East/West  btn(0)='1'=> North/South
                                led6_r<='0';
                                led6_b<='1';
                                led6_g<='0';
                            else
                                led6_r<='1';
                                led6_b<='0';
                                led6_g<='0';
                            end if;
                        else
                            state<=S2;
                            Count_OneSecDelay<=9;
                            if btn(0)='0' then          --Since only have one RGB light, else no need. btn(0)='0' => East/West  btn(0)='1'=> North/South
                                led6_r<='1';
                                led6_b<='0';
                                led6_g<='0';
                            else
                                led6_r<='0';
                                led6_b<='0';
                                led6_g<='1';
                            end if;                                
                        end if;
                    states_mon<="01";

                when S2 =>                              -- East/West direction light red and North/South direction green.
                        if Count_OneSecDelay>0 then
                            if btn(0)='0' then          --Since only have one RGB light, else no need. btn(0)='0' => East/West  btn(0)='1'=> North/South
                                led6_r<='1';
                                led6_b<='0';
                                led6_g<='0';
                            else
                                led6_r<='0';
                                led6_b<='0';
                                led6_g<='1';
                            end if;  
                ----------------------------------------------------------------  
                --    Requirement #4 Night Time Operation 
                            if (NTSwitch = '1' and VehiclesPresence(0) = '1' and btn(3) = '0') then
                                state<= S3;
                                Count_OneSecDelay <= 2; 
                             end if;
                ----------------------------------------------------------------                                
                        else
                            state<=S3;
                            Count_OneSecDelay<=2;
                            if btn(0)='0' then            --Since only have one RGB light, else no need. btn(0)='0' => East/West  btn(0)='1'=> North/South
                                led6_r<='1';
                                led6_b<='0';
                                led6_g<='0';
                            else
                                led6_r<='0';
                                led6_b<='1';
                                led6_g<='0';
                            end if;                                
                        end if;
        
                    states_mon<="10";

                    -- ~1.7 sec delay here

                when S3 =>
                        if Count_OneSecDelay>0 then
                            if btn(0)='0' then            --Since only have one RGB light, else no need. btn(0)='0' => East/West  btn(0)='1'=> North/South
                                led6_r<='1';
                                led6_b<='0';
                                led6_g<='0';
                            else
                                led6_r<='0';
                                led6_b<='1';
                                led6_g<='0';
                            end if;                                
                        else
                            state<=S0;
                            Count_OneSecDelay<=9;
                            if Count_OneSecDelay>0 then
                                if btn(0)='0' then              --Since only have one RGB light, else no need. btn(0)='0' => East/West  btn(0)='1'=> North/South
                                    led6_r<='0';
                                    led6_b<='0';
                                    led6_g<='1';
                                else
                                    led6_r<='1';
                                    led6_b<='0';
                                    led6_g<='0';
                                end if;
                            end if;
                          end if;
                        states_mon<="11";
     
                        -- ~1.7 sec delay here

                when others =>                      --Error condition
                        state<=S0;
                        Count_OneSecDelay<=9;
                        led6_r<='1';
                        led6_b<='1';
                        led6_g<='1';
            end case;
         end if;
         
    end process;
    
    ----------------------------------------------------------------  
   --Requirement #3 When a vehicle approaching intersection encounters a red light
    -- Write a process for Red Light Camera feature at the intersection.
    -- Hint: Since a flash light demo is desired, you can write a process to turn LED ON and another for OFF, in respective direction of travel.
    -- Start of your design

    -- End of your design
    Red_light_Flash_WE: process(btn(2)) --EAST WEST
    begin
    case btn(2) is
      when '1'  =>
        if (state = S2 and btn(0)='0') or ( state = S3 and btn(0)='0') then
            red_led(0)<= '1';
        end if;
      when '0'  =>
        red_led(0)<= '0';
      when others =>
    end case;
    end process;
    
    Red_light_Flash_NS: process(btn(3))-- NORTH SOUTH
    begin
        case btn(3) is
          when '1'  =>
            if (state = S0 and  btn(0)='1') or  (state = S1 and btn(0)='1') then
                red_led(1)<= '1';
            end if;   
          when '0'  =>
            red_led(1)<= '0';
          when others =>
        end case;
    end process;

    led<=states_mon;

        
end Behavioral;
