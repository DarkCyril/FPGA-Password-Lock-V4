/*====================================
* Modified: 6/2/2026
* Description: Handles Finite State Machine:
*      State Register, Next State,
*          and Output Logic
=======================================*/

module password_fsm(	clk,
							rst_n,
							mode,
							enter,
							ticks,
							pin_in,
							led,
							reload,
							failed_attempts,
							clear,
							clearpwm,
							GPIO
							);
							
	input 			clk, rst_n;
	input				mode;
	input 			enter;
	input 			ticks;
	input				reload; 
	input [3:0]		pin_in; //Connection to hardware to input 
	
	output[31:0] 	GPIO; //GPIO connection 
	
	output reg[9:0] led;
	output reg[2:0] failed_attempts;
	
	output clear;
	output clearpwm;

		
	reg [3:0] saved_pin; //Factory Reset Pin 1010 
	reg [3:0] enter_pin; //User input 
	
	reg [2:0]	curState;
	reg [2:0]	nextState;

	localparam 	S_IDLE 	= 3'b000,
					S_SET  	= 3'b001,
					S_INPUT	= 3'b010,
					S_CHK		= 3'b011,
					S_BLK		= 3'b100,
					S_UNBLK  = 3'b101;
					
	assign clear = (curState == S_CHK); 
	assign clearpwm = (curState != S_UNBLK && nextState == S_UNBLK);
	
	assign GPIO = (curState == S_UNBLK) ? reload: 0;	
	//==========State Register==========
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			curState <= S_IDLE;
			saved_pin <=  4'b1010;
			failed_attempts <= 3'b0;
		end else begin
			curState <= nextState;
			if(curState == S_SET && enter) begin
				saved_pin <= pin_in;
			end
			
			if(curState == S_INPUT && enter)begin
				enter_pin <= pin_in;
			end
			
			if(curState == S_BLK && ticks)begin
				if(failed_attempts < 3'b111)begin
					failed_attempts <= failed_attempts + 3'b1;
				end 
			end
			
			if(curState == S_UNBLK) begin
				failed_attempts <= 3'b0;
			end 
		end
	end
	
	//==========Next State==========
	always@(*)begin
		case (curState)
			S_IDLE:  begin
				if(mode && enter)begin
					nextState = S_SET; //Allows the user to change the password
				end else if (!mode && enter) begin
					nextState = S_INPUT; //Allows the user to input their guess 
				end else begin
					nextState = S_IDLE;
				end
			end
			
			S_SET:	begin
				if(enter) nextState = S_IDLE;
				else 		 nextState = S_SET;
			end
			
			S_INPUT:	begin		
			if(enter) nextState = S_CHK;
			else 		 nextState = S_INPUT;
			
			end
			
			S_CHK:	begin
				if(saved_pin == enter_pin)	begin
					nextState = S_UNBLK;
				end else	begin
					nextState = S_BLK;
				end
			end
			
			S_BLK:	begin
				if(ticks)	begin
					nextState = S_IDLE;
				end else
					nextState = S_BLK;
			end
			
			S_UNBLK:	begin
				if(enter || ticks)	begin
					nextState = S_IDLE;
				end else begin
					nextState = S_UNBLK;
				end
			end
			
			default: nextState = S_IDLE;			
		endcase
	end

	always@(*) begin
		led = 10'b00_0000_0000;  
		case(curState)
			S_IDLE: led[0] = 1'b1;
			S_SET:  led[1] = 1'b1;
			S_INPUT:led[2] = 1'b1;
			S_CHK:  led[3] = 1'b1;		
			S_BLK:  led[8] = 1'b1;		
			S_UNBLK:led[9] = 1'b1; 
			default: led = 10'b00_0000_0000;
		endcase
	end 
	
endmodule
