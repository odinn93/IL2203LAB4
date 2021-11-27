library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
--use std.env.finish;

entity gpio_tb is
end gpio_tb;

architecture sim of gpio_tb is

    constant clk_hz : integer := 100e6;
    constant clk_period : time := 1 sec / clk_hz;

    signal clk : std_logic := '1';
    signal rst : std_logic := '1';
    signal Din, Dout : std_logic_vector(7 downto 0);
    signal ie, oe : std_logic := '1';

begin

    clk <= not clk after clk_period / 2;

    DUT : entity work.gpio(behave)
    generic map(
        N => 8
    )
    port map (
        clk => clk,
        rst => rst,
        Din => Din,
        Dout => Dout,
        ie => ie,
        oe => oe
    );

    SEQUENCER_PROC : process
    begin
        wait until rising_edge(clk);
        rst <= '1';
        wait until rising_edge(clk);
        rst <= '0';

        Din <= "00011101";
        ie <= '1';
        oe <= '1';
        wait until rising_edge(clk);

        wait for 1 ns;
        assert Dout = Din
            report "IT NO WORK!!"
            severity failure;

        wait for 10 ns;
        --finish;
    end process;

end architecture;
