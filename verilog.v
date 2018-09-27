module ff ( input data, input c, input r, output q);
reg q;
always @(posedge c or negedge r) 
begin
 if(r==1'b0)
  q <= 1'b0; 
 else 
  q <= data; 
end 
endmodule //End 

module ff2 ( input data, input c, input r, output q);
reg q;
always @(posedge c or negedge r) 
begin
 if(r==1'b0)
  q <= 1'b1; 
 else 
  q <= data; 
end 
endmodule //End 



/* ESQUEMA MAQUINA
                           0
+-----------------------------------------------------+
|                                                     |
|      +---------+           +---------+          +---+-----+
|      |         |           |         |          |         |
+----> |         |    0      |         |    1     |         |
       |   E0    +---------> |  E3     +--------> |    E5   |
       |         |           |         |          |         |
       +---+-----+           +------+--+          +--------++
       ^   |                        |                      |
       |   |                 ^      |                      |
       |   |                 |      |                      |
       |   |               1 |      |0                     |1
       |   |1      +---------++     |        +---------+   |
       |   |       |          |     |        |         |   |
       |   |       |          |     +------> |    E2   |   |
       |   +-----> |   E4     |              |         | <-+
       +-----------+          | <------------+         |
            0      +----------+       0 OU 1 +---------+
*/
// ----   FSM alto nível com Case
module statem(clk, reset, a, saida);

input clk, reset, a;
output [2:0] saida;
reg [2:0] state;
parameter zero=3'd2, tres=3'd1, dois=3'd3, quatro=3'd4, cinco =3'd5;

assign saida = (state == zero)? 3'd0:
           (state == dois)? 3'd2:
	   (state == tres)? 3'd3:
	   (state == quatro)? 3'd4:3'd5;

always @(posedge clk or negedge reset)
     begin
          if (reset==0)
               state = zero;
          else
               case (state)
                    zero: if ( a == 1 ) state = quatro;
              else state = tres;
                    tres: if ( a == 1 ) state = cinco;
			  else state = dois;
                    quatro: if ( a == 1 ) state = tres;
			  else state = zero;
                    dois: state = quatro;
                    cinco: if ( a == 1 ) state = dois;
              else state = zero;
               endcase
     end
endmodule
// FSM com portas logicas
module statePorta(input clk, input res, input a, output [2:0] s);
wire [2:0] e;
wire [2:0] p;
assign s[0] = ~e[1]&e[0];
assign s[1] = ~e[2]&e[0];
assign s[2] = e[2];
assign p[0]  = ~e[1]&e[0] | a&~e[1] | ~a&~e[2]&~e[0];
assign p[1]  =  ~a&~e[1] |e[2]&e[0];
assign p[2] =   e[1]&e[0] | a&~e[2];
ff  e0(p[0],clk,res,e[0]);
ff2  e1(p[1],clk,res,e[1]);
ff  e2(p[2],clk,res,e[2]);

endmodule 

module stateMem(input clk,input res, input a, output [2:0] saida);
reg [5:0] StateMachine [0:15]; // 16 linhas e 6 bits de largura
initial
begin  // programar ainda....
StateMachine[1] = 6'h1b;  //27
StateMachine[2] = 6'h8;   //8
StateMachine[3] = 6'h22;   //34
StateMachine[4] = 6'h14;   //20
StateMachine[5] = 6'h1d;    //29
StateMachine[9] = 6'h2b;    //43
StateMachine[10] = 6'h20;  // 32
StateMachine[11] = 6'h22;    //34
StateMachine[12] = 6'hc;     //12
StateMachine[13] = 6'h1d;    //21
end
wire [3:0] address;  // 16 linhas = 4 bits de endereco
wire [5:0] dout; // 6 bits de largura 3+3 = proximo estado + saida
assign address[3] = a;
assign dout = StateMachine[address];
/*if(res == 0)
    assign dout = StateMachine[b'0010];
else
    assign dout = StateMachine[address];
    */
assign saida = dout[2:0];
ff st0(dout[3],clk,res,address[0]);
ff2 st1(dout[4],clk,res,address[1]);
ff st2(dout[5],clk,res,address[2]);
endmodule
/*
                  +---------------+
             A+--^+               |
        E2        |               |
      +----------^+    MEMORIA    |
      |    E1     |               |
   +-------------^+               |
   |  |       E0  |               |
+----------------^+               |
|  |  |           +-+-+-+--+-+--+-+
|  |  |             | | |  | |  |
|  |  |   +------+  | | |  | |  |
|  |  |   |      |  | | |  | |  |
|  |  +---+ FF1  +--+ | |  | |  |
|  |      |     <+    | |  | |  +-------------+
|  |      +------|    | |  | +----------+     |
|  |      +------+    | |  +--------+   |     |
|  +------+      |    | |           |   |     |
|         | FF2  +----+ |           |   |     |
|         |     <+      |           +   +     ++
|         +------|      |          S2   S1    S0
|         +------+      |
+---------+      |      |
          | FF3  +------+
          |     <+
          +------+

*/
module main;
reg c,res,a;
wire [2:0] saida;
wire [2:0] saida1;
wire [2:0] saida2;

statem FSM(c,res,a,saida);
//statePorta FSM(c,res,g,r,y);
statePorta FSM3(c,res,a,saida2);
stateMem FSM1(c,res,a,saida1);

initial
    c = 1'b0;
  always
    c= #(1) ~c;

// visualizar formas de onda usar gtkwave out.vcd
initial  begin
     $dumpfile ("out.vcd"); 
     $dumpvars; 
   end 

  initial 
    begin
     $monitor($time," c %b res %b a %b scase %d smem %d sporta %d",c,res,a,saida,saida1,saida2);
      #1 res=0; a=0;
      #1 res=1;
      #8 a=1;
      #16 a=0;
      #12 a=1;
      #4;
      $finish ;
    end
endmodule
