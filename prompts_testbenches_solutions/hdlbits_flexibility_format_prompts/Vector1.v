// You are a professional hardware designer that writes correct, fully functional Verilog modules.
// Given the fully implemented example of the Verilog module below:

`default_nettype none     // Disable implicit nets. Reduces some types of bugs.
module true_module( 
    input wire [15:0] in,
    output wire [7:0] out_hi,
    output wire [7:0] out_lo );

    assign out_hi = in[15:8];
    assign out_lo = in[7:0];
    
endmodule

// Finish writing a different and unique implementation of the provided true_module in the module below, top_module.
// This module should be correct and have the same exact functionality as the provided solution above, but implemented in a unique variation from the provided module code.
//The top_module should not utilize the true_module in any way.
module top_module ( 
    input wire [15:0] in,
    output wire [7:0] out_hi,
    output wire [7:0] out_lo );
