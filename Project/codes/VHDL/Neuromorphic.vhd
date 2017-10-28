library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;

package work_Neromorphic_Components is



component DataRegister is
	generic (data_width:integer);
	port (Din: in std_logic_vector(data_width-1 downto 0);
	      Dout: out std_logic_vector(data_width-1 downto 0);
	      clk, enable,reset: in std_logic);
end component DataRegister;







end;