
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.FloatPt.all;		--floating point package includes all the FP components
use work.work_Neromorphic_Components.all;

entity Neuron is

generic (clock_length:integer);
port(	clk	,start,ext_reset : 	in std_logic;	--50MHz master clock. Samples decimated to SAMPRATE.
		--reset		: 	in std_logic;
		Iin		: 	in std_logic_vector(31 downto 0);			--Input Sample, V(i).
	
		Spike		: 	out std_logic			--output Sample
	);
end entity Neuron;



architecture arch of Neuron is



	signal V_neuron_reg_in,V_neuron_reg_out,V_by_R,minus_V_by_R,I_minus_V_by_R,delta_V:std_logic_vector(31 downto 0):=(others=>'0');
	constant one_by_capacitor:std_logic_vector(31 downto 0) :="01001100101111101011110000100000" ;     -----1E8
	constant one_by_Resistance:std_logic_vector(31 downto 0):="00110101100001100011011110111101";		-- 1E-6;
	constant delta_T:std_logic_vector(31 downto 0):="00110101000001100011011110111101";		-- 500E-9;

	constant mul_constant:std_logic_vector(31 downto 0):="01000010010010000000000000000000";		-- 50;

	signal go_sub,go_add,go_mul_1,go_mul_3,go_mul_2,done_mul_1,done_mul_2,done_mul_3,done_sub,done_add,V_update_enable,reset:std_logic:='0';

	signal voltage : signed(15 downto 0);


begin


-------------------- -----------datapath -----------------------------------------------

	UMULT_1: FPP_MULT port map	--instantiate FP MULT
(		A			=> V_neuron_reg_out,
		B			=> one_by_Resistance,
		clk		    => clk,
		reset		=> reset,
		go			=> go_mul_1,
		done		=> done_mul_1,
		overflow	=> open,
		result	    => V_by_R );

minus_V_by_R(31)<= not V_by_R(31);
minus_V_by_R(30 downto 0) <= V_by_R(30 downto 0);

	UADD_SUB: FPP_ADD_SUB port map	--instantiate AFP DD_SUB
(		A			=> Iin,
		B			=> minus_V_by_R,
		clk		=> clk,
		reset		=> reset,
		go			=> go_sub,
		done		=> done_sub,
		result	=> I_minus_V_by_R);


--	UMULT_2: FPP_MULT port map	--instantiate FP MULT
--(		A			=> delta_T,
--		B			=> one_by_capacitor,
--		clk		=> clk,
--		reset		=> reset,
--		go			=> go_mul_2,
--		done		=> done_mul_2,
--		overflow	=> open,
--		result	=> mul_constant );

 	UMULT_3: FPP_MULT port map	--instantiate FP MULT
(		A			=> I_minus_V_by_R,
		B			=> mul_constant,
		clk		    => clk,
		reset		=> reset,
		go			=> go_mul_3,
		done		=> done_mul_3,
		overflow	=> open,
		result	=> delta_V );

	UADD_ADD: FPP_ADD_SUB port map	--instantiate AFP DD_SUB
(		A			=> delta_V,
		B			=> V_neuron_reg_out,
		clk		=> clk,
		reset		=> reset,
		go			=> go_add,
		done		=> done_add,
		result	=> V_neuron_reg_in);


V_reg:DataRegister	generic map (data_width=>32)
					port map (Din=>V_neuron_reg_in,
	      					Dout=>V_neuron_reg_out,
	      					clk=>clk, 
	      					enable=>V_update_enable,
	      					reset=>ext_reset);




------------------------------------ ControlPath ------------------------------------



process (clk,done_mul_1,done_mul_3,done_sub,done_add,start)





begin


	voltage<=FP_TO_Signed(one_by_capacitor,16);

	if rising_edge(clk) then

		if start='1' or reset='1' then
			go_mul_1<='1';
			V_update_enable<='0';
			reset<='0';

		end if;

		
		if done_mul_1='1' then

			go_sub<='1';
			V_update_enable<='0';

		end if;

		if done_sub='1'  then

			go_mul_3<='1';
			V_update_enable<='0';

		end if;

		if done_mul_3='1'  then

			go_add<='1';
			V_update_enable<='0';

		end if;

		if done_add='1'  then

			go_mul_1<='0';
		    go_mul_3<='0';
			go_sub<='0';
			go_add<='0';
			reset<='1';
			V_update_enable<='1';

		end if;
		--if done_mul_1='1' and done_mul_3='0' and done_sub<='1' and done_add='0' then

		--	go_mul_3<='1';

		--end if;

		--if done_mul_1='1' and done_mul_3='1' and done_sub<='1' and done_add='0' then

		--	go_add<='1';

		--end if;

		--if done_mul_1='1' and done_mul_3='1' and done_sub<='1' and done_add='1' then

		--	--if to_integer(FP_TO_Signed(V_neuron_reg_in,16))>1 then
		--	--	spike<='1';

		--	--else
		--	--	spike<='0';

		--	--end if;



		--end if;




	end if;

end process;

end arch;