




library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.FloatPt.all;		--floating point package includes all the FP components


entity Neuron is

port(	clk		: 	in std_logic;	--50MHz master clock. Samples decimated to SAMPRATE.
		reset		: 	in std_logic;
		Iin		: 	in std_logic_vector(31 downto 0);			--Input Sample, V(i).
	
		Spike		: 	out std_logic_vector(31 downto 0)			--output Sample
	);
end entity Neuron;



architecture arch of Neuron is



	signal V_neuron_reg_in,V_neuron_reg_out:std_logic_vector(31 downto 0);
	constant one_by_capacitor:std_logic_vector(31 downto 0) :="01001100101111101011110000100000" ;     -----1E8
	constant one_by_Resistance:std_logic_vector(31 downto 0):="00110101100001100011011110111101";		-- 1E-6;



begin



	UMULT: FPP_MULT port map	--instantiate FP MULT
(		A			=> V_neuron_reg_out,
		B			=> numB,
		clk		=> clk,
		reset		=> reset,
		go			=> go_mul,
		done		=> done_mul,
		overflow	=> open,
		result	=> mul_result );





















end arch;