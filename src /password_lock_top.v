/*=======================================
* Author: Fcyril
* Date Created: 5/18/26
* Modified: 6/10/26
* 
* Description: Top File 
*
* Board: Intel MAX10 DE10-Lite
=======================================*/
module password_lock_top( MAX10_CLK1_50,
								  SW,
								  KEY,
								  HEX0,
								  LEDR,
								  GPIO
								  );
								  
	input 				MAX10_CLK1_50; 
	input		[9:0]		SW;
	input		[1:0]		KEY;
	output	[9:0] 	LEDR;
	output 	[7:0] 	HEX0;
	output	[35:0] 	GPIO;
	
	//----Reset----
	wire rst_n;
	assign rst_n = KEY[0];
	
	//----Enter----
	wire enter;
	assign enter = clean;
	
	//----Ticks----
	wire ticks;
	
	//----Mode----
	wire mode;
	assign mode = SW[9];
	
	//----Pin_In----
	wire [3:0] pin_in;
	assign pin_in = SW[3:0];
	
	
	//----Debouncing---- 
	wire noisy;
	assign noisy = KEY[1];
	
	wire clean;
	
	//----Delay increase w/t wrong attempts----
	wire [2:0] failed_attempts;

	//----Clear (Syncs ticks) ----
	wire clear;
	
	//----GPIO----
	wire solenoid;
	assign  GPIO[0] = solenoid;
	
	//----reload----
	wire reload;
	
	//----clearpwm-----
	wire clearpwm;
	
	
	count_down U0(	.clk(MAX10_CLK1_50),
						.rst_n(rst_n),
						.clear(clear),
						.failed_attempts(failed_attempts),
						.ticks(ticks)
						);
						
						
	password_fsm U1(	.clk(MAX10_CLK1_50),
							.rst_n(rst_n),
							.mode(mode),
							.enter(enter),
							.ticks(ticks),
							.pin_in(pin_in),
							.led(LEDR),
							.failed_attempts(failed_attempts),
							.reload(reload),
							.clear(clear),
							.clearpwm(clearpwm),
							.GPIO(solenoid)
							);
							

	hexdisplay U3(	.inv(1'b1), 
						.bin(failed_attempts), 
						.a(HEX0[0]), 
						.b(HEX0[1]), 
						.c(HEX0[2]), 
						.d(HEX0[3]), 
						.e(HEX0[4]), 
						.f(HEX0[5]), 
						.g(HEX0[6])
						);
						
	assign HEX0[7] = 1'b1; //Decimal Point --> OFF
	
	debounce U4(	.clk(MAX10_CLK1_50),
						.rst_n(rst_n),
						.noisy(noisy),
						.clean(clean)
						);
	
	powersaving_mode U5 (	.clk(MAX10_CLK1_50),
									.rst_n(rst_n),
									.enable(1'b1),
									.clearpwm(clearpwm),
									.reload(reload)
									);

	
endmodule			
