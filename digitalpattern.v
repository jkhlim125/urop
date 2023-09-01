module digitalpattern (
    input wire clk,                       
    input wire reset,                     
    input wire [2:0] patterns,             
    input wire [2:0] trigger_conditions,  
    input wire enable_analyzer,           
    output reg [2:0] generated_patterns,  
    output wire match_detected            
);

    reg [2:0] current_pattern;         
    reg [2:0] count;                   
    reg generate_pattern;            
    reg analyze_pattern;               
    reg match_detected_internal;       

    always @(posedge clk or posedge reset) begin
        if (reset == 1'b1) begin
            current_pattern <= 3'b000;
            count <= 3'b000;
            generate_pattern <= 1'b0;
            match_detected_internal <= 1'b0;
        end else begin
            if (trigger_conditions != 3'b000) begin
                generate_pattern <= 1'b1;
            end
            if (generate_pattern) begin
                if (count == 3'b000)
                    current_pattern <= patterns;
                else if (count == 3'b011)
                    current_pattern <= 3'b000;
                else
                    current_pattern <= current_pattern << 1;
                    
                count <= count + 1;
            end
            
            if (enable_analyzer) begin
                if (current_pattern == patterns) begin
                    analyze_pattern <= 1'b1;
                end else begin
                    analyze_pattern <= 1'b0;
                end
            end
            
            match_detected_internal <= analyze_pattern & (patterns != 3'b000);
        end
    end

    always @* begin
        if (generate_pattern)
            generated_patterns <= current_pattern;
        else
            generated_patterns <= 3'b000;
    end

    assign match_detected = match_detected_internal;

endmodule