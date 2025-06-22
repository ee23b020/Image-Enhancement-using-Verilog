`timescale 1ms/1ns
`include "funcdef.v"

module imagetest;
reg clk;
reg reset;
reg start;
wire data_signal;
wire done;
reg [31:0] wfile;
reg [31:0] ofile;
reg [31:0] file;
reg [7:0] val;
reg [7:0] new_val;
integer data_count=0;
parameter total_pixels = 120000; 
parameter width = 1280;
parameter height = 833;
reg [7:0] mem [0:total_pixels-1];
integer i;
parameter value =150;
parameter bmp_headersize = 54;
parameter total_elements = total_pixels+ bmp_headersize;
reg [7:0] temp_mem [0:total_elements-1];
parameter input_file="input_image.txt";

state_flow  SF (clk,reset,start,done,data_signal);
image_proc IP  (clk,done,data_signal,ofile,data_count);
bmp_write BW (clk,done);
 
initial begin
    $dumpfile("imgfinal.vcd"); //for dumping the file foe gtkwavesimulation
    $dumpvars(0,imagetest);
end

initial begin
    clk=0;
    forever #10 clk =~clk;
end
initial begin 
    start=0;
    #5 start = ~start;
end
initial begin
    reset=0;
    #95 reset = ~reset;
end
initial begin
    #100 $finish;
end
//creating bmp file header for the output image
initial begin
        wfile=$fopen("try.txt","w");
        $fwrite(wfile,"%h\n",8'h42);
        $fwrite(wfile,"%h\n",8'h4d);
        $fwrite(wfile,"%h\n",8'hf6);
        $fwrite(wfile,"%h\n",8'hd4);
        $fwrite(wfile,"%h\n",8'h01);

        $fwrite(wfile,"%h\n",8'h00);
        $fwrite(wfile,"%h\n",8'h00);
        $fwrite(wfile,"%h\n",8'h00);
        $fwrite(wfile,"%h\n",8'h00);
        $fwrite(wfile,"%h\n",8'h00);

        $fwrite(wfile,"%h\n",8'h36);

        $fwrite(wfile,"%h\n",8'h00);
        $fwrite(wfile,"%h\n",8'h00);
        $fwrite(wfile,"%h\n",8'h00);

        $fwrite(wfile,"%h\n",8'h28);

        $fwrite(wfile,"%h\n",8'h00);
        $fwrite(wfile,"%h\n",8'h00);
        $fwrite(wfile,"%h\n",8'h00);

        $fwrite(wfile,"%h\n",8'hc8);

        $fwrite(wfile,"%h\n",8'h00);
        $fwrite(wfile,"%h\n",8'h00);
        $fwrite(wfile,"%h\n",8'h00);

        $fwrite(wfile,"%h\n",8'hc8);

        $fwrite(wfile,"%h\n",8'h00);
        $fwrite(wfile,"%h\n",8'h00);
        $fwrite(wfile,"%h\n",8'h00);

        $fwrite(wfile,"%h\n",8'h01);
        $fwrite(wfile,"%h\n",8'h00);
        $fwrite(wfile,"%h\n",8'h18);

        $fwrite(wfile,"%h\n",8'h00);
        $fwrite(wfile,"%h\n",8'h00);
        $fwrite(wfile,"%h\n",8'h00);
        $fwrite(wfile,"%h\n",8'h00);
        $fwrite(wfile,"%h\n",8'h00);
        $fwrite(wfile,"%h\n",8'h00);
        $fwrite(wfile,"%h\n",8'h00);
        $fwrite(wfile,"%h\n",8'h00);
        $fwrite(wfile,"%h\n",8'h00);
        $fwrite(wfile,"%h\n",8'h00);
        $fwrite(wfile,"%h\n",8'h00);
        $fwrite(wfile,"%h\n",8'h00);
        $fwrite(wfile,"%h\n",8'h00);
        $fwrite(wfile,"%h\n",8'h00);
        $fwrite(wfile,"%h\n",8'h00);
        $fwrite(wfile,"%h\n",8'h00);
        $fwrite(wfile,"%h\n",8'h00);
        $fwrite(wfile,"%h\n",8'h00);
        $fwrite(wfile,"%h\n",8'h00);
        $fwrite(wfile,"%h\n",8'h00);
        $fwrite(wfile,"%h\n",8'h00);
        $fwrite(wfile,"%h\n",8'h00);
        $fwrite(wfile,"%h\n",8'h00);
        $fwrite(wfile,"%h\n",8'h00);
        $fwrite(wfile,"%h\n",8'h00);
    $fclose(wfile);
    end
    initial begin
        $readmemh(input_file,mem,0,total_pixels-1);

    end
    `ifdef change_brightness 
    always @(posedge clk) begin
        if (data_signal) begin
        ofile = $fopen("try.txt","a");
        for(i=0;i<total_pixels;i=i+1)begin
            val = mem[i];
            mem[i] = val+value;
            new_val= mem[i];
        if(val+value >255) begin
                $fwrite(ofile,"%h\n",8'hff);
        end
        else begin 
                $fwrite(ofile,"%h\n",new_val);
        end
            data_count = data_count +1;
        end
        $fclose(ofile);
    end
    end
    initial begin
        file=$fopen("changed_brightness.bmp","wb+");
    end
    
    always @(done) begin
    if (done) begin
        $readmemh("try.txt",temp_mem,0,total_elements-1);
        for(i=0;i<total_elements;i=i+1) begin
             $fwrite(file,"%c",temp_mem[i]);
        end
        $display("Output image generated!");
    end
    end
    `endif 
     
    `ifdef invert
    always @(posedge clk) begin
        if (data_signal) begin
        ofile = $fopen("try.txt","a");
        for(i=0;i<total_pixels;i=i+3)begin
            val = (mem[i]+mem[i+1]+mem[i+2])/3;
            mem[i] = 255-val;
            mem[i+1] = 255-val;
            mem[i+2] = 255-val;
            $fwrite(ofile,"%h\n",mem[i]);
            $fwrite(ofile,"%h\n",mem[i+1]);
            $fwrite(ofile,"%h\n",mem[i+2]);
        
            data_count = data_count +3;
        end
        $fclose(ofile);
    end
    end
    initial begin
        file=$fopen("iverted.bmp","wb+");
    end
    
    always @(done) begin
    if (done) begin
        $readmemh("try.txt",temp_mem,0,total_elements-1);
        for(i=0;i<total_elements;i=i+1) begin
             $fwrite(file,"%c",temp_mem[i]);
        end
        $display("Output image generated!");
    end
    end
    `endif


endmodule 