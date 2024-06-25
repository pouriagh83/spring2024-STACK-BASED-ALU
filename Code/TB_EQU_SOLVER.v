module TB_EQU_SOLVER();
    reg clk;
    reg [4095:0] equ;
    wire signed [31:0] result;

    Solver solver(clk, equ, result);

    always #10 clk = ~clk;

    initial begin
        clk = 0;
        equ = "78";
        #80;
        equ = "(-2147483648 + 2147483647) * -12";
        #280;
        equ = "2 * 3 + (10 + 4 + 3) * -20 + (6 + 5)";
        #780;
        equ = "-1 * 0 + -2";
        #280;
        equ = "(((2 + 2) * 6) + -1) * -10";
        #480;
        equ = "3 + 4";
        #180;
        equ = "5 * 6";
        #180;
        equ = "(-3 + -4) * -5";
        #280;
        equ = "-40 + (-567 * (167 + 8))) + -12";
        #480;
        equ = "((81 + -12) * (0 + -1)) + 12";
        #480;
        equ = "0 * (12 * 24)";
        #280;
        equ = "-8 * -8";
        #180;
        equ = "-1 + -1 * -1 + -2";
        #380;
        equ = "(((((1 + 1) * 2) * 4) * 8) * 16) * -32";
        #680;
        equ = "(((-2 + -1) * (8 + 9) * -10) + (2 * 2) + -1) * 7";
        #880;
        equ = "1";
        #80;
        equ = "0 + 0";
        #180;
        equ = "-1 * -1";
        #180;
        $finish();
    end
    always @(result) begin
        $display("%0s = %0d", equ, result);
    end
endmodule