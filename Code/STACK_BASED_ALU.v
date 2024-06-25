module STACK_BASED_ALU #(parameter N)(
    input clk,
    input signed [N-1:0] input_data,
    input [2:0] opcode,
    output reg signed [N-1:0] output_data,
    output reg overflow
);
    reg signed [N-1:0] stack [0:511];
    reg [9:0] sp;
    
    initial begin
        sp = 0;
    end
    
    always @(posedge clk) begin
        case (opcode)
            3'b100: begin
                if (sp > 1) begin
                    output_data = stack[sp-1] + stack[sp-2];
                    if (((stack[sp-1] > 0) && (stack[sp-2] > 0) && (output_data <= 0)) ||
                        ((stack[sp-1] < 0) && (stack[sp-2] < 0) && (output_data >= 0))) begin
                        overflow = 1;
                    end
                    else begin
                        overflow = 0;
                    end
                end
                else begin
                    overflow = 1'bx;
                    output_data = {N{1'bx}};
                end
            end
            3'b101: begin
                if (sp > 1) begin
                    output_data = stack[sp-1] * stack[sp-2];
                    if ((stack[sp-1] != 0 && stack[sp-2] != 0) && (output_data / stack[sp-1] != stack[sp-2])) begin
                        overflow = 1;
                    end
                    else begin
                        overflow = 0;
                    end
                end
                else begin
                    overflow = 1'bx;
                    output_data = {N{1'bx}};
                end
            end
            3'b110: begin
                overflow = 1'bx;
                output_data = {N{1'bx}};
                if (sp < 512) begin
                    stack[sp] = input_data;
                    sp = sp + 1;
                end
            end
            3'b111: begin
                overflow = 1'bx;
                if (sp > 0) begin
                    sp = sp - 1;
                    output_data = stack[sp];
                    stack[sp] = {N{1'bx}};
                end
                else begin
                    output_data = {N{1'bx}};
                end
            end
            default: begin
                overflow = 1'bx;
                output_data = {N{1'bx}};
            end

        endcase
    end
endmodule
