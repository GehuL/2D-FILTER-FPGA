----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.12.2024 13:12:53
-- Design Name: 
-- Module Name: filtre3x3 - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
package my_types_pkg is
type kernel_type is array(0 to 8) of STD_LOGIC_VECTOR(2 downto 0);
type pixels_type is array(0 to 8) of STD_LOGIC_VECTOR(7 downto 0);
end package;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_signed.ALL;

use work.my_types_pkg.all;   

entity filtre3x3 is Port(CLK: in STD_LOGIC;
                        EN: in STD_LOGIC;
                        RESET: in STD_LOGIC;
                        
                        KERNEL: in kernel_type;
                        PIXELS_IN: in pixels_type;
                        
                        COEF_SUM: in STD_LOGIC_VECTOR(6 downto 0);
                        PIXEL_OUT: out STD_LOGIC_VECTOR(7 downto 0)
                        );
end filtre3x3;

architecture Behavioral of filtre3x3 is

type mult_outs_t is array(0 to 8) of STD_LOGIC_VECTOR(10 downto 0); 
signal mult_outs: mult_outs_t;

signal pix1_1: STD_LOGIC_VECTOR(11 downto 0); 
signal pix1_2: STD_LOGIC_VECTOR(11 downto 0); 
signal pix1_3: STD_LOGIC_VECTOR(11 downto 0); 
signal pix1_4: STD_LOGIC_VECTOR(11 downto 0); 

signal pix2_1: STD_LOGIC_VECTOR(12 downto 0); 
signal pix2_2: STD_LOGIC_VECTOR(12 downto 0); 

signal pix3_1: STD_LOGIC_VECTOR(13 downto 0);
signal pix4_1: STD_LOGIC_VECTOR(13 downto 0);

begin

gen1: for i in 0 to 8 generate
mult_outs(i) <=  (others => '0')            when RESET = '1' else
                 (PIXELS_IN(i) * KERNEL(i)) when EN = '1' else 
                 mult_outs(i);
end generate gen1;

P1: process(CLK, RESET)
begin

    if(RESET = '1') then
        PIXEL_OUT <= (others => '0');
        pix1_1 <= (others => '0');
        pix1_2 <= (others => '0');
        pix1_3 <= (others => '0');
        pix1_4 <= (others => '0');
        pix2_1 <= (others => '0');
        pix2_2 <= (others => '0');
        pix3_1 <= (others => '0');
        pix4_1 <= (others => '0');
    elsif(CLK'event and CLK='1')
    then
    
        if(EN = '1') then
                pix1_1 <= ('0'&mult_outs(0)) + ('0'&mult_outs(1));
                pix1_2 <= ('0'&mult_outs(2)) + ('0'&mult_outs(3));
                pix1_3 <= ('0'&mult_outs(4)) + ('0'&mult_outs(5));
                pix1_4 <= ('0'&mult_outs(6)) + ('0'&mult_outs(7));
                
                pix2_1 <= ('0'&pix1_1) + ('0'&pix1_2);
                pix2_2 <= ('0'&pix1_3) + ('0'&pix1_4);
                
                pix3_1 <= ('0'&pix2_1) + ('0'&pix2_2);
                
                PIXEL_OUT <= std_logic_vector(to_unsigned(unsigned(pixel3_1) / unsigned(COEF_SUM), 8));
        end if;
    
    
    end if;

end process;


end Behavioral;
