# RISC-V
Система под управлением процессора с архитектурой RISC-V, управляющего периферийными устройствами.<br /> 
Система на ПЛИС состоит из: процессора, памяти, контроллера прерываний и контроллеров периферийных устройств.<br />
Основной модуль(riscv_unit.sv) включает в себя ядро процессора(riscv_core.sv), внешнюю память(miriscv_ram.sv), контроллер прерываний(IC.sv), контроллер периферии(UART_RX_SB_CTRL.sv, UART_TX_SB_CTRL.sv). Ядро состоит из регистрового файла(rf_riscv.sv), АЛУ(alu_rscv.sv), основного дешифратора(decoder_riscv.sv), модуля загрузки и сохранения(miriscv_lsu.sv) и контроллера регистров статуса и контроля(CSR.sv). 

