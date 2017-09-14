`timescale 1ns / 2ns
`default_nettype none

//combination lock FSM using behavioral verilog
module combination_lock_fsm(
	output reg [2:0] state,
	output wire Locked,//asserted when locked
	input wire Right, Left,//direction
	input wire [4:0] Count,//position
	input wire Center,//unlock button
	input wire Clk, South//clock and reset
);

	reg [2:0] nextState;
	
	parameter S0 = 3'b000,
			  S1 = 3'b001,
			  S2 = 3'b010,
			  S3 = 3'b011,
			  S4 = 4'b100;

	always@(*)//combinational	
		case(state)
			S0: begin
				if(Right)
					nextState = S1;
				else
					nextState = S0;
			end
			S1: begin
				if(Left&&Count==5'b01101)//13
					nextState = S2;
				else if(Left&&Count!=5'b01101)
					nextState = S0;
				else
					nextState = S1;
			end
			S2: begin
				if(Right&&Count==5'b00111)//7
					nextState = S3;
				else if(Right&&Count!=5'b00111)
					nextState = S0;
				else
					nextState = S2;
			end
			S3: begin
				if(Center&&Count==5'b10001)//17
					nextState = S4;
				else if(Center&&Count!=5'b10001)
					nextState = S0;
				else
					nextState = S3;
			end
			S4: begin
			
			Locked = 1'b0;
			
			end		
		endcase	
	always@(posedge Clk) begin//synchronous logic
		if(reset)//reset state
			state <= S0;
			Locked = 1'b1;
		else
			state <= nextState;
	
	//output logic
	assign Count = state;
	
endmodule
		
		