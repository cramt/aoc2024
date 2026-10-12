library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Registered X + 10, wrapping at 32 bits. One cycle of latency; Y_VALID follows X_VALID.
entity add10 is
  port (
    CLK     : in  std_logic;
    RST     : in  std_logic;
    X       : in  unsigned(31 downto 0);
    X_VALID : in  std_logic;
    Y       : out unsigned(31 downto 0);
    Y_VALID : out std_logic
  );
end entity;

architecture rtl of add10 is
begin
  process (CLK)
  begin
    if rising_edge(CLK) then
      if RST = '1' then
        Y       <= (others => '0');
        Y_VALID <= '0';
      else
        Y       <= X + 10;
        Y_VALID <= X_VALID;
      end if;
    end if;
  end process;
end architecture;
