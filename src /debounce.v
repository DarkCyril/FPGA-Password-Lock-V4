/*======================================================
 * Modified: 5/29/26
 * Description: Debounces a noisy input by sampling every 20 ms
      and outputs a one-clock pulse on a falling edge.
=====================================================*/
module debounce(	clk,
						rst_n,
						noisy,
						clean
						);

	input clk, rst_n;
	input noisy;
	output clean;
	
	reg clean;
	
	reg curkey;
	reg prekey;
	
	reg [31:0] cnt;
	reg tick_ctrl;
	
	localparam CLK_2_DELAY = (1_000_000 ); // 20 miliseconds 
	
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			cnt <= 32'b0;
			tick_ctrl <= 1'b0;
		end else if (cnt >= CLK_2_DELAY - 1)begin
			cnt <= 32'b0;
			tick_ctrl <= 1'b1;
		end else begin
			cnt <= cnt + 1'b1;
			tick_ctrl <= 1'b0;
		end
	end
	
	always@(posedge clk)begin
		clean <= 1'b0;
		
		if(tick_ctrl)begin
			curkey <= noisy;
			prekey <= curkey;
			
			clean <= (curkey == 1'b0) && (prekey == 1'b1);
		end 
	end
	

endmodule
