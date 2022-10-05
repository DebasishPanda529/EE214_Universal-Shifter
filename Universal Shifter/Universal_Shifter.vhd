library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity MUX is
 port (A: in std_logic_vector(1 downto 0); S: in std_logic_vector(0 downto 0); OUTPUT: out std_logic);
end entity MUX;

architecture Struct of MUX is
 signal S_BAR, S0, S1: std_logic;
begin
  AND1: AND_2 port map (A => A(0), B => S_BAR, Y => S0);
  AND2: AND_2 port map (A => A(1), B => S(0), Y => S1);
  INV1: INVERTER port map (A => S(0), Y => S_BAR);
  OR1: OR_2 port map (A => S0, B => S1, Y => OUTPUT);
end Struct;

-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity Universal_Shifter is
 port (A: in std_logic_vector(7 downto 0); B: in std_logic_vector(2 downto 0); L: in std_logic_vector(0 downto 0); Y: out std_logic_vector(7 downto 0));
end entity Universal_Shifter;

architecture Complex of Universal_Shifter is
 signal Q: std_logic_vector(7 downto 0); signal R: std_logic_vector(7 downto 0); signal T: std_logic_vector(7 downto 0); signal U: std_logic_vector(7 downto 0);
 
   component MUX is
	port (A: in std_logic_vector(1 downto 0); S: in std_logic_vector(0 downto 0); OUTPUT: out std_logic);
	end component MUX;

   for all: MUX
   use entity work.MUX(Struct);
	
begin 
 mux_1: for i in 0 to 7 generate
 MUX1: MUX port map (A(0) => A(i), A(1) => A(7-i), S(0) => L(0), OUTPUT => Q(i));
 end generate;
 
 n4_bit : for i in 0 to 7 generate
 lsb: if i < 4 generate
 MUX2: MUX port map(A(0) => Q(i), A(1) => Q(i+4), S(0) => B(2), OUTPUT => R(i));
 end generate lsb;
 msb: if i > 3 generate
 MUX2: MUX port map(A(0) => Q(i), A(1) => '0', S(0) => B(2), OUTPUT => R(i));
 end generate msb;
 end generate;
  
 n2_bit : for i in 0 to 7 generate
 lsb: if i < 6 generate
 MUX3: MUX port map(A(0) => R(i), A(1) => R(i+2), S(0) => B(1), OUTPUT => T(i));
 end generate lsb;
 msb: if i > 5 generate
 MUX3: MUX port map(A(0) => R(i), A(1) => '0', S(0) => B(1), OUTPUT => T(i));
 end generate msb;
 end generate;
 
 n1_bit : for i in 0 to 7 generate
 lsb: if i < 7 generate
 MUX4: MUX port map(A(0) => T(i), A(1) => T(i+1), S(0) => B(0), OUTPUT => U(i));
 end generate lsb;
 msb: if i > 6 generate
 MUX4: MUX port map(A(0) => T(i), A(1) => '0', S(0) => B(0), OUTPUT => U(i));
 end generate msb;
 end generate;
 
 mux_2: for i in 0 to 7 generate
 MUX5: MUX port map (A(0) => U(i), A(1) => U(7-i), S(0) => L(0), OUTPUT => Y(i));
 end generate; 
 
end Complex;
