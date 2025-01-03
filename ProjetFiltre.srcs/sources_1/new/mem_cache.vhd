----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.11.2024 10:54:40
-- Design Name: 
-- Module Name: mem_cache - Behavioral
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

entity mem_cache is Port ( CLK: in STD_LOGIC;
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
end mem_cache;

architecture Behavioral of mem_cache is

component FIFO PORT (
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    prog_full_thresh : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    full : OUT STD_LOGIC;
    almost_full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC;
    prog_full : OUT STD_LOGIC;
    wr_rst_busy : OUT STD_LOGIC;
    rd_rst_busy : OUT STD_LOGIC
  );
end component;

component FLIPFLOP is
generic ( BIT_CNT: integer := 8);
    Port (  
           CLK : in STD_LOGIC;
           D : in STD_LOGIC_VECTOR (BIT_CNT - 1 downto 0);
           EN: in STD_LOGIC;
           RESET : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (BIT_CNT - 1 downto 0);
           Qnot : out STD_LOGIC_VECTOR (BIT_CNT - 1 downto 0));
end component;


signal prog_full: STD_LOGIC;
signal wr_en : STD_LOGIC;

signal FIFO_OUT1: STD_LOGIC_VECTOR(7 downto 0);
signal FIFO_OUT2: STD_LOGIC_VECTOR(7 downto 0);

signal PIX1: STD_LOGIC_VECTOR(7 downto 0);
signal PIX2: STD_LOGIC_VECTOR(7 downto 0);
signal PIX3: STD_LOGIC_VECTOR(7 downto 0);
signal PIX4: STD_LOGIC_VECTOR(7 downto 0);
signal PIX5: STD_LOGIC_VECTOR(7 downto 0);
signal PIX6: STD_LOGIC_VECTOR(7 downto 0);
signal PIX7: STD_LOGIC_VECTOR(7 downto 0);
signal PIX8: STD_LOGIC_VECTOR(7 downto 0);
signal PIX9: STD_LOGIC_VECTOR(7 downto 0);

begin

-- [ PREMIERE LIGNE ]
FF1: FLIPFLOP port map(CLK => CLK,  D => PIXEL_in, EN => EN, RESET => RESET, Q => PIX1, Qnot => open);
FF2: FLIPFLOP port map(CLK => CLK,  D => PIX1, EN => EN, RESET => RESET, Q => PIX2, Qnot => open);
FF3: FLIPFLOP port map(CLK => CLK,  D => PIX2, EN => EN, RESET => RESET, Q => PIX3, Qnot => open);

fifo1: FIFO port map(clk => CLK, rst => RESET, din => PIX3, wr_en => EN, rd_en => prog_full, -- prog full relié à rd_en pour ligne a retard
prog_full_thresh => full_tresh, dout => FIFO_OUT1, full => open, almost_full => open, empty => open, prog_full => prog_full, 
wr_rst_busy => open, rd_rst_busy => open);

-- [ DEUXIEME LIGNE ]
FF4: FLIPFLOP port map(CLK => CLK,  D => FIFO_OUT1, EN => EN, RESET => RESET, Q => PIX4, Qnot => open);
FF5: FLIPFLOP port map(CLK => CLK,  D => PIX4, EN => EN, RESET => RESET, Q => PIX5, Qnot => open);
FF6: FLIPFLOP port map(CLK => CLK,  D => PIX5, EN => EN, RESET => RESET, Q => PIX6, Qnot => open);

fifo2: FIFO port map(clk => CLK, rst => RESET, din => PIX6, wr_en => EN, rd_en => prog_full, -- prog full relié à rd_en pour ligne a retard
prog_full_thresh => full_tresh, dout => FIFO_OUT2, full => open, almost_full => open, empty => open, prog_full => prog_full, 
wr_rst_busy => open, rd_rst_busy => open);

-- [ TROISIEME LIGNE ]
FF7: FLIPFLOP port map(CLK => CLK,  D => FIFO_OUT2, EN => EN, RESET => RESET, Q => PIX7, Qnot => open);
FF8: FLIPFLOP port map(CLK => CLK,  D => PIX7, EN => EN, RESET => RESET, Q => PIX8, Qnot => open);
FF9: FLIPFLOP port map(CLK => CLK,  D => PIX8, EN => EN, RESET => RESET, Q => PIX9, Qnot => open);

-- [ SORTIES ]
PIXEL_out1 <= PIX1;
PIXEL_out2 <= PIX2;
PIXEL_out3 <= PIX3;
PIXEL_out4 <= PIX4;
PIXEL_out5 <= PIX5;
PIXEL_out6 <= PIX6;
PIXEL_out7 <= PIX7;
PIXEL_out8 <= PIX8;
PIXEL_out9 <= PIX9;

p1: process(CLK, RESET)
begin

end process;

end Behavioral;
