library ieee;
use ieee.std_logic_1164.all;

library std;
use std.standard.all;

library work;
use work.Neromorphic_Components.all;

entity DataRegister is
	generic (data_width:integer);
	port (Din: in std_logic_vector(data_width-1 downto 0);
	      Dout: out std_logic_vector(data_width-1 downto 0);
	      clk, enable: in std_logic);
end entity;


architecture Store of DataRegister is
begin

    process(clk)

    begin
       if(clk'event and (clk  = '1')) then
           if(enable = '1') then
               Dout <= Din;
           end if;
       end if;
       
    end process;

end Store;