module Solver (
    input clk,
    input wire [4095:0] equation,
    output reg signed [31:0] result
);

    reg signed [7:0] postfix [0:511];
    reg signed [7:0] tmp [0:511];
    integer i, postfix_idx, tmp_idx;
    reg break;
    reg break_for;
    reg operand_on;
    reg pop_first;
    reg pop_second;
    reg pop_result;
    reg end_op;
    reg result_ready;
    reg number;

    reg signed [31:0] save_result;

    reg signed [31:0] input_data;
    reg [2:0] opcode;
    wire signed [31:0] output_data;
    wire overflow;

    STACK_BASED_ALU #(32) stack_based_alu(clk, input_data, opcode, output_data, overflow);

    always @(equation) begin
        for (i = 0; i < 512; i = i + 1) begin
            postfix[i] = 8'bx;
            tmp[i] = 8'bx;
        end
        postfix_idx = 0;
        tmp_idx = 0;
        for (i = 511; i >= 0; i = i - 1) begin
            if (equation[i*8 +: 8] != 0)
            begin
                if (equation[i*8 +: 8] != 8'h2B &&
                    equation[i*8 +: 8] != 8'h2A &&
                    equation[i*8 +: 8] != 8'h28 &&
                    equation[i*8 +: 8] != 8'h29)
                begin
                    postfix[postfix_idx] = equation[i*8 +: 8];
                    postfix_idx = postfix_idx + 1;
                end
                else if (equation[i*8 +: 8] == 8'h28) begin
                    tmp[tmp_idx] = equation[i*8 +: 8];
                    tmp_idx = tmp_idx + 1;
                end
                else if (equation[i*8 +: 8] == 8'h29) begin
                    break = 0;
                    while (tmp_idx != 0 && !break) begin
                        if (tmp[tmp_idx - 1] != 8'h28) begin
                            postfix[postfix_idx] = tmp[tmp_idx - 1];
                            postfix_idx = postfix_idx + 1;
                            tmp_idx = tmp_idx - 1;
                        end
                        else begin
                            tmp_idx = tmp_idx - 1;
                            break = 1;
                        end
                    end
                end
                else if (equation[i*8 +: 8] == 8'h2B ||
                         equation[i*8 +: 8] == 8'h2A)
                begin
                    if (tmp_idx == 0) begin
                        tmp[tmp_idx] = equation[i*8 +: 8];
                        tmp_idx = tmp_idx + 1;
                    end
                    else begin
                        break = 0;
                        while(tmp_idx != 0 && !break) begin
                            if (tmp[tmp_idx - 1] == 8'h28) begin
                                break = 1;
                            end
                            else if(tmp[tmp_idx - 1] == 8'h2A || tmp[tmp_idx - 1] == 8'h2B) begin
                                if (tmp[tmp_idx - 1] > equation[i*8 +: 8]) begin
                                    break = 1;
                                end
                                else begin
                                    postfix[postfix_idx] = tmp[tmp_idx - 1];
                                    tmp_idx = tmp_idx - 1;
                                    postfix_idx = postfix_idx + 1;
                                end
                            end
                        end
                        tmp[tmp_idx] = equation[i*8 +: 8];
                        tmp_idx = tmp_idx + 1;
                    end
                end     
            end
        end

        while (tmp_idx != 0) begin
            postfix[postfix_idx] = tmp[tmp_idx - 1];
            tmp_idx = tmp_idx - 1;
            postfix_idx = postfix_idx + 1;

        end
        
        save_result = 0;
        postfix_idx = 0;
        operand_on = 0;
        pop_first = 0;
        pop_second = 0;
        pop_result = 0;
        end_op = 0;
        result_ready = 0;
    end

    always @(posedge clk) begin
        if (pop_result) begin
            pop_result = 0;
            result_ready = 1;
        end
        else if (result_ready) begin
            result = output_data;
            result_ready = 0;
            end_op = 1;
        end
        else if (operand_on) begin
            opcode = 3'b111;
            pop_first = 1;
            operand_on = 0;
        end
        else if (pop_first) begin
            save_result = output_data;
            opcode = 3'b111;
            pop_second = 1;
            pop_first = 0;
        end
        else if (pop_second) begin
            input_data = save_result;
            opcode = 3'b110;
            pop_second = 0;
        end
        else if (postfix_idx < 512 && postfix[postfix_idx] <= 57) begin
            if (postfix[postfix_idx] == 32) begin
               while(postfix[postfix_idx] == 32) begin
                    postfix_idx = postfix_idx + 1;
                end 
            end
            if (postfix[postfix_idx] == 45 || (postfix[postfix_idx] <= 57 && postfix[postfix_idx] >= 48)) begin
                input_data = 0;
                case (postfix[postfix_idx])
                    45: begin
                        postfix_idx = postfix_idx + 1;
                        while(postfix[postfix_idx] <= 57 && postfix[postfix_idx] >= 48) begin
                            input_data = (10 * input_data) + (postfix[postfix_idx] - 48);
                            postfix_idx = postfix_idx + 1;
                        end
                        input_data = -1 * input_data;
                    end
                    default: begin
                       while(postfix[postfix_idx] <= 57 && postfix[postfix_idx] >= 48) begin
                            input_data = (10 * input_data) + (postfix[postfix_idx] - 48);
                            postfix_idx = postfix_idx + 1;
                        end 
                    end
                endcase
                opcode = 3'b110;
            end
            else begin
                case(postfix[postfix_idx])
                    8'h2B: begin
                        opcode = 3'b100;
                        operand_on = 1;
                    end
                    8'h2A: begin
                        opcode = 3'b101;
                        operand_on = 1;
                    end
                endcase
                postfix_idx = postfix_idx + 1;
            end
        end
        else begin
            if (end_op == 0) begin
                opcode = 3'b111;
                pop_result = 1;
            end
        end
    end

endmodule
