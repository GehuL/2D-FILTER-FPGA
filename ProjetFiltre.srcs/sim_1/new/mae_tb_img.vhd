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

entity mae_tb_img is
--  Port ( );
end mae_tb_img;

architecture mae_tb_img_arch of mae_tb_img is

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

component MAE_filtre Port( CLK: in STD_LOGIC;
                           RST: in STD_LOGIC;
                           EN: in STD_LOGIC;
                           data_in_av: in STD_LOGIC; 
                           data_av: out STD_LOGIC;
                           read_ready: out STD_LOGIC;
                           
                           pix_in: in STD_LOGIC_VECTOR(7 downto 0);
                           pix_out: out STD_LOGIC_VECTOR(7 downto 0)
                         );
end component;

constant clock_period: time := 10 ns;
signal clock_init: STD_LOGIC;

signal CLK: STD_LOGIC;
signal EN: STD_LOGIC;
signal RESET: STD_LOGIC;
signal PIXEL_in: STD_LOGIC_VECTOR(7 downto 0);
                           
signal O1 : std_logic_vector (7 downto 0); 

signal PIXEL_OUT : STD_LOGIC_VECTOR(7 downto 0);

signal data_in_av, data_av, read_ready: STD_LOGIC;

begin

FILTRE: MAE_filtre port map(CLK => CLK, RST => RESET, EN => EN, data_in_av=> data_in_av, data_av => data_av, read_ready => read_ready, pix_in => PIXEL_in, pix_out => PIXEL_OUT);

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
    file_open (vectors,"Lena128x128g_8bits.dat", read_mode);
    clock_init <= '1';
    
    PIXEL_in <= (others => '0');
    EN <= '0';              
    RESET <= '1';
    data_in_av <= '0';
    
    wait for clock_period*2;
    
    RESET <= '0';
    EN <= '1';
    
   wait until read_ready = '1'; -- Attendre l'initialisation
    
   data_in_av <= '1';

   while not endfile(vectors) loop
      readline (vectors,Iline);
      read (Iline,I1_var);
                
      PIXEL_in <= I1_var;
	  wait for clock_period;
    end loop;
    
    data_in_av <= '0'; -- Informe qu'il n'y a plus de données,
    wait until data_av = '0'; -- Attend que toutes les données soient traitées
    EN <= '0';
    RESET <= '1';
    
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
    
    wait until data_av = '1'; -- attend tant que data_available passe à 1

    while data_av='1' loop
      write (Oline, O1, right, 2);
      writeline (results, Oline);
      wait for clock_period;  
    end loop;
    
    file_close (results);
    wait;
 end process;
 
O1 <= PIXEL_OUT;

end mae_tb_img_arch;
