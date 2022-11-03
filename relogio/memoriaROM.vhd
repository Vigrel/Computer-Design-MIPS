	library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity memoriaROM is
   generic (
          dataWidth: natural := 13;
          addrWidth: natural := 9
    );
   port (
          Endereco : in std_logic_vector (addrWidth-1 DOWNTO 0);
          Dado : out std_logic_vector (dataWidth-1 DOWNTO 0)
    );
end entity;

architecture assincrona of memoriaROM is

	constant NOP  : std_logic_vector(14 downto 0) := "000000000000000";
	constant LDA  : std_logic_vector(3 downto 0) := "0001";
	constant SOMA : std_logic_vector(3 downto 0) := "0010";
	constant LDI  : std_logic_vector(3 downto 0) := "0100";
	constant SUB  : std_logic_vector(3 downto 0) := "0011";
	constant STA  : std_logic_vector(3 downto 0) := "0101";
	constant JMP  : std_logic_vector(3 downto 0) := "0110";
	constant JEQ  : std_logic_vector(3 downto 0) := "0111";
	constant CEQ  : std_logic_vector(3 downto 0) := "1000";
   constant JSR  : std_logic_vector(3 downto 0) := "1001";
   constant RET  : std_logic_vector(3 downto 0) := "1010";
	
  
  type blocoMemoria is array(0 TO 2**addrWidth - 1) of std_logic_vector(dataWidth-1 DOWNTO 0);

  function initMemory
        return blocoMemoria is variable tmp : blocoMemoria := (others => (others => '0'));
  begin
  
  
tmp(0) := x"4" & "01" & std_logic_vector(to_unsigned(1, addrWidth));	-- LDI %R1 $1         		#Setup 
tmp(1) := x"5" & "01" & std_logic_vector(to_unsigned(1, addrWidth));	-- STA %R1 @1          	#Posicao fixa de memoria fixa = 30
tmp(2) := x"4" & "01" & std_logic_vector(to_unsigned(10, addrWidth));	-- LDI %R1 $10     
tmp(3) := x"5" & "01" & std_logic_vector(to_unsigned(30, addrWidth));	-- STA %R1 @30         	#Posicao de memória fixa = 10
tmp(4) := x"4" & "00" & std_logic_vector(to_unsigned(0, addrWidth));	-- LDI %R0 $0       
tmp(5) := x"5" & "00" & std_logic_vector(to_unsigned(0, addrWidth));	-- STA %R0 @0
tmp(6) := x"5" & "00" & std_logic_vector(to_unsigned(10, addrWidth));	-- STA %R0 @10
tmp(7) := x"5" & "00" & std_logic_vector(to_unsigned(11, addrWidth));	-- STA %R0 @11
tmp(8) := x"5" & "00" & std_logic_vector(to_unsigned(12, addrWidth));	-- STA %R0 @12
tmp(9) := x"5" & "00" & std_logic_vector(to_unsigned(13, addrWidth));	-- STA %R0 @13
tmp(10) := x"5" & "00" & std_logic_vector(to_unsigned(14, addrWidth));	-- STA %R0 @14
tmp(11) := x"5" & "00" & std_logic_vector(to_unsigned(15, addrWidth));	-- STA %R0 @15
tmp(12) := x"5" & "00" & std_logic_vector(to_unsigned(288, addrWidth));	-- STA %R0 @288
tmp(13) := x"5" & "00" & std_logic_vector(to_unsigned(289, addrWidth));	-- STA %R0 @289
tmp(14) := x"5" & "00" & std_logic_vector(to_unsigned(290, addrWidth));	-- STA %R0 @290
tmp(15) := x"5" & "00" & std_logic_vector(to_unsigned(291, addrWidth));	-- STA %R0 @291
tmp(16) := x"5" & "00" & std_logic_vector(to_unsigned(292, addrWidth));	-- STA %R0 @292
tmp(17) := x"5" & "00" & std_logic_vector(to_unsigned(293, addrWidth));	-- STA %R0 @293
tmp(18) := x"5" & "00" & std_logic_vector(to_unsigned(510, addrWidth));	-- STA %R0 @510
tmp(19) := x"5" & "00" & std_logic_vector(to_unsigned(511, addrWidth));	-- STA %R0 @511
tmp(20) := x"5" & "00" & std_logic_vector(to_unsigned(257, addrWidth));	-- STA %R0 @257
tmp(21) := x"5" & "00" & std_logic_vector(to_unsigned(506, addrWidth));	-- STA %R0 @506        	#Se foi apertado, incrementa
tmp(22) := x"5" & "00" & std_logic_vector(to_unsigned(505, addrWidth));	-- STA %R0 @505
tmp(23) := x"4" & "11" & std_logic_vector(to_unsigned(10, addrWidth));	-- LDI %R3 $10        		#Registrador fixo de 10 no setup
tmp(24) := x"4" & "10" & std_logic_vector(to_unsigned(0, addrWidth));	-- LDI %R2 $0        		#Registrador das unidades
tmp(25) := x"1" & "01" & std_logic_vector(to_unsigned(356, addrWidth));	-- LDA %R1 @356        	#Checa botao de reset
tmp(26) := x"8" & "01" & std_logic_vector(to_unsigned(0, addrWidth));	-- CEQ %R1 @0
tmp(27) := x"7" & "00" & std_logic_vector(to_unsigned(0, addrWidth));	-- JEQ @0              	#Se botao for pressionado vai para o inicio do programa
tmp(28) := x"1" & "00" & std_logic_vector(to_unsigned(321, addrWidth));	-- LDA %R0 @321         
tmp(29) := x"8" & "00" & std_logic_vector(to_unsigned(1, addrWidth));	-- CEQ %R0 @1
tmp(30) := x"7" & "00" & std_logic_vector(to_unsigned(36, addrWidth));	-- JEQ @BASE_ACELERADA
tmp(31) := x"1" & "01" & std_logic_vector(to_unsigned(357, addrWidth));	-- LDA %R1 @357    		#Checa pro botao de incremento
tmp(32) := x"8" & "01" & std_logic_vector(to_unsigned(0, addrWidth));	-- CEQ %R1 @0
tmp(33) := x"7" & "00" & std_logic_vector(to_unsigned(45, addrWidth));	-- JEQ @CONTINUA         	#Se nao foi apertado vai para continua
tmp(34) := x"6" & "00" & std_logic_vector(to_unsigned(40, addrWidth));	-- JMP @INCREMENTA
tmp(35) := x"1" & "01" & std_logic_vector(to_unsigned(358, addrWidth));	-- LDA %R1 @358    		#Checa pro botao de incremento
tmp(36) := x"8" & "01" & std_logic_vector(to_unsigned(0, addrWidth));	-- CEQ %R1 @0
tmp(37) := x"7" & "00" & std_logic_vector(to_unsigned(45, addrWidth));	-- JEQ @CONTINUA
tmp(38) := x"6" & "00" & std_logic_vector(to_unsigned(40, addrWidth));	-- JMP @INCREMENTA
tmp(39) := x"4" & "00" & std_logic_vector(to_unsigned(1, addrWidth));	-- LDI %R0 $1          	#Se foi apertado, incrementa
tmp(40) := x"5" & "00" & std_logic_vector(to_unsigned(506, addrWidth));	-- STA %R0 @506        
tmp(41) := x"5" & "00" & std_logic_vector(to_unsigned(505, addrWidth));	-- STA %R0 @505
tmp(42) := x"E" & "10" & std_logic_vector(to_unsigned(1, addrWidth));	-- ADDI %R2 $1
tmp(43) := x"5" & "10" & std_logic_vector(to_unsigned(10, addrWidth));	-- STA %R2 @10
tmp(44) := x"C" & "10" & std_logic_vector(to_unsigned(30, addrWidth));	-- CLT %R2 @30
tmp(45) := x"D" & "00" & std_logic_vector(to_unsigned(48, addrWidth));	-- JLT @SALVA_HEX  		#Se for menor que 10 salva no hex, caso contrario chama subrotina de overflow
tmp(46) := x"9" & "00" & std_logic_vector(to_unsigned(50, addrWidth));	-- JSR @OVERFLOW
tmp(47) := x"5" & "10" & std_logic_vector(to_unsigned(288, addrWidth));	-- STA %R2 @288
tmp(48) := x"6" & "00" & std_logic_vector(to_unsigned(25, addrWidth));	-- JMP @LOOP
tmp(49) := x"4" & "10" & std_logic_vector(to_unsigned(0, addrWidth));	-- LDI %R2 $0
tmp(50) := x"5" & "10" & std_logic_vector(to_unsigned(10, addrWidth));	-- STA %R2 @10
tmp(51) := x"5" & "10" & std_logic_vector(to_unsigned(288, addrWidth));	-- STA %R2 @288
tmp(52) := x"1" & "00" & std_logic_vector(to_unsigned(11, addrWidth));	-- LDA %R0 @11 		#Incrementa HEX1 e checa se é menor que 10, se for menor sai da subrotina
tmp(53) := x"E" & "00" & std_logic_vector(to_unsigned(1, addrWidth));	-- ADDI %R0 $1
tmp(54) := x"5" & "00" & std_logic_vector(to_unsigned(11, addrWidth));	-- STA %R0 @11
tmp(55) := x"8" & "11" & std_logic_vector(to_unsigned(11, addrWidth));	-- CEQ %R3 @11
tmp(56) := x"7" & "00" & std_logic_vector(to_unsigned(60, addrWidth));	-- JEQ @HEX2
tmp(57) := x"5" & "00" & std_logic_vector(to_unsigned(289, addrWidth));	-- STA %R0 @289
tmp(58) := x"6" & "00" & std_logic_vector(to_unsigned(108, addrWidth));	-- JMP @RETURN
tmp(59) := x"4" & "00" & std_logic_vector(to_unsigned(0, addrWidth));	-- LDI %R0 $0
tmp(60) := x"5" & "00" & std_logic_vector(to_unsigned(289, addrWidth));	-- STA %R0 @289
tmp(61) := x"5" & "00" & std_logic_vector(to_unsigned(11, addrWidth));	-- STA %R0 @11
tmp(62) := x"1" & "00" & std_logic_vector(to_unsigned(12, addrWidth));	-- LDA %R0 @12
tmp(63) := x"E" & "00" & std_logic_vector(to_unsigned(1, addrWidth));	-- ADDI %R0 $1
tmp(64) := x"5" & "00" & std_logic_vector(to_unsigned(12, addrWidth));	-- STA %R0 @12
tmp(65) := x"8" & "11" & std_logic_vector(to_unsigned(12, addrWidth));	-- CEQ %R3 @12
tmp(66) := x"7" & "00" & std_logic_vector(to_unsigned(70, addrWidth));	-- JEQ @HEX3
tmp(67) := x"5" & "00" & std_logic_vector(to_unsigned(290, addrWidth));	-- STA %R0 @290
tmp(68) := x"6" & "00" & std_logic_vector(to_unsigned(108, addrWidth));	-- JMP @RETURN
tmp(69) := x"4" & "00" & std_logic_vector(to_unsigned(0, addrWidth));	-- LDI %R0 $0
tmp(70) := x"5" & "00" & std_logic_vector(to_unsigned(290, addrWidth));	-- STA %R0 @290
tmp(71) := x"5" & "00" & std_logic_vector(to_unsigned(12, addrWidth));	-- STA %R0 @12
tmp(72) := x"1" & "00" & std_logic_vector(to_unsigned(13, addrWidth));	-- LDA %R0 @13
tmp(73) := x"E" & "00" & std_logic_vector(to_unsigned(1, addrWidth));	-- ADDI %R0 $1
tmp(74) := x"5" & "00" & std_logic_vector(to_unsigned(13, addrWidth));	-- STA %R0 @13
tmp(75) := x"8" & "11" & std_logic_vector(to_unsigned(13, addrWidth));	-- CEQ %R3 @13
tmp(76) := x"7" & "00" & std_logic_vector(to_unsigned(80, addrWidth));	-- JEQ @HEX4
tmp(77) := x"5" & "00" & std_logic_vector(to_unsigned(291, addrWidth));	-- STA %R0 @291
tmp(78) := x"6" & "00" & std_logic_vector(to_unsigned(108, addrWidth));	-- JMP @RETURN
tmp(79) := x"4" & "00" & std_logic_vector(to_unsigned(0, addrWidth));	-- LDI %R0 $0
tmp(80) := x"5" & "00" & std_logic_vector(to_unsigned(291, addrWidth));	-- STA %R0 @291
tmp(81) := x"5" & "00" & std_logic_vector(to_unsigned(13, addrWidth));	-- STA %R0 @13
tmp(82) := x"1" & "00" & std_logic_vector(to_unsigned(14, addrWidth));	-- LDA %R0 @14
tmp(83) := x"E" & "00" & std_logic_vector(to_unsigned(1, addrWidth));	-- ADDI %R0 $1
tmp(84) := x"5" & "00" & std_logic_vector(to_unsigned(14, addrWidth));	-- STA %R0 @14
tmp(85) := x"8" & "11" & std_logic_vector(to_unsigned(14, addrWidth));	-- CEQ %R3 @14
tmp(86) := x"7" & "00" & std_logic_vector(to_unsigned(90, addrWidth));	-- JEQ @HEX5
tmp(87) := x"5" & "00" & std_logic_vector(to_unsigned(295, addrWidth));	-- STA %R0 @295
tmp(88) := x"6" & "00" & std_logic_vector(to_unsigned(108, addrWidth));	-- JMP @RETURN
tmp(89) := x"4" & "00" & std_logic_vector(to_unsigned(0, addrWidth));	-- LDI %R0 $0
tmp(90) := x"5" & "00" & std_logic_vector(to_unsigned(292, addrWidth));	-- STA %R0 @292
tmp(91) := x"5" & "00" & std_logic_vector(to_unsigned(14, addrWidth));	-- STA %R0 @14
tmp(92) := x"1" & "00" & std_logic_vector(to_unsigned(15, addrWidth));	-- LDA %R0 @15
tmp(93) := x"E" & "00" & std_logic_vector(to_unsigned(1, addrWidth));	-- ADDI %R0 $1
tmp(94) := x"5" & "00" & std_logic_vector(to_unsigned(15, addrWidth));	-- STA %R0 @15
tmp(95) := x"8" & "11" & std_logic_vector(to_unsigned(15, addrWidth));	-- CEQ %R3 @15 		# Adicionar JEQ para overflow de 999999
tmp(96) := x"7" & "00" & std_logic_vector(to_unsigned(99, addrWidth));	-- JEQ @ATINGIU_LIMITE   	#Se ao incrementar HEX5 == 10, vai para LABEL de overflow geral
tmp(97) := x"6" & "00" & std_logic_vector(to_unsigned(108, addrWidth));	-- JMP @RETURN
tmp(98) := x"4" & "00" & std_logic_vector(to_unsigned(0, addrWidth));	-- LDI %R0 $0
tmp(99) := x"5" & "00" & std_logic_vector(to_unsigned(293, addrWidth));	-- STA %R0 @293
tmp(100) := x"5" & "00" & std_logic_vector(to_unsigned(15, addrWidth));	-- STA %R0 @15
tmp(101) := x"4" & "00" & std_logic_vector(to_unsigned(1, addrWidth));	-- LDI %R0 $1
tmp(102) := x"5" & "00" & std_logic_vector(to_unsigned(257, addrWidth));	-- STA %R0 @257
tmp(103) := x"1" & "01" & std_logic_vector(to_unsigned(356, addrWidth));	-- LDA %R1 @356    
tmp(104) := x"8" & "01" & std_logic_vector(to_unsigned(0, addrWidth));	-- CEQ %R1 @0
tmp(105) := x"7" & "00" & std_logic_vector(to_unsigned(0, addrWidth));	-- JEQ @0
tmp(106) := x"6" & "00" & std_logic_vector(to_unsigned(104, addrWidth));	-- JMP @ESPERA_RESET
tmp(107) := x"A" & "00" & std_logic_vector(to_unsigned(0, addrWidth));	-- RET 








        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;