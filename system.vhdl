library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ENCRYP is
    port(
        MESSAGE     : in  std_logic_vector(7 downto 0);
        KEY         : in  std_logic_vector(7 downto 0);
        DIRECTION   : in  std_logic;
        RED_LED     : out std_logic;
        GREEN_LED   : out std_logic;
        OUT_MESSAGE : out std_logic_vector(7 downto 0)
    );
end entity ENCRYP;

architecture BEHAV of ENCRYP is
    signal COMP_MESSAGE  : std_logic_vector(7 downto 0);
    signal SHIFT_AMOUNT  : std_logic_vector(2 downto 0);
    signal ROT_MESSAGE   : std_logic_vector(7 downto 0);
    signal UNROT_MESSAGE : std_logic_vector(7 downto 0);
    signal ENC_MESSAGE   : std_logic_vector(7 downto 0);
    signal DEC_MESSAGE   : std_logic_vector(7 downto 0);

begin
    
    comparator : entity work.comparator
        port map(
            MESSAGE     => MESSAGE,
            OUT_MESSAGE => COMP_MESSAGE,
            RED_LED     => RED_LED,
            GREEN_LED   => GREEN_LED
        );

    SHIFT_AMOUNT <= KEY(2 downto 0);

    barrelshift1 : entity work.barrel_mux
        port map(
            SHIFT_AMOUNT => SHIFT_AMOUNT,
            MESSAGE      => COMP_MESSAGE,
            DIRECTION    => DIRECTION,
            OUT_MESSAGE  => ROT_MESSAGE
        );

    encrypt_xor : entity work.xor_enc
        port map(
            MESSAGE     => ROT_MESSAGE,
            KEY         => KEY,
            OUT_MESSAGE => ENC_MESSAGE
        );

    decrypt_xor : entity work.xor_enc
        port map(
            MESSAGE     => ENC_MESSAGE,
            KEY         => KEY,
            OUT_MESSAGE => DEC_MESSAGE
        );

    barrelshift2 : entity work.barrel_mux
        port map(
            SHIFT_AMOUNT => SHIFT_AMOUNT,
            MESSAGE      => DEC_MESSAGE,
            DIRECTION    => not DIRECTION,
            OUT_MESSAGE  => UNROT_MESSAGE
        );

    case_mod : entity work.case_modifier
        port map(
            MESSAGE     => UNROT_MESSAGE,
            OUT_MESSAGE => OUT_MESSAGE
        );

end architecture BEHAV;
