library verilog;
use verilog.vl_types.all;
entity Solver is
    port(
        clk             : in     vl_logic;
        equation        : in     vl_logic_vector(4095 downto 0);
        result          : out    vl_logic_vector(31 downto 0)
    );
end Solver;
