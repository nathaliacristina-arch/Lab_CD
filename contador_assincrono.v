module contador_assincrono(SW,HEX4, V_BT);
	input [0:17]SW;
	output[0:6]HEX4;
	reg [3:0]sff;
	
	decoder TX(.sffd(sff), .SW(SW),.HEX4(HEX4));
	//SW[17]==clk
	//SW[0]==reset
	always @ ( posedge V_BT[2] or posedge SW[0])
	begin
		if(SW[0])
		    sff<= 4'b0000;
		else
            if(sff ==7)
                sff<=0;
            else
                sff <=sff + 1'b1;
		
		
	end
	endmodule 




module decodificador (sffd,SW,HEX4);
    input [3:0]sffd;
    input [0:17]SW;
    output [0:6]HEX4;
    reg [6:0] segmentos;
    always @(*)
    begin
    case ({sffd[2],sffd[1],sffd[0]})
        3'b000: segmentos=7'b0000001;
        3'b001: segmentos=7'b1001111;
        3'b010: segmentos=7'b0010010;
        3'b011: segmentos=7'b0000110;
        3'b100: segmentos=7'b1001100;
        3'b101: segmentos=7'b0100100;
        3'b110: segmentos=7'b0100000;
        3'b111: segmentos=7'b0001111;
        default: segmentos = 7'b1111111;
    endcase
    end
    assign {HEX4[0],HEX4[1],HEX4[2],HEX4[3],HEX4[4],HEX4[5],HEX4[6]} = segmentos;
endmodule