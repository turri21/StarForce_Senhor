`define QUARTUS
//`define TRION
//`default_nettype none


module starforce_memory 
  (
   input wire [15:0] CPU0_A,
   input wire [15:0] CPU1_A,

   output wire [7:0] sndrom,
   output wire [7:0] rom23,
   output wire [7:0] rom45,
 
   input wire	     sndclk,
   input wire	     cpuclk,
   input wire	     grpclk1,
   input wire	     grpclk2,

//b2
   output wire [7:0] rom9_o,rom10_o,rom11_o,rom12_o,rom13_o,rom14_o,
   input wire [12:0] ROMA_addr,
   input wire [11:0] romb_addr,
   output wire [7:0] rom6_o,rom7_o,rom8_o,
    
//b3
   input wire [12:0] sw12_a,
   input wire [12:0] rom1517_a,
   input wire [12:0] rom1820_a,
   input wire	     sw12_a12,
   output wire [7:0] sw1_o,sw2_o,
   output wire [7:0] rom15_o,rom16_o,rom17_o,
   output wire [7:0] rom18_o,rom19_o,rom20_o,
   output wire [7:0] sw1b_o,
	
	input wire [7:0] sndprom_ain,
	output wire [7:0] sndprom_dout,

   input wire	     ROMCL,
   input wire [17:0] ROMAD,
   input wire [7:0]  ROMDT,
   input wire	     ROMEN


	
);


   wire  cs_main1  = (  ROMAD[17:14] == 4'b00_00   );
   wire	cs_main2  = (  ROMAD[17:14] == 4'b00_01   );
   wire	cs_snd1   = (  ROMAD[17:13] == 5'b00_100  );
   wire	cs_snd2   = (  ROMAD[17:13] == 5'b00_101  );

   wire	cs_rom6   = (  ROMAD[17:12] == 6'b00_1100 );
   wire	cs_rom7   = (  ROMAD[17:12] == 6'b00_1101 );
   wire	cs_rom8   = (  ROMAD[17:12] == 6'b00_1110 );
	
   wire	cs_rom9   = (  ROMAD[17:13] == 5'b01_000  );  
   wire	cs_rom10  = (  ROMAD[17:13] == 5'b01_001  ); 
   wire	cs_rom11  = (  ROMAD[17:13] == 5'b01_010  ); 
   wire	cs_rom12  = (  ROMAD[17:13] == 5'b01_011  ); 
   wire	cs_rom13  = (  ROMAD[17:13] == 5'b01_100  ); 
   wire	cs_rom14  = (  ROMAD[17:13] == 5'b01_101  ); 

   wire	cs_romsw1 = (  ROMAD[17:13] == 5'b01_110  ); 
   wire	cs_romsw2 = (  ROMAD[17:12] == 6'b01_1110 );
   wire	cs_rom15  = (  ROMAD[17:13] == 5'b10_000  );
   wire	cs_rom16  = (  ROMAD[17:13] == 5'b10_001  );
   wire	cs_rom17  = (  ROMAD[17:13] == 5'b10_010  );
   wire	cs_rom18  = (  ROMAD[17:13] == 5'b10_011  );
   wire	cs_rom19  = (  ROMAD[17:13] == 5'b10_100  );
   wire	cs_rom20  = (  ROMAD[17:13] == 5'b10_101  );
   wire	cs_prom   = (  ROMAD[17:5]  ==  13'b10_1100_0000_000 );


/*
	   <rom index="0" zip="starforc.zip" md5="none" type="merged|nonmerged">
	   <part crc="8ba27691" name="3.3p"/>  <!-- main 0-3fff -->      <!-- 00000 - 03FFF --> 00_0000_0000_0000_0000 - 00_0011_1111_1111_1111
		<part crc="0fc4d2d6" name="2.3mn"/> <!-- 4000-7fff -->        <!-- 04000 - 07FFF --> 00_0100_0000_0000_0000 - 00_0111_1111_1111_1111
		<part crc="2735bb22" name="1.3hj"/> <!-- snd 0-1fff -->       <!-- 08000 - 09FFF --> 00_1000_0000_0000_0000 - 00_1001_1111_1111_1111
		<part repeat="8192">00</part>       <!-- (snd stereo ) -->    <!-- 0A000 - 0BFFF --> 00_1010_0000_0000_0000 - 00_1011_1111_1111_1111
		<part crc="eead1d5c" name="9.3fh"/> <!-- rom6 0-fff -->       <!-- 0C000 - 0CFFF --> 00_1100_0000_0000_0000 - 00_1100_1111_1111_1111
		<part crc="96979684" name="8.3fh"/> <!-- rom7 0-fff -->       <!-- 0D000 - 0DFFF --> 00_1101
		<part crc="f4803339" name="7.2fh"/> <!-- rom8 0-fff -->       <!-- 0E000 - 0EFFF --> 00_1110
		<part repeat="4096">00</part>       <!-- pad -->              <!-- 0F000 - 0FFFF --> none
		<part crc="dd9d68a4" name="4.8lm"/> <!-- rom9,10 0-3fff -->   <!-- 10000 - 13FFF --> 01_0000 - 01_0001 , 01_0010 - 01_0011
 		<part crc="f71717f8" name="5.9lm"/> <!-- rom11,12 0-3fff -->  <!-- 14000 - 17FFF --> 01_0100 - 01_0101 , 01_0110 - 01_0111 
		<part crc="5468a21d" name="6.10lm"/> <!-- rom13,14 0-3fff --> <!-- 18000 - 1BFFF --> 01_1000 - 01_1001 , 01_1010 - 01_1011
		<part crc="68c60d0f" name="17.9pq"/> <!-- sw1 0-fff -->       <!-- 1C000 - 1CFFF --> 01_1100
		<part crc="ce20b469" name="16.8pq"/> <!-- sw1 1000-1fff -->   <!-- 1D000 - 1DFFF --> 01_1101
		<part crc="6455c3ad" name="18.10pq"/> <!-- sw2 0-fff -->      <!-- 1E000 - 1EFFF --> 01_1110
		<part repeat="4096">00</part>       <!-- pad -->              <!-- 1F000 - 1FFFF -->
		<part crc="84603285" name="13.8jk"/> <!-- rom15 0-1fff -->    <!-- 20000 - 21FFF --> 10_0000 - 10_0001 
		<part crc="9e9384fe" name="14.9jk"/> <!-- rom16 0-1fff -->    <!-- 22000 - 23FFF --> 10_0010 - 10_0011
		<part crc="c3bda12f" name="15.10jk"/> <!-- rom17 0-1fff -->   <!-- 24000 - 25FFF --> 10_0100 - 10_0101
		<part crc="c62a19c1" name="10.8de"/> <!-- rom18 0-1fff -->    <!-- 26000 - 27FFF --> 10_0110 - 10_0111
		<part crc="668aea14" name="11.9de"/> <!-- rom19 0-1fff -->    <!-- 28000 - 29FFF --> 10_1000 - 10_1001
		<part crc="fdd9e38b" name="12.10de"/> <!-- rom20 0-1fff -->   <!-- 2A000 - 2BFFF --> 10_1010 - 10_1011
		<part crc="68db8300" name="07b.bin"/> <!-- prom 0-1f -->      <!-- 2C000 - 2C01F --> 10_1010_0000_0000_0000 - 10_1010_0000_0001_1111 
   
*/

   //board1 rom
   //   M_sndrom_0_3fff sndrom0

   dpram14 rrom23
     ( .address_a (CPU0_A[13:0]), .q_a (rom23), .clock_a (~cpuclk) ,
       .address_b (ROMAD), .data_b (ROMDT), .clock_b (ROMCL),  .wren_b ( ROMEN & cs_main1 ) );

   dpram14 rrom45
     ( .address_a (CPU0_A[13:0]), .q_a (rom45), .clock_a (~cpuclk) ,
       .address_b (ROMAD), .data_b (ROMDT), .clock_b (ROMCL),  .wren_b ( ROMEN & cs_main2 ) );
	
   dpram13 sndrom0
     ( .address_a (CPU1_A[12:0]), .q_a (sndrom), .clock_a (grpclk1) ,
       .address_b (ROMAD), .data_b (ROMDT), .clock_b (ROMCL),  .wren_b ( ROMEN & cs_snd1 ) );
       
   //board2 rom
   dpram12 rom6
     ( .address_a ( romb_addr ), .q_a ( rom6_o ), .clock_a ( ~grpclk1 ) ,
       .address_b (ROMAD), .data_b (ROMDT), .clock_b (ROMCL),  .wren_b ( ROMEN & cs_rom6 ) );

   dpram12 rom7
     ( .address_a ( romb_addr ), .q_a ( rom7_o ), .clock_a ( ~grpclk1 ) ,
       .address_b (ROMAD), .data_b (ROMDT), .clock_b (ROMCL),  .wren_b ( ROMEN & cs_rom7 ) );

   dpram12 rom8
     ( .address_a ( romb_addr ), .q_a ( rom8_o ), .clock_a ( ~grpclk1 ) ,
       .address_b (ROMAD), .data_b (ROMDT), .clock_b (ROMCL),  .wren_b ( ROMEN & cs_rom8 ) );

   dpram13 rom9 
     ( .address_a ( ROMA_addr ), .q_a ( rom9_o ), .clock_a ( grpclk1 ) ,
       .address_b (ROMAD), .data_b (ROMDT), .clock_b (ROMCL),  .wren_b ( ROMEN & cs_rom9 ) );

   dpram13 rom10
     ( .address_a ( ROMA_addr ), .q_a ( rom10_o ), .clock_a ( grpclk1 ) ,
       .address_b (ROMAD), .data_b (ROMDT), .clock_b (ROMCL),  .wren_b ( ROMEN & cs_rom10 ) );

   dpram13 rom11
     ( .address_a ( ROMA_addr ), .q_a ( rom11_o ), .clock_a ( grpclk1 ) ,
       .address_b (ROMAD), .data_b (ROMDT), .clock_b (ROMCL),  .wren_b ( ROMEN & cs_rom11 ) );

   dpram13 rom12
     ( .address_a ( ROMA_addr ), .q_a ( rom12_o ), .clock_a ( grpclk1 ) ,
       .address_b (ROMAD), .data_b (ROMDT), .clock_b (ROMCL),  .wren_b ( ROMEN & cs_rom12 ) );

   dpram13 rom13
     ( .address_a ( ROMA_addr ), .q_a ( rom13_o ), .clock_a ( grpclk1 ) ,
       .address_b (ROMAD), .data_b (ROMDT), .clock_b (ROMCL),  .wren_b ( ROMEN & cs_rom13 ) );

   dpram13 rom14
     ( .address_a ( ROMA_addr ), .q_a ( rom14_o ), .clock_a ( grpclk1 ) ,
       .address_b (ROMAD), .data_b (ROMDT), .clock_b (ROMCL),  .wren_b ( ROMEN & cs_rom14 ) );
     
   //board3 rom
   dpram13 sw1
     ( .address_a ( sw12_a[11:0] /*{sw12_a12,sw12_a[11:0]}*/ ), .q_a ( sw1_o ), .clock_a ( ~grpclk2 ) ,
       .address_b (ROMAD), .data_b (ROMDT), .clock_b (ROMCL),  .wren_b ( ROMEN & cs_romsw1 ) );

   dpram13 sw1b
     ( .address_a ( { 1'b1, sw12_a[11:0]} ), .q_a ( sw1b_o ), .clock_a ( ~grpclk2 ) ,
       .address_b (ROMAD), .data_b (ROMDT), .clock_b (ROMCL),  .wren_b ( ROMEN & cs_romsw1 ) );

   dpram12 sw2
     ( .address_a ( sw12_a[11:0] ), .q_a ( sw2_o ), .clock_a ( ~grpclk2 ) ,
       .address_b (ROMAD), .data_b (ROMDT), .clock_b (ROMCL),  .wren_b ( ROMEN & cs_romsw2 ) );
     	
   dpram13 rom15
     ( .address_a ( rom1517_a ), .q_a ( rom15_o ), .clock_a ( ~grpclk2 ) ,
       .address_b (ROMAD), .data_b (ROMDT), .clock_b (ROMCL),  .wren_b ( ROMEN & cs_rom15 ) );
   
   dpram13 rom16
     ( .address_a ( rom1517_a ), .q_a ( rom16_o ), .clock_a ( ~grpclk2 ) ,
       .address_b (ROMAD), .data_b (ROMDT), .clock_b (ROMCL),  .wren_b ( ROMEN & cs_rom16 ) );
   
   dpram13 rom17
     ( .address_a ( rom1517_a ), .q_a ( rom17_o ), .clock_a ( ~grpclk2 ) ,
       .address_b (ROMAD), .data_b (ROMDT), .clock_b (ROMCL),  .wren_b ( ROMEN & cs_rom17 ) );

   dpram13 rom18
     ( .address_a ( rom1820_a ), .q_a ( rom18_o ), .clock_a ( grpclk1 ) ,
       .address_b (ROMAD), .data_b (ROMDT), .clock_b (ROMCL),  .wren_b ( ROMEN & cs_rom18 ) );

   dpram13 rom19
     ( .address_a ( rom1820_a ), .q_a ( rom19_o ), .clock_a ( grpclk1 ) ,
       .address_b (ROMAD), .data_b (ROMDT), .clock_b (ROMCL),  .wren_b ( ROMEN & cs_rom19 ) );
   
   dpram13 rom20
     ( .address_a ( rom1820_a ), .q_a ( rom20_o ), .clock_a ( grpclk1 ) ,
       .address_b (ROMAD), .data_b (ROMDT), .clock_b (ROMCL),  .wren_b ( ROMEN & cs_rom20 ) );
		 
	// sound prom
   dpram10 prom
     ( .address_a ( sndprom_ain ), .q_a ( sndprom_dout ), .clock_a ( grpclk1 ) ,
       .address_b (ROMAD), .data_b (ROMDT), .clock_b (ROMCL),  .wren_b ( ROMEN & cs_prom ) );


endmodule
      
