module maquina_moore ( input clock, input RESET, output [0:6] HEX, input UP, input DOWN);
reg [ 3 : 0 ] Z; //tipo padrão. Define as saidas
reg [ 3 : 0] estado_atual, proximo_estado; //define tres bits
wire OUT;
// reg declara os fios intermediarios

parameter A = 0, B = 1, C = 2, D = 3, E = 4, F = 5, G = 6, H = 7, I = 8, display_apagado = 9; 




always @ ( UP or DOWN or estado_atual) 

    begin
    case (estado_atual) //define proximo estado
    
    A: if (UP==0 & DOWN==0) proximo_estado =  A; //mantem estado atual
        else if (UP==1 & DOWN==0) proximo_estado = B; //contagem crescente
        else if (UP==0 & DOWN==1) proximo_estado = I; //contagem decrescente
        else if (UP==1 & DOWN==1) proximo_estado = display_apagado;
        
    B: if (UP==0 && DOWN==0 ) proximo_estado = B;
        else if (UP==1 & DOWN==0) proximo_estado = C; 
        else if (UP==0 & DOWN==1) proximo_estado = A;
        else if (UP==1 & DOWN==1) proximo_estado = display_apagado;
        
    C: if (UP==0 & DOWN==0 ) proximo_estado = C;
        else if (UP==1 & DOWN==0) proximo_estado = D; 
        else if (UP==0 & DOWN==1) proximo_estado = B;
        else if (UP==1 & DOWN==1) proximo_estado = display_apagado;
        
    D: if (UP==0 & DOWN==0 ) proximo_estado = D;
        else if (UP==1 & DOWN==0) proximo_estado = E; 
        else if (UP==0 & DOWN==1) proximo_estado = C;
        else if (UP==1 & DOWN==1) proximo_estado = display_apagado;   
        
        
    E: if (UP==0 & DOWN==0 ) proximo_estado = E;
        else if (UP==1 & DOWN==0) proximo_estado = F; 
        else if (UP==0 & DOWN==1) proximo_estado = D;
        else if (UP==1 & DOWN==1) proximo_estado = display_apagado;
        
    F: if (UP==0 & DOWN==0 ) proximo_estado = F;
        else if (UP==1 & DOWN==0) proximo_estado = G; 
        else if (UP==0 & DOWN==1) proximo_estado = E;
        else if (UP==1 & DOWN==1) proximo_estado = display_apagado;
        
    G: if (UP==0 & DOWN==0 ) proximo_estado = G;
        else if (UP==1 & DOWN==0) proximo_estado = H; 
        else if (UP==0 & DOWN==1) proximo_estado = F;
        else if (UP==1 & DOWN==1) proximo_estado = display_apagado;
        
    H: if (UP==0 & DOWN==0 ) proximo_estado = H;
        else if (UP==1 & DOWN==0) proximo_estado = I; 
        else if (UP==0 & DOWN==1) proximo_estado = G;
        else if (UP==1 & DOWN==1) proximo_estado = display_apagado;
        
    I: if (UP==0 & DOWN==0 ) proximo_estado = I;
        else if (UP==1 & DOWN==0) proximo_estado = A; 
        else if (UP==0 & DOWN==1) proximo_estado = H;
        else if (UP==1 & DOWN==1) proximo_estado = display_apagado;
   
    display_apagado: if (UP==0 & DOWN==0 ) proximo_estado = display_apagado;   
        else if (UP==1 & DOWN==0) proximo_estado = A; 
        else if (UP==0 & DOWN==1) proximo_estado = A;
        else if (UP==1 & DOWN==1) proximo_estado = display_apagado;
    
endcase
end

    always @ ( posedge OUT or posedge RESET)
    begin
    if (RESET == 1) estado_atual <= A;
    else estado_atual <= proximo_estado;
    end
always @ ( estado_atual )
 begin
   case (estado_atual) // Atribui a Z a saida conforme a sequencia
            A : Z = 4'b0101 ; // numero 05
            B : Z = 4'b0000 ; // numero 00
            C : Z = 4'b1000 ; // numero 08
            D : Z = 4'b0100 ; // numero 04
            E : Z = 4'b0001 ; // numero 01
			F : Z = 4'b0011 ; // numero 03
		    G : Z = 4'b1000 ; // numero 08
            H : Z = 4'b1001; // numero 09
		    I : Z = 4'b0010 ; // numero 02
			default: Z = 4'b1111 ; // exibe o display apagado
	endcase
 end
    
     divisor print (.CLK (clock),.SAIDA(OUT));
     decodificadorbcd7segmentos imprimir (.BOX1(Z),.HEX4(HEX));
endmodule


module divisor (CLK, SAIDA);
input CLK;
output reg SAIDA;
reg [25:0] OUT;
always @ (posedge CLK)

   if (OUT == 26'd50000000 )
            begin
              OUT <= 26'd0;
              SAIDA <= 1;
         end
     
    else
        begin
        OUT<= OUT+1;
        SAIDA <= 0;
        
    end
    
endmodule


 module decodificadorbcd7segmentos (BOX1, HEX4);
    input [3:0]BOX1;
    output [6:0]HEX4;
    reg [6:0] saida;
    always @ (*)
        begin
            case ({BOX1[3], BOX1[2], BOX1[1], BOX1[0]})
            // 5 0 8 4 1 3 8 9 2
			4'b0000 : saida = 7'b0000001 ; 
			4'b0001 : saida = 7'b1001111 ;
		   4'b0010 : saida = 7'b0010010 ;
			4'b0011 : saida = 7'b0000110 ;
			4'b0100 : saida = 7'b1001100 ;
		   4'b0101 : saida = 7'b0100100 ;
			4'b0110 : saida = 7'b0100000 ;
			4'b0111 : saida = 7'b0001111 ;
			4'b1000 : saida = 7'b0000000 ;
			4'b1001 : saida = 7'b0000100 ;
			default : saida = 7'b1111111 ; // exibe o display apagado
            endcase
        end
        
    assign HEX4 = saida;
    
    
    
    
    
    endmodule
    