/*====================================
* Modified: 6/10/2026
* Description: Generates 40% duty-cycle PWM
*              for solenoid power-saving mode.
*              PWM counter resets using clearpwm
*              so the waveform starts from count 0
*              when entering S_UNBLK.
=======================================*/
module powersaving_mode( clk,
                         rst_n,
                         enable,
                         reload,
                         clearpwm
                         );

    input  clk, rst_n;
    input  enable;
    input  clearpwm;

    output reload;

    localparam PWM_PERIOD = 50_000;
    localparam DUTY_40    = (PWM_PERIOD * 40) / 100; //40% Duty Cycle

    localparam HOLD = 20;
    reg [4:0] count_hold;
    reg count_hold_done;

    reg [15:0] count; //only needs 50_000!! 2^16 - 1 = 65,535
    reg reload;

    always @(posedge clk or negedge rst_n or posedge clearpwm) begin
    if ((!rst_n) || (clearpwm)) begin
        count <= 16'b0;
        reload <= 1'b0;
        count_hold <= 5'd0;
        count_hold_done <= 1'b0;
    end else if (!enable) begin
        count <= 16'b0;
        reload <= 1'b0;
		  count_hold_done <= 1'b0;
		  count_hold <= 5'b0;
    end else begin
        if (count >= PWM_PERIOD - 1) begin
            count <= 16'b0;
            count_hold <= count_hold + 5'b1;
        end else if (count_hold == HOLD) begin
            count_hold <= 5'b0;
            count_hold_done <= 1'b1;
        end else begin
            count <= count + 16'b1;
            count_hold <= count_hold;
        end

        if (!count_hold_done) begin
            reload <= 1'b1;
        end else begin
            reload <= (count < DUTY_40);
        end
    end
end

endmodule
