library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TRAFFIC is
    port (
        reset, clk : in std_logic;
        A, B, C, D : out std_logic_vector(0 to 3)
    );
end TRAFFIC;

architecture Behavioral of TRAFFIC is
    signal green_signal : std_logic := '1';  -- สีเขียวเป็นสถานะเริ่มต้น
    signal yellow_signal : std_logic := '0';
    signal red_signal : std_logic := '0';
    signal straight_signal : std_logic := '1';  -- ทางตรงสามารถเคลื่อนที่ได้เริ่มต้น
    signal right_signal : std_logic := '0';  -- ทางเลี้ยวขวาไม่สามารถเคลื่อนที่ได้เริ่มต้น
    signal seconds : integer := 0;
    signal minutes : integer := 0;
    signal hours : integer := 0;
    constant green_duration : time := 20 sec;
    constant yellow_duration : time := 2 sec;
    constant red_duration : time := 2 sec;

begin
    process (clk, reset)
    begin
        if reset = '1' then
            -- รีเซ็ตค่าตัวแปรเริ่มต้น
            green_signal <= '1';
            yellow_signal <= '0';
            red_signal <= '0';
            straight_signal <= '1';
            right_signal <= '0';
            seconds <= 0;
            minutes <= 0;
            hours <= 0;
        elsif rising_edge(clk) then
            -- นับเวลา
            seconds <= seconds + 1;
            if seconds = 60 then
                seconds <= 0;
                minutes <= minutes + 1;
                if minutes = 60 then
                    minutes <= 0;
                    hours <= hours + 1;
                end if;
            end if;

            -- กำหนดสีไฟจราจรตามขั้นตอน
            if green_signal = '1' then
                A <= "1100";
                B <= "0010";
                C <= "0010";
                D <= "1100";
            elsif yellow_signal = '1' then
                A <= "0010";
                B <= "0010";
                C <= "0010";
                D <= "0010";
            elsif red_signal = '1' then
                A <= "0010";
                B <= "1100";
                C <= "1100";
                D <= "0010";
            end if;
        end if;
    end process;

    process
    begin
        wait for green_duration;
        green_signal <= '0';
        yellow_signal <= '1';
        wait for yellow_duration;
        yellow_signal <= '0';
        red_signal <= '1';
        wait for red_duration;
        red_signal <= '0';
        wait for 2 sec;
        green_signal <= '1';
    end process;
end Behavioral;
