library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Clocked solution, driven by a JHDL testbench (`just test XX`, `just stream XX`).
--
-- After RST falls, the input arrives one byte per clock on DIN, qualified by
-- DIN_VALID. DIN_LAST is high alongside the final byte. Raise DONE once
-- PART1/PART2 hold the answers; the runner reads them on the first cycle DONE is high.
entity dayXX_stream is
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

architecture rtl of dayXX_stream is
begin
end architecture;
