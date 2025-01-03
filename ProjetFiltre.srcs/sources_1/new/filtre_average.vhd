----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.11.2024 08:29:28
-- Design Name: 
-- Module Name: filtre_average - Behavioral
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
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity filtre_average is Port ( 
                           CLK: in STD_LOGIC;
                           EN: in STD_LOGIC;
                           RESET: in STD_LOGIC;
                           
                           PIXEL1: in STD_LOGIC_VECTOR(7 downto 0);
                           PIXEL2: in STD_LOGIC_VECTOR(7 downto 0);
                           PIXEL3: in STD_LOGIC_VECTOR(7 downto 0);
                           PIXEL4: in STD_LOGIC_VECTOR(7 downto 0);
                           PIXEL5: in STD_LOGIC_VECTOR(7 downto 0);
                           PIXEL6: in STD_LOGIC_VECTOR(7 downto 0);
                           PIXEL7: in STD_LOGIC_VECTOR(7 downto 0);
                           PIXEL8: in STD_LOGIC_VECTOR(7 downto 0);
                           PIXEL9: in STD_LOGIC_VECTOR(7 downto 0);
                           
                           PIXEL_out: out STD_LOGIC_VECTOR(7 downto 0)                         
                           );
end filtre_average;

architecture filtre_average_arch of filtre_average is

signal pix1_1: STD_LOGIC_VECTOR(8 downto 0); 
signal pix1_2: STD_LOGIC_VECTOR(8 downto 0); 
signal pix1_3: STD_LOGIC_VECTOR(8 downto 0); 
signal pix1_4: STD_LOGIC_VECTOR(8 downto 0); 

signal pix2_1: STD_LOGIC_VECTOR(9 downto 0); 
signal pix2_2: STD_LOGIC_VECTOR(9 downto 0); 

signal pix3_1: STD_LOGIC_VECTOR(10 downto 0);
signal pix4_1: STD_LOGIC_VECTOR(11 downto 0); 

begin

P1: process(CLK, RESET)
begin

    if RESET = '1' then
        PIXEL_OUT <= (others => '0');
        pix1_1 <= (others => '0');
        pix1_2 <= (others => '0');
        pix1_3 <= (others => '0');
        pix1_4 <= (others => '0');
        pix2_1 <= (others => '0');
        pix2_2 <= (others => '0');
        pix3_1 <= (others => '0');
        pix4_1 <= (others => '0');
    elsif CLK'event and CLK = '1' then
        if(EN = '1') then
            -- 1er cycle
            pix1_1 <= ('0'&PIXEL1) + ('0'&PIXEL2);
            pix1_2 <= ('0'&PIXEL3) + ('0'&PIXEL4);
            pix1_3 <= ('0'&PIXEL5) + ('0'&PIXEL6);
            pix1_4 <= ('0'&PIXEL7) + ('0'&PIXEL8);
    
            -- 2e cycle
            pix2_1 <= ('0'&pix1_1) + ('0'&pix1_2);
            pix2_2 <= ('0'&pix1_3) + ('0'&pix1_4);
            
            -- 3e cycle
            pix3_1 <= ('0'&pix2_1) + ('0'&pix2_2);
            
            -- Addtionne le dernier pixel
           -- pix4_1 <= ('0'&pix3_1) + ("0000"&PIXEL9);
            
            
            -- Division par 16 (impossible de faire une division par 9 ou 8 car on ne respecterait pas la taille du bus)
           -- PIXEL_OUT <=  pix4_1(11 downto 4); 
            
            -- Division par 8 
            PIXEL_OUT <= pix3_1(10 downto 3);
        
        end if;
    end if;
end process;

end filtre_average_arch;
