
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY altera_mf;
USE altera_mf.all;

USE work.microcode.all;

ENTITY fake_memory IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q			: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
END fake_memory;


ARCHITECTURE fake OF fake_memory IS

	signal RAM:program(0 to 255):=(
		(iLDI & R5 & B"1_0000_0000"), --0
		(iADD & R5 & R5 & R5 & NU),   --1
		(iADD & R5 & R5 & R5 & NU),   --2
		(iADD & R5 & R5 & R5 & NU),   --3
		(iADD & R5 & R5 & R5 & NU),   --4
		(iLDI & R6 & B"0_0010_0000"), --5, H'20
		(iLDI & R3 & B"0_0000_0011"), --6, D'3
		(iST  & R6 & R3 & NU & NU),	  --7
		(iLDI & R1 & B"0_0000_0001"), --8
		(iLDI & R0 & B"0_0000_1110"), --9
		(iMOV & R2 & R0 & NU & NU),	  --A
 		(iADD & R2 & R2 & R1 & NU),	  --B
		(iSUB & R0 & R0 & R1 & NU),	  --C
		(iBRZ & X"003"),			  --D (X"003" because we need 12 bits)
		(iNOP & NU & NU & NU & NU),	  --E
		(iBRA & X"FFC"),			  --F (X"FFC" because we need 12 bits)
		(iST & R6 & R2 & NU & NU),    --10
		(iST & R5 & R2 & NU & NU),	  --11
		(iBRA & X"000"),			  --12 (12 bits again)
		(iNOP & NU & NU & NU & NU),   --13
		(iNOP & NU & NU & NU & NU),   --14

		others=>(iNOP & R0 & R0 & R0 & NU));

	signal wren_out : std_logic;

BEGIN
	process(clock)
	begin
 		if (rising_edge(clock)  and wren_out = '1') then
 			RAM(to_integer(unsigned(address))) <= data;
 		end if;
 		if (rising_edge(clock)) then
 			wren_out <= wren;
 			q <= RAM(to_integer(unsigned(address)));
 		end if;
 	end process;
END fake;
