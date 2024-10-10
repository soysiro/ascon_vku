`default_nettype none

module user_proj_example #(
    parameter BITS = 16
)(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,

    // Logic Analyzer Signals

    // IOs
    input  [13:0] io_in,
    output [2:0] io_out,
    output [2:0] io_oeb
);
    wire clk;
    wire rst;

    wire clk = wb_clk_i;
    wire rst = !wb_rst_i;
    
    wire output_dataxSO_out;
    wire ascon_readyxSO_out;
    wire tagxSO_out;
    
    assign io_oeb = 1'b0;

    Ascon the_ascon(
        .clk(clk),
        .rst(rst),
        .keyxSI(io_in[13:11]),
        .noncexSI(io_in[10:8]),
        .associated_dataxSI(io_in[7:5]),
        .input_dataxSI(io_in[4:2]),
        .ascon_startxSI(io_in[1]),
        .decrypt(io_in[0]),
        .output_dataxSO(output_dataxSO_out),
        .tagxSO(tagxSO_out),
        .ascon_readyxSO(ascon_readyxSO_out)
    );
    
    assign io_out[0] = output_dataxSO_out;
    assign io_out[1] = tagxSO_out;
    assign io_out[2] = ascon_readyxSO_out;
endmodule
`default_nettype wire
