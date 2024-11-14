//******************************************************************************
// file:    axis_1553_encoder.v
//
// author:  JAY CONVERTINO
//
// date:    2021/05/17
//
// about:   Brief
// AXIS MIL-STD-1553 ENCODER
//
// license: License MIT
// Copyright 2021 Jay Convertino
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.
//
//******************************************************************************

`timescale 1ns/100ps

/*
 * Module: axis_1553_encoder
 *
 * AXI streaming to MIL-STD-1553 encoder. This encoder can be used at 2 Mhz or above.
 * TDATA is 16 bit data to be transmitted. TUSER sets how the core works.
 *
 * Parameters:
 *
 *   CLOCK_SPEED     - This is the aclk frequency in Hz, must be 2 MHz or above.
 *   SAMPLE_RATE     - 2 MHz or above rate that is an even divisor of CLOCK_SPEED
 *
 * Ports:
 *
 *   aclk           - Clock for all logic
 *   arstn          - Negative reset
 *   s_axis_tdata   - Input data for 1553 encoder.
 *   s_axis_tvalid  - When set active high the input data is valid.
 *   s_axis_tuser   - Information about the AXIS data {TYY,NA,I,P}
 *
 *                    Bits explained below:
 *                  --- Code
 *                    - TYY = TYPE OF DATA
 *                          - 000 = NA
 *                          - 001 = REG (NOT IMPLIMENTED)
 *                          - 010 = DATA
 *                          - 100 = CMD/STATUS
 *                    - D   = DELAY ENABLED
 *                    - I   = INVERT DATA
 *                    - P   = PARITY
 *                          - 1 = ODD
 *                          - 0 = EVEN
 *                  ---
 *
 *   s_axis_tready  - When active high the device is ready for input data.
 *   diff           - Output data in TTL differential format.
 *   en_diff        - When diff is valid data, this is active high and can be used to switch a mux.
 */
module axis_1553_encoder #(
    parameter CLOCK_SPEED = 2000000,
    parameter SAMPLE_RATE = 2000000
  ) 
  (
    input               aclk,
    input               arstn,
    input   [15:0]      s_axis_tdata,
    input               s_axis_tvalid,
    input   [7:0]       s_axis_tuser,
    output              s_axis_tready,
    output  [1:0]       diff,
    output              en_diff
  );
  
  `include "util_helper_math.vh"
  
  // var: base_1553_clock_rate
  // 1553 base clock rate
  localparam integer base_1553_clock_rate = 1000000;
  // var: samples_per_mhz
  // sample rate to caputre transmission bits at
  localparam integer samples_per_mhz = SAMPLE_RATE / base_1553_clock_rate;
  // var: cycles_per_mhz
  // calculate the number of cycles the clock changes per period
  localparam integer cycles_per_mhz = CLOCK_SPEED / base_1553_clock_rate;
  // var: samples_to_skip
  // calculate the number of samples to skip
  localparam integer samples_to_skip = ((cycles_per_mhz > samples_per_mhz) ? cycles_per_mhz / samples_per_mhz - 1 : 0);
  // var: bit_rate_per_mhz
  // bit rate per mhz
  localparam integer bit_rate_per_mhz = samples_per_mhz;
  // var: delay_time
  // delay time, 4 is for 4 us (min 1553 time)
  localparam integer delay_time = cycles_per_mhz * 4;
  // var: sync_pulse_len
  // sync pulse length
  localparam integer sync_pulse_len = bit_rate_per_mhz * 3;
  // var: bits_per_trans
  // bits per transmission
  localparam integer bits_per_trans = 20;
  // var: synth_bits_per_trans
  // sync bits per trans
  localparam integer synth_bits_per_trans = (bits_per_trans*bit_rate_per_mhz);
  // var: bit_pattern
  // create the bit pattern. This is based on outputing data on the negative and positive. This allows the encoder to run down to 1 mhz.
  localparam [(bit_rate_per_mhz)-1:0]bit_pattern = {{bit_rate_per_mhz/2{1'b1}}, {bit_rate_per_mhz/2{1'b0}}};
  // var: synth_clk
  // synth clock is the clock constructed by the repeating the bit pattern. this is intended to be a representation of the clock. Captured at a bit_rate_per_mhz of a 1mhz clock.
  localparam [synth_bits_per_trans-1:0]synth_clk = {bits_per_trans{bit_pattern}};
  // var: sync_cmd_stat
  // sync pulse command
  localparam [sync_pulse_len-1:0]sync_cmd_stat = {{sync_pulse_len/2{1'b0}}, {sync_pulse_len/2{1'b1}}};
  // var: sync_data
  // sync pulse data
  localparam [sync_pulse_len-1:0]sync_data     = {{sync_pulse_len/2{1'b1}}, {sync_pulse_len/2{1'b0}}};
  // var: cmd_data
  // tuser decode for data
  localparam cmd_data = 3'b010;
  // var: cmd_data
  // tuser decode for command
  localparam cmd_cmnd = 3'b100;
  // var: cmd_data
  // enable diff output
  localparam enable_diff_output = 1'b1;

  // Group: State Machine
  // Constants that makeup the encoder state machine.

  // var: data_cap
  // data capture
  localparam data_cap     = 3'd1;
  // var: data_invert
  // invert data
  localparam data_invert  = 3'd2;
  // var: parity_gen
  // parity generator
  localparam parity_gen   = 3'd3;
  // var: process
  // command processor
  localparam process      = 3'd4;
  // var: pause_ck
  // check for pause (4us)
  localparam pause_ck     = 3'd5;
  // var: trans
  // transmit data
  localparam trans        = 3'd6;
  // var: error
  // someone made a whoops
  localparam error        = 3'd0;
  
  //for loop indexs
  integer xor_index;
  integer cycle_index;
  //data reg
  reg [synth_bits_per_trans-1:0]reg_data;
  //parity bit storage
  reg parity_bit;
  //state machine
  reg [2:0]  state = error;
  //incoming data to transmit
  reg [15:0] data;
  reg [15:0] r_data;
  //incoming cmd to parse
  reg [7:0]  cmd;
  //counters
  reg [clogb2(samples_to_skip):0]         skip_counter;
  reg [clogb2(delay_time)-1:0]            pause_counter;
  reg [clogb2(synth_bits_per_trans)-1:0]  trans_counter;
  reg [clogb2(synth_bits_per_trans)-1:0]  prev_trans_counter;
  //for outputs
  reg [1:0]   r_diff;
  reg         r_en_diff;
  
  assign s_axis_tready = (state == data_cap ? arstn : 0);
  assign diff = r_diff;
  assign en_diff = r_en_diff;

  //pause_counter(must be 4us or more between transmit)
  always @(posedge aclk) begin
    if(arstn == 1'b0) begin
      pause_counter <= delay_time-1;
    end else begin
      case (state)
        trans:
          pause_counter <= delay_time-1;
        default: begin
          pause_counter <= pause_counter - 1;
          
          if(pause_counter == 0) begin
            pause_counter <= 0;
          end
        end
      endcase
    end
  end
  
  //axis data input
  always @(posedge aclk) begin
    if(arstn == 1'b0) begin
      data        <= 0;
      cmd         <= 0;
    end else begin
      data <= data;
      cmd  <= cmd;
      
      case (state)
        data_cap: begin
          if(s_axis_tvalid == 1'b1) begin
            data <= s_axis_tdata;
            cmd  <= s_axis_tuser;
          end
        end
        trans: begin
          data <= 0;
          cmd  <= 0;
        end
      endcase
    end
  end
  
  //data processing
  always @(posedge aclk) begin
    if(arstn == 1'b0) begin
      state       <= error;
      parity_bit  <= 0;
      xor_index   <= 0;
      cycle_index <= 0;
      reg_data    <= synth_clk;
    end else begin
      case (state)
        //capture data from axis interface
        data_cap: begin
          state <= data_cap;
          reg_data <= synth_clk;
          parity_bit <= 0;
          r_data     <= 0;
          
          if(s_axis_tvalid == 1'b1) begin
            state <= data_invert;
          end
        end
        data_invert: begin
          state <= parity_gen;
          
          r_data <= data;
          
          if(cmd[1] == 1'b1) begin
            r_data <= ~data;
          end
        end
        //generate parity using reduction operator
        parity_gen: begin
          state <= process;
          
          parity_bit <= ^r_data;
            
        end
        //process command data to setup data transmission
        process: begin
          state <= pause_ck;
          
          //skip pause check if delay set to 0
          if(cmd[2] == 1'b0) begin
            state <= trans;
          end
          
          //insert correct sync pulse
          case (cmd[7:5])
            cmd_data:
              reg_data[synth_bits_per_trans-1:synth_bits_per_trans-sync_pulse_len] <= sync_data;
            cmd_cmnd:
              reg_data[synth_bits_per_trans-1:synth_bits_per_trans-sync_pulse_len] <= sync_cmd_stat;
            default:
              reg_data[synth_bits_per_trans-1:synth_bits_per_trans-sync_pulse_len] <= 0;
          endcase
          
          //insert parity bit and set to odd or even
          reg_data[bit_rate_per_mhz-1:0] <= reg_data[bit_rate_per_mhz-1:0] ^ {bit_rate_per_mhz{parity_bit}} ^ {bit_rate_per_mhz{cmd[0]}};
          
          //expand data for xor
          //xor data with synth clock
          for(xor_index = 0; xor_index < 16; xor_index = xor_index + 1) begin
            for(cycle_index = (bit_rate_per_mhz*xor_index)+(bit_rate_per_mhz); cycle_index < (bit_rate_per_mhz*xor_index)+(bit_rate_per_mhz*2); cycle_index = cycle_index + 1)
              reg_data[cycle_index] <= reg_data[cycle_index] ^ r_data[xor_index];
          end
        end
        //wait for 4us between transmissions, if that time hasn't elapsed already.
        //pause count in pause count process above.
        pause_ck: begin
          state <= pause_ck;
          
          if(pause_counter == 0) begin
            state <= trans;
          end
        end
        //transmit data, actually done in data output process below.
        trans: begin
          state <= trans;
          
          if((trans_counter == 0) && (prev_trans_counter == 0) && (skip_counter == samples_to_skip)) begin
            state <= data_cap;
          end
        end
        default:
          state <= data_cap;
      endcase
    end
  end
  
  //differential data output positive edge
  always @(posedge aclk) begin
    if(arstn == 1'b0) begin
      r_diff              <= 0;
      r_en_diff           <= ~enable_diff_output;
      trans_counter       <= synth_bits_per_trans-1;
      prev_trans_counter  <= synth_bits_per_trans-1;
    end else begin
      prev_trans_counter <= trans_counter;
      
      case (state)
        //once the state machine is in transmisson state, begin data output
        trans: begin
          skip_counter <= skip_counter + 1;
          
          r_en_diff <= enable_diff_output;
          
          r_diff[0] <= reg_data[trans_counter];
          r_diff[1] <= ~reg_data[trans_counter];
          
          if(skip_counter == samples_to_skip) begin
            
            trans_counter <= trans_counter - 1;
            
            skip_counter <= 0;
          end
          
          //once 0 hold counter
          if(trans_counter == 0) begin
            trans_counter <= 0;
          end
        end
        default: begin
          //default state of counters and data output.
          r_diff              <= 0;
          skip_counter        <= 0;
          r_en_diff           <= ~enable_diff_output;
          trans_counter       <= synth_bits_per_trans-1;
          prev_trans_counter  <= synth_bits_per_trans-1;
        end
        endcase
    end
  end
endmodule
