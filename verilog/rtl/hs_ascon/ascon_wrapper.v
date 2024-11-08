`default_nettype none

module ascon_wrapper (
`ifdef USE_POWER_PINS
    inout vccd1,    // User area 1 1.8V supply
    inout vssd1,    // User area 1 digital ground
`endif
    input      clk,
    input      rst,
    input      [5:0] io_in,
    output reg [2:0] io_out,
    output reg [10:0] io_oeb
);

    // Đặt giá trị mặc định cho io_oeb trong khối always
    always @(*) begin
        io_oeb = 11'b1111_1111_000;
    end

    // Module Ascon
    wire output_dataxSO;
    wire tagxSO;
    wire ascon_readyxSO;

    Ascon ascon (
        .clk(clk),
        .rst(rst),
        .keyxSI(io_in[5]),
        .noncexSI(io_in[4]),
        .associated_dataxSI(io_in[3]),
        .input_dataxSI(io_in[2]),
        .ascon_startxSI(io_in[1]),
        .decrypt(io_in[0]),
        .output_dataxSO(output_dataxSO),
        .tagxSO(tagxSO),
        .ascon_readyxSO(ascon_readyxSO)
    );

    // Gán giá trị cho io_out trong khối always
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            io_out <= 3'b000;
        end else begin
            io_out[2] <= output_dataxSO;
            io_out[1] <= tagxSO;
            io_out[0] <= ascon_readyxSO;
        end
    end

endmodule

`default_nettype wire
