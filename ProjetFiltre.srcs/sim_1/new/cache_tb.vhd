----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.11.2024 11:44:02
-- Design Name: 
-- Module Name: cache_tb - Behavioral
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

entity cache_tb is
--  Port ( );
end cache_tb;

architecture Behavioral of cache_tb is

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

constant full_tresh: STD_LOGIC_VECTOR(9 downto 0) := "0000001000";
constant clock_period: time := 10 ns;
signal clock_init: STD_LOGIC;

signal CLK: STD_LOGIC;
signal EN: STD_LOGIC;
signal RESET: STD_LOGIC;
signal PIXEL_in: STD_LOGIC_VECTOR(7 downto 0);
                           
signal PIXEL1: STD_LOGIC_VECTOR(7 downto 0);
signal PIXEL2: STD_LOGIC_VECTOR(7 downto 0);
signal PIXEL3: STD_LOGIC_VECTOR(7 downto 0);
signal PIXEL4: STD_LOGIC_VECTOR(7 downto 0);
signal PIXEL5: STD_LOGIC_VECTOR(7 downto 0);
signal PIXEL6: STD_LOGIC_VECTOR(7 downto 0);
signal PIXEL7: STD_LOGIC_VECTOR(7 downto 0);
signal PIXEL8: STD_LOGIC_VECTOR(7 downto 0);
signal PIXEL9: STD_LOGIC_VECTOR(7 downto 0);

signal compteur: integer range 0 to 1023;

begin

MEMOIRE: mem_cache Port map(CLK => CLK, EN => EN, RESET => RESET, full_tresh =>full_tresh, PIXEL_in => PIXEL_in, 
PIXEL_out1 => PIXEL1, PIXEL_out2 => PIXEL2, PIXEL_out3 => PIXEL3,
PIXEL_out4 => PIXEL4, PIXEL_out5 => PIXEL5, PIXEL_out6 => PIXEL6,
PIXEL_out7 => PIXEL7, PIXEL_out8 => PIXEL8, PIXEL_out9 => PIXEL9);

stimulus: process
begin
    clock_init <= '1';
    
    PIXEL_in <= X"AA";
    EN <= '0';              
    RESET <= '1';
    wait for clock_period*15; -- Attendre l'initialisation
    RESET <= '0';
    wait for clock_period*15; -- Attendre l'initialisation
    EN <= '1';                -- Début ecriture
    PIXEL_in <= X"BB";
    
    wait until compteur = 15;

    --wait for clock_period;
    --wait for clock_period*125;
    -- On devrait voir les pixels 4,5,6 actualisés
    --wait for clock_period*125;
    -- On devrait voir les pixels 7,8,9 actualisés
    --wait for clock_period*10;
    RESET <= '1';

    wait;
end process;

clocking: process
begin
 CLK <= '0'; 
 wait for clock_period/2;
 CLK <= clock_init;
 wait for clock_period/2; 
end process;

-- Permet de vérifier le bon nombre de pixel
compt: process(CLK)
begin
    if(CLK'event and CLK = '1') then
        if( EN = '1') then
         compteur <= compteur + 1;
        end if;
    end if;
end process;

end Behavioral;
