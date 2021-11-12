
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity one_chip_computer is
  port(
      led_output : out std_logic_vector(15 downto 0)
  );
end entity;

architecture top of one_chip_computer is
  constant N: integer := 16;
  constant M: integer := 3;

  signal clk, rst, RW_tmp : std_logic;
  signal Din_tmp, Dout_tmp, address_tmp: std_logic_vector(N-1 downto 0);
  signal ie_activator, oe_activator: std_logic;
begin
  cpu_inst: entity work.fsm(behave)
    port map (
      clk     => clk,
      rst   => rst,
      Din     => Din_tmp,
      address => address_tmp,
      Dout    => Dout_tmp,
      RW      => RW_tmp
    );

  gpio_inst: entity work.gpio(behave)
    generic map (
      N => N
    )
    port map (
      clk   => clk,
      rst => rst,
      ie    => ie_activator,
      oe    => oe_activator,
      Din   => Dout_tmp,
      Dout  => led_output
    );

  memory_inst: entity work.memory(SYN)
    port map (
      address => address_tmp(7 downto 0),
      clock   => clk,
      data    => Dout_tmp,
      wren    => RW_tmp,
      q       => Din_tmp
    );
    
  ie_activator <= '1' when (address_tmp = "1111000000000000" and (RW_tmp = '0')) else '0';
  oe_activator <= '0';
end architecture;