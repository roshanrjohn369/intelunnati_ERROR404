module atpmachroshbless_tb;

reg clk,rst,scan, cashop,cheqop;
reg [9:0] IA;
reg stop;
wire [9:0] BAO;
wire [9:0] EXCSO; 


  
atpmachroshbless dut (.clk(clk),.rst(rst),.scan(scan),.cashop(cashop),.cheqop(cheqop),.IA(IA),.stop(stop),.BAO(BAO),
.EXCSO(EXCSO) );

  always #5 clk = ~clk;
  
  // Initialize signals
  initial begin
   $monitor($time,"clk=%b,rst=%b,scan=%b,cashop=%b,cheqop=%b,IA=%d,stop=%b,BAO=%d,EXCSO=%d",clk,rst,scan,cashop,cheqop,IA,stop,BAO,EXCSO); 

    clk = 1;
    rst = 1;
	 scan = 0;
    cashop = 0;
    cheqop = 0;
    IA = 0;
	 stop = 0;
	
   
//cash state 
#5
rst=0;
scan =1;
cashop=0;
cheqop = 0;
IA=0;
stop = 0;
#5
rst=0;
scan =0;
cashop=1;
cheqop = 0;
IA=10'd50;
stop = 0;
#25
rst=0;
scan =0;
cashop=1;
cheqop = 0;
IA=0;
stop = 1;
#10
//cheque state 
rst = 1;
scan = 0;
cashop = 0;
cheqop = 0;
IA = 0;
stop = 0;
#5
rst=0;
scan =1;
cashop=0;
cheqop = 0;
IA=0;
stop = 0;
#10
rst=0;
scan =0;
cashop=0;
cheqop = 1;
IA=10'd5;
stop = 0;
#35



$finish;
end
endmodule
