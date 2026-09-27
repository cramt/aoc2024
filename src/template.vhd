library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity dayXX_tb is
  generic (INPUT_PATH : string := "input/XX.txt");
end entity;

architecture sim of dayXX_tb is
begin
  process
    file input   : text open read_mode is INPUT_PATH;
    variable l   : line;
    variable n   : natural := 0;
  begin
    while not endfile(input) loop
      readline(input, l);
      n := n + 1;
    end loop;

    report "lines read: " & to_string(n);
    report "part 1: TODO";
    report "part 2: TODO";
    std.env.finish;
  end process;
end architecture;
