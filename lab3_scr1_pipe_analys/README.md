# Лабораторная работа №3 по предмету "ПСНК"

## Цель

Познакомиться с архитектурой пайплайна SCR1. Доработать тестбенч для вывода информации об микроархитектурном состоянии и состоянии конвеера при выполении определенной команды.

## Задание

 1) В вашей копии репозитория scr1 (в форке) из лабораторной 2 необходимо добавить
ветку lab3_scr1_pipe_analys.
 2) Запустить тест, в котором используется заданная по варианту команда.
 3) В соответствии с вариантом исследовать выполнение заданной команды на пайплайне.
Вывести на диаграмму следующие значения, а также дополнительно сигналы
поясняющие работу пайплайна по вашему усмотрению.
 4) Добавить несинтезируемый блок в верификационное окружение scr1. Верификационное
окружение должно отслеживать выполнение определенной конструкции и в случае
обнарежения конструкции в пайплайне выводить отладочную информацию.
Отладочная инфомрация определяется в соответствии с вашим вариантом.
 5) Добавить в папку report в вашей ветке scr1 скрин с wave формой на которой отражено
выполнение вашей команды. Также добавить вывод вашего отладочного модуля.
 6) Закоммитить и запушить изменения на github.

| Номер варианта | ФИО         | Исследуемая команда | Отладочная информация      |
|----------------|-------------|---------------------|----------------------------|
| 1              | Болдов Олег | xor                 | Вывести регистры состояния |

## Ход работы

### Исследуемая команда

Аналогично действпиям во второй лабораторной работе был отредактирован список запускаемых тестов.

Анализируемый ассемблер - `isa/rv32ui/xor.S` - содержит несколько тестов с инструкцией xor, которая кодируется, как `0020c1b3`. Именно эту инструкцию необходимо отлавливать в добавочном тестовом окружении.

```
000002a0 <_run_test>:
 2a0:	ff0100b7          	lui	ra,0xff010
 2a4:	f0008093          	addi	ra,ra,-256 # ff00ff00 <__global_pointer$+0xff00efb8>
 2a8:	0f0f1137          	lui	sp,0xf0f1
 2ac:	f0f10113          	addi	sp,sp,-241 # f0f0f0f <__global_pointer$+0xf0effc7>
 2b0:	0020c1b3          	xor	gp,ra,sp
 2b4:	f00ffeb7          	lui	t4,0xf00ff
 2b8:	0ebd                	addi	t4,t4,15 # f00ff00f <__global_pointer$+0xf00fe0c7>
 2ba:	4e09                	li	t3,2
 2bc:	3bd19663          	bne	gp,t4,668 <fail>

000002c0 <test_3>:
 2c0:	0ff010b7          	lui	ra,0xff01
 2c4:	10c1                	addi	ra,ra,-16 # ff00ff0 <__global_pointer$+0xff000a8>
 2c6:	f0f0f137          	lui	sp,0xf0f0f
 2ca:	616d                	addi	sp,sp,240
 2cc:	0020c1b3          	xor	gp,ra,sp
 2d0:	ff010eb7          	lui	t4,0xff010
 2d4:	f00e8e93          	addi	t4,t4,-256 # ff00ff00 <__global_pointer$+0xff00efb8>
 2d8:	4e0d                	li	t3,3
 2da:	39d19763          	bne	gp,t4,668 <fail>

000002de <test_4>:
 2de:	00ff00b7          	lui	ra,0xff0
 2e2:	0ff08093          	addi	ra,ra,255 # ff00ff <__global_pointer$+0xfef1b7>
 2e6:	0f0f1137          	lui	sp,0xf0f1
 2ea:	f0f10113          	addi	sp,sp,-241 # f0f0f0f <__global_pointer$+0xf0effc7>
 2ee:	0020c1b3          	xor	gp,ra,sp
 2f2:	0ff01eb7          	lui	t4,0xff01
 2f6:	1ec1                	addi	t4,t4,-16 # ff00ff0 <__global_pointer$+0xff000a8>
 2f8:	4e11                	li	t3,4
 2fa:	37d19763          	bne	gp,t4,668 <fail>

000002fe <test_5>:
 2fe:	f00ff0b7          	lui	ra,0xf00ff
 302:	00bd                	addi	ra,ra,15 # f00ff00f <__global_pointer$+0xf00fe0c7>
 304:	f0f0f137          	lui	sp,0xf0f0f
 308:	616d                	addi	sp,sp,240
 30a:	0020c1b3          	xor	gp,ra,sp
 30e:	00ff0eb7          	lui	t4,0xff0
 312:	0ffe8e93          	addi	t4,t4,255 # ff00ff <__global_pointer$+0xfef1b7>
 316:	4e15                	li	t3,5
 318:	35d19863          	bne	gp,t4,668 <fail>
 ```

 ### Тестовое окружение

 ```
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
```

Полученный модуль состоит из сигнала находления необходимой инструкции `detect` и набора выводов статусных регистров.
Сам модуль необходимо разместить в `scr1_top_tb_ahb.sv`, так как отсюда есть доступ и в `imem_ahb`, где можно отловить эту инструкцию, так и в `pipe_csr`, где можно собрать статусные регистры.

### Анализ конвейера выполнения команды

<img width="2460" height="980" alt="изображение" src="https://github.com/pupyr/scr1/blob/lab3_scr1_pipe_analys/report/Screenshot from 2025-12-01 21-02-00.png" />

Сигнал `detect` из написанного тестового окружения отлавливает `Fetch` стадию, то есть загрузку инструкции из памяти.
После инструкция попадает на `Decode` стадию, на которой она анализируется. На скриншоте можно обратить внимание на `ialu_cmd`, который равен 3.

По `riscv-isa-decoding.svh` можно определить, что 3 - это $XOR$.

```
typedef enum logic [SCR1_IALU_CMD_WIDTH_E-1:0] {
    SCR1_IALU_CMD_NONE  = '0,   // IALU disable
    SCR1_IALU_CMD_AND,          // op1 & op2
    SCR1_IALU_CMD_OR,           // op1 | op2
    SCR1_IALU_CMD_XOR,          // op1 ^ op2
    SCR1_IALU_CMD_ADD,          // op1 + op2
    SCR1_IALU_CMD_SUB,          // op1 - op2
    SCR1_IALU_CMD_SUB_LT,       // op1 < op2
    SCR1_IALU_CMD_SUB_LTU,      // op1 u< op2
    SCR1_IALU_CMD_SUB_EQ,       // op1 = op2
    SCR1_IALU_CMD_SUB_NE,       // op1 != op2
    SCR1_IALU_CMD_SUB_GE,       // op1 >= op2
    SCR1_IALU_CMD_SUB_GEU,      // op1 u>= op2
    SCR1_IALU_CMD_SLL,          // op1 << op2
    SCR1_IALU_CMD_SRL,          // op1 >> op2
    SCR1_IALU_CMD_SRA           // op1 >>> op2
`ifdef SCR1_RVM_EXT
    ,
    SCR1_IALU_CMD_MUL,          // low(unsig(op1) * unsig(op2))
    SCR1_IALU_CMD_MULHU,        // high(unsig(op1) * unsig(op2))
    SCR1_IALU_CMD_MULHSU,       // high(op1 * unsig(op2))
    SCR1_IALU_CMD_MULH,         // high(op1 * op2)
    SCR1_IALU_CMD_DIV,          // op1 / op2
    SCR1_IALU_CMD_DIVU,         // op1 u/ op2
    SCR1_IALU_CMD_REM,          // op1 % op2
    SCR1_IALU_CMD_REMU          // op1 u% op2
`endif  // SCR1_RVM_EXT
} type_scr1_ialu_cmd_sel_e;
```
На стадии `Execution` в модуле `ialu` происходит вычисление $XOR$.

$$FF00FF00 \oplus 0F0F0F0F = F00FF00F$$

Результат записывается в регистровый файл.

## Выводы

В данной лабораторной работе был произведен анализ конвейера scr1 ядра и добавлен модуль с тестовым окружением. В ходе выполнения получены навыки поиска информации в полноценном кластере.
