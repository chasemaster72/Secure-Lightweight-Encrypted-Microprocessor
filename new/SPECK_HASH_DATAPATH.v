`timescale 1ns / 1ps

module SPECK_HASH_DATAPATH( X,
                    reset8,
                    reset4,
                    reset_reg,
                    reset_counter,
                    clk,
                    H1,
                    K1,
                    Y1,
                    hout,
                    ld,ld1,
                    eqz4_9,
                    eqz2_0,
                    eqz4_1,
                    wr,
                    rd,
                    en
    );
    input [63:0] X,H1,K1,Y1;
    input clk,reset8,reset4,reset_reg,reset_counter,wr,rd,en;
    output [3:0] hout;
    output eqz4_9,eqz2_0,eqz4_1;
    input ld,ld1;
    wire [63:0] X_out,Y_out,H_final;
    wire[63:0] H;
    wire[63:0] mtoxw,mtoyw,mtohw,mjky;
    wire[63:0] w1,w2,w3,w4,w5,w7,w10,w11;
    wire[63:0] w21,w22,w23,w24,w25,w26,w27,w28,w29,ww;
    wire[63:0] w6,w8;
    wire[2:0] w13;
    wire[1:0] w33;
    wire[3:0] uc3,add01;
    
    counter_4bit_up_speck up_counter (.q(uc3),.reset(reset4),.clk(clk)); //4 bit up counter for comapring 4 bit 9 in eqz_comparing_9
    counter_4bit_up_speck uc4 (.q(add01),.reset(reset_counter),.clk(clk)); // 4 bit up counter for seeing output 
    counter_2bit_down_speck dch (.q(w33),.clk(clk),.reset(reset4)); // 2 bit down counter
    counter_3bit_down_speck dc (.q(w13),.clk(clk),.reset(reset8));   //3 bit down counter
    
    mux2to1_speck m1(.in1(X),.in2(w6),.ld(ld),.out(mtoxw));
    mux2to1_speck m2(.in1(Y1),.in2(w8),.ld(ld),.out(mtoyw));
   
    reg_speck   regx  (.din(mtoxw),.dout(w1),.clk(clk),.reset(reset_reg));
    reg_speck   regy  (.din(mtoyw),.dout(w2),.clk(clk),.reset(reset_reg));
    reg_speck   regk1 (.din(K1),.dout(w5),.clk(clk),.reset(reset_reg));
    
    shift_right_speck sr  (.in(w1),.out(w3));
    adder_speck add       (.ain1(w3),.ain2(w2),.add_out(w4));
    assign w6 = w4 ^ w5;

    shift_left_speck sl   (.in(w2),.out(w7));
    assign w8 = w6 ^ w7;

    

    buffer_speck bf1      (.in1(w6),.out(w10),.ld(|w13),.reset(reset_reg),.clk(clk));
    buffer_speck bf2      (.in1(w8),.out(w11),.ld(|w13),.reset(reset_reg),.clk(clk));
    
    reg_speck finalx (.din(w10),.dout(X_out),.clk(clk),.reset(reset_reg));
    reg_speck finaly (.din(w11),.dout(Y_out),.clk(clk),.reset(reset_reg));
    
    assign H = w10 ^ w11;
    assign H_final = H ^ H1;
    
    mux2to1_speck mh          (.in1(H_final),.in2(ww),.ld(ld1),.out(w21));
    shift_right_speck sr1     (.in(w21),.out(w23));
    shift_left_speck sl1     (.in(w21),.out(w25));
     
    adder_speck     add1      (.ain1(w23),.ain2(w5),.add_out(w24));
    assign w26  = w24 ^ w25;
    reg_speck   addh    (.din(w26),.dout(ww),.clk(clk),.reset(reset_reg));
    
   
    buffer_speck bf1h      (.in1(ww),.out(w28),.ld(|w33),.reset(reset_reg),.clk(clk));
    
   
    
    eqz_comparing_0_speck EQZ_COMPARED_0_speck (.eqz(eqz2_0), .data(w33)); //TWO BIT ZEROS ARE BEING COMAPRED HERE.
    eqz_comparing_1_speck EQZ_COMPARED_1_speck (.eqz(eqz4_1), .data(add01)); //Four Bit one is being comapred here.
    eqz_comparing_9_speck EQZ_COMPARED_9_speck (.eqz(eqz4_9), .data(uc3));  //FOUR BIT 9 IS BEING COMAPRED HERE.    
    write_read_final_speck_memory final_value (.clk(clk),.wr(wr),.rd(rd),.en(en),.in1(w28),.out1(hout),.addo(add01));
endmodule
