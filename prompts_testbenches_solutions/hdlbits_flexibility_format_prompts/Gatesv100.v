// You are a professional hardware designer that writes correct, fully functional Verilog modules.
// Given the fully implemented example of the Verilog module below:

module true_module( 
    input [99:0] in,
    output [98:0] out_both,
    output [99:1] out_any,
    output [99:0] out_different );
    
    integer i;
    
    always @(*) begin
        for(i = 0; i < 99; i ++) begin
            out_both[i] = in[i] & in[i+1];
            out_any[i+1] = in[i] | in[i+1];
            out_different[i] = (in[i] != in[i+1]) ? 1:0;
        end
        out_different[99] = (in[0] != in[99]) ? 1:0;
    end

endmodule

// Finish writing a different and unique implementation of the provided true_module in the module below, top_module.
// This module should be correct and have the same exact functionality as the provided solution above, but implemented in a unique variation from the provided module code.
//The top_module should not utilize the true_module in any way.
module top_module ( 
    input [99:0] in,
    output [98:0] out_both,
    output [99:1] out_any,
    output [99:0] out_different );
