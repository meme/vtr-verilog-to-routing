/*
 * Copyright (c) 2021 Seyed Alireza Damghani (sdamghann@gmail.com)   
 *                                                                   
 * Permission is hereby granted, free of charge, to any person       
 * obtaining a copy of this software and associated documentation    
 * files (the "Software"), to deal in the Software without           
 * restriction, including without limitation the rights to use,      
 * copy, modify, merge, publish, distribute, sublicense, and/or sell 
 * copies of the Software, and to permit persons to whom the         
 * Software is furnished to do so, subject to the following          
 * conditions:                                                       
 *                                                                   
 * The above copyright notice and this permission notice shall be    
 * included in all copies or substantial portions of the Software.   
 *                                                                   
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,   
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES   
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND          
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT       
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,      
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING      
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR     
 * OTHER DEALINGS IN THE SOFTWARE.                                   
 *                                                                   
 * The library contains the implementation of read-only memory used  
 * to be replaced with yosys mem block that has only read access.    
 * Specified paramateres are compatible with yosys infrastructure to 
 * avoid complaining.The rom block then maps and splits into VTR     
 * memory primitives using Odin-II.                                  
 *                                                                   
 *                                CLK                                
 *                                 |                                 
 *                             ____v____                             
 *                            |         |                            
 *                    CLK --> |   ROM   |<--- RD_ADDR                
 *                            |_________|                            
 *                                 |                                 
 *                                 v                                 
 *                                RD_DATA                            
*/
 (* blackbox *)
module _$ROM (CLK, RD_EN, RD_ADDR, RD_DATA);

    parameter MEMID = "";
    parameter signed OFFSET = 0;
    parameter signed ABITS = 1;
    parameter signed WIDTH = 1;
    parameter signed SIZE = 2;
    parameter signed INIT = 1'bx;

    parameter CLK_ENABLE = 1'b1;
    
    parameter signed RD_PORTS = 1;

    /* read input */
    input CLK;
    input [RD_PORTS-1:0] RD_EN;
    input [RD_PORTS*ABITS-1:0] RD_ADDR;
    /* read output */
    output reg [RD_PORTS*WIDTH-1:0] RD_DATA;

    reg [WIDTH-1:0] memory [SIZE-1:0];
  
    integer i;
    always@(posedge CLK) begin
        for (i = 0; i < RD_PORTS; i = i+1) begin
            if (RD_EN[i]) begin
              RD_DATA[i*WIDTH +: WIDTH] <= memory[RD_ADDR[i*ABITS +: ABITS]];
            end
        end
    end

endmodule