`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2018 04:14:52 AM
// Design Name: 
// Module Name: cs151_processor
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// Adder
module Adder(
    input wire [5:0] preInst,
    output reg [5:0] postInst
);
   initial begin
   postInst=6'd0;
   end

    always@(preInst)
    begin
        postInst <= preInst + 1;
    end
endmodule

// PC
module PC(
    input wire clk,
    input wire [5:0] pre,
    output reg [5:0] post
);

    always @ (posedge clk)
    begin
        post <= pre;
    end
endmodule

// Instruction memory
module inst_mem(
    input wire [5:0] addr,
    output reg [31:0] readData
);

    reg [31:0] regMem [0:63];
    always@(addr)
    begin
        readData <= regMem[addr];
    end
	
	initial begin
	regMem[0]=32'h80088014;
	regMem[1]=32'h8010800F;
	regMem[2]=32'h80188004;
	regMem[3]=32'h00000000;/////NOP
	regMem[4]=32'h04208200;
	regMem[5]=32'h80290014;
	regMem[6]=32'h02310200;
	regMem[7]=32'h8A42AAAA;
	regMem[8]=32'h04128200;
	regMem[9]=32'h00000000;////NOP
	regMem[10]=32'h084b8000;
	regMem[11]=32'h844B0001;
	regMem[12]=32'h844C8002;
	regMem[13]=32'h12158000;
	regMem[14]=32'h00338000;
	regMem[15]=32'h80088002;
	regMem[16]=32'h840C801E;
	regMem[17]=32'h00000000;////nop
	regMem[18]=32'h0c388200;
	regMem[19]=32'h0c308c00;
	regMem[20]=32'h00000000;/////NOP
	regMem[21]=32'h06230A00;///这块错了
	regMem[22]=32'h10240400;
	regMem[23]=32'h88242AAA;/////答案也错了
	regMem[24]=32'h80558006;
	regMem[25]=32'h80158004;
	regMem[26]=32'h04548000;
	regMem[27]=32'h00000000;
	regMem[28]=32'h00000000;
	regMem[29]=32'h00000000;
	regMem[30]=32'h00000000;
	regMem[31]=32'h00000000;
	regMem[32]=32'h00000000;
	regMem[33]=32'h00000000;
	regMem[34]=32'h00000000;
	regMem[35]=32'h00000000;
	regMem[36]=32'h00000000;
	regMem[37]=32'h00000000;
	regMem[38]=32'h00000000;
	regMem[39]=32'h00000000;
	regMem[40]=32'h00000000;
	regMem[41]=32'h00000000;
	regMem[42]=32'h00000000;
	regMem[43]=32'h00000000;
	regMem[44]=32'h00000000;
	regMem[45]=32'h00000000;
	regMem[46]=32'h00000000;
	regMem[47]=32'h00000000;
	regMem[48]=32'h00000000;
	regMem[49]=32'h00000000;
	regMem[50]=32'h00000000;
	regMem[51]=32'h00000000;
	regMem[52]=32'h00000000;
	regMem[53]=32'h00000000;
	regMem[54]=32'h00000000;
	regMem[55]=32'h00000000;
	regMem[56]=32'h00000000;
	regMem[57]=32'h00000000;
	regMem[58]=32'h00000000;
	regMem[59]=32'h00000000;
	regMem[60]=32'h00000000;
	regMem[61]=32'h00000000;
	regMem[62]=32'h00000000;
	regMem[63]=32'h00000000;
	end
	
endmodule

// Register file
module RegisterFile(
    input wire clk,
    input wire [5:0] RA1,
    input wire [5:0] RA2,
    input wire 		 RE1,
    input wire 		 RE2,
    input wire [5:0] WA,
    input wire [31:0] WD,
    input wire WE1,
    output wire [31:0] RD1,
    output wire [31:0] RD2
);

    reg [31:0] regFile [0:63];
	integer i;
	initial begin
	for(i=0;i<=63;i=i+1)
	regFile[i]=0;
	end
	
	
    
    always @ (posedge clk)
    begin
        if(WE1)
            regFile[WA] <= WD;
    end
    

assign  RD1 = regFile[RA1];
assign  RD2 = regFile[RA2];

endmodule

// ALU
module ALU32bit(
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [3:0] ALUopsel,
    input wire Iinstr,
    output reg [31:0] res,
    output reg overflow,
    output reg eq,
    output reg carry
);

   initial begin
   res=32'd0;
   overflow=1'd0;
   eq=1'd0;
   carry=1'd0;
   end

    always @(*)
    begin
        case (ALUopsel)
        4'b0000:    begin 
					res <= 0;
					overflow <= 1'b0;
					carry <= 1'b0;
					eq <= 1'b0;
					end
        4'b0001:    begin   ////Adder
                        res <= a + b;
                        if (!res[31] && (a[31] || b[31])) begin
                            overflow <= 1'b1;
                            eq <= 1'bz;
                            carry <= 1'b1;
							end
                        else if(res[31] && (a[31] && b[31])) begin
                            overflow <= 1'b0;
                            eq <= 1'bz;
                            carry <= 1'b1;	
                        end							
                        else begin
                            overflow <= 1'b0;
                            eq <= 1'bz;
                            carry <= 1'b0;
                        end
                    end
        4'b0010:    begin   ////Subtractor
                        if (a == b) begin
                            res <= 0;
                            overflow <= 1'b0;
                            eq <= 1'b1;
                            carry <= 1'b0;
                        end else begin
                            res <= a - b;
                            if (res > a && res > b) begin
                                overflow <= 1'b1;
                                eq <= 1'b0;
                                carry <= !a[31];
                            end else begin
                                overflow <= 1'b0;
                                eq <= 1'b0;
                                carry <= 1'b0;
                            end
                        end
                    end
        4'b0101:    begin    ////And
                        res <= a & b;
                        overflow <= 1'bz;
                        eq <= 1'bz;
                        carry <= 1'bz;
                    end
        4'b0110:    begin    ////Or
                        res <= a | b;
                        overflow <= 1'bz;
                        eq <= 1'bz;
                        carry <= 1'bz;
                    end
        4'b0111:    begin       ////Not
                        res <= ~a;
                        overflow <= 1'bz;
                        eq <= 1'bz;
                        carry <= 1'bz;
                    end
        4'b1000:    begin       //// XOR
                        if (a == b) begin
                            res <= 0;
                            overflow <= 1'bz;
                            eq <= 1'b1;
                            carry <= 1'bz;
                        end else begin
                            res <= a ^ b;
                            overflow <= 1'bz;
                            eq <= 1'b0;
                            carry <= 1'bz;
                        end
                    end
        4'b1001:    begin       //// SLL
                        if (a[31] == 1'b1) begin
                            overflow <= 1'b1;
                            eq <= 1'bz;
                            carry <= 1'bz;
                        end
                        res <= a << b;
                    end
        4'b1011:    res <= (Iinstr) ? b : a;        ////Move
        endcase
    end
endmodule

// I-instr MUX
module MUX1(
    input wire [31:0] regData,
    input wire [31:0] iData,
    input wire MUXsel,
    output reg [31:0] out
);

    always @(MUXsel,iData,regData)
    begin
        if (MUXsel == 1'b0)
            out <= regData;
        else
            out <= iData;
    end
endmodule

// Sign Extend
module sign_extend(
    input wire [14:0] imm,
    output reg [31:0] ext_imm
    );
    initial begin
	ext_imm=32'd0;
	end
    always @ (imm) begin
        ext_imm <= {{17{imm[14]}},imm};
    end
endmodule

// Controller
module Controller(
    input wire [31:0] instr,
    output reg [3:0] ALUopsel,
    output reg MUXsel1,
    output reg RegWrite,
    output reg RdEn1,
    output reg RdEn2,
    output reg [5:0] rs,
    output reg [5:0] rd,
    output reg [5:0] rt,
    output reg [14:0] imm
);

    always @(instr)
    begin
        if (instr[31]) begin    // I-instrucion
            if (instr[18:15] == 4'b1001)
                rs <= instr[24:19];
            else
                rs <= instr[30:25];
            MUXsel1 <= 1'b1;
            RdEn2 <= 0;
            rt <= 0;
            imm <= instr[14:0];
        end else begin
		     if (instr[18:15] == 4'b1001)
				rt <= instr[30:25];	
            else
                rt <= instr[14:9];
		     if (instr[18:15] == 4'b1001)
                //rt <= instr[24:19];
				rs <= instr[24:19];
            else
                rs <= instr[30:25];			
            MUXsel1 <= 1'b0;
           // rs <= instr[30:25];
            //rt <= instr[14:9];
            RdEn2 <= 1;
            imm <= 0;
        end
        rd <= instr[24:19];
        RegWrite <= 1;
        RdEn1 <= 1;
        ALUopsel <= instr[18:15];
    end
endmodule

// Main processor
module cs151_processor(
    input  wire	 clk,
    output wire overflow,
    output wire equal,
    output wire carry
);
    wire [5:0] postPC;
    wire [5:0] prePC;
    wire [31:0] inst;
    wire [5:0] rs, rt, rd;
    wire [14:0] imm;
    wire  MUXsel1, RegWrite;
    wire rsEn, rtEn;
    wire [31:0] OperandA, RD2, ext_imm, OperandB;
    wire [31:0] ALUresult;
	wire [3:0]  ALUopsel;

    

    
    PC progCounter(
        .clk (clk),
        .pre (prePC),
        .post (postPC)
    );
    inst_mem InstMem(
        .addr (postPC),
        .readData(inst)
    );
    Adder instAdder(
        .preInst (postPC),
        .postInst (prePC)  
    );
    Controller control(
        .instr(inst),
        .ALUopsel (ALUopsel),
        .MUXsel1 (MUXsel1),
        .RegWrite (RegWrite),
        .rd (rd),
        .RdEn1 (rsEn),
        .rs (rs),
        .RdEn2 (rtEn),
        .rt (rt),
        .imm (imm)
    );
    RegisterFile regfile(
        .clk (clk),
        .RA1 (rs),
        .RE1 (rsEn),
        .RD1 (OperandA),
        .RA2 (rt),
        .RE2 (rtEn),
        .RD2 (RD2),
        .WA (rd),
        .WE1 (RegWrite),
        .WD (ALUresult)
    );
    sign_extend SgnExt(
        .imm (imm),
        .ext_imm (ext_imm)
    );
    MUX1 b_mux(
        .regData (RD2),
        .iData (ext_imm),
        .MUXsel(MUXsel1),
        .out (OperandB)
    );
    ALU32bit ALU(
        .a (OperandA),
        .b (OperandB),
        .res (ALUresult),
        .ALUopsel (ALUopsel),
        .Iinstr (MUXsel1),
        .overflow (overflow),
        .eq (equal),
        .carry (carry)
    );
endmodule