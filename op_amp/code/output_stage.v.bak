module output_stage(
    input wire clk,
    input wire signed [15:0] input_signal,
    input wire signed [15:0] vcc,
    input wire signed [15:0] vee,
    output reg signed [15:0] final_output
);

    wire signed [15:0] vcc_limit;
    wire signed [15:0] vee_limit;
    
    // Output cannot exceed supply rails (with margin)
    assign vcc_limit = vcc - 16'd2000;  // 2V margin from +rail
    assign vee_limit = vee + 16'd2000;  // 2V margin from -rail
    
    always @(posedge clk) begin
        if (input_signal > vcc_limit)
            final_output <= vcc_limit;
        else if (input_signal < vee_limit)
            final_output <= vee_limit;
        else
            final_output <= input_signal;
    end

endmodule 