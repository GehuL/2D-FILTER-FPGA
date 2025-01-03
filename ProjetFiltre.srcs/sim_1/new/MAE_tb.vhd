----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.12.2024 13:37:15
-- Design Name: 
-- Module Name: MAE_tb - Behavioral
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

entity MAE_tb is
--  Port ( );
end MAE_tb;

architecture Behavioral of MAE_tb is

component MAE_filtre Port ( CLK: in STD_LOGIC;
                           RST: in STD_LOGIC;
                           EN: in STD_LOGIC;
                           
                           wr_en: out STD_LOGIC;
                           data_av: out STD_LOGIC;
                           
                           pix_in: in STD_LOGIC_VECTOR(7 downto 0);
                           pix_out: out STD_LOGIC_VECTOR(7 downto 0)
                         );
end component;


constant clock_period: time := 10 ns;
signal clock_init: STD_LOGIC;

signal CLK: STD_LOGIC;
signal EN: STD_LOGIC;
signal RESET: STD_LOGIC;

signal pix_in: STD_LOGIC_VECTOR(7 downto 0);
signal pix_out: STD_LOGIC_VECTOR(7 downto 0);


signal wr_en, data_av: STD_LOGIC;

begin

MAE: MAE_filtre port map(CLK => CLK, RST => RESET, EN => EN,
                           wr_en => wr_en, data_av => data_av,      
                           pix_in => pix_in, pix_out => pix_out);
                           
stimulus: process
begin
    
    clock_init <= '1';
    RESET <= '1';
    
    pix_in <= X"AB";
    
    wait for clock_period;
    
    EN <= '1';
    RESET <= '0';
    
    wait until wr_en = '1';
    
    wait for clock_period;
    
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

end Behavioral;
