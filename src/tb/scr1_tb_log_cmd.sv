`include "scr1_arch_description.svh"
`include "scr1_csr.svh"
`include "scr1_arch_types.svh"
`include "scr1_riscv_isa_decoding.svh"
`ifdef SCR1_IPIC_EN
`include "scr1_ipic.svh"
`endif // SCR1_IPIC_EN
`ifdef SCR1_DBG_EN
`include "scr1_hdu.svh"
`endif // SCR1_DBG_EN
`ifdef SCR1_TDU_EN
`include "scr1_tdu.svh"
`endif // SCR1_TDU_EN

module scr1_tb_log_cmd();

logic detect;
assign detect = scr1_top_tb_ahb.i_top.i_imem_ahb.imem_resp == 2'b01 & scr1_top_tb_ahb.i_top.i_imem_ahb.imem_rdata == 32'h20c1b3;

always @(posedge scr1_top_tb_ahb.i_top.i_imem_ahb.clk) begin
	if (detect) begin
	    $display("MVENDORID:      %b", SCR1_CSR_MVENDORID);
	    $display("MARCHID:        %b", SCR1_CSR_MARCHID);
	    $display("MIMPID:         %b", SCR1_CSR_MIMPID);
	    $display("MHARTID:        %b", scr1_top_tb_ahb.i_top.i_core_top.i_pipe_top.i_pipe_csr.soc2csr_fuse_mhartid_i);
	    $display("MSTATUS:        %b", scr1_top_tb_ahb.i_top.i_core_top.i_pipe_top.i_pipe_csr.csr_mstatus);
	    $display("MISA:           %b", SCR1_CSR_MISA);
	    $display("MIE:            %b", scr1_top_tb_ahb.i_top.i_core_top.i_pipe_top.i_pipe_csr.csr_mie);
	    $display("MTVEC:          %b", {scr1_top_tb_ahb.i_top.i_core_top.i_pipe_top.i_pipe_csr.csr_mtvec_base, 4'd0, 2'(scr1_top_tb_ahb.i_top.i_core_top.i_pipe_top.i_pipe_csr.csr_mtvec_mode)});
	    $display("MSCRATCH:       %b", scr1_top_tb_ahb.i_top.i_core_top.i_pipe_top.i_pipe_csr.csr_mscratch_ff);
	    $display("MEPC:           %b", scr1_top_tb_ahb.i_top.i_core_top.i_pipe_top.i_pipe_csr.csr_mepc);
	    $display("MCAUSE:         %b", {scr1_top_tb_ahb.i_top.i_core_top.i_pipe_top.i_pipe_csr.csr_mcause_i_ff, type_scr1_csr_mcause_ec_v'(scr1_top_tb_ahb.i_top.i_core_top.i_pipe_top.i_pipe_csr.csr_mcause_ec_ff)});
	    $display("MTVAL:          %b", scr1_top_tb_ahb.i_top.i_core_top.i_pipe_top.i_pipe_csr.csr_mtval_ff);
	    $display("MIP:            %b", scr1_top_tb_ahb.i_top.i_core_top.i_pipe_top.i_pipe_csr.csr_mip);
	    $display("mtimer[31:0]:   %b", scr1_top_tb_ahb.i_top.i_core_top.i_pipe_top.i_pipe_csr.soc2csr_mtimer_val_i[31:0]);
	    $display("mcycle[31:0]:   %b", scr1_top_tb_ahb.i_top.i_core_top.i_pipe_top.i_pipe_csr.csr_mcycle[31:0]);
	    $display("minstret[31:0]: %b", scr1_top_tb_ahb.i_top.i_core_top.i_pipe_top.i_pipe_csr.csr_minstret[31:0]);
	    $display("mtimer[63:32]:  %b", scr1_top_tb_ahb.i_top.i_core_top.i_pipe_top.i_pipe_csr.soc2csr_mtimer_val_i[63:32]);
	    $display("mcycle[63:32]:  %b", scr1_top_tb_ahb.i_top.i_core_top.i_pipe_top.i_pipe_csr.csr_mcycle[63:32]);
	    $display("minstret[63:32]:%b", scr1_top_tb_ahb.i_top.i_core_top.i_pipe_top.i_pipe_csr.csr_minstret[63:32]);
	    $display("MCOUNTEN:       %b", scr1_top_tb_ahb.i_top.i_core_top.i_pipe_top.i_pipe_csr.csr_mcounten);
	    $display("IPIC:           %b", scr1_top_tb_ahb.i_top.i_core_top.i_pipe_top.i_pipe_csr.ipic2csr_rdata_i);
	    $display("HDU:            %b", scr1_top_tb_ahb.i_top.i_core_top.i_pipe_top.i_pipe_csr.hdu2csr_rdata_i);
	    $display("TDU:            %b", scr1_top_tb_ahb.i_top.i_core_top.i_pipe_top.i_pipe_csr.tdu2csr_rdata_i);
	    $display();
	end
end

endmodule
