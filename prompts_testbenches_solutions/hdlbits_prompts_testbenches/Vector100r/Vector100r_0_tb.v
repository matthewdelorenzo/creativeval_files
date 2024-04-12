`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps

module top_module_tb;

    // duration for each bit = 20 * timescale = 20 * 1 ns  = 20ns
    localparam period = 20;

    reg [99:0] in;

    wire [99:0] out;


    integer mismatch_count;

    top_module UUT (.in(in), .out(out));

    initial begin
        mismatch_count = 0;

        // Tick 0: Inputs = 100'b0100110000001000100101011110100000011000010010000100110101100000100110110001111100000101011001100011, Generated = out, Reference = 100'b1100011001101010000011111000110110010000011010110010000100100001100000010111101010010001000000110010
        in = 100'b0100110000001000100101011110100000011000010010000100110101100000100110110001111100000101011001100011; // Set input values
        #period;
        if (!(out === 100'b1100011001101010000011111000110110010000011010110010000100100001100000010111101010010001000000110010)) begin
            $display("Mismatch at index 0: Inputs = [%b], Generated = [%b], Reference = [%b]", 100'b0100110000001000100101011110100000011000010010000100110101100000100110110001111100000101011001100011, out, 100'b1100011001101010000011111000110110010000011010110010000100100001100000010111101010010001000000110010);
            mismatch_count = mismatch_count + 1;
        end

        else begin
            $display("Test 0 passed!");
        end

        // Tick 1: Inputs = 100'b1101010001101101111110011001100011011011001011000010100001000110010110001001001101110101001000010010, Generated = out, Reference = 100'b0100100001001010111011001001000110100110001000010100001101001101101100011001100111111011011000101011
        in = 100'b1101010001101101111110011001100011011011001011000010100001000110010110001001001101110101001000010010; // Set input values
        #period;
        if (!(out === 100'b0100100001001010111011001001000110100110001000010100001101001101101100011001100111111011011000101011)) begin
            $display("Mismatch at index 1: Inputs = [%b], Generated = [%b], Reference = [%b]", 100'b1101010001101101111110011001100011011011001011000010100001000110010110001001001101110101001000010010, out, 100'b0100100001001010111011001001000110100110001000010100001101001101101100011001100111111011011000101011);
            mismatch_count = mismatch_count + 1;
        end

        else begin
            $display("Test 1 passed!");
        end

        // Tick 2: Inputs = 100'b0001000001101101011111001101000011010011101100100011111100010111011000011110100011011100110100111101, Generated = out, Reference = 100'b1011110010110011101100010111100001101110100011111100010011011100101100001011001111101011011000001000
        in = 100'b0001000001101101011111001101000011010011101100100011111100010111011000011110100011011100110100111101; // Set input values
        #period;
        if (!(out === 100'b1011110010110011101100010111100001101110100011111100010011011100101100001011001111101011011000001000)) begin
            $display("Mismatch at index 2: Inputs = [%b], Generated = [%b], Reference = [%b]", 100'b0001000001101101011111001101000011010011101100100011111100010111011000011110100011011100110100111101, out, 100'b1011110010110011101100010111100001101110100011111100010011011100101100001011001111101011011000001000);
            mismatch_count = mismatch_count + 1;
        end

        else begin
            $display("Test 2 passed!");
        end

        // Tick 3: Inputs = 100'b1101010001100010110111110111100011000111110011111101111010011111100111100011001101110010010011000110, Generated = out, Reference = 100'b0110001100100100111011001100011110011111100101111011111100111110001100011110111110110100011000101011
        in = 100'b1101010001100010110111110111100011000111110011111101111010011111100111100011001101110010010011000110; // Set input values
        #period;
        if (!(out === 100'b0110001100100100111011001100011110011111100101111011111100111110001100011110111110110100011000101011)) begin
            $display("Mismatch at index 3: Inputs = [%b], Generated = [%b], Reference = [%b]", 100'b1101010001100010110111110111100011000111110011111101111010011111100111100011001101110010010011000110, out, 100'b0110001100100100111011001100011110011111100101111011111100111110001100011110111110110100011000101011);
            mismatch_count = mismatch_count + 1;
        end

        else begin
            $display("Test 3 passed!");
        end

        // Tick 4: Inputs = 100'b0101110101010001001111010010101010100111001010101111111101111110010110111011110100100111001001110111, Generated = out, Reference = 100'b1110111001001110010010111101110110100111111011111111010101001110010101010100101111001000101010111010
        in = 100'b0101110101010001001111010010101010100111001010101111111101111110010110111011110100100111001001110111; // Set input values
        #period;
        if (!(out === 100'b1110111001001110010010111101110110100111111011111111010101001110010101010100101111001000101010111010)) begin
            $display("Mismatch at index 4: Inputs = [%b], Generated = [%b], Reference = [%b]", 100'b0101110101010001001111010010101010100111001010101111111101111110010110111011110100100111001001110111, out, 100'b1110111001001110010010111101110110100111111011111111010101001110010101010100101111001000101010111010);
            mismatch_count = mismatch_count + 1;
        end

        else begin
            $display("Test 4 passed!");
        end

        // Tick 5: Inputs = 100'b0010010001111110110011011011100011110111100100110000011010011111001011100111011101101001011011001110, Generated = out, Reference = 100'b0111001101101001011011101110011101001111100101100000110010011110111100011101101100110111111000100100
        in = 100'b0010010001111110110011011011100011110111100100110000011010011111001011100111011101101001011011001110; // Set input values
        #period;
        if (!(out === 100'b0111001101101001011011101110011101001111100101100000110010011110111100011101101100110111111000100100)) begin
            $display("Mismatch at index 5: Inputs = [%b], Generated = [%b], Reference = [%b]", 100'b0010010001111110110011011011100011110111100100110000011010011111001011100111011101101001011011001110, out, 100'b0111001101101001011011101110011101001111100101100000110010011110111100011101101100110111111000100100);
            mismatch_count = mismatch_count + 1;
        end

        else begin
            $display("Test 5 passed!");
        end

        // Tick 6: Inputs = 100'b1000111000101100101001001110110001010010111001011000010010010101110011011110100011100010100010111101, Generated = out, Reference = 100'b1011110100010100011100010111101100111010100100100001101001110100101000110111001001010011010001110001
        in = 100'b1000111000101100101001001110110001010010111001011000010010010101110011011110100011100010100010111101; // Set input values
        #period;
        if (!(out === 100'b1011110100010100011100010111101100111010100100100001101001110100101000110111001001010011010001110001)) begin
            $display("Mismatch at index 6: Inputs = [%b], Generated = [%b], Reference = [%b]", 100'b1000111000101100101001001110110001010010111001011000010010010101110011011110100011100010100010111101, out, 100'b1011110100010100011100010111101100111010100100100001101001110100101000110111001001010011010001110001);
            mismatch_count = mismatch_count + 1;
        end

        else begin
            $display("Test 6 passed!");
        end

        // Tick 7: Inputs = 100'b1101101100101010011100100110011001011011000111101111011000100110001100000101011100111000011100001010, Generated = out, Reference = 100'b0101000011100001110011101010000011000110010001101111011110001101101001100110010011100101010011011011
        in = 100'b1101101100101010011100100110011001011011000111101111011000100110001100000101011100111000011100001010; // Set input values
        #period;
        if (!(out === 100'b0101000011100001110011101010000011000110010001101111011110001101101001100110010011100101010011011011)) begin
            $display("Mismatch at index 7: Inputs = [%b], Generated = [%b], Reference = [%b]", 100'b1101101100101010011100100110011001011011000111101111011000100110001100000101011100111000011100001010, out, 100'b0101000011100001110011101010000011000110010001101111011110001101101001100110010011100101010011011011);
            mismatch_count = mismatch_count + 1;
        end

        else begin
            $display("Test 7 passed!");
        end

        if (mismatch_count == 0)
            $display("All tests passed!");
        else
            $display("%0d mismatches out of %0d total tests.", mismatch_count, 8);
        $finish;
    end

endmodule