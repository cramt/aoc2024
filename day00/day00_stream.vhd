library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- day00 isn't a puzzle: it's a worked example of a clocked day, written by Claude
-- as a reference and a JHDL smoke test. The input is one decimal number per line.
-- Each number goes through add10; PART1 is the sum of the results, PART2 how many there were.
entity day00_stream is
  port (
    CLK       : in  std_logic;
    RST       : in  std_logic;
    DIN       : in  std_logic_vector(7 downto 0);
    DIN_VALID : in  std_logic;
    DIN_LAST  : in  std_logic;
    PART1     : out unsigned(63 downto 0);
    PART2     : out unsigned(63 downto 0);
    DONE      : out std_logic
  );
end entity;

architecture rtl of day00_stream is
  function is_digit(c : std_logic_vector(7 downto 0)) return boolean is
  begin
    return unsigned(c) >= character'pos('0') and unsigned(c) <= character'pos('9');
  end function;

  -- Parser state: the number being read, and whether it has any digits yet
  signal num    : unsigned(31 downto 0);
  signal in_num : std_logic;

  -- Parser -> add10 -> accumulator
  signal x          : unsigned(31 downto 0);
  signal x_valid    : std_logic;
  signal y          : unsigned(31 downto 0);
  signal y_valid    : std_logic;
  signal input_done : std_logic;

  signal sum   : unsigned(63 downto 0);
  signal count : unsigned(63 downto 0);
begin
  add : entity work.add10
    port map (CLK => CLK, RST => RST, X => x, X_VALID => x_valid, Y => y, Y_VALID => y_valid);

  parse : process (CLK)
    variable next_num : unsigned(31 downto 0);
  begin
    if rising_edge(CLK) then
      -- A one-cycle pulse per number, overridden below when one completes
      x_valid <= '0';

      if RST = '1' then
        num        <= (others => '0');
        in_num     <= '0';
        x          <= (others => '0');
        input_done <= '0';
      elsif DIN_VALID = '1' then
        if is_digit(DIN) then
          -- `*` on unsigned doubles the width, so resize back down
          next_num := resize(num * 10, num'length) + unsigned(DIN(3 downto 0));
          num      <= next_num;
          in_num   <= '1';
          -- A number at the very end of the input has no separator after it
          if DIN_LAST = '1' then
            x       <= next_num;
            x_valid <= '1';
          end if;
        else
          if in_num = '1' then
            x       <= num;
            x_valid <= '1';
          end if;
          num    <= (others => '0');
          in_num <= '0';
        end if;

        if DIN_LAST = '1' then
          input_done <= '1';
        end if;
      end if;
    end if;
  end process;

  accumulate : process (CLK)
  begin
    if rising_edge(CLK) then
      if RST = '1' then
        sum   <= (others => '0');
        count <= (others => '0');
        DONE  <= '0';
      else
        if y_valid = '1' then
          sum   <= sum + y;
          count <= count + 1;
        end if;
        -- With the input over and both pipeline stages empty, nothing else can reach sum
        if input_done = '1' and x_valid = '0' and y_valid = '0' then
          DONE <= '1';
        end if;
      end if;
    end if;
  end process;

  PART1 <= sum;
  PART2 <= count;
end architecture;
