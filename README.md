# AXIS 1553 ENCODER
### AXIS TO MIL-STD-1553 bus.
---

   author: Jay Convertino   
   
   date: 2021.05.17  
   
   details: Incoming AXI streaming data is used to populate a MIL-STD-1553 compliant signal.   
   
   license: MIT   
   
---

### Dependencies
#### Build

  - AFRL:utility:helper:1.0.0
  
#### Simulation

  - AFRL:simulation:axis_stimulator
  - AFRL:utility:sim_helper

### IP USAGE
#### INSTRUCTIONS

TDATA input should contain the 16 bit data payload. TUSER is a 8 bit command register   
that takes a discription what type of data it is (command or data) and other options.   
described below.   

* TUSER = {TYY,NA,D,I,P} (7 downto 0)
  * TYY = TYPE OF DATA
    * 000 N/A
    * 001 REG (NOT IMPLIMENTED)
    * 010 DATA
    * 100 CMD/STATUS
  * NA = RESERVED FOR FUTURE USE.
  * D = DELAY ENABLED
    * 1 = 4 us delay enabled.
    * 0 = no delay between transmissions.
  * I = INVERT DATA
    * 1 = Invert data.
    * 0 = Normal data.
  * P = PARITY
    * 1 = ODD
    * 0 = EVEN

#### PARAMETERS

* clock_speed : DEFAULT = 2000000 : clock speed of aclk to the core in hz.
* sample_rate : DEFAULT = 2000000 : sample rate of generated signal in hz (minimum 2 MHz).

### COMPONENTS
#### SRC

* axis_1553_encoder.v
  
#### TB

* tb_1553_enc.vhd
  
### fusesoc

* fusesoc_info.core created.
* Simulation uses icarus to run data through the core for a fixed amount of time, no verifcation of data in/out.
