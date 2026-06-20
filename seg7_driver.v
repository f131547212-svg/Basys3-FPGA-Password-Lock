module seg7_driver(
    input             clk,
    input             rst,
    input      [15:0] seg_data,
    output reg [3:0]  an,
    output reg [6:0]  seg
);
    reg [19:0] refresh_counter;
    wire [1:0] activating_led;
    reg [3:0]  current_nibble;

    always @(posedge clk or posedge rst) begin
        if (rst) refresh_counter <= 0;
        else     refresh_counter <= refresh_counter + 1;
    end
    assign activating_led = refresh_counter[19:18];

    // 動態掃描：輪流點亮 4 個位數，並把對應的 4-bit 丟給解碼器
    always @(*) begin
        case(activating_led)
            2'b00: begin an = 4'b1110; current_nibble = seg_data[3:0];   end // 第0位
            2'b01: begin an = 4'b1101; current_nibble = seg_data[7:4];   end // 第1位
            2'b10: begin an = 4'b1011; current_nibble = seg_data[11:8];  end // 第2位
            2'b11: begin an = 4'b0111; current_nibble = seg_data[15:12]; end // 第3位
        endcase
    end

    // 硬體 16 進位與自訂字型解碼器
    always @(*) begin
        case(current_nibble)
            4'h0: seg = 7'b1000000; // '0'
            4'h1: seg = 7'b1000111; // 'L'
            4'h4: seg = 7'b0001000; // 'A'
            4'h5: seg = 7'b0010010; // 'S'
            4'h6: seg = 7'b0000110; // 'E'
            4'h7: seg = 7'b0111111; // '-'
            4'hA: seg = 7'b0001100; // 'P'
            4'hC: seg = 7'b1000110; // 'C'
            4'hF: seg = 7'b0001110; // 'F'
            4'h1: seg = 7'b1111001; // 'I' (與 L 共用通道區隔)
            default: seg = 7'b0111111; // '-'
        endcase
    end
endmodule