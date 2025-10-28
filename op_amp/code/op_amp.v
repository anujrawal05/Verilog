module op_amp(
    input wire pin1_offset_null,        // Pin 1: Offset Null
    input wire signed [15:0] pin2_inv_input,      // Pin 2: Inverting Input (-)
    input wire signed [15:0] pin3_noninv_input,   // Pin 3: Non-Inverting Input (+)
    input wire signed [15:0] pin4_vee,            // Pin 4: Negative Supply (-VEE)
    input wire pin5_offset_null,        // Pin 5: Offset Null
    output wire signed [15:0] pin6_output,        // Pin 6: Output
    input wire signed [15:0] pin7_vcc,            // Pin 7: Positive Supply (+VCC)
    input wire pin8_nc,                 // Pin 8: No Connection
    input wire clk                      // Clock for synchronous operation
);

    // Internal signals
    wire signed [15:0] diff_out;
    wire signed [15:0] gain_out;
    wire signed [15:0] final_out;
    
    // Instantiate differential input stage
    diff_amplifier diff_stage(clk, pin3_noninv_input, pin2_inv_input, pin1_offset_null,
	                            pin5_offset_null, diff_out);
    
    // Instantiate gain stage
    gain_stage gain_block(clk, diff_out, gain_out);
    
    // Instantiate output stage with saturation
    output_stage out_block(clk, gain_out, pin7_vcc, pin4_vee, final_out);
    
    assign pin6_output = final_out;

endmodule 