/*======================================================
 * Modified: 5/29/26
 * Description: Variable delay counter.
 * Delay increases by 5 seconds per failed attempt.
=====================================================*/
module count_down(	clk,
							rst_n,
							clear,
							failed_attempts,
							ticks							
							);

	input 		clk, rst_n;
	input 		clear; //syncs the ticks 
	input [2:0]	failed_attempts;
	output 		ticks;
	
	localparam CLK_5_DELAY = (50_000_000 * 5);

	reg [31:0] 	count;
	reg 			ticks;

	reg [31:0]  target_delay; 

	always @(posedge clk or negedge rst_n or posedge clear)begin
			
		if(!rst_n || clear)begin
			count 				<= 32'b0;
			ticks					<= 1'b0;
			target_delay  	<= CLK_5_DELAY * (1 + failed_attempts);
		end else if (count >= target_delay -1)begin
			count 			<= 32'b0;
			ticks				<= 1'b1;
		end else begin
			count <= count + 1'b1;
			ticks  <= 1'b0;
		end
	end
endmodule
