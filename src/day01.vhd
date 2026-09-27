package day01_pkg is
type pair is record
  a : natural;
  b : natural;
end record;

type pair_array is array (natural range <>) of pair;
end package;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.day01_pkg.all;

-- The solution. N is the input's line count, known at elaboration.
entity day01 is
  generic (N : natural; INPUT : pair_array);
end entity;

architecture rtl of day01 is
begin
  process
  begin
  report to_string(INPUT(0).a);
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
use work.day01_pkg.all;

entity day01_tb is
  generic (INPUT_PATH : string := "input/XX.txt");
end entity;

architecture sim of day01_tb is
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

  impure function parse(path : string) return natural is
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
  subtype input_t is pair_array(0 to N-1);
  impure function parse(path : string) return input_t is
    file f     : text open read_mode is path;
    variable l : line;
    variable a : natural;
    variable b : natural;
    variable n : natural := 0;
    variable r : input_t;
  begin
  while not endfile(f) loop
    readline(f, l);
    read(l, a);
    read(l, b);
    r(n).a := a;
    r(n).b := b;
    n := n + 1;
  end loop;
    return r;
  end function;

  constant INPUT : input_t := parse(INPUT_PATH);
begin
  dut : entity work.day01 generic map (N => N, INPUT => INPUT);

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
