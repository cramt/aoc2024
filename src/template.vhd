library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- The solution. N is the input's line count, known at elaboration.
entity dayXX is
  generic (N : natural);
end entity;

architecture rtl of dayXX is
begin
  process
  begin
    report "N = " & to_string(N);
    report "part 1: TODO";
    report "part 2: TODO";
    std.env.finish;
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity dayXX_tb is
  generic (INPUT_PATH : string := "input/XX.txt");
end entity;

architecture sim of dayXX_tb is
  -- impure: a pure function may not declare a file
  impure function count_lines(path : string) return natural is
    file f     : text open read_mode is path;
    variable l : line;
    variable n : natural := 0;
  begin
    while not endfile(f) loop
      readline(f, l);
      n := n + 1;
    end loop;
    return n;
  end function;

  constant N : natural := count_lines(INPUT_PATH);
begin
  dut : entity work.dayXX generic map (N => N);

  process
    file input : text open read_mode is INPUT_PATH;
    variable l : line;
  begin
    while not endfile(input) loop
      readline(input, l);
      -- l points to this line only: the next readline replaces it, so parse it here
    end loop;
    wait;
  end process;
end architecture;
