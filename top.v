module top(
    input         clk,          // 100MHz 系統時脈
    input         rst,          // 重置按鈕 (板上最右邊按鈕 BTNR)
    input  [3:0]  sw,           // SW0~SW3 密碼輸入
    input         btnC,         // BTN-C 觸發驗證
    input         btnU,         // BTN-U (此專案暫不使用)
    output [15:0] led,          // LED 燈指示
    output [3:0]  an,           // 七段顯示器致能
    output [6:0]  seg           // 七段顯示器控制
);

    reg [15:0] seg_data;
    reg [1:0]  error_cnt;
    reg        is_lock;
    reg        is_pass;
    reg        btnC_d1, btnC_d2;
    wire       btnC_posedge;

    // 1. 按鈕邊緣偵測 (防止按一下被判斷成好幾萬次)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            btnC_d1 <= 1'b0;
            btnC_d2 <= 1'b0;
        end else begin
            btnC_d1 <= btnC;
            btnC_d2 <= btnC_d1;
        end
    end
    assign btnC_posedge = btnC_d1 && !btnC_d2; // 只有在按下的瞬間觸發一次

    // 2. 密碼驗證核心邏輯 (預設密碼: 0101)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            error_cnt <= 2'b0;
            is_lock   <= 1'b0;
            is_pass   <= 1'b0;
            seg_data  <= 16'h7777; // 顯示 "----"
        end else if (is_lock) begin
            seg_data  <= 16'h10C4; // 顯示 "LOCK"
        end else if (btnC_posedge) begin
            if (sw == 4'b0101) begin
                is_pass  <= 1'b1;
                seg_data <= 16'h7A55; // 顯示 "PASS"
            end else begin
                if (error_cnt >= 2'd2) begin
                    is_lock  <= 1'b1;
                    seg_data <= 16'h10C4; // 顯示 "LOCK"
                end else begin
                    error_cnt <= error_cnt + 1'b1;
                    seg_data  <= 16'h4611; // 顯示 "FAIL"
                end
            end
        end
    end

    // 指示燈：鎖死時讓最左邊的 LED 亮起
    assign led = is_lock ? 16'h8000 : 16'h0000;

    // 3. 七段顯示器掃描模組
    seg7_driver u_seg7 (
        .clk(clk),
        .rst(rst),
        .seg_data(seg_data),
        .an(an),
        .seg(seg)
    );

endmodule