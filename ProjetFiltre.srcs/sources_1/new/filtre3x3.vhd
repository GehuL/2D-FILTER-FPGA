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

use work.my_types_pkg.all;   

entity filtre3x3 is Port(CLK: in STD_LOGIC;
                        EN: in STD_LOGIC;
                        RESET: in STD_LOGIC;
                        
                        KERNEL: in kernel_type;
                        PIXELS_IN: in pixels_type;
                        
                        COEF_SUM: in STD_LOGIC_VECTOR(6 downto 0)
                        );
end filtre3x3;

architecture Behavioral of filtre3x3 is

signal pix1_1: STD_LOGIC_VECTOR(10 downto 0); 
signal pix1_2: STD_LOGIC_VECTOR(10 downto 0); 
signal pix1_3: STD_LOGIC_VECTOR(10 downto 0); 
signal pix1_4: STD_LOGIC_VECTOR(10 downto 0); 

signal pix2_1: STD_LOGIC_VECTOR(11 downto 0); 
signal pix2_2: STD_LOGIC_VECTOR(11 downto 0); 

signal pix3_1: STD_LOGIC_VECTOR(12 downto 0);
signal pix4_1: STD_LOGIC_VECTOR(12 downto 0);

begin

P1: process(CLK, RESET)
begin

    if(CLK'event and CLK='1')
    then
    
        
    
    
    end if;

end process;


end Behavioral;
