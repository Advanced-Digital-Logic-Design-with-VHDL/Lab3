----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/08/2019 02:28:39 PM
-- Design Name: 
-- Module Name: traffic_intersection_tb - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--use IEEE.STD_LOGIC_1164.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity traffic_intersection_tb is
--  Port ( );
end traffic_intersection_tb;

architecture Behavioral of traffic_intersection_tb is
--Add traffic_intersection component

component traffic_intersection is
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
            red_led: out STD_LOGIC_VECTOR (1 downto 0):="00";    -- Red Light Camera [red_led(0), red_led(1) ];
            CC :        out STD_LOGIC;                     --Common cathode input to select respective 7-segment digit.
            out_7seg :  out STD_LOGIC_VECTOR (6 downto 0);  -- Output  signal for selected 7 Segment display. 
            KeyPad_Col: out STD_LOGIC_VECTOR (3 downto 0) :="0000";
            KeyPad_Row: in STD_LOGIC_VECTOR(3 DOWNTO 0)
           );
end component;

--Clock component
component clock_divider is
    port (  clk: in STD_LOGIC;
            clk_out: out STD_LOGIC
          );
end component;


-- input signals 
signal clk: std_logic :='0'; --also for clk
signal btn,sw: std_logic_vector(3 downto 0):="0000";

--output signals 
signal led6_r,  led6_g, led6_b, CC: std_logic;
signal led, red_led: std_logic_vector(1 downto 0);
signal out_7seg: std_logic_vector(6 downto 0);
signal clk_out: std_logic; -- for clk
signal KeyPad_Col: STD_LOGIC_VECTOR(3 downto 0) :="0000";
signal  KeyPad_Row: STD_LOGIC_VECTOR(3 DOWNTO 0);

Constant clock_period: time:=500ps;

begin
    --initalize 
   TI: traffic_intersection Port Map
                (
                clk=>clk,
                btn=>btn,       
                sw=>sw,  
               led6_r=>led6_r,
               led6_g=>led6_g,
               led6_b=>led6_b,
               led=>led, 
               red_led=>red_led,
               CC=>CC,
               out_7seg=>out_7seg,
               KeyPad_Row=> KeyPad_Row,
               KeyPad_Col=> KeyPad_Col
         );
    -- initalize
    
    divider: clock_divider port map
    (
            clk=>clk,
            clk_out=> clk_out
          );
 
    clock: process
    begin
        clk <='0';
        wait for clock_period/2;
        clk <='1';
        wait for clock_period/2;
    end process;
    
 ---------------------------------------------------------------
 ---NOTE:
   --Input
      -- SW(0)='1' =>Vehicle present on East/West direction 
      -- SW(1)='1' =>Vehicle present on North/South direction 
      --btn(0)='1' =>Shows the Led,r,g,b in N/S
      --btn(1)='1' =>Reset to state zero on clk change
  ---------------------------------------------------------------
   --Output
       --Led shows the state 
       --Led,r,g,b shows the light in E/W by defult    
    ---------------------------------------------------------------                                       
    simulation: process
    begin
    --------------------------Requirement #2 Normal Simulation-------------------------------------

--        wait for 100ns; --then continue
         
--        btn<= "0001";
        
--        wait for 50ns; --holding the input
        
--        btn<= "0000";
        
--        wait for 100ns;
        
    ------------------------- Requirement #3 Red Light Flash--------------------------------------  
        
----        Vehical approches intersection so flash_red if state is 2 or 3(red light) 
--        btn<= "0000";
        
--        wait for 50ns;
        
--        btn(2) <= '1'; -- Vehicle crosing on East/West (Output: red_led(0)=>1, at states: 2, 3)
       
--        wait for 50ns;
        
--        btn(2) <= '0';
                   
--        wait for 50ns;
        
-- --        Vehical approches intersection so flash_red if state is 0 or 1(red light) 
--        btn<= "0001";
        
--        wait for 50ns;
        
--        btn(3) <= '1'; -- Vehicle crosing on North West (Output: red_led(1)=>1, at states: , 0, 1)
        
--        wait for 50ns;
        
--        btn(3) <= '0';
        
--        wait for 50ns;

--        ---------------------Requirement #4 Night Time Operation-------------------------------------------  
--        --1)   
--        btn<= "0000";
--        sw<= "0000";
        
--        wait for 50ns;
        
--        --SW(3) to simulate the light sensor
--        sw(3) <= '1';
        
--        wait for 50ns;
       
--        sw(0) <= '1'; -- vehicle's presence in the East or West direction 
        
--        --should encounter a red light, we should then change it to green sw(1) is not 1(no vehical in N/S)
        
--        --cheking theat the other direction is red 
--        wait for 20ns;
--        btn<= "0001";
        
--        wait for 50ns;
        
--        --2)
--        btn<= "0001";
--        sw<= "0000";
       
--       wait for 50ns;
        
--        --SW(3) to simulate the light sensor
--        sw(3) <= '1';
        
--        wait for 50ns;
       
--        sw(1) <= '1'; -- vehicle's presence in the North or South direction 
        
--        --should encounter a red light, we should then change it to green sw(0) is not 1(no vehical in E/W)
        
--        --cheking theat the other direction is red 
--        wait for 20ns;
       
--        btn<= "0000";
        
--        wait for 50ns;

    ---------------------------------------------------------------
    --Requirement #6
--Display the pedestrian crosswalk signal as '0' for stop and '1' for walking on the seven segments. You can use
--one segment for the East-West direction and other for the North-South direction pedestrian crosswalk signals.
        btn<= "0000";
        sw<= "0000";
        
        wait for 25ns; 
        
        KeyPad_Row <= "1111"; -- key is not pressed 

        wait for 25ns; 
        
        KeyPad_Row <= "0111"; -- key is not pressed 
        
        wait for 25ns;
        
    ---------------------------------------------------------------
 
    end Process;

end Behavioral;

