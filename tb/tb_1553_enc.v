//******************************************************************************
/// @file    tb_1553_enc.v
/// @author  JAY CONVERTINO
/// @date    2021.05.25
/// @brief   SIMPLE TEST BENCH FOR 1553... THIS NEEDS MORE... STUFF. 8^)
///
/// @LICENSE MIT
///  Copyright 2021 Jay Convertino
///
///  Permission is hereby granted, free of charge, to any person obtaining a copy
///  of this software and associated documentation files (the "Software"), to 
///  deal in the Software without restriction, including without limitation the
///  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or 
///  sell copies of the Software, and to permit persons to whom the Software is 
///  furnished to do so, subject to the following conditions:
///
///  The above copyright notice and this permission notice shall be included in 
///  all copies or substantial portions of the Software.
///
///  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
///  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
///  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
///  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
///  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
///  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
///  IN THE SOFTWARE.
//******************************************************************************

`timescale 1 ns/10 ps

module tb_1553;
  
  reg         tb_data_clk = 0;
  reg         tb_rst = 0;
  wire [1:0]  tb_dout;
  wire        tb_en_dout;
  wire [15:0] tb_tdata;
  reg  [7:0]  tb_tuser;
  wire        tb_tvalid;
  wire        tb_tready;
  
  //1ns
  localparam CLK_PERIOD = 50;
  localparam RST_PERIOD = 100;
  
  //produce data
  slave_axis_stimulus #(
    .BUS_WIDTH(2),
    .USER_WIDTH(8),
    .DEST_WIDTH(1),
    .FILE("8bit_count.bin")
  ) slave_axis_stim (
    // output to slave
    .m_axis_aclk(tb_data_clk),
    .m_axis_arstn(~tb_rst),
    .m_axis_tvalid(tb_tvalid),
    .m_axis_tready(tb_tready),
    .m_axis_tdata(tb_tdata),
    .m_axis_tkeep(),
    .m_axis_tlast(),
    .m_axis_tuser(),
    .m_axis_tdest(),
    .eof()
  );
  
  //device under test
  axis_1553_encoder #(
    .CLOCK_SPEED(20000000)
  ) dut (
    .aclk(tb_data_clk),
    .arstn(~tb_rst),
    //slave input
    .s_axis_tdata(tb_tdata),
    .s_axis_tvalid(tb_tvalid),
    .s_axis_tuser(tb_tuser),
    .s_axis_tready(tb_tready),
    //diff output
    .diff(tb_dout),
    .en_diff(tb_en_dout)
  );
    
  //reset
  initial begin
    tb_rst <= 1'b1;
    
    #RST_PERIOD;
    
    tb_rst <= 1'b0;
  end
  
  //copy pasta, fst generation
  initial begin
    $dumpfile("tb_1553_enc.fst");
    $dumpvars(0,tb_1553);
  end
  
  //clock
  always begin
    tb_data_clk <= ~tb_data_clk;
    
    #(CLK_PERIOD/2);
  end
  
  //toggle user between data and command
  always @(posedge tb_data_clk) begin
    if(tb_rst == 1'b1) begin
      tb_tuser <= 8'h81;
    end else begin
      // send command sync
      tb_tuser <= 8'h81;
      
      // send data sync
      if(^tb_tdata[7:0] == 1'b1) begin
        tb_tuser <= 8'h41;
      end
    end
  end
  
  //copy pasta, no way to set runtime... this works in vivado as well.
  initial begin
    #10_000_000; // Wait a long time in simulation units (adjust as needed).
    $display("END SIMULATION");
    $finish;
  end
endmodule

