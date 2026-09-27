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
    file input : text open read_mode is INPUT_PATH;
    variable l : line;
  begin
    while not endfile(input) loop
      readline(input, l);
      -- l points to this line only: the next readline replaces it, so parse it here
    end loop;

    report "part 1: TODO";
    report "part 2: TODO";
    std.env.finish;
  end process;
end architecture;
