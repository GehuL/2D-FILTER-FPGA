----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.11.2024 15:02:14
-- Design Name: 
-- Module Name: cache_tb_img - Behavioral
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
use std.textio.all;
use ieee.std_logic_textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity average_tb_img is
--  Port ( );
end average_tb_img;

architecture cache_tb_img_arch of average_tb_img is

component mem_cache Port(CLK: in STD_LOGIC;
                           EN: in STD_LOGIC;
                           RESET: in STD_LOGIC;
                           full_tresh: in STD_LOGIC_VECTOR(9 downto 0);
                           PIXEL_in: in STD_LOGIC_VECTOR(7 downto 0);
                           
                           PIXEL_out1: out STD_LOGIC_VECTOR(7 downto 0);
                           PIXEL_out2: out STD_LOGIC_VECTOR(7 downto 0);
                           PIXEL_out3: out STD_LOGIC_VECTOR(7 downto 0);
                           PIXEL_out4: out STD_LOGIC_VECTOR(7 downto 0);
                           PIXEL_out5: out STD_LOGIC_VECTOR(7 downto 0);
                           PIXEL_out6: out STD_LOGIC_VECTOR(7 downto 0);
                           PIXEL_out7: out STD_LOGIC_VECTOR(7 downto 0);
                           PIXEL_out8: out STD_LOGIC_VECTOR(7 downto 0);
                           PIXEL_out9: out STD_LOGIC_VECTOR(7 downto 0));
end component;

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
                           
                           PIXEL_out: out STD_LOGIC_VECTOR(7 downto 0)); 
end component;

constant full_tresh: STD_LOGIC_VECTOR(9 downto 0) := "0001111100";
constant clock_period: time := 10 ns;
signal clock_init: STD_LOGIC;

signal CLK: STD_LOGIC;
signal EN: STD_LOGIC;
signal RESET: STD_LOGIC;
signal PIXEL_in: STD_LOGIC_VECTOR(7 downto 0);
                           
type pixels_t is array(0 to 8) of STD_LOGIC_VECTOR(7 downto 0);
signal pixels: pixels_t;

signal DATA_AVAILABLE : STD_LOGIC;
signal O1 : std_logic_vector (7 downto 0); 
signal compteur: integer range 0 to 1024;

signal PIXEL_OUT : STD_LOGIC_VECTOR(7 downto 0);

begin

MEMOIRE: mem_cache Port map(CLK => CLK, EN => EN, RESET => RESET, full_tresh => full_tresh, PIXEL_in => PIXEL_in, 
PIXEL_out1 => pixels(0), PIXEL_out2 => pixels(1), PIXEL_out3 => pixels(2),
PIXEL_out4 => pixels(3), PIXEL_out5 => pixels(4), PIXEL_out6 => pixels(5),
PIXEL_out7 => pixels(6), PIXEL_out8 => pixels(7), PIXEL_out9 => pixels(8));

MOYENNEUR: filtre_average Port map(CLK => CLK, EN => EN, RESET => RESET, 
PIXEL1 => pixels(0), PIXEL2 => pixels(1), PIXEL3 => pixels(2),
PIXEL4 => pixels(3), PIXEL5 => pixels(4), PIXEL6 => pixels(5),
PIXEL7 => pixels(6), PIXEL8 => pixels(7), PIXEL9 => pixels(8),
PIXEL_out => PIXEL_OUT);

stimulus: process
begin
    
end process;

clocking: process
begin
 CLK <= '0'; 
 wait for clock_period/2;
 CLK <= clock_init;
 wait for clock_period/2;
end process;

p_read : process

  FILE vectors : text;
  variable Iline : line;
  variable I1_var :std_logic_vector (7 downto 0);
    
    begin
	DATA_AVAILABLE <= '0';
    file_open (vectors,"Lena128x128g_8bits.dat", read_mode);
    clock_init <= '1';
    
    PIXEL_in <= (others => '0');
    EN <= '0';              
    RESET <= '1';
    
    wait for clock_period*15;
    RESET <= '0';
    
    wait for clock_period*15; -- Attendre l'initialisation
    EN <= '1';   
    
   while not endfile(vectors) loop
      readline (vectors,Iline);
      read (Iline,I1_var);
                
      PIXEL_in <= I1_var;
	  DATA_AVAILABLE <= '1';
	  wait for clock_period;
    end loop;
    
    -- Remplissage du buffer + délai du filtre
    wait for (259+4)*clock_period; 
    
    DATA_AVAILABLE <= '0';
    EN <= '0';
    
    wait for 10 ns;
    file_close (vectors);
    wait;
end process;

p_write: process
  file results : text;
  variable OLine : line;
  variable O1_var :std_logic_vector (7 downto 0);
    
    begin
    file_open (results,"Lena128x128g_8bits_r.dat", write_mode);
    wait for clock_period/2;
    
    wait until DATA_AVAILABLE = '1'; -- attend tant que data_available est à zéro
    
    -- Attend le remplissage du buffer + délai du filtre
    wait for (259+5)*clock_period; 

    while DATA_AVAILABLE ='1' loop
      write (Oline, O1, right, 2);
      writeline (results, Oline);
      wait for clock_period;  
    end loop;
    file_close (results);
    wait;
 end process;
 
O1 <= PIXEL_OUT;

end cache_tb_img_arch;
