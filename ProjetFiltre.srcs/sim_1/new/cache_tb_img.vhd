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

entity cache_tb_img is
--  Port ( );
end cache_tb_img;

architecture Behavioral of cache_tb_img is

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

constant full_tresh: STD_LOGIC_VECTOR(9 downto 0) := "0001111011";
constant clock_period: time := 10 ns;
signal clock_init: STD_LOGIC;

signal CLK: STD_LOGIC;
signal EN: STD_LOGIC;
signal RESET: STD_LOGIC;
signal PIXEL_in: STD_LOGIC_VECTOR(7 downto 0);
                           
--signal PIXEL1: STD_LOGIC_VECTOR(7 downto 0);
--signal PIXEL2: STD_LOGIC_VECTOR(7 downto 0);
--signal PIXEL3: STD_LOGIC_VECTOR(7 downto 0);
--signal PIXEL4: STD_LOGIC_VECTOR(7 downto 0);
--signal PIXEL5: STD_LOGIC_VECTOR(7 downto 0);
--signal PIXEL6: STD_LOGIC_VECTOR(7 downto 0);
--signal PIXEL7: STD_LOGIC_VECTOR(7 downto 0);
--signal PIXEL8: STD_LOGIC_VECTOR(7 downto 0);
--signal PIXEL9: STD_LOGIC_VECTOR(7 downto 0);


type pixels_t is array(0 to 8) of STD_LOGIC_VECTOR(7 downto 0);
signal pixels: pixels_t;

signal DATA_AVAILABLE : STD_LOGIC;
signal O1 : std_logic_vector (7 downto 0); 
signal compteur: integer range 0 to 1024;

begin

MEMOIRE: mem_cache Port map(CLK => CLK, EN => EN, RESET => RESET, full_tresh => full_tresh, PIXEL_in => PIXEL_in, 
PIXEL_out1 => pixels(0), PIXEL_out2 => pixels(1), PIXEL_out3 => pixels(2),
PIXEL_out4 => pixels(3), PIXEL_out5 => pixels(4), PIXEL_out6 => pixels(5),
PIXEL_out7 => pixels(6), PIXEL_out8 => pixels(7), PIXEL_out9 => pixels(8));

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
    
    for i in 1 to (128*2+3) loop
      compteur <= compteur + 1;
      readline (vectors,Iline);
      read (Iline,I1_var);
                
      PIXEL_in <= I1_var;
	  	  
	  wait until CLK='1';
	  
    end loop;
    
    assert (pixels(0) = X"9D") report "Erreur d'alignement sur 01";
    assert (pixels(1) = X"9B") report "Erreur d'alignement sur 02";
    assert (pixels(2) = X"9C") report "Erreur d'alignement sur 03";
    assert (pixels(3) = X"9E") report "Erreur d'alignement sur 04";
    assert (pixels(4) = X"9F") report "Erreur d'alignement sur 05";
    assert (pixels(5) = X"A3") report "Erreur d'alignement sur 06";
    assert (pixels(6) = X"A2") report "Erreur d'alignement sur 07";
    assert (pixels(7) = X"A3") report "Erreur d'alignement sur 08";
    assert (pixels(8) = X"A2") report "Erreur d'alignement sur 09";

    DATA_AVAILABLE <= '1';
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
    wait for 5 ns;
    
    wait until DATA_AVAILABLE = '1'; -- attend tant que data_available est à zéro
    wait for 5 ns;
    
    for i in 0 to 8 loop
        write (Oline, pixels(8 - i), right, 2);
        writeline (results, Oline);
        wait for 5 ns;        
    end loop;
    file_close (results);
    wait;
 end process;
 
 O1 <= PIXEL_in;

end Behavioral;
