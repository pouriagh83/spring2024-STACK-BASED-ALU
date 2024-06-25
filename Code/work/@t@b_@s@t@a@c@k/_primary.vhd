library verilog;
use verilog.vl_types.all;
entity TB_STACK is
    generic(
        N               : integer := 32
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of N : constant is 1;
end TB_STACK;
