`include "digitalpattern.v"
module digitalpattern_tb;

    parameter CLK_PERIOD = 10; 
    
    reg clk;                            
    reg reset;                           
    reg [2:0] patterns;                  
    reg [2:0] trigger_conditions;        
    reg enable_analyzer;                 
    wire [2:0] generated_patterns;       
    wire match_detected;                 

    digitalpattern_tb dut (
        .clk(clk),
        .reset(reset),
        .patterns(patterns),
        .trigger_conditions(trigger_conditions),
        .enable_analyzer(enable_analyzer),
        .generated_patterns(generated_patterns),
        .match_detected(match_detected)
    );

    always begin
        clk = 0;
        #((CLK_PERIOD)/2);
        clk = 1;
        #((CLK_PERIOD)/2);
    end

    initial begin
        reset = 1;
        patterns = 0;
        trigger_conditions = 0;
        enable_analyzer = 0;
        
        $dumpfile("digitalpattern_tb.vcd");
        $dumpvars(0, digitalpattern_tb);
        
        #10;
        
        reset = 0;
        
        // Test Scenario 1: No trigger conditions, analyzer disabled
        #20;
        $display("Test Scenario 1: No trigger conditions, analyzer disabled");
        $display("Generated Patterns: %b", generated_patterns);
        $display("Match Detected: %b", match_detected);
        
        // Test Scenario 2: Random trigger conditions, analyzer disabled
        trigger_conditions = $random;
        #20;
        $display("Test Scenario 2: Random trigger conditions, analyzer disabled");
        $display("Generated Patterns: %b", generated_patterns);
        $display("Match Detected: %b", match_detected);
        
        // Test Scenario 3: Random trigger conditions, analyzer enabled, random patterns
        trigger_conditions = $random;
        enable_analyzer = 1;
        patterns = $random;
        #20;
        $display("Test Scenario 3: Random trigger conditions, analyzer enabled, random patterns");
        $display("Generated Patterns: %b", generated_patterns);
        $display("Match Detected: %b", match_detected);
        
        // Test Scenario 4: Random trigger conditions, analyzer enabled, matched patterns
        trigger_conditions = $random;
        enable_analyzer = 1;
        patterns = generated_patterns;
        #20;
        $display("Test Scenario 4: Random trigger conditions, analyzer enabled, matched patterns");
        $display("Generated Patterns: %b", generated_patterns);
        $display("Match Detected: %b", match_detected);
        
        // Test Scenario 5: Random trigger conditions, analyzer enabled, mismatched patterns
        trigger_conditions = $random;
        enable_analyzer = 1;
        patterns = ~generated_patterns;
        #20;
        $display("Test Scenario 5: Random trigger conditions, analyzer enabled, mismatched patterns");
        $display("Generated Patterns: %b", generated_patterns);
        $display("Match Detected: %b", match_detected);
        
        $finish;
    end

endmodule