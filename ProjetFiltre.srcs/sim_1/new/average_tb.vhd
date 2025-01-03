----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.11.2024 09:24:04
-- Design Name: 
-- Module Name: average_tb - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity average_tb is
--  Port ( );
end average_tb;

architecture Behavioral of average_tb is

component filtre_average Port ( 
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
end component;

constant clock_period: time := 10 ns;
signal clock_init: STD_LOGIC;

signal CLK: STD_LOGIC;
signal EN: STD_LOGIC;
signal RESET: STD_LOGIC;

signal PIXEL1: STD_LOGIC_VECTOR(7 downto 0);
signal PIXEL2: STD_LOGIC_VECTOR(7 downto 0);
signal PIXEL3: STD_LOGIC_VECTOR(7 downto 0);
signal PIXEL4: STD_LOGIC_VECTOR(7 downto 0);
signal PIXEL5: STD_LOGIC_VECTOR(7 downto 0);
signal PIXEL6: STD_LOGIC_VECTOR(7 downto 0);
signal PIXEL7: STD_LOGIC_VECTOR(7 downto 0);
signal PIXEL8: STD_LOGIC_VECTOR(7 downto 0);
signal PIXEL9: STD_LOGIC_VECTOR(7 downto 0);

signal PIXEL_OUT: STD_LOGIC_VECTOR(7 downto 0);

begin

filtre: filtre_average port map(CLK => CLK, EN => EN, RESET => RESET, 
PIXEL1 => PIXEL1, PIXEL2 => PIXEL2, PIXEL3 => PIXEL3, 
PIXEL4 => PIXEL4, PIXEL5 => PIXEL5, PIXEL6 => PIXEL6, 
PIXEL7 => PIXEL7, PIXEL8 => PIXEL8, PIXEL9 => PIXEL9,
PIXEL_out => PIXEL_OUT);

stimulus: process
begin
    clock_init <= '1';
    
    RESET <= '1';
    
    PIXEL1 <= X"02";
    PIXEL2 <= X"02";
    PIXEL3 <= X"02";
    PIXEL4 <= X"02";
    PIXEL5 <= X"02";
    PIXEL6 <= X"02";
    PIXEL7 <= X"02";
    PIXEL8 <= X"02";
    PIXEL9 <= X"02";
    
    wait for clock_period;
    RESET <= '0';
    EN <= '1';
    
    wait for clock_period * 5; -- Le moyenneur prend 5 cycles
    
    assert PIXEL_OUT = X"02" report "PIXEL_out n'est pas égale à 2";    

    PIXEL1 <= X"08";
    PIXEL2 <= X"07";
    PIXEL3 <= X"07";
    PIXEL4 <= X"01";
    PIXEL5 <= X"02";
    PIXEL6 <= X"02";
    PIXEL7 <= X"AC";
    PIXEL8 <= X"02";
    PIXEL9 <= X"78";
    
    wait for clock_period * 5;

    assert PIXEL_OUT = X"E" report "PIXEL_out n'est pas égale à 14";    


wait;
end process;

clocking: process
begin
 CLK <= '0'; 
 wait for clock_period/2;
 CLK <= clock_init;
 wait for clock_period/2;
end process;

end Behavioral;
