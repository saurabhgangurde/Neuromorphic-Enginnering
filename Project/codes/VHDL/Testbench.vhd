library std;
use std.textio.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Testbench is

end entity;


architecture Behave of Testbench is


component Neuron is

generic (clock_length:integer);
port( clk ,start,ext_reset  :   in std_logic; --50MHz master clock. Samples decimated to SAMPRATE.
    --reset   :   in std_logic;
    Iin   :   in std_logic_vector(31 downto 0);     --Input Sample, V(i).
  
    Spike   :   out std_logic     --output Sample
  );
end component Neuron;



  constant Iin:std_logic_vector(31 downto 0) :="00101011100011001011110011001100";  ----1e-12;
  
  signal clk,start,spike: std_logic := '0';
  
 


  signal reset:std_logic:='1';
  function to_std_logic (x: bit) return std_logic is
  begin
  if(x = '1') then return ('1');
  else return('0'); end if;
  end to_std_logic;


  function to_std_logic_vector(x: bit_vector) return std_logic_vector is
    alias lx: bit_vector(1 to x'length) is x;
    variable ret_var : std_logic_vector(1 to x'length);
  begin
     for I in 1 to x'length loop
        if(lx(I) = '1') then
           ret_var(I) :=  '1';
        else 
           ret_var(I) :=  '0';
  end if;
     end loop;
     return(ret_var);
  end to_std_logic_vector;

  function to_string(x: string) return string is
      variable ret_val: string(1 to x'length);
      alias lx : string (1 to x'length) is x;
  begin
      ret_val := lx;
      return(ret_val);
  end to_string;

  function to_bit_vector(x: std_logic_vector) return bit_vector is
    alias lx: std_logic_vector(1 to x'length) is x;
    variable ret_var : bit_vector(1 to x'length);
  begin
     for I in 1 to x'length loop
        if(lx(I) = '1') then
           ret_var(I) :=  '1';
        else 
           ret_var(I) :=  '0';
  end if;
     end loop;
     return(ret_var);
  end to_bit_vector;


begin

  start<='1' after 15 ns;
  reset<='0' after 5 ns;
  clk <= not clk after 10 ns;


  


dut:Neuron generic map (clock_length=>0)
            port map ( clk=>clk,
             Iin=>Iin,
             start=>start,
             Spike=>Spike,
             ext_reset=>reset );


        

end Behave;

