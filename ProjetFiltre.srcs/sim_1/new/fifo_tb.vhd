----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.11.2024 11:56:15
-- Design Name: 
-- Module Name: fifo_tb - fifo_tb_arch
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

entity fifo_tb is
--  Port ( );
end fifo_tb;

architecture fifo_tb_arch of fifo_tb is

component FIFO PORT (
    clk : in STD_LOGIC;
    rst : in STD_LOGIC;
    din : in STD_LOGIC_VECTOR ( 7 downto 0 );
    wr_en : in STD_LOGIC;
    rd_en : in STD_LOGIC;
    dout : out STD_LOGIC_VECTOR ( 7 downto 0 );
    full : out STD_LOGIC;
    almost_full : out STD_LOGIC;
    empty : out STD_LOGIC;
    prog_full : out STD_LOGIC;
    wr_rst_busy : out STD_LOGIC;
    rd_rst_busy : out STD_LOGIC
  );
end component;

  constant clock_period: time := 10 ns;
  signal clock_init: STD_LOGIC;
  
  signal CLOCK_s : STD_LOGIC;
  signal rst : STD_LOGIC;
  signal din : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal wr_en : STD_LOGIC;
  -- signal rd_en : STD_LOGIC;
  signal dout : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal full : STD_LOGIC;                          -- Flag detection mémoire pleine (1024)
  signal almost_full : STD_LOGIC;                   -- Flag détection treshold - 1 atteinte
  signal empty : STD_LOGIC;                         -- Flag détection mémoire vide
  signal prog_full : STD_LOGIC;                     -- Flag détection treshold atteinte
  signal wr_rst_busy : STD_LOGIC;
  signal rd_rst_busy : STD_LOGIC;

begin

fifo_inst: FIFO port map(clk => CLOCK_s, rst => rst, din => din, wr_en => wr_en, rd_en => prog_full, -- prog full relié à rd_en 
dout => dout, full => full, almost_full => almost_full, empty => empty, prog_full => prog_full, 
wr_rst_busy => wr_rst_busy, rd_rst_busy => rd_rst_busy);

stimulus: process
begin
      clock_init <= '1';
      
      rst <= '1';
      din <= (others => '1');
      wr_en <= '0';
      --rd_en <= '0';
      wait for 200 ns;
      rst <= '0';
      wait for clock_period*10; -- attend l'initialisation
      -- wait until (full='0' and empty='1');
      wait for clock_period*5;
      wr_en <= '1';
   
      wait until prog_full = '1';
      din <= x"0a";
      wait for clock_period;
      din <= x"0b";
      wait for clock_period;
      din <= x"0c";
      wait for clock_period;
      din <= x"0d";
      wait for clock_period;
      din <= x"0e";
      
       wait for clock_period;
     
        rst <= '1';

    wait;
end process;

clocking: process
begin
 CLOCK_s <= '0'; 
 wait for clock_period/2;
 CLOCK_s <= clock_init;
 wait for clock_period/2;
end process;

end fifo_tb_arch;
