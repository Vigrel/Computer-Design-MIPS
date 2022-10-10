library ieee;
use ieee.std_logic_1164.all;

entity Aula7e8 is
  generic ( 
		  larguraDados : natural := 8;
		  larguraEnderecos : natural := 9;
        largurainstrucao : natural := 13;
		  simulacao : boolean := FALSE
  );
  port   (
    CLOCK_50:in std_logic;
	 KEY: in  std_logic_vector(3 downto 0);
	 LEDR : out std_logic_vector (larguraEnderecos downto 0);
	 HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6: out std_logic_vector(6 downto 0) 
  );
end entity;


architecture arquitetura of Aula7e8 is
	signal CLK, hab_rd, hab_wr: std_logic;
	signal saida_ROM: std_logic_vector (largurainstrucao-1 downto 0);
	signal saida_RAM: std_logic_vector (larguraDados-1 downto 0);
	signal data_out: std_logic_vector (larguraDados-1 downto 0);
	signal data_add_out: std_logic_vector (larguraEnderecos-1 downto 0);
	signal rom_add_out: std_logic_vector (larguraEnderecos-1 downto 0);
	signal saida_decoder_blocos: std_logic_vector (larguraDados-1 downto 0);
	signal saida_decoder_enderecos: std_logic_vector (larguraDados-1 downto 0);
	signal saida_led: std_logic_vector (9 downto 0);

begin

gravar:  if simulacao generate
CLK <= KEY(0);
else generate
detectorSub0: work.edgeDetector(bordaSubida)
        port map (clk => CLOCK_50, entrada => (not KEY(0)), saida => CLK);
end generate;

CPU: entity work.CPU 
		  port map (
		  CLOCK_50 => CLK,
		  FPGA_RESET => KEY(1),
        Instruction_IN => saida_ROM,
		  Data_IN => saida_RAM,
 		  Data_OUT => data_out,
		  Rd => hab_rd, 
		  Wr => hab_wr,
		  Data_Address => data_add_out, 
		  ROM_Adrress => rom_add_out
		  );

ROM: entity work.memoriaROM
		  port map (Endereco => rom_add_out, Dado => saida_ROM);

RAM: entity work.memoriaRAM
         port map (
			addr => data_add_out(5 downto 0), 
			clk => CLK, 
			dado_in => data_out, 
			habilita => saida_decoder_blocos(0), 
			re => hab_rd, 
			we => hab_wr, 
			dado_out => saida_RAM
			);

DEC_Blocos: entity work.decoder3x8
			port map (
			entrada => data_add_out(8 downto 6),
			saida => saida_decoder_blocos
			);

DEC_Enderecos: entity work.decoder3x8
			port map (
			entrada => data_add_out(2 downto 0),
			saida => saida_decoder_enderecos
			);
			
logica_LED: entity work.ledComponent
			port map(
		   CLK => CLK,
		   wr => hab_wr,
		   Data_OUT => data_out,
		   dec_bloco => saida_decoder_blocos(4),
			habilita_led => not data_add_out(5),
		   dec_ende => saida_decoder_enderecos(2 downto 0),
	 	   saida_led => saida_led
			);

comp_HEX0: entity work.hexComponent
			port map(
		   CLK => CLK,
		   wr => hab_wr,
		   Data_OUT => data_out(3 downto 0),
		   dec_bloco => saida_decoder_blocos(4),
			habilita_hex => data_add_out(5),
		   dec_ende => saida_decoder_enderecos(0),
	 	   saida_7seg => HEX0
			);
			
comp_HEX1: entity work.hexComponent
			port map(
		   CLK => CLK,
		   wr => hab_wr,
		   Data_OUT => data_out(3 downto 0),
		   dec_bloco => saida_decoder_blocos(4),
			habilita_hex => data_add_out(5),
		   dec_ende => saida_decoder_enderecos(1),
	 	   saida_7seg => HEX1
			);

comp_HEX2: entity work.hexComponent
			port map(
		   CLK => CLK,
		   wr => hab_wr,
		   Data_OUT => data_out(3 downto 0),
		   dec_bloco => saida_decoder_blocos(4),
			habilita_hex => data_add_out(5),
		   dec_ende => saida_decoder_enderecos(2),
	 	   saida_7seg => HEX2
			);
			
comp_HEX3: entity work.hexComponent
			port map(
		   CLK => CLK,
		   wr => hab_wr,
		   Data_OUT => data_out(3 downto 0),
		   dec_bloco => saida_decoder_blocos(4),
			habilita_hex => data_add_out(5),
		   dec_ende => saida_decoder_enderecos(3),
	 	   saida_7seg => HEX3
			);
			
			
comp_HEX4: entity work.hexComponent
			port map(
		   CLK => CLK,
		   wr => hab_wr,
		   Data_OUT => data_out(3 downto 0),
		   dec_bloco => saida_decoder_blocos(4),
			habilita_hex => data_add_out(5),
		   dec_ende => saida_decoder_enderecos(4),
	 	   saida_7seg => HEX4
			);
			
comp_HEX5: entity work.hexComponent
			port map(
		   CLK => CLK,
		   wr => hab_wr,
		   Data_OUT => data_out(3 downto 0),
		   dec_bloco => saida_decoder_blocos(4),
			habilita_hex => data_add_out(5),
		   dec_ende => saida_decoder_enderecos(5),
	 	   saida_7seg => HEX5
			);
			
comp_HEX6: entity work.hexComponent
			port map(
		   CLK => CLK,
		   wr => hab_wr,
		   Data_OUT => data_out(3 downto 0),
		   dec_bloco => saida_decoder_blocos(4),
			habilita_hex => data_add_out(5),
		   dec_ende => saida_decoder_enderecos(6),
	 	   saida_7seg => HEX6
			);
			
LEDR <= saida_led;

end architecture;