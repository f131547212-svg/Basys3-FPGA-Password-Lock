module addr_decoder(
    input             clk,
    input             rst,
    input      [31:0] addr,
    input      [31:0] wdata,
    input             wen,
    output reg [31:0] rdata,
    
    input      [3:0]  switches,
    input      [1:0]  buttons,
    output reg [15:0] leds,
    output reg [15:0] seg_data
);
    // 對輸入的開關與按鈕做一級暫存，防止訊號抖動
    reg [3:0] sw_reg;
    reg [1:0] btn_reg;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sw_reg  <= 4'b0;
            btn_reg <= 2'b0;
        end else begin
            sw_reg  <= switches;
            btn_reg <= buttons;
        end
    end

    always @(*) begin
        case(addr)
            32'h4000_0000: rdata = {28'b0, sw_reg};
            32'h4000_0004: rdata = {30'b0, btn_reg};
            default:       rdata = 32'b0;
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            leds     <= 16'b0;
            seg_data <= 16'h7777; // 初始顯示 "----"
        end else if (wen) begin
            case(addr)
                32'h4000_0008: leds     <= wdata[15:0];
                32'h4000_000C: seg_data <= wdata[15:0];
            endcase
        end
    end
endmodule