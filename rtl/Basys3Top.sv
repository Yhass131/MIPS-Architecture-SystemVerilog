`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Personal Project
// Engineer: Yunus Hassen
//
// Create Date: 07/16/2026 04:03:30 PM
// Design Name: MIPS
// Module Name: Basys3Top
// Project Name: MIPS_inVerilog
// Target Devices: xc7a35tcpg236-1
// Tool Versions: Vivado 2025.1
// Description:
// Top-level FPGA wrapper for the Basys3 board. Debounces and edge-detects
// the board's push buttons to derive a single-step clock enable for the
// MIPS core (BTNC advances exactly one instruction per press, BTNL pauses
// stepping while held, BTNR resets), instantiates the TopLevel MIPS
// datapath running off the free-running 100MHz board clock, and drives
// the seven-segment display and LEDs from the core's write-back data and
// status flags. This module does not decode instructions or compute any
// datapath value itself - it only conditions I/O around the TopLevel core.
//
// Inputs:
//   CLK    - 1-bit  - board 100MHz clock, free-running
//   BTNU   - 1-bit  - selects upper/lower half-word on the 7-seg display
//   BTNC   - 1-bit  - step button, advances one instruction per press
//   BTNL   - 1-bit  - held to pause stepping
//   BTNR   - 1-bit  - synchronous reset for the MIPS core
// Outputs:
//   LED      - 16-bit - [4:0]=PC word index, [13]=Carryout, [14]=Overflow, [15]=Zero
//   SSEG_CA  - 8-bit  - seven-segment cathode pattern (active-low, includes decimal point)
//   SSEG_AN  - 4-bit  - seven-segment digit anode select (active-low)
//
// Dependencies:
// debounce, edge_detect, seg7_decode, seg7_display (defined in this file), TopLevel
//
// Additional Comments:
// This file also defines four small helper modules used only by Basys3Top:
// debounce (button synchronizer/debouncer), edge_detect (rising-edge pulse
// generator), seg7_decode (hex-to-7-segment pattern lookup), and
// seg7_display (time-multiplexed 4-digit display driver). They are grouped
// here rather than split into separate files because none are reused
// elsewhere in the design.
//////////////////////////////////////////////////////////////////////////////////

//========= Button Debouncer =========
module debounce #(
    parameter int DEBOUNCE_BITS = 20
)(
    input  logic clk,
    input  logic btn_raw,
    output logic btn_clean
    );

    logic sync_ff1, sync_ff2;
    logic [DEBOUNCE_BITS-1:0] counter;

    always_ff @(posedge clk) begin
        sync_ff1 <= btn_raw;
        sync_ff2 <= sync_ff1;
    end

    always_ff @(posedge clk) begin
        if (sync_ff2 != btn_clean) begin
            counter <= counter + 1'b1;
            if (counter == {DEBOUNCE_BITS{1'b1}}) begin
                btn_clean <= sync_ff2;
                counter   <= '0;
            end
        end else begin
            counter <= '0;
        end
    end
endmodule


//========= Rising-Edge Pulse Detector =========
module edge_detect(
    input  logic clk,
    input  logic sig_in,
    output logic pulse
    );

    logic sig_d;
    always_ff @(posedge clk)
        sig_d <= sig_in;

    assign pulse = sig_in & ~sig_d;
endmodule


//========= Hex-to-7-Segment Decoder =========
module seg7_decode(
    input  logic [3:0] hex,
    output logic [6:0] seg
    );

    always_comb begin
        case (hex)
            4'h0: seg = 7'b0111111;
            4'h1: seg = 7'b0000110;
            4'h2: seg = 7'b1011011;
            4'h3: seg = 7'b1001111;
            4'h4: seg = 7'b1100110;
            4'h5: seg = 7'b1101101;
            4'h6: seg = 7'b1111101;
            4'h7: seg = 7'b0000111;
            4'h8: seg = 7'b1111111;
            4'h9: seg = 7'b1101111;
            4'hA: seg = 7'b1110111;
            4'hB: seg = 7'b1111100;
            4'hC: seg = 7'b0111001;
            4'hD: seg = 7'b1011110;
            4'hE: seg = 7'b1111001;
            4'hF: seg = 7'b1110001;
            default: seg = 7'b0000000;
        endcase
    end
endmodule


//========= Multiplexed 7-Segment Display Driver =========
module seg7_display(
    input  logic        clk,
    input  logic [31:0] value,
    input  logic        half_sel,
    output logic [7:0]  SSEG_CA,
    output logic [3:0]  SSEG_AN
    );

    logic [17:0] refresh_counter;
    logic [1:0]  digit_sel;
    logic [15:0] active_half;
    logic [3:0]  nibble;
    logic [6:0]  seg;

    always_ff @(posedge clk)
        refresh_counter <= refresh_counter + 1'b1;

    assign digit_sel   = refresh_counter[17:16];
    assign active_half = half_sel ? value[31:16] : value[15:0];

    always_comb begin
        case (digit_sel)
            2'b00: nibble = active_half[3:0];
            2'b01: nibble = active_half[7:4];
            2'b10: nibble = active_half[11:8];
            2'b11: nibble = active_half[15:12];
            default: nibble = 4'h0;
        endcase
    end

    seg7_decode dec0(.hex(nibble), .seg(seg));

    assign SSEG_CA = ~{1'b0, seg};

    always_comb begin
        case (digit_sel)
            2'b00: SSEG_AN = 4'b1110;
            2'b01: SSEG_AN = 4'b1101;
            2'b10: SSEG_AN = 4'b1011;
            2'b11: SSEG_AN = 4'b0111;
            default: SSEG_AN = 4'b1111;
        endcase
    end
endmodule


//========= Top-Level Board Wrapper =========
module Basys3Top(
    input  logic        CLK,
    input  logic        BTNU,
    input  logic        BTNC,
    input  logic        BTNL,
    input  logic        BTNR,
    output logic [15:0] LED,
    output logic [7:0]  SSEG_CA,
    output logic [3:0]  SSEG_AN
    );

    // ---------------- button conditioning ----------------
    logic btnU_clean, btnC_clean, btnL_clean, btnR_clean;

    debounce db_u(.clk(CLK), .btn_raw(BTNU), .btn_clean(btnU_clean));
    debounce db_c(.clk(CLK), .btn_raw(BTNC), .btn_clean(btnC_clean));
    debounce db_l(.clk(CLK), .btn_raw(BTNL), .btn_clean(btnL_clean));
    debounce db_r(.clk(CLK), .btn_raw(BTNR), .btn_clean(btnR_clean));

    // single-cycle step strobe, still needed - a press must advance
    // exactly one instruction regardless of how long it's held
    logic step_pulse;
    edge_detect ed_step(.clk(CLK), .sig_in(btnC_clean), .pulse(step_pulse));

    // ---------------- MIPS control signals ----------------
    // CLK is now the TRUE free-running 100MHz clock, always. No derived
    // clock, no race. RST is sampled synchronously on every real edge.
    logic rst_level;
    assign rst_level = btnR_clean;

    // BTNL held -> pause: suppress the step strobe entirely while held,
    // so a step press during a pause has no effect.
    logic step_enable;
    assign step_enable = step_pulse & ~btnL_clean;

    // ---------------- MIPS core ----------------
    logic [31:0] Dout;
    logic [4:0]  PCout;
    logic Zero, Overflow, Carryout;

    TopLevel Top (
        .CLK(CLK),           // real clock, not derived
        .EN(step_enable),    // single-cycle enable pulse per step press
        .RST(rst_level),     // ordinary synchronous reset, no race
        .Dout(Dout),
        .PCout(PCout),
        .Zero(Zero),
        .Overflow(Overflow),
        .Carryout(Carryout)
    );

    // ---------------- 7-segment display ----------------
    seg7_display seg0(
        .clk(CLK),
        .value(Dout),
        .half_sel(btnU_clean),
        .SSEG_CA(SSEG_CA),
        .SSEG_AN(SSEG_AN)
    );

    // ---------------- LEDs ----------------
    assign LED[4:0]  = PCout;
    assign LED[12:5] = 8'b0;
    assign LED[13]   = Carryout;
    assign LED[14]   = Overflow;
    assign LED[15]   = Zero;

endmodule