module TB_STACK ();
    reg clk;
    parameter N = 32;

    reg signed [N-1:0] input_data;
    reg [2:0] opcode;
    wire signed [N-1:0] output_data;
    wire overflow;

    integer i;

    reg signed [N-1:0] element1;
    reg signed [N-1:0] element2;

    reg signed [N-1:0] true_output;
    reg true_overflow;

    integer number_of_false_result;
    integer number_of_false_overflow;

    STACK_BASED_ALU #(N) Stack_based_alu(clk, input_data, opcode, output_data, overflow);

    always #10 clk <= ~clk;

    initial begin
        clk = 0;
        number_of_false_overflow = 0;
        number_of_false_result = 0;
        #5;

        for (i = -3; i < 4; i = i + 1) begin
            input_data = i;
            opcode = 3'b110;
            #20;
        end
        

        for (i = 0; i < 7; i = i + 1) begin
            opcode = 3'b111;
            #10;
            $display("Pop result = %0d", output_data);
            #10;
        end

        $display();

        input_data = ((-1) ** ($random() % 2)) * ($random() % (2**(N-1)));
        opcode = 3'b110;
        element1 = input_data;

        #20;

        input_data = ((-1) ** ($random() % 2)) * ($random() % (2**(N-1)));
        opcode = 3'b110;
        element2 = input_data;

        #20;

        for (i = 0; i < 30; i = i + 1) begin
            if ($random() % 2 == 0) begin
                opcode = 3'b100;
                #10;
                print(0, element1, element2, output_data, overflow);
                true_result(0, element1, element2, true_output, true_overflow);
                print_true(true_output, true_overflow);
                if (overflow != true_overflow) begin
                    number_of_false_overflow = number_of_false_overflow + 1;
                end
                if (output_data != true_output) begin
                    number_of_false_result = number_of_false_result + 1;
                end
            end

            else begin
                opcode = 3'b101;
                #10;
                print(1, element1, element2, output_data, overflow);
                true_result(1, element1, element2, true_output, true_overflow);
                print_true(true_output, true_overflow);
                if (overflow != true_overflow) begin
                    number_of_false_overflow = number_of_false_overflow + 1;
                end
                if (output_data != true_output) begin
                    number_of_false_result = number_of_false_result + 1;
                end
            end

            #10;

            element1 = element2;
            input_data = ((-1) ** ($random() % 2)) * ($random() % (2**(N-1)));
            opcode = 3'b110;
            element2 = input_data;

            #20;
        end

        $display();
        
        for (i = 0; i < 32; i = i + 1) begin
            opcode = 3'b111;
            #20;
        end

        for (i = 0; i < 20; i = i + 1) begin
            input_data = ((-1) ** ($random() % 2)) * ($random() % (2**(N-1)));
            opcode = 3'b110;
            element1 = input_data;
            #20;
            input_data = ((-1) ** ($random() % 2)) * ($random() % (2**(N-1)));
            opcode = 3'b110;
            element2 = input_data;
            #20;
            if ($random() % 2 == 0) begin
                opcode = 3'b100;
                #10;
                print(0, element1, element2, output_data, overflow);
                true_result(0, element1, element2, true_output, true_overflow);
                print_true(true_output, true_overflow);
                if (overflow != true_overflow) begin
                    number_of_false_overflow = number_of_false_overflow + 1;
                end
                if (output_data != true_output) begin
                    number_of_false_result = number_of_false_result + 1;
                end
            end
            else begin
                opcode = 3'b101;
                #10;
                print(1, element1, element2, output_data, overflow);
                true_result(1, element1, element2, true_output, true_overflow);
                print_true(true_output, true_overflow);
                if (overflow != true_overflow) begin
                    number_of_false_overflow = number_of_false_overflow + 1;
                end
                if (output_data != true_output) begin
                    number_of_false_result = number_of_false_result + 1;
                end
            end
            #10;
        end

        $display();

        for (i = 0; i < 49; i = i + 1) begin
            opcode = 3'b111;
            #10;
            $display("ouput pop = %0d", output_data);
            #10;
        end

        $display();

        input_data = -(2**(N-1));
        element1 = input_data;
        opcode = 3'b110;

        #20;

        input_data = 2**(N-1) - 1;
        element2 = input_data;
        opcode = 3'b110;

        #20;

        opcode = 3'b100;
        #10;
        print(0, element1, element2, output_data, overflow);
        true_result(0, element1, element2, true_output, true_overflow);
        print_true(true_output, true_overflow);
        if (overflow != true_overflow) begin
            number_of_false_overflow = number_of_false_overflow + 1;
        end
        if (output_data != true_output) begin
            number_of_false_result = number_of_false_result + 1;
        end
        #10;

        opcode = 3'b101;
        #10;
        print(1, element1, element2, output_data, overflow);
        true_result(1, element1, element2, true_output, true_overflow);
        print_true(true_output, true_overflow);
        if (overflow != true_overflow) begin
            number_of_false_overflow = number_of_false_overflow + 1;
        end
        if (output_data != true_output) begin
            number_of_false_result = number_of_false_result + 1;
        end
        #10;    

        opcode = 3'b111;

        #20;

        input_data = -(2**(N-1));
        element2 = input_data;
        opcode = 3'b110;

        #20;

        opcode = 3'b100;
        #10;
        print(0, element1, element2, output_data, overflow);
        true_result(0, element1, element2, true_output, true_overflow);
        print_true(true_output, true_overflow);
        if (overflow != true_overflow) begin
            number_of_false_overflow = number_of_false_overflow + 1;
        end
        if (output_data != true_output) begin
            number_of_false_result = number_of_false_result + 1;
        end
        #10;

        opcode = 3'b101;
        #10;
        print(1, element1, element2, output_data, overflow);
        true_result(1, element1, element2, true_output, true_overflow);
        print_true(true_output, true_overflow);
        if (overflow != true_overflow) begin
            number_of_false_overflow = number_of_false_overflow + 1;
        end
        if (output_data != true_output) begin
            number_of_false_result = number_of_false_result + 1;
        end
        #10;

        input_data = (2**(N-1)) - 1;
        element1 = input_data;
        opcode = 3'b110;

        #20;

        input_data = (2**(N-1)) - 1;
        element2 = input_data;
        opcode = 3'b110;

        #20;

        opcode = 3'b100;
        #10;
        print(0, element1, element2, output_data, overflow);
        true_result(0, element1, element2, true_output, true_overflow);
        print_true(true_output, true_overflow);
        if (overflow != true_overflow) begin
            number_of_false_overflow = number_of_false_overflow + 1;
        end
        if (output_data != true_output) begin
            number_of_false_result = number_of_false_result + 1;
        end
        #10;

        opcode = 3'b101;
        #10;
        print(1, element1, element2, output_data, overflow);
        true_result(1, element1, element2, true_output, true_overflow);
        print_true(true_output, true_overflow);
        if (overflow != true_overflow) begin
            number_of_false_overflow = number_of_false_overflow + 1;
        end
        if (output_data != true_output) begin
            number_of_false_result = number_of_false_result + 1;
        end
        #10;

        element1 = (2**(N-1)) - 1;
        input_data = 0;
        element2 = input_data;
        opcode = 3'b110;

        #20;

        opcode = 3'b100;
        #10;
        print(0, element1, element2, output_data, overflow);
        true_result(0, element1, element2, true_output, true_overflow);
        print_true(true_output, true_overflow);
        if (overflow != true_overflow) begin
            number_of_false_overflow = number_of_false_overflow + 1;
        end
        if (output_data != true_output) begin
            number_of_false_result = number_of_false_result + 1;
        end
        #10;  

        opcode = 3'b101;
        #10;
        print(1, element1, element2, output_data, overflow);
        true_result(1, element1, element2, true_output, true_overflow);
        print_true(true_output, true_overflow);
        if (overflow != true_overflow) begin
            number_of_false_overflow = number_of_false_overflow + 1;
        end
        if (output_data != true_output) begin
            number_of_false_result = number_of_false_result + 1;
        end
        #10;   

        for(i = 0; i < 6; i = i + 1) begin
            opcode = 3'b111;
            #20;
        end

        for(i = 0; i < 512; i = i + 1) begin
            input_data = 0;
            opcode = 3'b110;
            #20;
        end

        input_data = 1;
        opcode = 3'b110;
        
        #20;

        opcode = 3'b100;
        element1 = 0;
        element2 = 0;
        #10;
        print(0, element1, element2, output_data, overflow);
        true_result(0, element1, element2, true_output, true_overflow);
        print_true(true_output, true_overflow);
        if (overflow != true_overflow) begin
            number_of_false_overflow = number_of_false_overflow + 1;
        end
        if (output_data != true_output) begin
            number_of_false_result = number_of_false_result + 1;
        end
        #10;

        opcode = 3'b101;
        #10;
        print(1, element1, element2, output_data, overflow);
        true_result(1, element1, element2, true_output, true_overflow);
        print_true(true_output, true_overflow);
        if (overflow != true_overflow) begin
            number_of_false_overflow = number_of_false_overflow + 1;
        end
        if (output_data != true_output) begin
            number_of_false_result = number_of_false_result + 1;
        end
        #10;

        opcode = 3'b111;

        #20;

        input_data = 1;
        element2 = 1;
        opcode = 3'b110;
        
        #20;

        opcode = 3'b100;
        #10;
        print(0, element1, element2, output_data, overflow);
        true_result(0, element1, element2, true_output, true_overflow);
        print_true(true_output, true_overflow);
        if (overflow != true_overflow) begin
            number_of_false_overflow = number_of_false_overflow + 1;
        end
        if (output_data != true_output) begin
            number_of_false_result = number_of_false_result + 1;
        end
        #10;

        for (i = 0; i < 4; i = i + 1) begin
            opcode = i;
            #10;
            $display("Output on No-Op = %0d", output_data);
            #10;
        end
        $display();
        $display("Number of false overflow = %0d, Number of false result = %0d for N = %0d", number_of_false_overflow, number_of_false_result, N);
        $finish();
    end

    task print;
        input operand;
        input signed [N-1:0] element1;
        input signed [N-1:0] element2;
        input signed [N-1:0] output_data;
        input overflow;
        begin
            //Add
            if(operand == 0) begin
                $display("input 1 = %0d, input 2 = %0d, Adder output = %0d, overflow = %0d", element1, element2, output_data, overflow);
            end

            //Multiply
            else begin
                $display("input 1 = %0d, input 2 = %0d, Multiplier output = %0d, overflow = %0d", element1, element2, output_data, overflow);
            end
        end
    endtask

    task print_true;
        input signed [N-1:0] true_output;
        input true_overflow;
        begin
            $display("True value: Result = %0d, overflow = %0d", true_output, true_overflow);
            $display();
        end
    endtask

    task true_result;
        input operand;
        input signed [N-1:0] element1;
        input signed [N-1:0] element2;
        output signed [N-1:0] true_output;
        output true_overflow;
        reg signed [2*N - 1:0] double_bit_result;
        begin
            true_overflow = 0;
            //Add
            if (operand == 0) begin
                double_bit_result = element1 + element2;
                true_output = double_bit_result[N-1:0];
                if ((element1[N-1] == element2[N-1]) && (element1[N-1] != true_output[N-1])) begin
                    true_overflow = 1;
                end
            end

            //Multiply
            else begin
                double_bit_result = element1 * element2;
                true_output = double_bit_result[N-1:0];
                if ((element1 != 0 && element2 != 0) && ((true_output / element1) != element2)) begin
                    true_overflow = 1;
                end
            end
        end
    endtask
endmodule