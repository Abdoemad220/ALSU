module ALSU_me #(parameter INPUT_PERIORITY = "A" ,parameter FULL_ADDER = "ON"  ) 
(
    input [2:0] A,
    input [2:0] B,
    input [2:0] opcode,
    input       cin   ,
    input    serial_in,
    input    direction,
    input   red_op_A  ,
    input   red_op_B  ,
    input   bypass_A  ,
    input   bypass_B  ,
    input   CLK       ,
    input   RST_n     ,
    output  reg [5:0]out   ,
    output  reg [15:0]leds  
);

reg cin_reg, serial_in_reg, direction_reg, red_op_A_reg, red_op_B_reg, bypass_A_reg, bypass_B_reg;
reg [2:0] A_reg, B_reg, opcode_reg,Counter;
always @(posedge CLK or negedge RST_n) begin
   if (!RST_n) begin
        out  <= 6'b0;
        leds <= 16'b0; 
    end
    else begin
A_reg <= A;
B_reg <= B;
opcode_reg <= opcode;
cin_reg <= cin ;
serial_in_reg <= serial_in;
direction_reg <= direction;
red_op_A_reg  <= red_op_A;
red_op_B_reg  <= red_op_B;
bypass_A_reg  <= bypass_A;
bypass_B_reg  <= bypass_B;
    end 

end


always @(posedge CLK or negedge RST_n) begin
    if (!RST_n) begin
        out  <= 6'b0;
        leds <= 16'b0; 
        Counter <=0;
    end
else if(!Counter)
begin

     if (bypass_A_reg && bypass_B_reg) begin
        if (INPUT_PERIORITY == "A") begin
            out <= A_reg   ;
            leds <= 16'b0  ;
        end
        else begin
            out <= B   ;
            leds <= 16'b0  ;
        end
    end
    else if (bypass_A_reg) begin
        out <= A   ;
        leds <= 16'b0  ;
    end 
     else if (bypass_B_reg) begin
        out <= B   ;
        leds <= 16'b0  ;
    end
    else begin
    case (opcode_reg)
        3'b000 : begin
            if (red_op_A_reg && red_op_B_reg) begin
                if (INPUT_PERIORITY=="A") begin
                    out  <= &A_reg;
                end
                else begin
                    out  <= &B_reg;
                end
            end
            else if (red_op_A_reg) begin
                out  <= &A_reg;
            end
            else if (red_op_B_reg) begin
                out  <= &B_reg;
            end
            else out  <= A_reg & B_reg;
            leds <= 16'b0  ;
        end 
       3'b001 :begin
            if (red_op_A_reg && red_op_B_reg) begin
                if (INPUT_PERIORITY== "A" ) begin
                    out  <= ^A_reg;
                end
                else begin
                    out  <= ^B_reg;
                end
            end
         if (red_op_A_reg) begin
                out  <= ^A_reg;
            end
            else if (red_op_B_reg) begin
                out  <= ^B_reg;
            end
            else out  <= A_reg^B_reg;
            leds <= 16'b0  ;
             out  <= A_reg^B_reg;
             leds <= 16'b0  ;
        end
        3'b010:begin
            if (red_op_A_reg||red_op_B_reg) begin
                 out  <= 6'b0       ;
            leds <= 16'hffff        ;  /////////////////////invaliad case/////////////////////// 
            Counter <= 6;    
            end
           else if (FULL_ADDER == "ON") begin
                out  <= cin_reg+A_reg+B_reg;
            end
            else  begin
                out  <= A_reg+B_reg;
            end
            
            leds <= 16'b0  ;
            
        end
        3'b011:begin
            if (red_op_A_reg||red_op_B_reg) begin
                 out <= 6'b0       ;
            leds <= 16'hffff        ;  ////////////////////invaliad case///////////////////////
            Counter <= 6;
            end
            out  <= A_reg*B_reg;
            leds <= 16'b0  ;
            
        end
         3'b100:begin
            if (red_op_A_reg||red_op_B_reg) begin
                 out  <= 6'b0       ;
            leds <= 16'hffff        ;       ////////////////////invaliad case///////////////////////
            Counter <= 6;
            end
            if (direction_reg) begin ///////////shift left ////////////////
                out <= {out[4:0],serial_in_reg};
                
            end
            else out <= {serial_in_reg,out[5:1]};//////////////shift right////////////
            leds <=16'b0;
        end
         3'b101:begin  
            if (red_op_A_reg||red_op_B_reg) begin
                 out  <= 6'b0       ;
            leds <= 16'hffff        ; ////////////////////invaliad case///////////////////////
            Counter <= 6;
            end                        /////////////rotate output/////////////////
            if (direction_reg) begin
                out <= {out[4:0],out[5]};
            end
            else  out <= {out[0],out[5:1]};
                  
            leds <=16'b0  ;
            
        end
         3'b110:begin       ////////////invalid case///////////////////
            out  <= 6'b0       ;
            leds <= 16'hffff;
            Counter <= 6;
            
        end
        3'b111:begin       ////////////invalid case///////////////////
            out  <= 6'b0       ;
            leds <= 16'hffff;
            Counter <= 6;
            
        end
        
    endcase
    
    
    
    end
    
end
 else if (Counter>0)
      begin
        leds <= ~leds;
        Counter <= Counter - 1;
         end
     
end



    
endmodule