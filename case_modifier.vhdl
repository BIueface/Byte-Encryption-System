library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity case_modifier is
  port(
    MESSAGE      : in  std_logic_vector(7 downto 0);
    OUT_MESSAGE      : out std_logic_vector(7 downto 0)
  );
end entity case_modifier;

architecture BEHAV of case_modifier is
begin
  process(MESSAGE)
  begin
    OUT_MESSAGE <= MESSAGE(7 downto 6) & not MESSAGE(5) & MESSAGE(4 downto 0);
  end process;
end architecture BEHAV;