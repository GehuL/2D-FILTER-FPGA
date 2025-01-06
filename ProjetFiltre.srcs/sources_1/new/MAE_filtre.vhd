library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MAE_filtre is Port( CLK: in STD_LOGIC;
                           RST: in STD_LOGIC;
                           EN: in STD_LOGIC;
                           
                           data_in_av: in STD_LOGIC; -- Indique que des données arrivent
                           
                           data_av: out STD_LOGIC;
                           read_ready: out STD_LOGIC;
                           
                           pix_in: in STD_LOGIC_VECTOR(7 downto 0);
                           pix_out: out STD_LOGIC_VECTOR(7 downto 0)
                         );
end MAE_filtre;

architecture MAE_filtre_arch of MAE_filtre is 

component mem_cache is Port ( CLK: in STD_LOGIC;
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

component filtre_average is Port ( 
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

constant full_tresh: STD_LOGIC_VECTOR(9 downto 0) := "0001111100";

type ETAT_t is (ETAT0, ETAT1, ETAT2, ETAT3);

signal ETAT: ETAT_t := ETAT0;
signal compteur: integer range 0 to 1023 := 0;

signal EN_mem, EN_filtre: STD_LOGIC;
signal RST_mem, RST_filtre: STD_LOGIC;

type pixels_t is array(0 to 8) of STD_LOGIC_VECTOR(7 downto 0);
signal pixels_out: pixels_t;
signal pix_filtre: STD_LOGIC_VECTOR(7 downto 0);

signal read_ready_sig, data_av_sig: STD_LOGIC;

begin

memoire: mem_cache port map(CLK => CLK, EN => EN_mem, RESET => RST, full_tresh => full_tresh, PIXEL_in => pix_in,
PIXEL_out1 => pixels_out(0), PIXEL_out2 => pixels_out(1), PIXEL_out3 => pixels_out(2),
PIXEL_out4 => pixels_out(3), PIXEL_out5 => pixels_out(4), PIXEL_out6 => pixels_out(5),
PIXEL_out7 => pixels_out(6), PIXEL_out8 => pixels_out(7), PIXEL_out9 => pixels_out(8));

filtre: filtre_average port map( CLK => CLK, EN => EN_filtre, RESET => RST,
PIXEL1 => pixels_out(0), PIXEL2 => pixels_out(1), PIXEL3 => pixels_out(2),
PIXEL4 => pixels_out(3), PIXEL5 => pixels_out(4), PIXEL6 => pixels_out(5),
PIXEL7 => pixels_out(6), PIXEL8 => pixels_out(7), PIXEL9 => pixels_out(8),
PIXEL_out => pix_filtre);

CONNEXION: process(CLK, RST)
begin
    if(RST = '1') then
        compteur <= 0;
        ETAT <= ETAT0;
    elsif(CLK'event and CLK = '1') then
    
        if(EN = '1') then
            case(ETAT) is
                when ETAT0 =>
                    if(compteur >= 15) then     -- Initialisation mémoire cache
                       ETAT <= ETAT1;
                       compteur <= 0;
                    else
                       compteur <= compteur + 1;
                    end if;
                when ETAT1 => 
                
                    if(data_in_av = '1') 
                    then                
                        if(compteur >= 128*2+3) then -- Attend le remplissage du buffer
                           ETAT <= ETAT2;
                           compteur <= 0;
                        else
                           compteur <= compteur + 1;
                        end if;
                    else -- Standby de la mémoire 
                        compteur <= compteur; 
                    end if;
               
                when ETAT2 =>
                
                    if(compteur >= 4) then -- Compte 4 cycles pour le délai du filtre
                        ETAT <= ETAT3;
                        compteur <= 0;
                    else
                        compteur <= compteur + 1;
                    end if;
                    
                 when ETAT3 =>
                    
                    if(data_in_av = '0') -- Si il n'y a plus de donnée en entrée, on attend que la mémoire se vide
                    then
                        
                         if(compteur >= 128*2+8) then
                             ETAT <= ETAT1;
                             compteur <= 0;
                         else
                             compteur <= compteur + 1;
                         end if;

                    end if;
                    
                    when others =>
                        ETAT <= ETAT0;
            end case;
        end if;
    
    end if;
end process;

ACTION: process(ETAT, data_in_av)
begin
    case(ETAT) is
        when ETAT0 => 
            RST_filtre <= '1';
            EN_mem <= '0';
            EN_filtre <= '0';
            read_ready_sig <= '0';
            data_av_sig <= '0';
        when ETAT1 =>
            RST_filtre <= '0';
            EN_mem <= data_in_av;
            EN_filtre <= data_in_av;
            read_ready_sig <= '1';
            data_av_sig <= '0';
        when ETAT2 =>
            RST_filtre <= '0';
            EN_mem <= data_in_av;
            EN_filtre <= data_in_av;
            read_ready_sig <= '1';
            data_av_sig <= '0';
        when ETAT3 => -- Indique que des données en sorties sont disponibles
            RST_filtre <= '0';
            EN_mem <= data_in_av;
            EN_filtre <= data_in_av;
            read_ready_sig <= '1';
            data_av_sig <= '1';
        when others => 
    end case;
end process;

pix_out <= pix_filtre;
data_av <= data_av_sig;
read_ready <= read_ready_sig;

end MAE_filtre_arch;