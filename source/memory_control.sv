/*
	Eric Villasenor
	evillase@gmail.com

	this block is the coherence protocol
	and artibtration for ram
*/

// interface include
`include "cache_control_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module memory_control (
	input CLK, nRST,
	cache_control_if.cc ccif
);
	// type import
	import cpu_types_pkg::*;

	// number of cpus for cc
	parameter CPUS = 2;

	always_comb begin
		ccif.ramstore = '?;
		ccif.ramWEN = '0;
		ccif.ramREN = '0;
		ccif.ramaddr = '?;

		ccif.iwait = '1;
		ccif.dwait = '1;
		ccif.iload = ccif.ramload;
		ccif.dload = ccif.ramload;

		if (ccif.dWEN[0] || ccif.dWEN[1]) begin
			ccif.ramWEN = 1'b1;
			ccif.ramaddr = ccif.daddr;
			ccif.ramstore = ccif.dstore;
			if (ccif.ramstate == ACCESS) begin
				if (ccif.dWEN[0])
					ccif.dwait[0] = '0;
				if (ccif.dWEN[1])
					ccif.dwait[1] = '0;
			end
		end
		else if (ccif.dREN[0] || ccif.dREN[1]) begin
			ccif.ramREN = 1'b1;
			ccif.ramaddr = ccif.daddr;
			if (ccif.ramstate == ACCESS) begin
				if (ccif.dREN[0])
					ccif.dwait[0] = '0;
				if (ccif.dREN[1])
					ccif.dwait[1] = '0;
			end
		end
		else if (ccif.iREN[0] || ccif.iREN[1]) begin
			ccif.ramREN = 1'b1;
			ccif.ramaddr = ccif.iaddr;
			if (ccif.ramstate == ACCESS) begin
				if (ccif.iREN[0])
					ccif.iwait[0] = '0;
				if (ccif.iREN[1])
					ccif.iwait[1] = '0;
			end
		end
	end

endmodule
