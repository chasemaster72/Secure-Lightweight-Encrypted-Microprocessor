`timescale 1ns / 1ps


module write_rc4(input [3:0] addi,in,addo,
             input clk,wr_1,rd_1,
             output[3:0] out
    );
    
    reg [3:0] memory [0:15];
    reg [3:0] temp_out;
    assign out=temp_out;
    always @ (posedge clk)
    begin  
             if(wr_1 && !rd_1)
                memory[addi] <= in;
             else if (rd_1 && !wr_1)
               temp_out<=memory[addo];
    end
        
endmodule
