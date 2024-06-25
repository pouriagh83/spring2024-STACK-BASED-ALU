library verilog;
use verilog.vl_types.all;
entity STACK_BASED_ALU is
    generic(
        N               : vl_notype
    );
    port(
        clk             : in     vl_logic;
        input_data      : in     vl_logic_vector;
        opcode          : in     vl_logic_vector(2 downto 0);
        output_data     : out    vl_logic_vector;
        overflow        : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of N : constant is 5;
end STACK_BASED_ALU;
