LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_textio.all;
LIBRARY STD;
use std.textio.all;

ENTITY fadd_tb IS
	END fadd_tb;

ARCHITECTURE FADD_TESTBENCH OF fadd_tb IS 
	-- Component Declaration for the Unit Under Test (UUT)

	COMPONENT FADD
		PORT(
			    A: in std_logic_vector(31 downto 0);
			    B: in std_logic_vector(31 downto 0);
			    clk  : in  std_logic;
			    R: out std_logic_vector(31 downto 0) 
		    );
	END COMPONENT;

	--Inputs
	signal iA  : std_logic_vector(31 downto 0) := (others => '0');
	signal iB  : std_logic_vector(31 downto 0) := (others => '0');


	--Outputs
	signal r : std_logic_vector(31 downto 0) := (others => '0');

	--Signals
	signal state: integer range 0 to 3 :=0;
	signal simclk: std_logic;

	file A_LIST: text open read_mode is "alist.txt";
	file B_LIST: text open read_mode is "blist.txt";
	file RESULT: text open write_mode is "results.txt";


BEGIN
	uut: FADD PORT MAP (
				   A => iA,
				   B => iB,
				   clk=>simclk,
				   R => r
			   );

	process(simclk)
		variable li_A: line;
		variable li_B: line;
		variable li_R: line;
		variable vA: std_logic_vector(31 downto 0);
		variable vB: std_logic_vector(31 downto 0);
	begin
		if rising_edge(simclk) then
			case (state) is
				when 0 =>
					readline(A_LIST,li_A);
					read(li_A,vA);
					iA<=vA;
					readline(B_LIST,li_B);
					read(li_B,vB);
					iB<=vB;
					state<=1;
				when 1|2 =>
					state<=state+1;
				when 3 => 
					write(li_R,r);
					writeline(RESULT,li_R);
					readline(A_LIST,li_A);
					read(li_A,vA);
					iA<=vA;
					readline(B_LIST,li_B);
					read(li_B,vB);
					iB<=vB;
					state<=1;

			end case;
		end if;
	end process;

	clockgen: process
	begin
		simclk<='0';
		wait for 50 ns;
		simclk<='1';
		wait for 50 ns;
	end process;
END;
