
/*======================================================
 * Modified: 5/29/26
 * Description: 7-Segment Display Driver.
 *   Decodes a 4-bit binary input (0-F) into the
 *   corresponding 7-segment encoding. Supports active
 *   high and active low displays via the inv control.
 *   inv = 0: active high | inv = 1: active low
=====================================================*/

module hexdisplay(	inv, 
							bin, 
							a, 
							b, 
							c, 
							d, 
							e, 
							f, 
							g
							);

	input 		inv;
	input	[3:0]	bin;
	output a,b,c,d,e,f,g;

	reg [6:0] seg;
	assign {g,f,e,d,c,b,a} = (inv == 1'b0)? seg: ~seg; 
	
always@(*)begin
	case(bin)
		4'h0: seg = 7'b011_1111;
		4'h1: seg = 7'b000_0110;
		4'h2: seg = 7'b101_1011;
		4'h3: seg = 7'b100_1111;
		4'h4: seg = 7'b110_0110;
		4'h5: seg = 7'b110_1101;
		4'h6: seg = 7'b111_1101;
		4'h7: seg = 7'b000_0111;
		4'h8: seg = 7'b111_1111;
		4'h9: seg = 7'b110_1111;
		4'hA: seg = 7'b111_0111;
		4'hB: seg = 7'b111_1100;
		4'hC: seg = 7'b011_1001;
		4'hD: seg = 7'b101_1110;
		4'hE: seg = 7'b111_1001;
		4'hF: seg = 7'b111_0001;
		
		default: seg =  7'b000_0000;
	endcase
end	


endmodule 
