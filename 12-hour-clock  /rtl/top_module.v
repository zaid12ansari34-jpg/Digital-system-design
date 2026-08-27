module top_module( 
    input clk, 
    input reset, 
    input ena, 
    output reg pm, 
    output [7:0] hh, 
    output [7:0] mm, 
    output [7:0] ss
);  
    reg next_mm, next_hh, toggle_pm; 
     
    bcd_decade_counter second ( 
        .clk(clk), 
        .reset(reset), 
        .ena(ena), 
        .reset_val_l(4'd0), 
        .reset_val_h(4'd0), 
        .max_val_l(4'd9), 
        .max_val_h(4'd5), 
        .reset_max_l(4'd0), 
        .reset_max_h(4'd0), 
        .hour_mode(1'b0),
        .next(next_mm), 
        .q(ss)
    ); 
     
    bcd_decade_counter minute ( 
        .clk(clk), 
        .reset(reset), 
        .ena(next_mm), 
        .reset_val_l(4'd0), 
        .reset_val_h(4'd0), 
        .max_val_l(4'd9), 
        .max_val_h(4'd5), 
        .reset_max_l(4'd0), 
        .reset_max_h(4'd0), 
        .hour_mode(1'b0),
        .next(next_hh), 
        .q(mm)
    ); 
     
    bcd_decade_counter hour ( 
        .clk(clk), 
        .reset(reset), 
        .ena(next_hh), 
        .reset_val_l(4'd2), 
        .reset_val_h(4'd1), 
        .max_val_l(4'd9), 
        .max_val_h(4'd1), 
        .reset_max_l(4'd1), 
        .reset_max_h(4'd0), 
        .hour_mode(1'b1),
        .next(toggle_pm), 
        .q(hh)
    ); 
     
    always @(posedge clk) begin 
        if (reset) begin
            pm <= 1'b0; 
        end
        else if (next_hh && (hh == 8'h11)) begin
            pm <= ~pm;
        end
    end 
endmodule 
