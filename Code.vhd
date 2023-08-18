module top_module(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss); 

    wire ena1,ena2,ena3;
    BCD_SS_MM Sec(clk,reset,ena,ena1,ss);
    BCD_SS_MM Min(clk,reset,ena1,ena2,mm);
    BCD_HH Hr(clk,reset,ena2,ena3,hh);
    AM_PM AP(clk,reset,ena3,pm);
    
endmodule

module BCD_SS_MM(
    input clk,
    input reset,
    input ena_in,
    output ena_out,
    output [7:0] q);

    assign ena_out = ena_in&q[3:0]==4'd9&q[7:4]==4'd5;
        
    always @ (posedge clk)
        begin
            if(reset)
                begin
        			q<=8'd0;
                end
            else if(ena_in&~(q[3:0]==4'd9))
        		begin
                    q[3:0]<=q[3:0]+4'd1;
                end
            else if(ena_in&q[3:0]==4'd9&~(q[7:4]==4'd5))
                begin
                    q[3:0]<=4'd0;
                    q[7:4]<=q[7:4]+4'd1;
                end
            else if(ena_in&q[3:0]==4'd9&q[7:4]==4'd5)
                begin
                    q<=8'd0;
                end
        end
endmodule

module BCD_HH(
    input clk,
    input reset,
    input ena_in,
    output ena_out,
    output [7:0] q);
    
    assign ena_out = ena_in&q[3:0]==4'd1&q[7:4]==4'd1;
    
    always @ (posedge clk)
        begin
            if(reset)
                begin
        			q<=8'b00010010;
                end
            else if(ena_in&~(q[3:0]==4'd9)&q[7:4]==4'd0)
        		begin
                    q[3:0]<=q[3:0]+4'd1;
                end
            else if(ena_in&q[3:0]==4'd9&q[7:4]==4'd0)
                begin
                    q[3:0]<=4'd0;
                    q[7:4]<=q[7:4]+4'd1;
                end
            else if(ena_in&~(q[3:0]==4'd2)&(q[7:4]==4'd1))
                begin
                    q[3:0]<=q[3:0]+4'd1;
                end
            else if(ena_in&q[3:0]==4'd2&q[7:4]==4'd1)
                begin
                    q<=8'b00000001;
                end
        end
endmodule

module AM_PM(
    input clk,
    input reset,
    input ena_in,
    output pm);
    
    always @ (posedge clk)
        begin
            if(reset)
                begin
                    pm<=1'b0;
                end
            else if(ena_in)
                begin
                    pm<=~pm;
                end
        end
endmodule
