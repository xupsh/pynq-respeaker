`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/02 09:36:51
// Design Name: 
// Module Name: i2s_decode
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module i2s_decode#(
    parameter integer I2S_IN_WIDTH  = 3
)
(
    input S_AXI_ACLK,
    output [31:0] ch1,
    output [31:0] ch2,
    output [31:0] ch3,
    output [31:0] ch4,
    output [31:0] frame,
    input slv_reg_rden,
    input S_AXI_ARESETN,
    input [I2S_IN_WIDTH-1:0] I2S_i
    );
    
    wire sysclk = S_AXI_ACLK;
    wire i2s_clk = I2S_i[0];
    wire i2s_lrclk = I2S_i[1];
    wire i2s_adc = I2S_i[2];

    reg [31:0] ch1 = 32'd0;
    reg [31:0] ch2 = 32'd0;
    reg [31:0] ch3 = 32'd0;
    reg [31:0] ch4 = 32'd0;
    reg [31:0] frame = 32'd0;

    reg [31:0] ch1_r = 32'd0;
    reg [31:0] ch2_r = 32'd0;
    reg [31:0] ch3_r = 32'd0;
    reg [31:0] ch4_r = 32'd0;
 
    reg i2s_clk_pre = 1'b0;
    reg i2s_clk_r = 1'b0;
    reg i2s_lrclk_r = 1'b0;
    reg i2s_lrclk_r2 = 1'b0;
    reg i2s_adc_r = 1'b0;
    
    reg capture_clk = 1'b0;
    reg [7:0] bclk_cnt = 8'd0;
    
    always @(posedge sysclk)
    begin
        i2s_clk_pre <= i2s_clk_r;
        i2s_clk_r <= i2s_clk;
        i2s_lrclk_r <= i2s_lrclk;
        i2s_adc_r <= i2s_adc;
    end
    
    always @(posedge sysclk)
    begin
        if(!i2s_clk_pre & i2s_clk_r) begin
            capture_clk <= 1'b1;
        end else begin
            capture_clk <= 1'b0;
        end
    end
    
    always @(posedge sysclk)
    begin
        if(capture_clk)
            if(i2s_lrclk_r)
                bclk_cnt <= 8'd0;
            else
                bclk_cnt <= bclk_cnt + 1'b1;
        else
            bclk_cnt <= bclk_cnt;
    end    
    
    always @(posedge sysclk)
    begin
        if(capture_clk)
            if(bclk_cnt < 32)
                ch1_r <= {ch1_r[30:0],i2s_adc_r};
            else if(bclk_cnt < 64)
                ch2_r <= {ch2_r[30:0],i2s_adc_r};
            else if(bclk_cnt < 96)
                ch3_r <= {ch3_r[30:0],i2s_adc_r};
            else if(bclk_cnt < 128)
                ch4_r <= {ch4_r[30:0],i2s_adc_r};
            else;
        else;         
    end
    always @(posedge sysclk)
    begin
        if(capture_clk)
            i2s_lrclk_r2 <= i2s_lrclk_r;
        else;         
    end    

    always @(posedge sysclk)
    begin
        if(capture_clk)
            if(i2s_lrclk_r2 & !slv_reg_rden) begin
                ch1 <= ch1_r;
                ch2 <= ch2_r;
                ch3 <= ch3_r;
                ch4 <= ch4_r;
                frame <= frame > 254 ? 0 : frame + 1'b1;
            end else;
        else;         
    end
    
    wire clk = sysclk;
    wire [31:0] probe0 = ch1_r;
    wire [31:0] probe1 = ch2_r;
    wire [31:0] probe2 = ch3_r;
    wire [31:0] probe3 = ch4_r;
    wire [7:0] probe4 = frame;

    wire [7:0] probe5 = 
    {
        2'd0,
        capture_clk,
        i2s_clk_pre,
        i2s_clk_r,
        i2s_lrclk_r,
        i2s_lrclk_r2,
        i2s_adc_r
    };
    
    
    ila_0 ila_ins (
        .clk(clk), // input wire clk
    
    
        .probe0(probe0), // input wire [31:0]  probe0  
        .probe1(probe1), // input wire [31:0]  probe1 
        .probe2(probe2), // input wire [31:0]  probe2 
        .probe3(probe3), // input wire [31:0]  probe3 
        .probe4(probe4), // input wire [7:0]  probe4 
        .probe5(probe5) // input wire [7:0]  probe5
    );
    
endmodule

