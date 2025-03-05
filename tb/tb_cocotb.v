//******************************************************************************
// file:    tb_coctb.v
//
// author:  JAY CONVERTINO
//
// date:    2025/03/04
//
// about:   Brief
// Test bench wrapper for cocotb
//
// license: License MIT
// Copyright 2024 Jay Convertino
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
 * Module: tb_cocotb
 *
 * This core is a MIL-STD-1553 to AXI streaming decoder.
 * It uses the postive edge of a clock to sample data.
 * This restricts the core to 2 Mhz and above for a sample clock.
 *
 * Parameters:
 *
 *   CLOCK_SPEED      - This is the aclk frequency in Hz, must be 2 MHz or above.
 *   SAMPLE_RATE      - 2 MHz or above rate that is an even divisor of CLOCK_SPEED
 *
 * Ports:
 *
 *   aclk           - Clock for all logic
 *   arstn          - Negative reset
 *   s_axis_tdata   - Input data for 1553 encoder.
 *   s_axis_tvalid  - When active high the input data is valid.
 *   s_axis_tuser   - Information about the AXIS data {TYY,NA,I,P}
 *
 *                    Bits explained below:
 *                  --- Code
 *                    - TYY = TYPE OF DATA
 *                          - 000 NA
 *                          - 001 REG (NOT IMPLIMENTED)
 *                          - 010 DATA
 *                          - 100 CMD/STATUS
 *                    - NA  = RESERVED FOR FUTURE USE.
 *                    - D   = DELAY BEFORE DATA
 *                          - 1 = Delay of 4us or more before data
 *                          - 0 = No delay between data
 *                    - I   = INVERT
 *                          - 1 = Invert input data before output
 *                          - 0 = No inversion of data before output.
 *                    - P   = PARITY
 *                          - 1 = ODD
 *                          - 0 = EVEN
 *                  ---
 *
 *   s_axis_tready  - When active high the device is ready for data.
 *   diff           - Output data in TTL differential format.
 */
module tb_cocotb #(
    parameter CLOCK_SPEED = 20000000,
    parameter SAMPLE_RATE = 20000000
  )
  (
    input             aclk,
    input             arstn,
    input   [15:0]    s_axis_tdata,
    input             s_axis_tvalid,
    input   [ 7:0]    s_axis_tuser,
    output            s_axis_tready,
    output  [ 1:0]    diff,
    output            en_diff
  );
  // fst dump command
  initial begin
    $dumpfile ("tb_cocotb.fst");
    $dumpvars (0, tb_cocotb);
    #1;
  end
  
  //Group: Instantiated Modules

  /*
   * Module: dut
   *
   * Device under test, axis_1553_encoder
   */
   axis_1553_encoder #(
    .CLOCK_SPEED(CLOCK_SPEED),
    .SAMPLE_RATE(SAMPLE_RATE)
  ) dut (
    .aclk(aclk),
    .arstn(arstn),
    .s_axis_tdata(s_axis_tdata),
    .s_axis_tvalid(s_axis_tvalid),
    .s_axis_tuser(s_axis_tuser),
    .s_axis_tready(s_axis_tready),
    .diff(diff),
    .en_diff(en_diff)
  );
  
endmodule

