//=======================================================
/* FPGA STARFORCE PCB board2 module
   Copyright 2025, madov
 
  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.
 
  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.
 
  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
  MA 02110-1301, USA.
 
*/
 //=======================================================

`default_nettype none

module starforc_board2
  (
   input wire	      grpclk1,
   input wire	      grpclk2,
   input wire	      cpuclk,
   input wire	      clk48m,
   
   //graphic signal
   output reg	      nHSYNC,
   output wire	      nVSYNC,
   output wire	      nHBLANK,
   

   //connector 1    
   input wire	      nCS_V90,
   input wire	      nMERD,
   input wire	      BMP1_Ser,
   input wire	      BMP2_Ser,
   input wire	      FLIP,
   input wire	      nMEWR,
   output wire	      nSW,

   //connector2                                                                                                 
   output wire [7:0]  DCON_out,
   input wire [7:0]   DCON_in,
   input wire [10:0]  CPU_A,
   output reg	      nVBLANK,
   input wire	      nADDR9A9BXX,
   input wire	      nCS_SPR,


    //connector3
   output wire	      nCMPBLKs2,
   input wire [7:0]   BGPOS,
   output wire	      SC0,SC1,SC2,
   output wire	      SV0,SV1,SV2,
   output wire	      nCMPBLKs,
   input wire	      f3_12,
   output wire	      OC3,OC4,OC0,OC1,OC2,OV2,

   //connector 4
   output wire	      OV0,OV1,
   output wire	      f1V,f2V,f4V,f8V,f16V,f32V,f64V,f128V,
   output wire	      b1H,b2H,b4H,b8H,b16H,b32H,b64H,nTVSYNC,
   output wire	      b256H,bn256H,
   output wire	      f8H,f16H,f32H,f64H,f128H,


//memory
   
   output wire [12:0] ROMA_addr,
   input wire [7:0]   rom9_o,rom10_o,rom11_o,rom12_o,rom13_o,rom14_o,

   output reg [11:0]  romb_addr,
   input wire [7:0]   rom6_o,rom7_o,rom8_o
   
);

   wire [7:0] spr_deviation;
   
   reg [8:0]  xH;
   reg [8:0]  xV;
   //reg	     nHSYNC;
   reg	      s_256H_n_t1;
   reg	      s_16H_t1;
   
   always @(posedge grpclk1)
     if ( grpclk2 ) begin
	if ( xH == 9'b111111111 )
	  xH <= 9'b010000000;
	else
	  xH = xH + 1'b1;
     end
   
   always  @(negedge grpclk1)
     begin
	s_256H_n_t1 <= bn256H;
	if (~bn256H  & s_256H_n_t1 ) 
          begin
	     if (xV == 9'b111111111) 
               xV <= 9'b011111000;
             else begin
		xV <= xV + 1;
           	if (xV[4:0]==5'b01111) nVBLANK = ~( b32V & b64V & b128V );
             end
	  end 
     end 
   
   always @(posedge grpclk1 or posedge bn256H)
     begin
	if (bn256H)
          nHSYNC <= 1;
        else begin
	   s_16H_t1 <= b16H;
	   if (b16H & ~s_16H_t1) 
	     nHSYNC <= ~b32H | b64H;
	end 
     end
   
   assign b1H = xH[0];
   assign b2H = xH[1];
   assign b4H = xH[2];
   assign b8H = xH[3];
   assign b16H = xH[4];
   assign b32H = xH[5];
   assign b64H = xH[6];
   wire b128H = xH[7];
   assign bn256H = xH[8];
   
   assign b256H = ~xH[8];
   wire	b1V = xV[0];
   wire b2V = xV[1];
   wire b4V = xV[2];
   wire b8V = xV[3];
   wire b16V = xV[4];
   wire b32V = xV[5];
   wire b64V = xV[6];
   wire b128V = xV[7];
   assign nVSYNC = xV[8];
   
   wire	nb7H = ~( b4H & b2H & b1H );
   wire	clk6m_b7h = grpclk2 | nb7H ;
   reg	rb1Vs,rnCMPBLKs;
   wire	nCMPBLK = nVBLANK & bn256H;
   assign nHBLANK = ~ (  (xH > 9'h88 ) && (xH < 9'h100) ) ;  
	
   assign  nTVSYNC = nHSYNC & nVSYNC;

   assign	  f1V = b1V ^ FLIP;
   assign	  f2V = b2V ^ FLIP;
   assign	  f4V = b4V ^ FLIP;
   assign	  f8V = b8V ^ FLIP;
   assign	  f16V = b16V ^ FLIP;
   assign	  f32V = b32V ^ FLIP;
   assign	  f64V = b64V ^ FLIP;
   assign	  f128V = b128V ^ FLIP;
   assign	  f8H = b8H ^ FLIP;
   assign	  f16H = b16H ^ FLIP;
   assign	  f32H = b32H ^ FLIP;
   assign	  f64H = b64H ^ FLIP;
   assign	  f128H = b128H ^ FLIP;

   always @(posedge grpclk1)
     if (grpclk2) begin
	if (SLOAD) begin
	   rb1Vs <= b1V;
	   rnCMPBLKs <= nCMPBLK;
	end
     end

   reg s_256H_d1;
   wire	s256Hr = s_256H_d1;
      
   always @(posedge grpclk1)
     begin
	if (grpclk2) 
	  if ( !(b1H & b2H & b4H ) == 0 ) 
	    s_256H_d1 <= ~bn256H; 
     end
      
   
   wire [7:0] bRD;
   reg	      nMDL0,nCDL0,nVPL0;
   reg	      nMDL1,nCDL1,nVPL1;
   reg [7:0]  MD,CD,VP;
   reg	      nMDLb,nCDLb,nVPLb;
   wire	      nMDL = nMDL1 | ~nMDL0 ;
   wire	      nCDL = nCDL1 | ~nCDL0 ;
   wire	      nVPL = nVPL1 | ~nVPL0 ;
   
   always @(negedge grpclk1 )
     begin
 	nMDL1 <= nMDL0;
	nCDL1 <= nCDL0;
	nVPL1 <= nVPL0;
	
	nMDL0 <= (  b4H |  b2H | b1H );
	nCDL0 <= (  b4H | ~b2H | b1H );
	nVPL0 <= ( ~b4H |  b2H | b1H );
   
     end // always @ (negedge grpclk1 )
   

   always @(posedge grpclk1)
     begin
	VP <= nVPL ? VP : u1NP;
	MD <= nMDL ? MD : bRD;
	CD <= nCDL ? CD : bRD;
     end

   wire [7:0] u1NP = { f128V, f64V, f32V, f16V, f8V, f4V, f2V, f1V } + bRD;
   reg	      MC0,MC1,MC2,MC4,MC5,MHFLIP;
   
   //1R
   //always @(posedge grpclk2)
   always @(posedge grpclk1)
     if ( SLOAD && grpclk2 ) begin
	MC0 <= CD[0];
	MC1 <= CD[1];
	MC2 <= CD[2];
	MC4 <= CD[4];
	MC5 <= CD[5];
	MHFLIP <= CD[6];
     end
   

   //7T,8T
   wire	       b16MV = VP[4] ^ CD[7];
   wire	       b16MH = b16H ^ CD[6];
   
   assign ROMA_addr[12:5] = (MD[6] & MD[7]) ? { MD[5:0] , b16MV, b16MH } : MD[7:0] ;
   assign ROMA_addr[4:0] = { VP[3] ^ CD[7] , b8H ^ CD[6] , VP[2] ^ CD[7] , VP[1] ^ CD[7] , VP[0] ^ CD[7] };

   //2T
   wire	       rom_odd = (MD[6] & MD[7]) ? MD[6] : 0;
   wire	       u2T_1Y = (MD[6] & MD[7]) ? b16H : 0;
   
   //1HA
   wire	       SLOAD = ( b1H & b2H & b4H );
   
   wire	       u1HA = VP[5] & VP[6] & VP[7] & ( ( MD[6] & MD[7] ) ? 1'b1 : VP[4] ) ;
   wire	       S0 = MHFLIP | ( SLOAD & u1HA );
   wire	       S1 = MHFLIP ? ( SLOAD & u1HA ) : 1'b1 ;
   
   //1T
   wire	       nCNTRLDA = ~ ( SLOAD & ~b8H & ~b1V & ~u2T_1Y );
   wire	       nCNTRLDB = ~ ( SLOAD & ~b8H &  b1V & ~u2T_1Y );
   
   //3M,4M
   wire	       u34M_MR = nCNTRLDA | ~s256Hr;//rbn256Hs;
   reg [7:0]   RDc;
   
   
   assign spr_deviation = 8'hfe;
   
   
   always @(posedge grpclk2)
     if (u34M_MR == 0) RDc <= 8'b0;
     else 
       RDc <= nCNTRLDB ? RDc + 1 : bRD + spr_deviation;
   
   //5M,6M
   wire        u56M_MR = nCNTRLDB | ~s256Hr;//rbn256Hs;
   reg [7:0]   RDd;
   
   always @(posedge grpclk2)
     if (u56M_MR == 0) RDd <= 8'b0;
     else
       RDd <= nCNTRLDA ? RDd + 1 : bRD + spr_deviation;
   
   //serializer
   //7RS
   wire [7:0]  rom1413 = rom_odd ? rom14_o : rom13_o;
   wire [7:0]  rom1413ser;
   
   ls194x2b u7RS
     (.clk ( grpclk1 ),
      .en ( grpclk2 ),
      .CR ( 1'b1 ),
      .P ( {rom1413[0],rom1413[1],rom1413[2],rom1413[3],rom1413[4],rom1413[5],rom1413[6],rom1413[7]} ),
      .DR ( 1'b0 ),
      .DL ( 1'b0 ),
      .S ( {S1,S0} ),
      .Q ( rom1413ser )
      
      );
   
   wire	       rom1413_s1 = rom1413ser[7];
   wire	       rom1413_s2 = rom1413ser[0];

   //7NP
   wire [7:0]  rom1211 = rom_odd ? rom12_o : rom11_o;
   wire [7:0]  rom1211ser;

   ls194x2b u7NP
     (
      .clk ( grpclk1 ),
      .en ( grpclk2 ),
      .CR ( 1'b1 ),
      .P ( {rom1211[0],rom1211[1],rom1211[2],rom1211[3],rom1211[4],rom1211[5],rom1211[6],rom1211[7]} ),
      .DR ( 1'b0 ),
      .DL ( 1'b0 ),
      .S ( {S1,S0} ),
      .Q ( rom1211ser )
      
      );

   wire	       rom1211_s1 = rom1211ser[7];
   wire	       rom1211_s2 = rom1211ser[0];
   

   //7LM
   wire [7:0]  rom1009 = rom_odd ? rom10_o : rom9_o;
   wire [7:0]  rom1009ser;

   ls194x2b u7LM
     (
      .clk ( grpclk1 ),
      .en ( grpclk2 ),
      .CR ( 1'b1 ),
      .P ( {rom1009[0],rom1009[1],rom1009[2],rom1009[3],rom1009[4],rom1009[5],rom1009[6],rom1009[7]} ),
      .DR ( 1'b0 ),
      .DL ( 1'b0 ),
      .S ( {S1,S0} ),
      .Q ( rom1009ser )

      );

   wire        rom1009_s1 = rom1009ser[7];
   wire        rom1009_s2 = rom1009ser[0];
	    
   wire	       n2KLWR;
   wire        n2KLRD;
   
   ls139 u3LB 
     (
      .A1 ( nMEWR ),
      .A0 ( nMERD ),
      .nE ( nCS_SPR ),
      .nO0 (),
      .nO1 ( n2KLWR ),
      .nO2 ( n2KLRD ),
      .nO3 ()
      );

      wire S8V,S4V,S2V,S1V;
      wire u6F_c4;
      
   ls283 u6F 
     (
      .A ( BGPOS[3:0] ),
      .B ( { f8V, f4V, f2V, f1V} ),
      .c0 ( 1'b0 ),
      .S ( { S8V, S4V, S2V, S1V } ),
      .c4 ( u6F_c4 )
      );
   
   wire S128V,S64V,S32V,S16V;
   
   ls283 u6E 
     (
      .A ( BGPOS[7:4] ),
      .B ( { f128V, f64V, f32V, f16V } ),
      .c0 ( u6F_c4 ),
      .S ( { S128V, S64V, S32V, S16V } ),
      .c4 ()
      );

   assign nCMPBLKs = rnCMPBLKs;
   assign nCMPBLKs2 = nCMPBLK | nCMPBLKs;
   assign nSW = ~b2H & b4H ;
   
   //1KJ 74257
   wire	[6:0] u1KJ_A, u1KJ_B;
   wire [6:0] u1KJ_Y;
   wire [7:0] u2KL_D,u2KL_D2;
   wire	      b16HxS = (MD[6] & MD[7]) ? 0 : b16H;
   
   assign u1KJ_A = CPU_A[6:0] ;
   assign u1KJ_B = { bn256H, b128H, b64H, b32H, b16HxS, b4H, b2H };
   assign u1KJ_Y = nCS_SPR ? u1KJ_B : u1KJ_A ;
   
   assign bRD = u2KL_D;
   
   wire [7:0] DCON_out_u2J = (n2KLWR & ~n2KLRD )  ? u2KL_D2 : 8'b0;
       
   wire	      u5LA = FLIP & ~rb1Vs;
   wire	      u5LB = FLIP & rb1Vs;
   wire [7:0] u34P_addr = RDc ^ {8{u5LA}}  ;
   wire	      u34P_nCS = s256Hr & ~b1V ;
   wire [7:0] u56P_addr = RDd ^ {8{u5LB}}  ;
   wire	      u56P_nCS = s256Hr & b1V;
   reg	      ru34oe,ru56oe;

   always @*
     begin
	ru34oe = ~rb1Vs | grpclk2;
	ru56oe =  rb1Vs | grpclk2;
     end
   wire u34R_nOE = ru34oe;
   wire	u56R_nOE = ru56oe;
   wire [7:0] u34P_di = 
	      ( ~u34R_nOE & ~M9 ) ? ~M :
	      ( ~u34R_nOE &  M9 ) ? ~{MC5,MC4,MC2,MC1,MC0,MV2,MV1,MV0} : 
	      8'b11111111;
   
   wire [7:0] u56P_di = 
	      ( ~u56R_nOE & ~M19 ) ? ~M1 :
	      ( ~u56R_nOE &  M19 ) ? ~{MC5,MC4,MC2,MC1,MC0,MV2,MV1,MV0} : 
	      8'b11111111;
   
   reg [7:0]  M1;
   reg [7:0]  M;
   
   //3S,4S,5S,6S
   always @(negedge grpclk2)
     begin
	M  <=  ~u34P_nCS ? ~u34P_out : 8'b00000000;
	M1 <=  ~u56P_nCS ? ~u56P_out : 8'b00000000;
     end
   
   wire	M9 = ~( M[0] | M[1] | M[2] );
   wire	M19 = ~( M1[0] | M1[1] | M1[2] );
 
   wire [7:0]u34P_out,u56P_out;

   wire	       MV2 = MHFLIP ? rom1413_s1 : rom1413_s2;
   wire	       MV0 = MHFLIP ? rom1009_s1 : rom1009_s2;
   wire	       MV1 = MHFLIP ? rom1211_s1 : rom1211_s2;

   assign OV0 = rb1Vs ? M1[0] : M[0];
   assign OV1 = rb1Vs ? M1[1] : M[1];
   assign OV2 = rb1Vs ? M1[2] : M[2];
   assign OC0 = rb1Vs ? M1[3] : M[3];

   assign OC1 = rb1Vs ? M1[4] : M[4];
   assign OC2 = rb1Vs ? M1[5] : M[5];
   assign OC3 = rb1Vs ? M1[6] : M[6];
   assign OC4 = rb1Vs ? M1[7] : M[7];

   assign DCON_out = DCON_out_u2J | DCON_out_u8A;

   //chara part------------------------------------------------------------------------
   
   
   wire [10:0] cram_a;
   wire [7:0]  cram_d;
   wire [7:0]  cram_d2;   
   wire	       SS = ~b4H & nCMPBLK;
   wire	       cram_nwe;

   wire [10:0] cram_a_read;
   
   
   assign cram_nwe = SS ? 1'b1 : nCS_V90;
   assign cram_a_read = { b2H, S128V, S64V, S32V, S16V, S8V, f128H, f64H, f32H, f16H, f8H } ;
   
   wire	      u5CA = nMERD | nCS_V90;
   wire	      u3JD = u5CA & cram_nwe;
   wire [7:0] DCON_out_u8A = ( cram_nwe & ~u3JD ) ? cram_d2: 8'b0; 

   wire u34P_wr = ~grpclk2 & ~u34P_nCS ;
   wire u56P_wr = ~grpclk2 & ~u56P_nCS ;

  
   
   spram8 u2KLb
     ( .address ( u1KJ_Y ), .q ( u2KL_D ), .data ( DCON_in), .clock ( grpclk1), .wren ( ~n2KLWR ) );

   spram8 u34pb 
     (.address ( u34P_addr ), .q(u34P_out) ,.data ( u34P_di ), .clock ( grpclk1), .wren ( u34P_wr ) );

	spram8 u56pb
     (.address ( u56P_addr ), .q(u56P_out) ,.data ( u56P_di ), .clock ( grpclk1), .wren ( u56P_wr ) );
   
   dpram11 u7b
     (	.address_a ( cram_a_read ), .q_a ( cram_d ), .clock_a ( grpclk1), .wren_a ( ),
	.address_b ( CPU_A[10:0] ), .q_b ( cram_d2 ), .clock_b ( grpclk1 ), .wren_b ( ~cram_nwe ), .data_b ( DCON_in ) );
   
   reg	      bcram_d0;
   reg	      bcram_d1;
   reg	      bcram_d2;
   reg	      bcram_d6;

   always @(posedge grpclk2)
     begin
	if (xH[2:0] == 3'b001) //001+1
	  begin
	     romb_addr[10:3] <= cram_d;
	  end//011 ni kaeta v 
	if (xH[2:0] == 3'b011) //011+1
	  begin
	     bcram_d0 <= cram_d[0];
	     bcram_d1 <= cram_d[1];
	     bcram_d2 <= cram_d[2];
	     bcram_d6 <= cram_d[6];
	     
	     romb_addr[11] <= cram_d[4];
	     romb_addr[0] <= cram_d[7] ^ S1V;
	     romb_addr[1] <= cram_d[7] ^ S2V;
	     romb_addr[2] <= cram_d[7] ^ S4V;
	     
	  end
     end // always @ (posedge grpclk2)

   reg rSC0,rSC1,rSC2,rSC4;
   
   always @(posedge clk6m_b7h)
     begin
	rSC0 <= bcram_d0;
	rSC1 <= bcram_d1;
	rSC2 <= bcram_d2;
	rSC4 <= bcram_d6;
     end

   assign SC0 = rSC0;
   assign SC1 = rSC1;
   assign SC2 = rSC2;
   wire u6HB = FLIP ^ rSC4;
   //wire [7:0] rom6_o,rom7_o,rom8_o;

	     
   wire [7:0] rom8_ser;
   wire [7:0] rom7_ser;
   wire [7:0] rom6_ser;
   wire	      CHRS1 = ~nb7H | ~u6HB;
   wire	      CHRS0 = ~nb7H | u6HB;
   
   wire	      rom8_s2 = rom8_ser[7];
   wire	      rom8_s1 = rom8_ser[0];

   wire	      rom7_s2 = rom7_ser[7];
   wire	      rom7_s1 = rom7_ser[0];

   wire	      rom6_s2 = rom6_ser[7];
   wire	      rom6_s1 = rom6_ser[0];

	
   ls194x2 u7JK
     (
      .clk ( grpclk2 ),
      .CR ( 1'b1 ),
      .P ( {rom8_o[0],rom8_o[1],rom8_o[2],rom8_o[3],rom8_o[4],rom8_o[5],rom8_o[6],rom8_o[7]} ),
      .DR ( 1'b0 ),
      .DL ( 1'b0 ),
      .S ( {CHRS1,CHRS0} ),
      .Q ( rom8_ser )

      );	   
  
   ls194x2 u7FH
     (
      .clk ( grpclk2 ),
      .CR ( 1'b1 ),
      .P ( {rom7_o[0],rom7_o[1],rom7_o[2],rom7_o[3],rom7_o[4],rom7_o[5],rom7_o[6],rom7_o[7]} ),
      .DR ( 1'b0 ),
      .DL ( 1'b0 ),
      .S ( {CHRS1,CHRS0} ),
      .Q ( rom7_ser )

      );

   ls194x2 u7DE
     (
      .clk ( grpclk2 ),
      .CR ( 1'b1 ),
      .P ( {rom6_o[0],rom6_o[1],rom6_o[2],rom6_o[3],rom6_o[4],rom6_o[5],rom6_o[6],rom6_o[7]} ),
      .DR ( 1'b0 ),
      .DL ( 1'b0 ),
      .S ( {CHRS1,CHRS0} ),
      .Q ( rom6_ser )

      );


   assign  SV2 = u6HB ? rom6_s2 : rom6_s1;
   assign  SV1 = u6HB ? rom7_s2 : rom7_s1;
   assign  SV0 = u6HB ? rom8_s2 : rom8_s1;

   
endmodule // starforc_board2




