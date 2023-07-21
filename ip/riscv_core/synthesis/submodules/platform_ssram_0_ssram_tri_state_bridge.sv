// (C) 2001-2023 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// $Id: //acds/rel/22.1std/ip/merlin/altera_tristate_conduit_bridge/altera_tristate_conduit_bridge.sv.terp#1 $
// $Revision: #1 $
// $Date: 2021/10/27 $
// $Author: psgswbuild $

//Defined Terp Parameters


			    

`timescale 1 ns / 1 ns
  				      
module platform_ssram_0_ssram_tri_state_bridge (
     input  logic clk
    ,input  logic reset
    ,input  logic request
    ,output logic grant
    ,input  logic[ 3 :0 ] tcs_ssram_be_n
    ,output  wire [ 3 :0 ] ssram_be_n
    ,input  logic[ 0 :0 ] tcs_ssram_we_n
    ,output  wire [ 0 :0 ] ssram_we_n
    ,output logic[ 31 :0 ] tcs_fs_dq_in
    ,input  logic[ 31 :0 ] tcs_fs_dq
    ,input  logic tcs_fs_dq_outen
    ,inout  wire [ 31 :0 ]  fs_dq
    ,input  logic[ 0 :0 ] tcs_ssram_adsc_n
    ,output  wire [ 0 :0 ] ssram_adsc_n
    ,input  logic[ 0 :0 ] tcs_ssram_oe_n
    ,output  wire [ 0 :0 ] ssram_oe_n
    ,input  logic[ 19 :0 ] tcs_fs_addr
    ,output  wire [ 19 :0 ] fs_addr
    ,input  logic[ 0 :0 ] tcs_ssram_cs_n
    ,output  wire [ 0 :0 ] ssram_cs_n
		     
   );
   reg grant_reg;
   assign grant = grant_reg;
   
   always@(posedge clk) begin
      if(reset)
	grant_reg <= 0;
      else
	grant_reg <= request;      
   end
   


 // ** Output Pin ssram_be_n 
 
    reg                       ssram_be_nen_reg;     
  
    always@(posedge clk) begin
	 if( reset ) begin
	   ssram_be_nen_reg <= 'b0;
	 end
	 else begin
	   ssram_be_nen_reg <= 'b1;
	 end
     end		     
   
 
    reg [ 3 : 0 ] ssram_be_n_reg;   

     always@(posedge clk) begin
	 ssram_be_n_reg   <= tcs_ssram_be_n[ 3 : 0 ];
      end
          
 
    assign 	ssram_be_n[ 3 : 0 ] = ssram_be_nen_reg ? ssram_be_n_reg : 'z ;
        


 // ** Output Pin ssram_we_n 
 
    reg                       ssram_we_nen_reg;     
  
    always@(posedge clk) begin
	 if( reset ) begin
	   ssram_we_nen_reg <= 'b0;
	 end
	 else begin
	   ssram_we_nen_reg <= 'b1;
	 end
     end		     
   
 
    reg [ 0 : 0 ] ssram_we_n_reg;   

     always@(posedge clk) begin
	 ssram_we_n_reg   <= tcs_ssram_we_n[ 0 : 0 ];
      end
          
 
    assign 	ssram_we_n[ 0 : 0 ] = ssram_we_nen_reg ? ssram_we_n_reg : 'z ;
        


 // ** Bidirectional Pin fs_dq 
   
    reg                       fs_dq_outen_reg;
  
    always@(posedge clk) begin
	 fs_dq_outen_reg <= tcs_fs_dq_outen;
     end
  
  
    reg [ 31 : 0 ] fs_dq_reg;   

     always@(posedge clk) begin
	 fs_dq_reg   <= tcs_fs_dq[ 31 : 0 ];
      end
         
  
    assign 	fs_dq[ 31 : 0 ] = fs_dq_outen_reg ? fs_dq_reg : 'z ;
       
  
    reg [ 31 : 0 ] 	fs_dq_in_reg;
								    
    always@(posedge clk) begin
	 fs_dq_in_reg <= fs_dq[ 31 : 0 ];
    end
    
  
    assign      tcs_fs_dq_in[ 31 : 0 ] = fs_dq_in_reg[ 31 : 0 ];
        


 // ** Output Pin ssram_adsc_n 
 
    reg                       ssram_adsc_nen_reg;     
  
    always@(posedge clk) begin
	 if( reset ) begin
	   ssram_adsc_nen_reg <= 'b0;
	 end
	 else begin
	   ssram_adsc_nen_reg <= 'b1;
	 end
     end		     
   
 
    reg [ 0 : 0 ] ssram_adsc_n_reg;   

     always@(posedge clk) begin
	 ssram_adsc_n_reg   <= tcs_ssram_adsc_n[ 0 : 0 ];
      end
          
 
    assign 	ssram_adsc_n[ 0 : 0 ] = ssram_adsc_nen_reg ? ssram_adsc_n_reg : 'z ;
        


 // ** Output Pin ssram_oe_n 
 
    reg                       ssram_oe_nen_reg;     
  
    always@(posedge clk) begin
	 if( reset ) begin
	   ssram_oe_nen_reg <= 'b0;
	 end
	 else begin
	   ssram_oe_nen_reg <= 'b1;
	 end
     end		     
   
 
    reg [ 0 : 0 ] ssram_oe_n_reg;   

     always@(posedge clk) begin
	 ssram_oe_n_reg   <= tcs_ssram_oe_n[ 0 : 0 ];
      end
          
 
    assign 	ssram_oe_n[ 0 : 0 ] = ssram_oe_nen_reg ? ssram_oe_n_reg : 'z ;
        


 // ** Output Pin fs_addr 
 
    reg                       fs_addren_reg;     
  
    always@(posedge clk) begin
	 if( reset ) begin
	   fs_addren_reg <= 'b0;
	 end
	 else begin
	   fs_addren_reg <= 'b1;
	 end
     end		     
   
 
    reg [ 19 : 0 ] fs_addr_reg;   

     always@(posedge clk) begin
	 fs_addr_reg   <= tcs_fs_addr[ 19 : 0 ];
      end
          
 
    assign 	fs_addr[ 19 : 0 ] = fs_addren_reg ? fs_addr_reg : 'z ;
        


 // ** Output Pin ssram_cs_n 
 
    reg                       ssram_cs_nen_reg;     
  
    always@(posedge clk) begin
	 if( reset ) begin
	   ssram_cs_nen_reg <= 'b0;
	 end
	 else begin
	   ssram_cs_nen_reg <= 'b1;
	 end
     end		     
   
 
    reg [ 0 : 0 ] ssram_cs_n_reg;   

     always@(posedge clk) begin
	 ssram_cs_n_reg   <= tcs_ssram_cs_n[ 0 : 0 ];
      end
          
 
    assign 	ssram_cs_n[ 0 : 0 ] = ssram_cs_nen_reg ? ssram_cs_n_reg : 'z ;
        

endmodule

