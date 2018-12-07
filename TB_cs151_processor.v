`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   07:51:36 12/02/2018
// Design Name:   cs151_processor
// Module Name:   F:/2018project/time_count/risc_cpu/misp_cpu_ise/misp_cpu/TB_cs151_processor.v
// Project Name:  misp_cpu
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: cs151_processor
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TB_cs151_processor;

	// Inputs
	reg clk;

	// Outputs
	wire overflow;
	wire equal;
	wire carry;

	// Instantiate the Unit Under Test (UUT)
	cs151_processor uut (
		.clk(clk), 
		.overflow(overflow), 
		.equal(equal), 
		.carry(carry)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		// Wait 100 ns for global reset to finish
		
		forever #10 clk=!clk; 
		// Add stimulus here

	end
      
endmodule

