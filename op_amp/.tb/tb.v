module tb_opamp;
    reg clk;
    reg pin1, pin5, pin8;
    reg signed [15:0] pin2, pin3, pin4, pin7;
    wire signed [15:0] pin6;
    
    integer test_passed;
    integer test_failed;
    integer total_tests;
    
    // Instantiate the op-amp
    op_amp uut(
        .pin1_offset_null(pin1),
        .pin2_inv_input(pin2),
        .pin3_noninv_input(pin3),
        .pin4_vee(pin4),
        .pin5_offset_null(pin5),
        .pin6_output(pin6),
        .pin7_vcc(pin7),
        .pin8_nc(pin8),
        .clk(clk)
    );
    
    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;
    
    initial begin
        test_passed = 0;
        test_failed = 0;
        total_tests = 0;
        
        $display("========================================");
        $display("   OPERATIONAL AMPLIFIER IC TEST");
        $display("========================================");
        $display("Starting IC verification...\n");
        
        // Setup power supplies
        pin7 = 16'd15000;   // +15V
        pin4 = -16'd15000;  // -15V
        pin1 = 0;
        pin5 = 0;
        pin8 = 0;
        pin2 = 0;
        pin3 = 0;
        
        $display("Power Supply Configuration:");
        $display("  Pin 7 (VCC): +15V");
        $display("  Pin 4 (VEE): -15V\n");
        
        #50;  // Wait for initialization
        
        $display("Test# | Pin2(-) | Pin3(+) | Pin6(Out) | Status");
        $display("------|---------|---------|-----------|--------");
        
        // Test 1: Small positive difference
        total_tests = total_tests + 1;
        pin2 = 16'd100;
        pin3 = 16'd110;
        #50;
        if (pin6 > 0) begin
            $display("  1   |  %5d  |  %5d  |  %6d   | PASS", pin2, pin3, pin6);
            test_passed = test_passed + 1;
        end else begin
            $display("  1   |  %5d  |  %5d  |  %6d   | FAIL", pin2, pin3, pin6);
            test_failed = test_failed + 1;
        end
        
        // Test 2: Small negative difference
        total_tests = total_tests + 1;
        pin2 = 16'd110;
        pin3 = 16'd100;
        #50;
        if (pin6 < 0) begin
            $display("  2   |  %5d  |  %5d  |  %6d   | PASS", pin2, pin3, pin6);
            test_passed = test_passed + 1;
        end else begin
            $display("  2   |  %5d  |  %5d  |  %6d   | FAIL", pin2, pin3, pin6);
            test_failed = test_failed + 1;
        end
        
        // Test 3: Positive saturation
        total_tests = total_tests + 1;
        pin2 = 16'd0;
        pin3 = 16'd500;
        #50;
        if (pin6 > 12000 && pin6 < 14000) begin
            $display("  3   |  %5d  |  %5d  |  %6d   | PASS (Sat+)", pin2, pin3, pin6);
            test_passed = test_passed + 1;
        end else begin
            $display("  3   |  %5d  |  %5d  |  %6d   | FAIL", pin2, pin3, pin6);
            test_failed = test_failed + 1;
        end
        
        // Test 4: Negative saturation
        total_tests = total_tests + 1;
        pin2 = 16'd500;
        pin3 = 16'd0;
        #50;
        if (pin6 < -12000 && pin6 > -14000) begin
            $display("  4   |  %5d  |  %5d  |  %6d   | PASS (Sat-)", pin2, pin3, pin6);
            test_passed = test_passed + 1;
        end else begin
            $display("  4   |  %5d  |  %5d  |  %6d   | FAIL", pin2, pin3, pin6);
            test_failed = test_failed + 1;
        end
        
        // Test 5: Equal inputs (zero output test)
        total_tests = total_tests + 1;
        pin2 = 16'd200;
        pin3 = 16'd200;
        #50;
        if (pin6 > -1000 && pin6 < 1000) begin
            $display("  5   |  %5d  |  %5d  |  %6d   | PASS (Zero)", pin2, pin3, pin6);
            test_passed = test_passed + 1;
        end else begin
            $display("  5   |  %5d  |  %5d  |  %6d   | FAIL", pin2, pin3, pin6);
            test_failed = test_failed + 1;
        end
        
        // Test 6: Both inputs at zero
        total_tests = total_tests + 1;
        pin2 = 16'd0;
        pin3 = 16'd0;
        #50;
        if (pin6 > -1000 && pin6 < 1000) begin
            $display("  6   |  %5d  |  %5d  |  %6d   | PASS", pin2, pin3, pin6);
            test_passed = test_passed + 1;
        end else begin
            $display("  6   |  %5d  |  %5d  |  %6d   | FAIL", pin2, pin3, pin6);
            test_failed = test_failed + 1;
        end
        
        // Display results
        #50;
        $display("\n========================================");
        $display("         TEST SUMMARY");
        $display("========================================");
        $display("Total Tests Run    : %0d", total_tests);
        $display("Tests Passed       : %0d", test_passed);
        $display("Tests Failed       : %0d", test_failed);
        $display("Success Rate       : %0d%%", (test_passed * 100) / total_tests);
        $display("========================================");
        
        if (test_failed == 0) begin
            $display("\n*** IC IS WORKING PROPERLY ***");
            $display("All tests passed successfully!");
        end else begin
            $display("\n*** IC HAS ISSUES ***");
            $display("Some tests failed. Please check the design.");
        end
        
        $display("\nSimulation completed at time: %0t", $time);
        $display("========================================\n");
        
        // Keep ModelSim open - use $stop instead of $finish
        $stop;
    end
    
endmodule 