module atpmachroshbless(
input wire clk,rst,scan,cashop,cheqop,
input [9:0] IA,
input stop,
output reg [9:0] BAO
,output reg [9:0] EXCSO  
);

reg [9:0] BA;
reg  [9:0] EXCS;  
reg [2:0] cstate;
reg [2:0] nstate; 
parameter [2:0] START = 3'b000;
parameter [2:0] INFO_MODE = 3'b001;
parameter [2:0] CASH = 3'b010;
parameter [2:0] CHE_DD_PAYO = 3'b011;
parameter [2:0] WAITING_CASH = 3'b100;
parameter [2:0] INSUFF = 3'b101;
parameter [2:0] WAITING_CHE_DD_PAYO = 3'b110;
parameter [2:0] COMPLETED = 3'b111;

 
always @ (posedge clk or posedge rst) begin
if (rst) begin
cstate <= START;
end else begin
cstate <= nstate;
end
end
always @ (*) begin
if (rst) begin
BAO = 0;
EXCSO = 0;
nstate <= START;
end else begin
case (cstate)
START: begin

$display(" Welcome to Any Time Electric Bill Payment System");
$display("Please Show your bill at the scanner");
if (scan) begin
BA=10'd100;
EXCS=10'd0;
nstate <= INFO_MODE;
end else begin
nstate <= START;
end
end

INFO_MODE: begin
$display(" USER NAME:------------");
$display(" BILL AMOUNT:%d",BA);
$display(" EXCESS AMOUNT LEFT:%d",EXCS);
$display(" BILL NO:------------");
$display(" SELECT YOUR MODE OF PAYMENT:------------");
 if (cashop) begin
nstate <= CASH;
 end else if (cheqop) begin
nstate <= CHE_DD_PAYO;
end else begin
nstate <= INFO_MODE;
end
end

CASH: begin
$display(" INSERT YOUR CASH AT CASH ACCEPTOR ");
$display("----------------------PLEASE NOTE-------------------------");
 $display(" #Denominations of Rupees 1000, 500, 100, 50, 20, 10, 5 are accepted.(Only Notes are accepted)");
$display(" #Insert a single note at a time.");
$display(" #Please do not use soiled, torn, wet, oiled notes and coins.");
$display(" #Excess amount Paid will be adjusted in the subsequent cycles.");
 $display(" #Any short payment will lead to disconnection of your electricity line without any information");
 $display(" CURRENT BILL AMOUNT:%d",BA);
if (IA) begin
nstate <= WAITING_CASH;
end 
else begin
nstate <= CASH;
end
end

CHE_DD_PAYO: begin
$display(" INSERT YOUR CHEQUE/DD/PAY ORDER AT THE ACCEPTOR ");
$display("----------------------------PLEASE NOTE-----------------------------");
$display(" #Excess amount Paid will be adjusted in the subsequent cycles.");
$display(" #Any short payment will lead to disconnection of your electricity line without any information");
$display(" CURRENT BILL AMOUNT:%d",BA);
if(IA) begin
nstate <= WAITING_CHE_DD_PAYO;
end
else begin
nstate <=CHE_DD_PAYO;
end
end


WAITING_CASH: begin
$display(" #Input another note.");
$display(" CURRENT BILL AMOUNT:%d",BA);
if ((IA == 10'd1000) || (IA == 10'd500) || (IA == 10'd100) || (IA == 10'd50) || (IA == 10'd20) || (IA == 10'd10) || (IA == 10'd5)&& IA <= BA) begin
BA = BA - EXCS - IA ;
nstate <=WAITING_CASH;
end
else if (stop) begin
BA= ~BA;
nstate <= INSUFF;
end
 else
 begin
 BA = BA- EXCS - IA ;
nstate <= COMPLETED;
end
end

INSUFF: begin
BAO <= ~BA;
$display(" Remaining bill amount = %d", BAO);
  $display(" #If not paid to the sufficient bill amount within 10 days from today, your connection will be disconnected without any information.");
nstate <= START;
end

WAITING_CHE_DD_PAYO: begin
$display(" #Enter account_number , date , amount as on the payment instrument inserted.");
BA = BA- EXCS - IA ;
BA= ~BA;
if (IA < BA) begin
nstate <= INSUFF;
end else begin
BA= ~BA;
nstate <= COMPLETED;
end
end

COMPLETED: begin
EXCS <= ~BA;
EXCSO <= EXCS;
$display("Excess amount: %d", EXCSO);
$display(" CURRENT BILL AMOUNT:0");
$display(" #Please collect your receipt");
$display(" THANK YOU ");
nstate <= START;
end
endcase
end 
end
endmodule


