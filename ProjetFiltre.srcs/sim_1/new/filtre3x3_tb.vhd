----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.01.2025 19:27:31
-- Design Name: 
-- Module Name: filtre3x3_tb - Behavioral
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
use IEEE.STD_LOGIC_signed.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
use work.my_types_pkg.all;

entity filtre3x3_tb is
end filtre3x3_tb;



architecture Behavioral of filtre3x3_tb is

component filtre3x3 Port(CLK: in STD_LOGIC;
                        EN: in STD_LOGIC;
                        RESET: in STD_LOGIC;
                        
                        KERNEL: in kernel_type;
                        PIXELS_IN: in pixels_type;
                        
                        COEF_SUM: in STD_LOGIC_VECTOR(6 downto 0));
end component;

signal CLK: STD_LOGIC;
constant clock_period: time := 10 ns;

signal EN : STD_LOGIC;
signal RESET: STD_LOGIC;
signal coef_sum: STD_LOGIC_VECTOR(6 downto 0);

signal kernel: kernel_type;
signal pixels: pixels_type;

begin

filtre: filtre3x3 port map(CLK => CLK, EN => EN, RESET => RESET, KERNEL => kernel, PIXELS_IN => pixels, COEF_SUM => coef_sum);

stimulus: process
begin
    
    EN <= '0';
    RESET <= '1';
    
    for i in 0 to 8 loop
     kernel(i) <= std_logic_vector(to_unsigned(i, 3));
     pixels(i) <= std_logic_vector(to_unsigned(i, 8));
    end loop;
    
    coef_sum <= "0100100";
    
    wait for clock_period;
    
    EN <= '1';
    RESET <= '0';
    
    wait for clock_period;

    wait;
end process;

clock: process
begin
    CLK <= '0';
    wait for clock_period/2;
    CLK <= '1';
    wait for clock_period/2;
end process;

end Behavioral;
