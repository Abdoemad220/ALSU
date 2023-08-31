module ALSU_tb;
parameter INPUT_PERIORITY_tb = "A";
parameter FULL_ADDER_tb = "ON";
reg CLK_tb, RST_n_tb;
reg cin_tb, serial_in_tb, direction_tb, red_op_A_tb, red_op_B_tb, bypass_A_tb, bypass_B_tb;
reg [2:0] A_tb, B_tb, opcode_tb;
wire[5:0]  out_tb;
wire[15:0] leds_tb;

integer i;

ALSU #(.INPUT_PERIORITY(INPUT_PERIORITY_tb),.FULL_ADDER(FULL_ADDER_tb)) dut (.CLK(CLK_tb),.RST_n(RST_n_tb),.cin(cin_tb), .serial_in(serial_in_tb), .direction(direction_tb), .red_op_A(red_op_A_tb), .red_op_B(red_op_B_tb), .bypass_A(bypass_A_tb), .bypass_B(bypass_B_tb),.A(A_tb),.B(B_tb),.opcode(opcode_tb),.out(out_tb),.leds(leds_tb));

    always    #2 CLK_tb <= ~ CLK_tb;
    always    #15 RST_n_tb <= ~RST_n_tb;

    initial begin
        CLK_tb <= 0;
        RST_n_tb <=1;
        for (i=0 ;i<50 ;i=i+1 ) begin
      
        A_tb <= $random;
        B_tb <= $random;
        opcode_tb <= $random;
        cin_tb<=$random;
        serial_in_tb<=$random;
        direction_tb<=$random;
        red_op_A_tb<=$random;
        red_op_B_tb<=$random;
        bypass_A_tb<=$random;
        bypass_B_tb<=$random;

        #8;
        end
        $stop;

      
    end
endmodule
