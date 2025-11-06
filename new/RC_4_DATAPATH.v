
module RC4_DATAPATH(input en_s,clk_rst,en_k,reset1,reset2,reset3,clk,enc,reset4,reset_reg,reset_counter_final,wr_1,rd_1,
           input[3:0] in1s,in2s,in_k,add_to_read,
           output eqz3,eqz4,eqz5,
           output [3:0]out
    );
    
    wire[3:0] wt,c1,c2,c3,s1,k1,m1,j,mux_out,temp_si,temp_sj,swapped_si,swapped_sj,ss1,c22,c33,ss2,ss3;
    wire[4:0] a1,a2;
    wire [3:0] i,wj,wmi,wri,wmj,wh,wi,wl,cf1;
    wire [2:0] e3;
    wire[4:0] uc5;
    wire sel,clk_double;
    clk_div_rc4 cd (.clk(clk),.out1(clk_double),.reset(clk_rst));
    assign sel = ~clk_double;
    eqz_comparing_15_rc4 EQZ_COMPARED_15_RC_4 (.eqz(eqz4), .data(c1));
    eqz_comparing_7_rc4 EQZ_COMPARED_7_RC_4 (.eqz(eqz3), .data(e3)); 
    comparing_5bit_10101 EQZ_0_5bit (.eqz(eqz5), .data(uc5)); 
    counter_3bit_up_rc4 uc_3 (.q(e3),.reset(reset1),.clk(clk_double));
    counter_4bit_up_plus1_rc4 uc(.q(c1),.reset(reset1),.clk(clk_double));
    counter_4bit_up_plus2_rc4 uc1 (.q(c2),.reset(reset2),.clk(clk_double));
    up_counter_5bit up_counter_5bit (.q(uc5),.reset(reset1),.clk(clk_double));
    assign c3 = c2+1;
    sarray_read_rc4 S_array (.clk(clk_double),.en(en_s),.addi2(c3),.addi1(c2),.in1(in1s),.in2(in2s),.out1(s1),.addo1(c1));
    karray_read_write_rc4 K_array (.clk(clk_double),.en(en_k),.addi1(c1),.in1(in_k),.addo1(c1),.out1(k1));
    adder_rc4 add1  (.in1(s1),.in2(k1),.out(a1));
    reg_rc4 r(.din(m1),.dout(j),.clk(clk_double),.reset(reset3));
    adder_rc4 add2 (.in1(a1),.in2(j),.out(a2));
    mod16_rc4 m (.in(a2),.out(m1));
    reg_rc4 r1 (.din(s1),.dout(temp_si),.clk(clk_double),.reset(reset3));
    sarray_read_rc4 S_array_2 (.clk(clk_double),.en(en_s),.addi2(c3),.addi1(c2),.in1(in1s),.in2(in2s),.out1(temp_sj),.addo1(m1));
    swap_rc4 sw (.clk(clk),.reset(reset1),.out1(swapped_sj),.out2(swapped_si),.in1(temp_si),.in2(temp_sj),.sel(sel));
  
    counter_4bit_up_plus2_rc4 uc2 (.q(c22),.reset(reset4),.clk(clk_double));
    assign c33 = c22+1;
    
    
    
        wire [4:0] wai,waj,wij;
        wire [3:0] addo;// add_to_read;
        integer one = 1;
        counter_4bit_up_plus1_rc4 uc3 (.q(i),.clk(clk_double),.reset(reset1));
        adder_rc4 add3 (.in1(i),.in2(one),.out(wai));
        mod16_rc4 m2 (.in(wai),.out(wmi));
        copy_rc4 a (.clk(clk_double),.en(enc),.addi2(c33),.addi1(c22),.in1(swapped_sj),.in2(swapped_si),.out1(ss1),.addo1(wmi));
        adder_rc4 add4 (.in1(wj),.in2(ss1),.out(waj));
        mod16_rc4 m3 (.in(waj),.out(wmj));
        reg_rc4 rc1 (.din(wmj),.dout(wj),.clk(clk_double),.reset(reset_reg));
        copy_rc4 wjk  (.clk(clk_double),.en(enc),.addi2(c33),.addi1(c22),.in1(swapped_sj),.in2(swapped_si),.out1(ss2),.addo1(wj));
        adder_rc4 addd (.in1(ss1),.in2(ss2),.out(wij));
        mod16_rc4 m4 (.in(wij),.out(wt));
        copy_rc4 final (.clk(clk_double),.en(enc),.addi2(c33),.addi1(c22),.in1(swapped_sj),.in2(swapped_si),.out1(ss3),.addo1(wt));
        counter_4bit_up_plus1_rc4 ucc3 (.q(cf1),.clk(clk_double),.reset(reset_counter_final));
        counter_4bit_up_plus1_rc4 ucc4 (.q(addo),.clk(clk_double),.reset(~rd_1)); // to read final output
        write_rc4 wrt (.clk(clk_double),.addi(cf1),.in(ss3),.wr_1(wr_1),.rd_1(rd_1),.out(out),.addo(add_to_read));
        
        
//        read_s rs1(.addo1(wh),.clk(clk_half),.out1(wi));
//        Adder add5 (.in1(we),.in2(wi),.out(wk));
//        Mod16 m4 (.in(wk),.out(wj));
//        read_s rs2 (.clk(clk_half),.out1(wl),.addo1(wj));
//        write_block_final wb2 (.addi(wj),.in(wl),.clk(clk_half));
                                        
    endmodule