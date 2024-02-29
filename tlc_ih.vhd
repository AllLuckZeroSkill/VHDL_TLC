library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity trafficLight_module is
    port (
        sensor       : in  STD_LOGIC;
        clk          : in  STD_LOGIC;
        rst          : in  STD_LOGIC;
        highwayLight : out STD_LOGIC_VECTOR(2 downto 0);
        roadLight    : out STD_LOGIC_VECTOR(2 downto 0)
        -- RED_YELLOW_GREEN 1010
    );
end trafficLight_module;

architecture traffic_light of trafficLight_module is
    signal counter: std_logic_vector(27 downto 0) := x"0000000";
    signal delayCount: std_logic_vector(3 downto 0) := x"0";
    signal delay_10s, delay_3s_F, delay_3s_H, RED_LIGHT_ENABLE, YELLOW_LIGHT1_ENABLE, YELLOW_LIGHT2_ENABLE: std_logic := '0';
    signal enableClk: std_logic; -- 1s clock enable
    type FSM_States is (HGRE_FRED, HYEL_FRED, HRED_FGRE, HRED_FYEL);

    signal current_state, next_state: FSM_States;
begin
    process(clk, rst)
    begin
        if rst = '0' then
            current_state <= HGRE_FRED;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    process(current_state, sensor, delay_3s_F, delay_3s_H, delay_10s)
    begin
        case current_state is
            when HGRE_FRED =>
                -- When Green light on Highway and Red light on road
                RED_LIGHT_ENABLE <= '0';
                YELLOW_LIGHT1_ENABLE <= '0'; -- disable YELLOW light Highway delay counting
                YELLOW_LIGHT2_ENABLE <= '0'; -- disable YELLOW light road delay counting
                highwayLight <= "001"; -- Green light on Highway
                roadLight <= "100"; -- Red light on road
                if sensor = '1' then -- if vehicle is detected on road by sensors
                    next_state <= HYEL_FRED;
                else
                    next_state <= HGRE_FRED;
                    -- Otherwise, remains GREEN ON highway and RED on road
                end if;
            when HYEL_FRED =>
                -- When Yellow light on Highway and Red light on road
                highwayLight <= "010"; -- Yellow light on Highway
                roadLight <= "100"; -- Red light on road
                RED_LIGHT_ENABLE <= '0'; -- disable RED light delay counting
                YELLOW_LIGHT1_ENABLE <= '1'; -- enable YELLOW light Highway delay counting
                YELLOW_LIGHT2_ENABLE <= '0';
                if delay_3s_H = '1' then
                    -- if Yellow light delay counts to 3s,
                    -- turn Highway to RED,
                    -- road to green light
                    next_state <= HRED_FGRE;
                else
                    next_state <= HYEL_FRED;
                    -- Remains Yellow on highway and Red on road
                    -- if Yellow light not yet in 3s
                end if;
            when HRED_FGRE =>
                highwayLight <= "100"; -- RED light on Highway
                roadLight <= "001"; -- GREEN light on road
                RED_LIGHT_ENABLE <= '1'; -- enable RED light delay counting
                YELLOW_LIGHT1_ENABLE <= '0'; -- disable YELLOW light Highway delay counting
                YELLOW_LIGHT2_ENABLE <= '0'; -- disable YELLOW light road delay counting
                if delay_10s = '1' then
                    next_state <= HRED_FYEL;
                else
                    next_state <= HRED_FGRE;
                    -- Remains if delay counts for RED light on highway not enough 10s
                end if;
            when HRED_FYEL =>
                highwayLight <= "100"; -- RED light on Highway
                roadLight <= "010"; -- Yellow light on road
                RED_LIGHT_ENABLE <= '0'; -- disable RED light delay counting
                YELLOW_LIGHT1_ENABLE <= '0'; -- disable YELLOW light Highway delay counting
                YELLOW_LIGHT2_ENABLE <= '1'; -- enable YELLOW light road delay counting
                if delay_3s_F = '1' then
                    next_state <= HGRE_FRED;
                else
                    next_state <= HRED_FYEL;
                    -- if not enough 3s, remain the same state
                end if;
            when others =>
                next_state <= HGRE_FRED; -- Green on highway, red on road
        end case;
    end process;

    -- Delay counts for Yellow and RED light
    process(clk)
    begin
        if rising_edge(clk) then
            if enableClk = '1' then
                if RED_LIGHT_ENABLE = '1' or YELLOW_LIGHT1_ENABLE = '1' or YELLOW_LIGHT2_ENABLE = '1' then
                    delayCount <= delayCount + x"1";
                    if (delayCount = x"9") and RED_LIGHT_ENABLE = '1' then
                        delay_10s <= '1';
                        delay_3s_H <= '0';
                        delay_3s_F <= '0';
                        delayCount <= x"0";
                    elsif (delayCount = x"2") and YELLOW_LIGHT1_ENABLE = '1' then
                        delay_10s <= '0';
                        delay_3s_H <= '1';
                        delay_3s_F <= '0';
                        delayCount <= x"0";
                    elsif (delayCount = x"2") and YELLOW_LIGHT2_ENABLE = '1' then
                        delay_10s <= '0';
                        delay_3s_H <= '0';
                        delay_3s_F <= '1';
                        delayCount <= x"0";
                    else
                        delay_10s <= '0';
                        delay_3s_H <= '0';
                        delay_3s_F <= '0';
                    end if;
                end if;
            end if;
        end if;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            counter <= counter + x"0000001";
            if counter >= x"0000003" then -- x"0004" is for simulation
                -- change to x"2FAF080" for 50 MHz clock running real FPGA
                counter <= x"0000000";
            end if;
        end if;
    end process;

    enableClk <= '1' when counter = x"0003" else '0'; -- x"0002" is for simulation
    -- x"2FAF080" for 50Mhz clock on FPGA
end traffic_light;
