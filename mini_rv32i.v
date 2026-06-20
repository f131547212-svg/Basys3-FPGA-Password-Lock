module mini_rv32i(
    input             clk,
    input             rst,
    output reg [31:0] pc,
    input      [31:0] instr,
    output     [31:0] mem_addr,
    output     [31:0] mem_wdata,
    input      [31:0] mem_rdata,
    output            mem_wen
);
    reg [31:0] rf [0:31];
    reg [31:0] next_pc; // 移到這裡宣告就沒問題了！
    
    wire [4:0]  rs1    = instr[19:15];
    wire [4:0]  rs2    = instr[24:20];
    wire [4:0]  rd     = instr[11:7];
    wire [6:0]  opcode = instr[6:0];
    wire [2:0]  funct3 = instr[14:12];
    
    wire [31:0] imm_i  = {{20{instr[31]}}, instr[31:20]};
    wire [31:0] imm_s  = {{20{instr[31]}}, instr[31:25], instr[11:7]};
    wire [31:0] imm_b  = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
    wire [31:0] imm_u  = {instr[31:12], 12'b0};

    wire [31:0] rdata1 = (rs1 == 0) ? 32'b0 : rf[rs1];
    wire [31:0] rdata2 = (rs2 == 0) ? 32'b0 : rf[rs2];

    assign mem_addr  = rdata1 + ((opcode == 7'h23) ? imm_s : imm_i);
    assign mem_wdata = rdata2;
    assign mem_wen   = (opcode == 7'h23);

    integer i;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc <= 32'b0;
            for(i=0; i<32; i=i+1) rf[i] <= 32'b0;
        end else begin
            next_pc = pc + 4;
            case(opcode)
                7'h37: if (rd != 0) rf[rd] <= imm_u;
                7'h13: if (rd != 0) rf[rd] <= rdata1 + imm_i;
                7'h03: if (rd != 0) rf[rd] <= mem_rdata;
                7'h63: begin
                    if (funct3 == 3'h0 && rdata1 == rdata2) next_pc = pc + imm_b;
                    else if (funct3 == 3'h5 && $signed(rdata1) >= $signed(rdata2)) next_pc = pc + imm_b;
                end
            endcase
            pc <= next_pc;
        end
    end
endmodule