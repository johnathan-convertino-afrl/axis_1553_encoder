﻿NDSummary.OnToolTipsLoaded("File:axis_1553_encoder.v",{7:"<div class=\"NDToolTip TInformation LSystemVerilog\"><div class=\"TTSummary\">AXIS MIL-STD-1553 ENCODER</div></div>",8:"<div class=\"NDToolTip TInformation LSystemVerilog\"><div class=\"TTSummary\">Copyright 2021 Jay Convertino</div></div>",1:"<div class=\"NDToolTip TModule LSystemVerilog\"><div id=\"NDPrototype1\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><div class=\"PParameterCells\" data-WideColumnCount=\"6\" data-NarrowColumnCount=\"5\"><div class=\"PBeforeParameters\" data-WideGridArea=\"1/1/3/2\" data-NarrowGridArea=\"1/1/2/6\" style=\"grid-area:1/1/3/2\"><span class=\"SHKeyword\">module</span> axis_1553_encoder #(</div><div class=\"PType InFirstParameterColumn\" data-WideGridArea=\"1/2/2/3\" data-NarrowGridArea=\"2/1/3/2\" style=\"grid-area:1/2/2/3\"><span class=\"SHKeyword\">parameter</span>&nbsp;</div><div class=\"PName\" data-WideGridArea=\"1/3/2/4\" data-NarrowGridArea=\"2/2/3/3\" style=\"grid-area:1/3/2/4\">CLOCK_SPEED</div><div class=\"PDefaultValueSeparator\" data-WideGridArea=\"1/4/2/5\" data-NarrowGridArea=\"2/3/3/4\" style=\"grid-area:1/4/2/5\">&nbsp=&nbsp;</div><div class=\"PDefaultValue InLastParameterColumn\" data-WideGridArea=\"1/5/2/6\" data-NarrowGridArea=\"2/4/3/5\" style=\"grid-area:1/5/2/6\"><span class=\"SHNumber\">2000000</span>,</div><div class=\"PType InFirstParameterColumn\" data-WideGridArea=\"2/2/3/3\" data-NarrowGridArea=\"3/1/4/2\" style=\"grid-area:2/2/3/3\"><span class=\"SHKeyword\">parameter</span>&nbsp;</div><div class=\"PName\" data-WideGridArea=\"2/3/3/4\" data-NarrowGridArea=\"3/2/4/3\" style=\"grid-area:2/3/3/4\">SAMPLE_RATE</div><div class=\"PDefaultValueSeparator\" data-WideGridArea=\"2/4/3/5\" data-NarrowGridArea=\"3/3/4/4\" style=\"grid-area:2/4/3/5\">&nbsp=&nbsp;</div><div class=\"PDefaultValue InLastParameterColumn\" data-WideGridArea=\"2/5/3/6\" data-NarrowGridArea=\"3/4/4/5\" style=\"grid-area:2/5/3/6\"><span class=\"SHNumber\">2000000</span></div><div class=\"PAfterParameters NegativeLeftSpaceOnWide\" data-WideGridArea=\"2/6/3/7\" data-NarrowGridArea=\"4/1/5/6\" style=\"grid-area:2/6/3/7\">) ( <span class=\"SHKeyword\">input</span> aclk, <span class=\"SHKeyword\">input</span> arstn, <span class=\"SHKeyword\">input</span> [<span class=\"SHNumber\">15</span>:<span class=\"SHNumber\">0</span>] s_axis_tdata, <span class=\"SHKeyword\">input</span> s_axis_tvalid, <span class=\"SHKeyword\">input</span> [<span class=\"SHNumber\">7</span>:<span class=\"SHNumber\">0</span>] s_axis_tuser, <span class=\"SHKeyword\">output</span> s_axis_tready, <span class=\"SHKeyword\">output</span> [<span class=\"SHNumber\">1</span>:<span class=\"SHNumber\">0</span>] diff, <span class=\"SHKeyword\">output</span> en_diff )</div></div></div></div><div class=\"TTSummary\">AXI streaming to MIL-STD-1553 encoder. This encoder can be used at 2 Mhz or above.&nbsp; TDATA is 16 bit data to be transmitted. TUSER sets how the core works.</div></div>",10:"<div class=\"NDToolTip TVariable LSystemVerilog\"><div id=\"NDPrototype10\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\"><span class=\"SHKeyword\">localparam integer</span> base_1553_clock_rate = <span class=\"SHNumber\">1000000</span></div></div><div class=\"TTSummary\">1553 base clock rate</div></div>",11:"<div class=\"NDToolTip TVariable LSystemVerilog\"><div id=\"NDPrototype11\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\"><span class=\"SHKeyword\">localparam integer</span> samples_per_mhz = SAMPLE_RATE / base_1553_clock_rate</div></div><div class=\"TTSummary\">sample rate to caputre transmission bits at</div></div>",12:"<div class=\"NDToolTip TVariable LSystemVerilog\"><div id=\"NDPrototype12\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\"><span class=\"SHKeyword\">localparam integer</span> cycles_per_mhz = CLOCK_SPEED / base_1553_clock_rate</div></div><div class=\"TTSummary\">calculate the number of cycles the clock changes per period</div></div>",13:"<div class=\"NDToolTip TVariable LSystemVerilog\"><div id=\"NDPrototype13\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection PascalStyle\"><div class=\"PParameterCells\" data-WideColumnCount=\"6\" data-NarrowColumnCount=\"5\"><div class=\"PBeforeParameters\" data-WideGridArea=\"1/1/2/2\" data-NarrowGridArea=\"1/1/2/6\" style=\"grid-area:1/1/2/2\"><span class=\"SHKeyword\">localparam integer</span> samples_to_skip = (</div><div class=\"PModifierQualifier InFirstParameterColumn\" data-WideGridArea=\"1/2/2/3\" data-NarrowGridArea=\"2/1/3/2\" style=\"grid-area:1/2/2/3\">(cycles_per_mhz &gt; samples_per_mhz) ? cycles_per_mhz / samples_per_mhz -&nbsp;</div><div class=\"PName\" data-WideGridArea=\"1/3/2/4\" data-NarrowGridArea=\"2/2/3/3\" style=\"grid-area:1/3/2/4\"><span class=\"SHNumber\">1</span></div><div class=\"PTypeNameSeparator\" data-WideGridArea=\"1/4/2/5\" data-NarrowGridArea=\"2/3/3/4\" style=\"grid-area:1/4/2/5\">:&nbsp;</div><div class=\"PType InLastParameterColumn\" data-WideGridArea=\"1/5/2/6\" data-NarrowGridArea=\"2/4/3/5\" style=\"grid-area:1/5/2/6\"><span class=\"SHNumber\">0</span></div><div class=\"PAfterParameters\" data-WideGridArea=\"1/6/2/7\" data-NarrowGridArea=\"3/1/4/6\" style=\"grid-area:1/6/2/7\">)</div></div></div></div><div class=\"TTSummary\">calculate the number of samples to skip</div></div>",14:"<div class=\"NDToolTip TVariable LSystemVerilog\"><div id=\"NDPrototype14\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\"><span class=\"SHKeyword\">localparam integer</span> bit_rate_per_mhz = samples_per_mhz</div></div><div class=\"TTSummary\">bit rate per mhz</div></div>",15:"<div class=\"NDToolTip TVariable LSystemVerilog\"><div id=\"NDPrototype15\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\"><span class=\"SHKeyword\">localparam integer</span> delay_time = cycles_per_mhz * <span class=\"SHNumber\">4</span></div></div><div class=\"TTSummary\">delay time, 4 is for 4 us (min 1553 time)</div></div>",16:"<div class=\"NDToolTip TVariable LSystemVerilog\"><div id=\"NDPrototype16\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\"><span class=\"SHKeyword\">localparam integer</span> sync_pulse_len = bit_rate_per_mhz * <span class=\"SHNumber\">3</span></div></div><div class=\"TTSummary\">sync pulse length</div></div>",17:"<div class=\"NDToolTip TVariable LSystemVerilog\"><div id=\"NDPrototype17\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\"><span class=\"SHKeyword\">localparam integer</span> bits_per_trans = <span class=\"SHNumber\">20</span></div></div><div class=\"TTSummary\">bits per transmission</div></div>",18:"<div class=\"NDToolTip TVariable LSystemVerilog\"><div id=\"NDPrototype18\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><div class=\"PParameterCells\" data-WideColumnCount=\"3\" data-NarrowColumnCount=\"2\"><div class=\"PBeforeParameters\" data-WideGridArea=\"1/1/2/2\" data-NarrowGridArea=\"1/1/2/3\" style=\"grid-area:1/1/2/2\"><span class=\"SHKeyword\">localparam integer</span> synth_bits_per_trans = (</div><div class=\"PName InFirstParameterColumn InLastParameterColumn\" data-WideGridArea=\"1/2/2/3\" data-NarrowGridArea=\"2/1/3/2\" style=\"grid-area:1/2/2/3\">bits_per_trans*bit_rate_per_mhz</div><div class=\"PAfterParameters\" data-WideGridArea=\"1/3/2/4\" data-NarrowGridArea=\"3/1/4/3\" style=\"grid-area:1/3/2/4\">)</div></div></div></div><div class=\"TTSummary\">sync bits per trans</div></div>",19:"<div class=\"NDToolTip TVariable LSystemVerilog\"><div id=\"NDPrototype19\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><div class=\"PParameterCells\" data-WideColumnCount=\"3\" data-NarrowColumnCount=\"2\"><div class=\"PBeforeParameters\" data-WideGridArea=\"1/1/2/2\" data-NarrowGridArea=\"1/1/2/3\" style=\"grid-area:1/1/2/2\"><span class=\"SHKeyword\">localparam</span> [(</div><div class=\"PName InFirstParameterColumn InLastParameterColumn\" data-WideGridArea=\"1/2/2/3\" data-NarrowGridArea=\"2/1/3/2\" style=\"grid-area:1/2/2/3\">bit_rate_per_mhz</div><div class=\"PAfterParameters\" data-WideGridArea=\"1/3/2/4\" data-NarrowGridArea=\"3/1/4/3\" style=\"grid-area:1/3/2/4\">)<span class=\"SHNumber\">-1</span>:<span class=\"SHNumber\">0</span>]bit_pattern = {{bit_rate_per_mhz/<span class=\"SHNumber\">2</span>{<span class=\"SHNumber\">1\'b1</span>}}, {bit_rate_per_mhz/<span class=\"SHNumber\">2</span>{<span class=\"SHNumber\">1\'b0</span>}}}</div></div></div></div><div class=\"TTSummary\">create the bit pattern. This is based on outputing data on the negative and positive. This allows the encoder to run down to 1 mhz.</div></div>",20:"<div class=\"NDToolTip TVariable LSystemVerilog\"><div id=\"NDPrototype20\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><div class=\"PParameterCells\" data-WideColumnCount=\"3\" data-NarrowColumnCount=\"2\"><div class=\"PBeforeParameters RightSpaceOnWide\" data-WideGridArea=\"1/1/2/2\" data-NarrowGridArea=\"1/1/2/3\" style=\"grid-area:1/1/2/2\"><span class=\"SHKeyword\">localparam</span> [synth_bits_per_trans-<span class=\"SHNumber\">1</span>:<span class=\"SHNumber\">0</span>]synth_clk = {</div><div class=\"PName InFirstParameterColumn InLastParameterColumn\" data-WideGridArea=\"1/2/2/3\" data-NarrowGridArea=\"2/1/3/2\" style=\"grid-area:1/2/2/3\">bits_per_trans{bit_pattern}</div><div class=\"PAfterParameters LeftSpaceOnWide\" data-WideGridArea=\"1/3/2/4\" data-NarrowGridArea=\"3/1/4/3\" style=\"grid-area:1/3/2/4\">}</div></div></div></div><div class=\"TTSummary\">synth clock is the clock constructed by the repeating the bit pattern. this is intended to be a representation of the clock. Captured at a bit_rate_per_mhz of a 1mhz clock.</div></div>",21:"<div class=\"NDToolTip TVariable LSystemVerilog\"><div id=\"NDPrototype21\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><div class=\"PParameterCells\" data-WideColumnCount=\"4\" data-NarrowColumnCount=\"3\"><div class=\"PBeforeParameters RightSpaceOnWide\" data-WideGridArea=\"1/1/3/2\" data-NarrowGridArea=\"1/1/2/4\" style=\"grid-area:1/1/3/2\"><span class=\"SHKeyword\">localparam</span> [sync_pulse_len-<span class=\"SHNumber\">1</span>:<span class=\"SHNumber\">0</span>]sync_cmd_stat = {</div><div class=\"PSymbols InFirstParameterColumn\" data-WideGridArea=\"1/2/2/3\" data-NarrowGridArea=\"2/1/3/2\" style=\"grid-area:1/2/2/3\">{</div><div class=\"PName InLastParameterColumn\" data-WideGridArea=\"1/3/2/4\" data-NarrowGridArea=\"2/2/3/3\" style=\"grid-area:1/3/2/4\">sync_pulse_len/<span class=\"SHNumber\">2</span>{<span class=\"SHNumber\">1\'b0</span>}},</div><div class=\"PSymbols InFirstParameterColumn\" data-WideGridArea=\"2/2/3/3\" data-NarrowGridArea=\"3/1/4/2\" style=\"grid-area:2/2/3/3\">{</div><div class=\"PName InLastParameterColumn\" data-WideGridArea=\"2/3/3/4\" data-NarrowGridArea=\"3/2/4/3\" style=\"grid-area:2/3/3/4\">sync_pulse_len/<span class=\"SHNumber\">2</span>{<span class=\"SHNumber\">1\'b1</span>}}</div><div class=\"PAfterParameters\" data-WideGridArea=\"2/4/3/5\" data-NarrowGridArea=\"4/1/5/4\" style=\"grid-area:2/4/3/5\">}</div></div></div></div><div class=\"TTSummary\">sync pulse command</div></div>",22:"<div class=\"NDToolTip TVariable LSystemVerilog\"><div id=\"NDPrototype22\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><div class=\"PParameterCells\" data-WideColumnCount=\"4\" data-NarrowColumnCount=\"3\"><div class=\"PBeforeParameters RightSpaceOnWide\" data-WideGridArea=\"1/1/3/2\" data-NarrowGridArea=\"1/1/2/4\" style=\"grid-area:1/1/3/2\"><span class=\"SHKeyword\">localparam</span> [sync_pulse_len-<span class=\"SHNumber\">1</span>:<span class=\"SHNumber\">0</span>]sync_data = {</div><div class=\"PSymbols InFirstParameterColumn\" data-WideGridArea=\"1/2/2/3\" data-NarrowGridArea=\"2/1/3/2\" style=\"grid-area:1/2/2/3\">{</div><div class=\"PName InLastParameterColumn\" data-WideGridArea=\"1/3/2/4\" data-NarrowGridArea=\"2/2/3/3\" style=\"grid-area:1/3/2/4\">sync_pulse_len/<span class=\"SHNumber\">2</span>{<span class=\"SHNumber\">1\'b1</span>}},</div><div class=\"PSymbols InFirstParameterColumn\" data-WideGridArea=\"2/2/3/3\" data-NarrowGridArea=\"3/1/4/2\" style=\"grid-area:2/2/3/3\">{</div><div class=\"PName InLastParameterColumn\" data-WideGridArea=\"2/3/3/4\" data-NarrowGridArea=\"3/2/4/3\" style=\"grid-area:2/3/3/4\">sync_pulse_len/<span class=\"SHNumber\">2</span>{<span class=\"SHNumber\">1\'b0</span>}}</div><div class=\"PAfterParameters\" data-WideGridArea=\"2/4/3/5\" data-NarrowGridArea=\"4/1/5/4\" style=\"grid-area:2/4/3/5\">}</div></div></div></div><div class=\"TTSummary\">sync pulse data</div></div>",23:"<div class=\"NDToolTip TVariable LSystemVerilog\"><div id=\"NDPrototype23\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\"><span class=\"SHKeyword\">localparam</span> cmd_data = <span class=\"SHNumber\">3\'b010</span></div></div><div class=\"TTSummary\">tuser decode for data</div></div>",24:"<div class=\"NDToolTip TVariable LSystemVerilog\"><div class=\"TTSummary\">tuser decode for command</div></div>",25:"<div class=\"NDToolTip TVariable LSystemVerilog\"><div class=\"TTSummary\">enable diff output</div></div>",26:"<div class=\"NDToolTip TGroup LSystemVerilog\"><div class=\"TTSummary\">Variables that makeup the encoder state machine.</div></div>",27:"<div class=\"NDToolTip TVariable LSystemVerilog\"><div id=\"NDPrototype27\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\"><span class=\"SHKeyword\">localparam</span> data_cap = <span class=\"SHNumber\">3\'d1</span></div></div><div class=\"TTSummary\">data capture</div></div>",28:"<div class=\"NDToolTip TVariable LSystemVerilog\"><div id=\"NDPrototype28\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\"><span class=\"SHKeyword\">localparam</span> data_invert = <span class=\"SHNumber\">3\'d2</span></div></div><div class=\"TTSummary\">invert data</div></div>",29:"<div class=\"NDToolTip TVariable LSystemVerilog\"><div id=\"NDPrototype29\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\"><span class=\"SHKeyword\">localparam</span> parity_gen = <span class=\"SHNumber\">3\'d3</span></div></div><div class=\"TTSummary\">parity generator</div></div>",30:"<div class=\"NDToolTip TVariable LSystemVerilog\"><div id=\"NDPrototype30\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\"><span class=\"SHKeyword\">localparam</span> process = <span class=\"SHNumber\">3\'d4</span></div></div><div class=\"TTSummary\">command processor</div></div>",31:"<div class=\"NDToolTip TVariable LSystemVerilog\"><div id=\"NDPrototype31\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\"><span class=\"SHKeyword\">localparam</span> pause_ck = <span class=\"SHNumber\">3\'d5</span></div></div><div class=\"TTSummary\">check for pause (4us)</div></div>",32:"<div class=\"NDToolTip TVariable LSystemVerilog\"><div id=\"NDPrototype32\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\"><span class=\"SHKeyword\">localparam</span> trans = <span class=\"SHNumber\">3\'d6</span></div></div><div class=\"TTSummary\">transmit data</div></div>",33:"<div class=\"NDToolTip TVariable LSystemVerilog\"><div id=\"NDPrototype33\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\"><span class=\"SHKeyword\">localparam</span> error = <span class=\"SHNumber\">3\'d0</span></div></div><div class=\"TTSummary\">someone made a whoops</div></div>"});