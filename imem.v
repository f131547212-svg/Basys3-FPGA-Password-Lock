module imem(
    input  [31:0] addr,
    output reg [31:0] instr
);
    always @(*) begin
        case(addr[11:2])
            // 基礎初始化
            0: instr = 32'h400002B7; // lui t0, 0x40000       (t0 = 0x4000_0000 基底)
            1: instr = 32'h00500813; // addi s0, zero, 5      (s0 = 5, 預設密碼 0101)
            2: instr = 32'h00000893; // addi s1, zero, 0      (s1 = 0, 錯誤計數)

            // 【WAIT_LOOP】 輪詢 BTN-C 是否按下
            3: instr = 32'h0042A303; // lw t1, 4(t0)          (讀取按鈕暫存器)
            4: instr = 32'h00137313; // andi t1, t1, 1        (檢查 BTN-C)
            5: instr = 32'hFE030CE3; // beq t1, zero, -8      (沒按跳回第 3 條指令)

            // 按鈕按下，讀取 Switch 並比對密碼
            6: instr = 32'h0002A383; // lw t2, 0(t0)          (讀取開關暫存器)
            7: instr = 32'h00F37393; // andi t2, t2, 15       (取低 4 位)
            8: instr = 32'h00838663; // beq t2, s0, 12        (正確跳 MATCH_PASS)

            // 【MATCH_FAIL】 密碼錯誤處理
            9: instr = 32'h00140413; // addi s1, s1, 1        (錯誤計數 + 1)
            10: instr = 32'h00345463; // bge s1, zero, 8       (放寬條件：只要錯了直接跳過 LOCK 顯示 FAIL)
            11: instr = 32'h461103B7; // lui t2, 0x46110       (FAIL 的七段顯示編碼)
            12: instr = 32'h00C2A623; // sw t2, 12(t0)         (寫入七段顯示器)
            13: instr = 32'hFE510CE3; // j WAIT_LOOP           (跳回等待)

            // 【MATCH_PASS】 密碼正確處理
            14: instr = 32'h7A5503B7; // lui t2, 0x7A550       (PASS 的七段顯示編碼)
            15: instr = 32'h00C2A623; // sw t2, 12(t0)         (寫入七段顯示器)
            16: instr = 32'h00000893; // addi s1, zero, 0      (錯誤次數重設為 0)
            17: instr = 32'hFE110CE3; // j WAIT_LOOP           (跳回等待)

            default: instr = 32'h00000013; // nop
        endcase
    end
endmodule