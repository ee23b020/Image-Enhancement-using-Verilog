//-------------------Image enchancemnet using verilog----------------
module state_flow(clk,reset,start,done,data_signal);
    input done;
    input clk;
    input reset;
    input start;
    reg [1:0] current_state;
    reg start_proc;
    output reg data_signal;
    parameter start_state=2'b00, data_state=2'b01, done_state=2'b10;
    
    always @(posedge clk) begin
        if (start) begin
            start_proc <= 1;

            if (start_proc) begin
                current_state <= start_state;
            case(current_state) 
            2'b00: begin                       
                current_state <= data_state;
            end

            2'b01: begin 
                data_signal <=1;
                if (done) begin
                    current_state <= done_state;
                    data_signal <=0;
                end
                else begin
                    current_state <= data_state;
                end
                end
            2'b10:
                if (reset) begin
                    current_state <= start_state; 
                    start_proc <=0;
                end
        endcase
        end
        end
            
    end

endmodule

module image_proc#(parameter input_file="input_image.txt") (clk,done,data_signal,ofile,data_count);
    input clk;
    input data_signal;
    parameter total_pixels = 120000; 
    reg [7:0] mem [0:total_pixels-1];
    output reg done;
    input [31:0] data_count;
    integer i;
    input [31:0] ofile; 
    reg [7:0] val;
    reg [7:0] new_val;

    always @(posedge clk) begin
        if (data_signal) begin
            if (data_count == total_pixels) begin
                done <=1;
            end
        end
    end
    
  
endmodule

module bmp_write(clk,done);
 input done;
 input clk;
 parameter bmp_headersize = 54;
 parameter total_pixels = 120000; 
 parameter total_elements = total_pixels+ bmp_headersize;
 integer i;
 reg [31:0] file;
 reg [7:0] temp_mem [0:total_elements-1];
 

endmodule

