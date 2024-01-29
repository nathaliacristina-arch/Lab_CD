module alu (SW,HEX0);
    input [17:0]SW;
    output [6:0]HEX0;
    reg [3:0] s;
	Decoder TX(.I(s),.HEX0(HEX0));
    
    always @(SW[2:0], SW[17:10])
    begin
        case(SW[2:0])
            3'b000: s = (SW[13:10] & SW[17:14]);
            3'b001: s = (SW[13:10] | SW[17:14]);
            3'b010: s = (SW[13:10] + SW[17:14]);
            3'b011: s = (SW[17:14] - SW[13:10]);
            3'b100: s = (SW[17:14] * 2);
            3'b101: s = (SW[17:14] / 2);
            default: s = 3'b111;
         endcase   
    end
endmodule


module Decoder(I, HEX0);
    input [3:0]I;
    output [6:0]HEX0;
    reg [6:0] segmentos;
    always @(*)
    begin
    case ({I[3],I[2],I[1],I[0]})
        4'b0000: segmentos=7'b0000001;
        4'b0001: segmentos=7'b1001111;
        4'b0010: segmentos=7'b0010010;
        4'b0011: segmentos=7'b0000110;
        4'b0100: segmentos=7'b1001100;
        4'b0101: segmentos=7'b0100100;
        4'b0110: segmentos=7'b0100000;
        4'b0111: segmentos=7'b0001111;
        4'b1000: segmentos=7'b0000000;
        4'b1001: segmentos=7'b0000100;
        default: segmentos = 7'b1111111;
    endcase
    end
    assign {HEX0[0],HEX0[1],HEX0[2],HEX0[3],HEX0[4],HEX0[5],HEX0[6]} = segmentos;
endmodule