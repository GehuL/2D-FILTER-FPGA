----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.09.2024 08:59:14
-- Design Name: 
-- Module Name: flipflop - Behavioral
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

entity flipflop is
generic ( BIT_CNT: integer := 8);
    Port (  
           CLK : in STD_LOGIC;
           D : in STD_LOGIC_VECTOR (BIT_CNT - 1 downto 0);
           EN: in STD_LOGIC;
           RESET : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (BIT_CNT - 1 downto 0);
           Qnot : out STD_LOGIC_VECTOR (BIT_CNT - 1 downto 0));
end flipflop;

architecture Behavioral of flipflop is

signal sig : std_logic_vector(BIT_CNT - 1 downto 0) := (others => '0');

begin

P1: process(CLK, RESET)
begin
    if(RESET = '1') then
        sig <= (others => '0');
    elsif(CLK'event and CLK = '1') then
        if(EN = '1') then
            sig <= D;
        end if;
    end if;
end process;

Q <= sig;
Qnot <= not sig;

end Behavioral;
