
`timescale 1ns/100ps

`ifndef DISABLE_DEFAULT_NET
`default_nettype none
`endif

`include "define_state.h"

// This is the milestone1 module
// It connects the SRAM and VGA together
// It will first write RGB data of 8x8 rectangles of size 40x30 pixels into the SRAM
// The VGA will then read the SRAM and display the image
module milestone1 (
      input logic CLOCK_50_I,    // 50 MHz clock
		input logic resetn,
		
		//Access to SRAM 
		output logic SRAM_we_n,  
		output logic [17:0] SRAM_address,
		output logic [15:0] SRAM_write_data,
		input logic[15:0] SRAM_read_data,
	
		//control variables for M1
		input logic M1_enable,
		output logic M1_finish
);


milestone1_state_type M1_state;

//counters
logic [17:0] Y_counter;
logic [17:0] UV_counter;
logic [17:0] RGB_counter;
logic [17:0] LO_counter; //used to track the positio of lead out cases

//shift registers
logic [7:0] U_shift_reg [5:0];
logic [31:0] U_32_unsigned [5:0];
logic [7:0] V_shift_reg [5:0];
logic [31:0] V_32_unsigned [5:0];
logic [7:0] Y_reg [5:0];
logic [31:0] Y_32_unsigned [5:0];

//zero extension for Y, U and V
assign U_32_unsigned[0] = {24'b0,U_shift_reg[0]},
	    U_32_unsigned[1] = {24'b0,U_shift_reg[1]},
		 U_32_unsigned[2] = {24'b0,U_shift_reg[2]},
		 U_32_unsigned[3] = {24'b0,U_shift_reg[3]},
		 U_32_unsigned[4] = {24'b0,U_shift_reg[4]},
		 U_32_unsigned[5] = {24'b0,U_shift_reg[5]};
		 
assign V_32_unsigned[0] = {24'b0,V_shift_reg[0]},
	    V_32_unsigned[1] = {24'b0,V_shift_reg[1]},
		 V_32_unsigned[2] = {24'b0,V_shift_reg[2]},
		 V_32_unsigned[3] = {24'b0,V_shift_reg[3]},
		 V_32_unsigned[4] = {24'b0,V_shift_reg[4]},
		 V_32_unsigned[5] = {24'b0,V_shift_reg[5]};
		 
assign Y_32_unsigned[0] = {24'b0,Y_reg[0]},
	    Y_32_unsigned[1] = {24'b0,Y_reg[1]},
		 Y_32_unsigned[2] = {24'b0,Y_reg[2]},
		 Y_32_unsigned[3] = {24'b0,Y_reg[3]},
		 Y_32_unsigned[4] = {24'b0,Y_reg[4]},
		 Y_32_unsigned[5] = {24'b0,Y_reg[5]};

//multipliers
logic [31:0] Mul_op_1, Mul_op_2, Mul_op_3, Mul_op_4, Mul_op_5, Mul_op_6, Mul_op_7, Mul_op_8;
logic [31:0] Mul_result_1, Mul_result_2, Mul_result_3, Mul_result_4;
logic [63:0] Mul_result_long_1, Mul_result_long_2, Mul_result_long_3, Mul_result_long_4;

assign Mul_result_long_1 = Mul_op_1 * Mul_op_2,
		 Mul_result_long_2 = Mul_op_3 * Mul_op_4,
		 Mul_result_long_3 = Mul_op_5 * Mul_op_6,
		 Mul_result_long_4 = Mul_op_7 * Mul_op_8;
		 
assign Mul_result_1 = Mul_result_long_1[31:0],
		 Mul_result_2 = Mul_result_long_2[31:0],
	  	 Mul_result_3 = Mul_result_long_3[31:0],
		 Mul_result_4 = Mul_result_long_4[31:0];
		 
//buffers
logic [7:0] Y_buf, U_buf, V_buf;
//these values would be used as signed by $signed()
logic signed [31:0] Uprime_even, Uprime_odd, Vprime_even, Vprime_odd; 
logic signed [31:0] US_Y_buf_1, US_Y_buf_2, US_Y_buf_3, US_Y_buf_4, US_Y_buf_5, US_Y_buf_6;
logic signed [31:0] R_0, R_1, R_2, R_3;
logic signed [31:0] G_0, G_1, G_2, G_3;
logic signed [31:0] B_0, B_1, B_2, B_3;

//the output RGB values, each with 4 registers and are unsigned 8 bits
logic [7:0] R_out [3:0];
logic [7:0] G_out [3:0];
logic [7:0] B_out [3:0];

//convert the 32 bits red green blue values into 8 bits RGB values
assign R_out[0] = R_0[31] ? 8'd0 : |R_0[30:24] ? 8'd255 : R_0[23:16],
       R_out[1] = R_1[31] ? 8'd0 : |R_1[30:24] ? 8'd255 : R_1[23:16],
       R_out[2] = R_2[31] ? 8'd0 : |R_2[30:24] ? 8'd255 : R_2[23:16],
       R_out[3] = R_3[31] ? 8'd0 : |R_3[30:24] ? 8'd255 : R_3[23:16];
assign G_out[0] = G_0[31] ? 8'd0 : |G_0[30:24] ? 8'd255 : G_0[23:16],
       G_out[1] = G_1[31] ? 8'd0 : |G_1[30:24] ? 8'd255 : G_1[23:16],
       G_out[2] = G_2[31] ? 8'd0 : |G_2[30:24] ? 8'd255 : G_2[23:16],
       G_out[3] = G_3[31] ? 8'd0 : |G_3[30:24] ? 8'd255 : G_3[23:16];
assign B_out[0] = B_0[31] ? 8'd0 : |B_0[30:24] ? 8'd255 : B_0[23:16],
       B_out[1] = B_1[31] ? 8'd0 : |B_1[30:24] ? 8'd255 : B_1[23:16],
       B_out[2] = B_2[31] ? 8'd0 : |B_2[30:24] ? 8'd255 : B_2[23:16],
       B_out[3] = B_3[31] ? 8'd0 : |B_3[30:24] ? 8'd255 : B_3[23:16];

//FSM for M1
always_ff @ (posedge CLOCK_50_I or negedge resetn) begin
    if (resetn == 1'b0) begin
		M1_state <= S_M1_IDLE;
      SRAM_we_n <= 1'b1;
      SRAM_write_data <= 16'd0;
		SRAM_address <= 18'd0;
			
		//initialize counters
		Y_counter <= 18'd0;
		UV_counter <= 18'd0;
		RGB_counter <= 18'd0;
		LO_counter <= 18'd0;
		
		//initialize U_shift_reg
		U_shift_reg[0] <= 8'd0;
		U_shift_reg[1] <= 8'd0;
		U_shift_reg[2] <= 8'd0;
		U_shift_reg[3] <= 8'd0;
		U_shift_reg[4] <= 8'd0;
		U_shift_reg[5] <= 8'd0;
		U_buf <= 8'd0;
		
		//initialize V_shift_reg
		V_shift_reg[0] <= 8'd0;
		V_shift_reg[1] <= 8'd0;
		V_shift_reg[2] <= 8'd0;
		V_shift_reg[3] <= 8'd0;
		V_shift_reg[4] <= 8'd0;
		V_shift_reg[5] <= 8'd0;
		V_buf <= 8'd0;
		
		//initialize Y_reg
		Y_reg[0] <= 8'd0;
		Y_reg[1] <= 8'd0;
		Y_reg[2] <= 8'd0;
		Y_reg[3] <= 8'd0;
		Y_reg[4] <= 8'd0;
		Y_reg[5] <= 8'd0;
		
		//initialize prime values
		Uprime_odd <= 32'd0;
		Uprime_even <= 32'd0;
		Vprime_odd <= 32'd0;
		Vprime_even <= 32'd0;
		
		//initialize RGB values
		US_Y_buf_1 <= 32'd0;
		US_Y_buf_2 <= 32'd0;
		US_Y_buf_3 <= 32'd0;
		US_Y_buf_4 <= 32'd0;
		US_Y_buf_5 <= 32'd0;
		US_Y_buf_6 <= 32'd0;

		R_0 <= 32'd0;
		R_1 <= 32'd0;
		R_2 <= 32'd0;
		R_3 <= 32'd0;
		G_0 <= 32'd0;
		G_1 <= 32'd0;
		G_2 <= 32'd0;
		G_3 <= 32'd0;
		B_0 <= 32'd0;
		B_1 <= 32'd0;
		B_2 <= 32'd0;
		B_3 <= 32'd0;
		
		//initialize multiplier
		Mul_op_1 <= 32'd0;
		Mul_op_2 <= 32'd0;
		Mul_op_3 <= 32'd0;
		Mul_op_4 <= 32'd0;
		Mul_op_5 <= 32'd0;
		Mul_op_6 <= 32'd0;
		Mul_op_7 <= 32'd0;
		Mul_op_8 <= 32'd0;

    end else begin
        case (M1_state)
            S_M1_IDLE: begin
					if(M1_finish == 1'b1) begin
						// enable dummy reading to aviod wrong write
						SRAM_we_n <= 1'b1;
					end else begin
					if(M1_enable == 1'b1) begin
						// reset position counter, enable read
						LO_counter <= 18'd0;
						SRAM_we_n <= 1'b1;
						
						//provide address for U[0] U[1]
						SRAM_address <= UV_counter + U_OFFSET;
						M1_state <= S_LI_0;
					end
				end
			end

		S_LI_0: begin
			//provide address for V[0] V[1]
			SRAM_address <= UV_counter + V_OFFSET;
			UV_counter <= UV_counter + 18'd1;
         M1_state <= S_LI_1;
		end
		
		S_LI_1: begin
			//provide address for U[2] U[3]
			SRAM_address <= UV_counter + U_OFFSET;
         M1_state <= S_LI_2;
		end
		
		S_LI_2: begin
			U_shift_reg[0] <= SRAM_read_data[15:8]; //U[-2] = U[0]
			U_shift_reg[1] <= SRAM_read_data[15:8]; //U[-1] = U[0]
			U_shift_reg[2] <= SRAM_read_data[15:8]; //U[0]
			U_shift_reg[3] <= SRAM_read_data[7:0]; //U[1]
			
			//provide address for V[2] V[3]
			SRAM_address <= UV_counter + V_OFFSET;
			UV_counter <= UV_counter + 18'd1;
         M1_state <= S_LI_3;
		end
		
		S_LI_3: begin
			V_shift_reg[0] <= SRAM_read_data[15:8]; //V[-2] = V[0]
			V_shift_reg[1] <= SRAM_read_data[15:8]; //V[-1] = V[0]
			V_shift_reg[2] <= SRAM_read_data[15:8]; //V[0]
			V_shift_reg[3] <= SRAM_read_data[7:0]; //V[1]
			
			Mul_op_1 <= 32'd21;
			Mul_op_2 <= U_32_unsigned[0];
			
			Mul_op_3 <= 32'd52;
			Mul_op_4 <= U_32_unsigned[1];
			
			Mul_op_5 <= 32'd159;
			Mul_op_6 <= U_32_unsigned[2];
			
			Mul_op_7 <= 32'd159;
			Mul_op_8 <= U_32_unsigned[3];
			
			//provide address for Y[0] Y[1]
			SRAM_address <= Y_counter;
			Y_counter <= Y_counter + 18'd1;
			
         M1_state <= S_LI_4;
		end
		
		S_LI_4: begin
			U_shift_reg[4] <= SRAM_read_data[15:8]; //U[2]
			U_shift_reg[5] <= SRAM_read_data[7:0]; //U[3]
			
			Uprime_odd <= $signed(Mul_result_1 - Mul_result_2 + Mul_result_3 + Mul_result_4);
			
			Mul_op_1 <= 32'd21;
			Mul_op_2 <= V_32_unsigned[0];
			
			Mul_op_3 <= 32'd52;
			Mul_op_4 <= V_32_unsigned[1];
			
			Mul_op_5 <= 32'd159;
			Mul_op_6 <= V_32_unsigned[2];
			
			Mul_op_7 <= 32'd159;
			Mul_op_8 <= V_32_unsigned[3];
			
			M1_state <= S_LI_5;
		end
		
		S_LI_5: begin
			V_shift_reg[4] <= SRAM_read_data[15:8]; //V[2]
			V_shift_reg[5] <= SRAM_read_data[7:0]; //V[3]
			
			Vprime_odd <= $signed(Mul_result_1 - Mul_result_2 + Mul_result_3 + Mul_result_4);
			
			Mul_op_1 <= 32'd52;
			Mul_op_2 <= U_32_unsigned[4];
			
			Mul_op_3 <= 32'd21;
			Mul_op_4 <= U_32_unsigned[5];
			
			M1_state <= S_LI_6;
		end
		
		S_LI_6: begin
			Mul_op_5 <= 32'd52;
			Mul_op_6 <= V_32_unsigned[4];
			
			Mul_op_7 <= 32'd21;
			Mul_op_8 <= V_32_unsigned[5];
			
			Uprime_even <= U_shift_reg[2];//U'[0]
			Uprime_odd <= $signed(Uprime_odd - Mul_result_1 + Mul_result_2 + 32'd128)>>>8;
			
			Y_reg[0] <= SRAM_read_data[15:8];//Y[0]
         Y_reg[1] <= SRAM_read_data[7:0];//Y[1]
			
			M1_state <= S_LI_7;
		end
		
		S_LI_7: begin
			Vprime_even <= V_shift_reg[2];//V'[0]
			Vprime_odd <= $signed(Vprime_odd - Mul_result_3 + Mul_result_4 + 32'd128)>>>8;
			
			//prepare for RGB even
			Mul_op_1 <= 32'd76284;
         Mul_op_2 <= Y_32_unsigned[0]-(32'd16);
			Mul_op_3 <= 32'd76284;
         Mul_op_4 <= Y_32_unsigned[1]-(32'd16);
			
			//provide address for U[4] U[5]
			SRAM_address <= UV_counter + U_OFFSET;
			
			M1_state <= S_LI_8;
		end
		
		S_LI_8: begin
			//store a0Y
			US_Y_buf_1 <= Mul_result_1;
			US_Y_buf_2 <= Mul_result_2;
			 
			//prepare for RGB even
         Mul_op_1 <= 32'd104595;
         Mul_op_2 <= Vprime_even - (32'd128);
			
			Mul_op_3 <= 32'd25624;
         Mul_op_4 <= Uprime_even - (32'd128);
			
			Mul_op_5 <= 32'd53281;
         Mul_op_6 <= Vprime_even - (32'd128);
			
			Mul_op_7 <= 32'd132251;
         Mul_op_8 <= Uprime_even - (32'd128);
			
			//provide address for V[4] V[5]
			SRAM_address <= UV_counter + V_OFFSET;
			UV_counter <= UV_counter + 18'd1;
			
			M1_state <= S_LI_9;
		end
		
		S_LI_9: begin
			//get R_0 G_0 B_0
			R_0 <= US_Y_buf_1 + Mul_result_1;
			G_0 <= US_Y_buf_1 - Mul_result_2 - Mul_result_3;
			B_0 <= US_Y_buf_1 + Mul_result_4;
			
			//prepare for RGB odd
         Mul_op_1 <= 32'd104595;
         Mul_op_2 <= Vprime_odd - (32'd128);
			
			Mul_op_3 <= 32'd25624;
         Mul_op_4 <= Uprime_odd - (32'd128);
			
			Mul_op_5 <= 32'd53281;
         Mul_op_6 <= Vprime_odd - (32'd128);
			
			Mul_op_7 <= 32'd132251;
         Mul_op_8 <= Uprime_odd - (32'd128);
			
			M1_state <= S_LI_10;
		end

		S_LI_10: begin
			//get R_1 G_1 B_1
			R_1 <= US_Y_buf_2 + Mul_result_1;
			G_1 <= US_Y_buf_2 - Mul_result_2 - Mul_result_3;
			B_1 <= US_Y_buf_2 + Mul_result_4;
			
			//new cycle begin, shift begin
			U_shift_reg[0] <= U_shift_reg[1]; //U[-1] = U[0]
			U_shift_reg[1] <= U_shift_reg[2]; //U[0]
			U_shift_reg[2] <= U_shift_reg[3]; //U[1]
			U_shift_reg[3] <= U_shift_reg[4]; //U[2]
			U_shift_reg[4] <= U_shift_reg[5]; //U[3]
			U_shift_reg[5] <= SRAM_read_data[15:8]; //U[2]
			
			//U_buf to store 
			U_buf <= SRAM_read_data[7:0]; //Buffer U[5]
			
			SRAM_address <= Y_counter;
			Y_counter <= Y_counter + 18'd1;
			
			M1_state <= S_LI_11;
		end
		
		S_LI_11: begin
			V_shift_reg[0] <= V_shift_reg[1]; //V[-1] = U[0]
			V_shift_reg[1] <= V_shift_reg[2]; //V[0]
			V_shift_reg[2] <= V_shift_reg[3]; //V[1]
			V_shift_reg[3] <= V_shift_reg[4]; //V[2]
			V_shift_reg[4] <= V_shift_reg[5]; //V[3]
			V_shift_reg[5] <= SRAM_read_data[15:8]; //U[2]
			
			//V_buf to store 
			V_buf <= SRAM_read_data[7:0]; //Buffer V[5]
	
			LO_counter <= 18'd1;
			SRAM_address <= Y_counter;
			Y_counter <= Y_counter + 18'd1;
		
			M1_state <= S_COMMON_0;
		end
		
		S_COMMON_0: begin		
			
			Mul_op_1 <= 32'd21;
			Mul_op_2 <= U_32_unsigned[0];
			
			Mul_op_3 <= 32'd52;
			Mul_op_4 <= U_32_unsigned[1];
			
			Mul_op_5 <= 32'd159;
			Mul_op_6 <= U_32_unsigned[2];
			
			Mul_op_7 <= 32'd159;
			Mul_op_8 <= U_32_unsigned[3];
			
			M1_state <= S_COMMON_1;
		end
		
		S_COMMON_1: begin
			Uprime_odd <= $signed(Mul_result_1 - Mul_result_2 + Mul_result_3 + Mul_result_4);
			
			Mul_op_1 <= 32'd21;
			Mul_op_2 <= V_32_unsigned[0];
			
			Mul_op_3 <= 32'd52;
			Mul_op_4 <= V_32_unsigned[1];
			
			Mul_op_5 <= 32'd159;
			Mul_op_6 <= V_32_unsigned[2];
			
			Mul_op_7 <= 32'd159;
			Mul_op_8 <= V_32_unsigned[3];
			
			Y_reg[0] <= SRAM_read_data[15:8];//Y[0]
         Y_reg[1] <= SRAM_read_data[7:0];//Y[1]
			
			M1_state <= S_COMMON_2;
		end
		
		S_COMMON_2: begin
			Vprime_odd <= $signed(Mul_result_1 - Mul_result_2 + Mul_result_3 + Mul_result_4);
			
			Mul_op_1 <= 32'd52;
			Mul_op_2 <= U_32_unsigned[4];
			
			Mul_op_3 <= 32'd21;
			Mul_op_4 <= U_32_unsigned[5];
			
			Mul_op_5 <= 32'd52;
			Mul_op_6 <= V_32_unsigned[4];
			
			Mul_op_7 <= 32'd21;
			Mul_op_8 <= V_32_unsigned[5];
		
			Y_reg[2] <= SRAM_read_data[15:8];//Y[0]
         Y_reg[3] <= SRAM_read_data[7:0];//Y[1]	
			
			//enable write
			SRAM_we_n <= 1'b0;
			//provide address for RGB0
			SRAM_address <= RGB_counter+RGB_OFFSET;
			RGB_counter <= RGB_counter + 18'd1;
         SRAM_write_data <= {R_out[0],G_out[0]};//write R0 G0
			
			M1_state <= S_COMMON_3;
		end
		
		S_COMMON_3: begin
			Uprime_even <= U_shift_reg[2];//U'[0]
			Uprime_odd <= $signed(Uprime_odd - Mul_result_1 + Mul_result_2 + 32'd128)>>>8;
					
			Vprime_even <= V_shift_reg[2];//V'[0]
			Vprime_odd <= $signed(Vprime_odd - Mul_result_3 + Mul_result_4 + 32'd128)>>>8;		
					
			Mul_op_1 <= 32'd76284;
         Mul_op_2 <= Y_32_unsigned[0]-(32'd16);

			Mul_op_3 <= 32'd76284;
         Mul_op_4 <= Y_32_unsigned[1] - (32'd16);

			Mul_op_5 <= 32'd76284;
         Mul_op_6 <= Y_32_unsigned[2]-(32'd16);

			Mul_op_7 <= 32'd76284;
         Mul_op_8 <= Y_32_unsigned[3] - (32'd16);
			
			SRAM_address <= RGB_counter+RGB_OFFSET;
			RGB_counter <= RGB_counter + 18'd1;
         SRAM_write_data <= {B_out[0],R_out[1]};//write B0 R1
					
			M1_state <= S_COMMON_4;
		end
		
		S_COMMON_4: begin
			//store a0Ys
			US_Y_buf_1 <= Mul_result_1;
			US_Y_buf_2 <= Mul_result_2;
			US_Y_buf_3 <= Mul_result_3;
			US_Y_buf_4 <= Mul_result_4;
			
			//prepare for RGB even
         Mul_op_1 <= 32'd104595;
         Mul_op_2 <= Vprime_even - (32'd128);
			
			Mul_op_3 <= 32'd25624;
         Mul_op_4 <= Uprime_even - (32'd128);
			
			Mul_op_5 <= 32'd53281;
         Mul_op_6 <= Vprime_even - (32'd128);
			
			Mul_op_7 <= 32'd132251;
         Mul_op_8 <= Uprime_even - (32'd128);
			
			//provide address
			SRAM_address <= RGB_counter +RGB_OFFSET;
			RGB_counter <= RGB_counter + 18'd1;
         SRAM_write_data <= {G_out[1],B_out[1]};//write G1 B1
			
			LO_counter <= LO_counter + 18'd4;
			
			M1_state <= S_COMMON_5;
		end
		
		S_COMMON_5: begin
			R_2 <= US_Y_buf_1 + Mul_result_1;
			G_2 <= US_Y_buf_1 - Mul_result_2 - Mul_result_3;
			B_2 <= US_Y_buf_1 + Mul_result_4;
			
			//prepare for RGB odd
         Mul_op_1 <= 32'd104595;
         Mul_op_2 <= Vprime_odd - (32'd128);
			
			Mul_op_3 <= 32'd25624;
         Mul_op_4 <= Uprime_odd - (32'd128);
			
			Mul_op_5 <= 32'd53281;
         Mul_op_6 <= Vprime_odd - (32'd128);
			
			Mul_op_7 <= 32'd132251;
         Mul_op_8 <= Uprime_odd - (32'd128);
			
			U_shift_reg[0] <= U_shift_reg[1]; //U[0]
			U_shift_reg[1] <= U_shift_reg[2]; //U[1]
			U_shift_reg[2] <= U_shift_reg[3]; //U[2]
			U_shift_reg[3] <= U_shift_reg[4]; //U[3]
			U_shift_reg[4] <= U_shift_reg[5]; //U[4]
			U_shift_reg[5] <= U_buf;
			
			//check if it is Uprime_313
			SRAM_we_n <= 1'b1;//enable read
			if (LO_counter != 18'd313) begin
				SRAM_address <= UV_counter + U_OFFSET;
			end
			
			M1_state <= S_COMMON_6;
		end
		
		S_COMMON_6: begin
			R_3 <= US_Y_buf_2 + Mul_result_1;
			G_3 <= US_Y_buf_2 - Mul_result_2 - Mul_result_3;
			B_3 <= US_Y_buf_2 + Mul_result_4;
			
			Mul_op_1 <= 32'd21;
			Mul_op_2 <= U_32_unsigned[0];
			
			Mul_op_3 <= 32'd52;
			Mul_op_4 <= U_32_unsigned[1];
			
			Mul_op_5 <= 32'd159;
			Mul_op_6 <= U_32_unsigned[2];
			
			Mul_op_7 <= 32'd159;
			Mul_op_8 <= U_32_unsigned[3];
			
			V_shift_reg[0] <= V_shift_reg[1]; //V[0]
			V_shift_reg[1] <= V_shift_reg[2]; //V[1]
			V_shift_reg[2] <= V_shift_reg[3]; //V[2]
			V_shift_reg[3] <= V_shift_reg[4]; //V[3]
			V_shift_reg[4] <= V_shift_reg[5]; //V[4]
			V_shift_reg[5] <= V_buf;//V[5]
			
			if (LO_counter != 18'd313) begin
				SRAM_address <= UV_counter + V_OFFSET;
				UV_counter <= UV_counter + 18'd1;
			end
			
			M1_state <= S_COMMON_7;
		end
		
		S_COMMON_7: begin
			Uprime_odd <= $signed(Mul_result_1 - Mul_result_2 + Mul_result_3 + Mul_result_4);
			
			Mul_op_1 <= 32'd21;
			Mul_op_2 <= V_32_unsigned[0];
			
			Mul_op_3 <= 32'd52;
			Mul_op_4 <= V_32_unsigned[1];
			
			Mul_op_5 <= 32'd159;
			Mul_op_6 <= V_32_unsigned[2];
			
			Mul_op_7 <= 32'd159;
			Mul_op_8 <= V_32_unsigned[3];
			
			//provide address 
			SRAM_we_n <= 1'b0;//enable write
			SRAM_address <= RGB_counter + RGB_OFFSET;
			RGB_counter <= RGB_counter + 18'd1;
         SRAM_write_data <= {R_out[2],G_out[2]};//write R2 G2
			
			M1_state <= S_COMMON_8;
		end
		
		S_COMMON_8: begin
			Vprime_odd <= $signed(Mul_result_1 - Mul_result_2 + Mul_result_3 + Mul_result_4);
			
			Mul_op_1 <= 32'd52;
			Mul_op_2 <= U_32_unsigned[4];
			
			Mul_op_3 <= 32'd21;
			Mul_op_4 <= U_32_unsigned[5];
			
			Mul_op_5 <= 32'd52;
			Mul_op_6 <= V_32_unsigned[4];
			
			Mul_op_7 <= 32'd21;
			Mul_op_8 <= V_32_unsigned[5];
			
			Uprime_even <= U_shift_reg[2];//U'[0]
			Vprime_even <= V_shift_reg[2];//V'[0]
			
			//SRAM_we_n <= 1'b1;//enable read
			if (LO_counter != 18'd313) begin
				//new cycle begin, shift begin
				U_shift_reg[0] <= U_shift_reg[1]; //U[-1] = U[0]
				U_shift_reg[1] <= U_shift_reg[2]; //U[0]
				U_shift_reg[2] <= U_shift_reg[3]; //U[1]
				U_shift_reg[3] <= U_shift_reg[4]; //U[2]
				U_shift_reg[4] <= U_shift_reg[5]; //U[3]
				U_shift_reg[5] <= SRAM_read_data[15:8]; //U[2]
			
				//U_buf to store 
				U_buf <= SRAM_read_data[7:0]; //Buffer U[5]
			end
			
			SRAM_address <= RGB_counter+RGB_OFFSET;
			RGB_counter <= RGB_counter + 18'd1;
         SRAM_write_data <= {B_out[2],R_out[3]};//write G2 R3
			
			M1_state <= S_COMMON_9;
		end
		
		S_COMMON_9: begin
			Uprime_odd <= $signed(Uprime_odd - Mul_result_1 + Mul_result_2 + 32'd128)>>>8;
			Vprime_odd <= $signed(Vprime_odd - Mul_result_3 + Mul_result_4 + 32'd128)>>>8;
			
			//prepare for RGB even
         Mul_op_1 <= 32'd104595;
         Mul_op_2 <= Vprime_even - (32'd128);
			
			Mul_op_3 <= 32'd25624;
         Mul_op_4 <= Uprime_even - (32'd128);
			
			Mul_op_5 <= 32'd53281;
         Mul_op_6 <= Vprime_even - (32'd128);
			
			Mul_op_7 <= 32'd132251;
         Mul_op_8 <= Uprime_even - (32'd128);
			
			if (LO_counter != 18'd313) begin
				V_shift_reg[0] <= V_shift_reg[1]; //V[-1] = U[0]
				V_shift_reg[1] <= V_shift_reg[2]; //V[0]
				V_shift_reg[2] <= V_shift_reg[3]; //V[1]
				V_shift_reg[3] <= V_shift_reg[4]; //V[2]
				V_shift_reg[4] <= V_shift_reg[5]; //V[3]
				V_shift_reg[5] <= SRAM_read_data[15:8]; //U[2]
				
				//V_buf to store 
				V_buf <= SRAM_read_data[7:0]; //Buffer V[5]
			end
			
			//provide address
			SRAM_address <= RGB_counter+RGB_OFFSET;
			RGB_counter <= RGB_counter + 18'd1;
         SRAM_write_data <= {G_out[3],B_out[3]};//write G3 B3
							
			M1_state <= S_COMMON_10;
		end

		S_COMMON_10: begin
			//get R_0 G_0 B_0
			R_0 <= US_Y_buf_3 + Mul_result_1;
			G_0 <= US_Y_buf_3 - Mul_result_2 - Mul_result_3;
			B_0 <= US_Y_buf_3 + Mul_result_4;
			
			//prepare for RGB odd
         Mul_op_1 <= 32'd104595;
         Mul_op_2 <= Vprime_odd - (32'd128);
			
			Mul_op_3 <= 32'd25624;
         Mul_op_4 <= Uprime_odd - (32'd128);
			
			Mul_op_5 <= 32'd53281;
         Mul_op_6 <= Vprime_odd - (32'd128);
			
			Mul_op_7 <= 32'd132251;
         Mul_op_8 <= Uprime_odd - (32'd128);
			
			SRAM_we_n <= 1'b1;//enable read
			SRAM_address <= Y_counter;
			Y_counter <= Y_counter + 18'd1;
			
  		   M1_state <= S_COMMON_11;
		end

		S_COMMON_11: begin
			//get R_1 G_1 B_1
			R_1 <= US_Y_buf_4 + Mul_result_1;
			G_1 <= US_Y_buf_4 - Mul_result_2 - Mul_result_3;
			B_1 <= US_Y_buf_4 + Mul_result_4;
			
			SRAM_we_n <= 1'b1;//enable read
			SRAM_address <= Y_counter;
			Y_counter <= Y_counter + 18'd1;
			
			if (LO_counter == 18'd313) begin
				M1_state <= S_LO_0;
			end else begin
				M1_state <= S_COMMON_0;
			end

		end
		
		S_LO_0: begin
			//new cycle begin, shift begin
			SRAM_address <= Y_counter;
			Y_counter <= Y_counter + 18'd1;
				
			U_shift_reg[0] <= U_shift_reg[1];
			U_shift_reg[1] <= U_shift_reg[2];
			U_shift_reg[2] <= U_shift_reg[3];
			U_shift_reg[3] <= U_shift_reg[4];
			U_shift_reg[4] <= U_shift_reg[5];
			U_shift_reg[5] <= U_shift_reg[5];
			
			V_shift_reg[0] <= V_shift_reg[1];
			V_shift_reg[1] <= V_shift_reg[2];
			V_shift_reg[2] <= V_shift_reg[3];
			V_shift_reg[3] <= V_shift_reg[4];
			V_shift_reg[4] <= V_shift_reg[5];
			V_shift_reg[5] <= V_shift_reg[5];
			
			M1_state <= S_LO_1;
		end

		S_LO_1: begin	
			Y_reg[0] <= SRAM_read_data[15:8];
         Y_reg[1] <= SRAM_read_data[7:0];//Y[3]
		
			Mul_op_1 <= 32'd21;
			Mul_op_2 <= U_32_unsigned[0];
			
			Mul_op_3 <= 32'd52;
			Mul_op_4 <= U_32_unsigned[1];
			
			Mul_op_5 <= 32'd159;
			Mul_op_6 <= U_32_unsigned[2];
			
			Mul_op_7 <= 32'd159;
			Mul_op_8 <= U_32_unsigned[3];
							
			M1_state <= S_LO_2;
		end

		S_LO_2: begin
			Y_reg[2] <= SRAM_read_data[15:8];
         Y_reg[3] <= SRAM_read_data[7:0];//Y[3]
			
			Uprime_odd <= $signed(Mul_result_1 - Mul_result_2 + Mul_result_3 + Mul_result_4);
			
			Mul_op_1 <= 32'd21;
			Mul_op_2 <= V_32_unsigned[0];
			
			Mul_op_3 <= 32'd52;
			Mul_op_4 <= V_32_unsigned[1];
			
			Mul_op_5 <= 32'd159;
			Mul_op_6 <= V_32_unsigned[2];
			
			Mul_op_7 <= 32'd159;
			Mul_op_8 <= V_32_unsigned[3];
			
			M1_state <= S_LO_3;
		end
		
		S_LO_3: begin
			Y_reg[4] <= SRAM_read_data[15:8];
         Y_reg[5] <= SRAM_read_data[7:0];//Y[3]
			
			Vprime_odd <= $signed(Mul_result_1 - Mul_result_2 + Mul_result_3 + Mul_result_4);
		
			Mul_op_1 <= 32'd52;
			Mul_op_2 <= U_32_unsigned[4];
			
			Mul_op_3 <= 32'd21;
			Mul_op_4 <= U_32_unsigned[5];
			
			Mul_op_5 <= 32'd52;
			Mul_op_6 <= V_32_unsigned[4];
			
			Mul_op_7 <= 32'd21;
			Mul_op_8 <= V_32_unsigned[5];
			
			M1_state <= S_LO_4;
		end
		
		S_LO_4: begin
			Uprime_even <= U_shift_reg[2];//U'[0]
			Vprime_even <= V_shift_reg[2];//V'[0]
		
			Uprime_odd <= $signed(Uprime_odd - Mul_result_1 + Mul_result_2 + 32'd128)>>>8;
			Vprime_odd <= $signed(Vprime_odd - Mul_result_3 + Mul_result_4 + 32'd128)>>>8;

			Mul_op_1 <= 32'd76284;
         Mul_op_2 <= Y_32_unsigned[0]-(32'd16);

			Mul_op_3 <= 32'd76284;
         Mul_op_4 <= Y_32_unsigned[1] - (32'd16);

			Mul_op_5 <= 32'd76284;
         Mul_op_6 <= Y_32_unsigned[2]-(32'd16);

			Mul_op_7 <= 32'd76284;
         Mul_op_8 <= Y_32_unsigned[3]-(32'd16);
			
			SRAM_we_n <= 1'b0; //enable write
			SRAM_address <= RGB_counter+RGB_OFFSET;
			RGB_counter <= RGB_counter + 18'd1;
         SRAM_write_data <= {R_out[0],G_out[0]};
			
			M1_state <= S_LO_5;
		end

		S_LO_5: begin
			//store a0Y
			US_Y_buf_1 <= Mul_result_1;
			US_Y_buf_2 <= Mul_result_2;
			US_Y_buf_3 <= Mul_result_3;
			US_Y_buf_4 <= Mul_result_4;
			 
			//prepare for RGB even
         Mul_op_1 <= 32'd104595;
         Mul_op_2 <= Vprime_even - (32'd128);
			
			Mul_op_3 <= 32'd25624;
         Mul_op_4 <= Uprime_even - (32'd128);
			
			Mul_op_5 <= 32'd53281;
         Mul_op_6 <= Vprime_even - (32'd128);
			
			Mul_op_7 <= 32'd132251;
         Mul_op_8 <= Uprime_even - (32'd128);
			
			SRAM_address <= RGB_counter+RGB_OFFSET;
			RGB_counter <= RGB_counter + 18'd1;
         SRAM_write_data <= {B_out[0],R_out[1]};
			
			M1_state <= S_LO_6;
		end
		
		S_LO_6: begin
			R_2 <= US_Y_buf_1 + Mul_result_1;
			G_2 <= US_Y_buf_1 - Mul_result_2 - Mul_result_3;
			B_2 <= US_Y_buf_1 + Mul_result_4;
			
			//prepare for RGB even
			Mul_op_1 <= 32'd76284;
         Mul_op_2 <= Y_32_unsigned[4]-(32'd16);
			
			//prepare for RGB odd
			Mul_op_3 <= 32'd76284;
         Mul_op_4 <= Y_32_unsigned[5] - (32'd16);
			
			SRAM_address <= RGB_counter+RGB_OFFSET;
			RGB_counter <= RGB_counter + 18'd1;
         SRAM_write_data <= {G_out[1],B_out[1]};
			
			M1_state <= S_LO_7;
		end
		
		S_LO_7: begin
			US_Y_buf_5 <= Mul_result_1;
			US_Y_buf_6 <= Mul_result_2;
			 
			//prepare for RGB odd
         Mul_op_1 <= 32'd104595;
         Mul_op_2 <= Vprime_odd - (32'd128);
			
			Mul_op_3 <= 32'd25624;
         Mul_op_4 <= Uprime_odd - (32'd128);
			
			Mul_op_5 <= 32'd53281;
         Mul_op_6 <= Vprime_odd - (32'd128);
			
			Mul_op_7 <= 32'd132251;
         Mul_op_8 <= Uprime_odd - (32'd128);
			
			U_shift_reg[0] <= U_shift_reg[1];
			U_shift_reg[1] <= U_shift_reg[2];
			U_shift_reg[2] <= U_shift_reg[3];
			U_shift_reg[3] <= U_shift_reg[4];
			U_shift_reg[4] <= U_shift_reg[5];
			U_shift_reg[5] <= U_shift_reg[5];
			
			SRAM_address <= RGB_counter+RGB_OFFSET;
			RGB_counter <= RGB_counter + 18'd1;
         SRAM_write_data <= {R_out[2],G_out[2]};

			M1_state <= S_LO_8;
		end
		
		S_LO_8: begin
			//get R_1 G_1 B_1
			R_3 <= US_Y_buf_2 + Mul_result_1;
			G_3 <= US_Y_buf_2 - Mul_result_2 - Mul_result_3;
			B_3 <= US_Y_buf_2 + Mul_result_4;
			
			SRAM_we_n <= 1'b1;//enable read
			
			Mul_op_1 <= 32'd21;
			Mul_op_2 <= U_32_unsigned[0];
			
			Mul_op_3 <= 32'd52;
			Mul_op_4 <= U_32_unsigned[1];
			
			Mul_op_5 <= 32'd159;
			Mul_op_6 <= U_32_unsigned[2];
			
			Mul_op_7 <= 32'd159;
			Mul_op_8 <= U_32_unsigned[3];
			
			V_shift_reg[0] <= V_shift_reg[1];
			V_shift_reg[1] <= V_shift_reg[2];
			V_shift_reg[2] <= V_shift_reg[3];
			V_shift_reg[3] <= V_shift_reg[4];
			V_shift_reg[4] <= V_shift_reg[5];
			V_shift_reg[5] <= V_shift_reg[5];
							
			M1_state <= S_LO_9;
		end
		
		S_LO_9: begin
			Uprime_odd <= $signed(Mul_result_1 - Mul_result_2 + Mul_result_3 + Mul_result_4);
			
			Mul_op_1 <= 32'd21;
			Mul_op_2 <= V_32_unsigned[0];
			
			Mul_op_3 <= 32'd52;
			Mul_op_4 <= V_32_unsigned[1];
			
			Mul_op_5 <= 32'd159;
			Mul_op_6 <= V_32_unsigned[2];
			
			Mul_op_7 <= 32'd159;
			Mul_op_8 <= V_32_unsigned[3];
			
			SRAM_we_n <= 1'b0;	
			
			SRAM_address <= RGB_counter+RGB_OFFSET;
			RGB_counter <= RGB_counter + 18'd1;
         SRAM_write_data <= {B_out[2],R_out[3]};
					 
  		   M1_state <= S_LO_10;
		end
		
		S_LO_10: begin
			Vprime_odd <= $signed(Mul_result_1 - Mul_result_2 + Mul_result_3 + Mul_result_4);
		
			Mul_op_1 <= 32'd52;
			Mul_op_2 <= U_32_unsigned[4];
			
			Mul_op_3 <= 32'd21;
			Mul_op_4 <= U_32_unsigned[5];
			
			Mul_op_5 <= 32'd52;
			Mul_op_6 <= V_32_unsigned[4];
			
			Mul_op_7 <= 32'd21;
			Mul_op_8 <= V_32_unsigned[5];
			
			Uprime_even <= U_shift_reg[2];//U'[0]
			Vprime_even <= V_shift_reg[2];//V'[0]
			
			SRAM_address <= RGB_counter+RGB_OFFSET;
			RGB_counter <= RGB_counter + 18'd1;
         SRAM_write_data <= {G_out[3],B_out[3]};
			
			M1_state <= S_LO_11;
		end
		
		S_LO_11: begin
			//prepare for RGB even
         Mul_op_1 <= 32'd104595;
         Mul_op_2 <= Vprime_even - (32'd128);
			
			Mul_op_3 <= 32'd25624;
         Mul_op_4 <= Uprime_even - (32'd128);
			
			Mul_op_5 <= 32'd53281;
         Mul_op_6 <= Vprime_even - (32'd128);
			
			Mul_op_7 <= 32'd132251;
         Mul_op_8 <= Uprime_even - (32'd128);
			
			SRAM_we_n <= 1'b1;//enable write
		
			Uprime_odd <= $signed(Uprime_odd - Mul_result_1 + Mul_result_2 + 32'd128)>>>8;
			Vprime_odd <= $signed(Vprime_odd - Mul_result_3 + Mul_result_4 + 32'd128)>>>8;
								
			M1_state <= S_LO_12;
		end
		
		S_LO_12: begin
			//get R_0 G_0 B_0
			R_0 <= US_Y_buf_3 + Mul_result_1;
			G_0 <= US_Y_buf_3 - Mul_result_2 - Mul_result_3;
			B_0 <= US_Y_buf_3 + Mul_result_4;

			//prepare for RGB odd
         Mul_op_1 <= 32'd104595;
         Mul_op_2 <= Vprime_odd - (32'd128);
			
			Mul_op_3 <= 32'd25624;
         Mul_op_4 <= Uprime_odd - (32'd128);
			
			Mul_op_5 <= 32'd53281;
         Mul_op_6 <= Vprime_odd - (32'd128);
			
			Mul_op_7 <= 32'd132251;
         Mul_op_8 <= Uprime_odd - (32'd128);
			
			U_shift_reg[0] <= U_shift_reg[1];
			U_shift_reg[1] <= U_shift_reg[2];
			U_shift_reg[2] <= U_shift_reg[3];
			U_shift_reg[3] <= U_shift_reg[4];
			U_shift_reg[4] <= U_shift_reg[5];
			U_shift_reg[5] <= U_shift_reg[5];
			
			M1_state <= S_LO_13;
		end
		
		S_LO_13: begin
			R_1 <= US_Y_buf_4 + Mul_result_1;
			G_1 <= US_Y_buf_4 - Mul_result_2 - Mul_result_3;
			B_1 <= US_Y_buf_4 + Mul_result_4;
			
			Mul_op_1 <= 32'd21;
			Mul_op_2 <= U_32_unsigned[0];
			
			Mul_op_3 <= 32'd52;
			Mul_op_4 <= U_32_unsigned[1];
			
			Mul_op_5 <= 32'd159;
			Mul_op_6 <= U_32_unsigned[2];
			
			Mul_op_7 <= 32'd159;
			Mul_op_8 <= U_32_unsigned[3];
			
			V_shift_reg[0] <= V_shift_reg[1];
			V_shift_reg[1] <= V_shift_reg[2];
			V_shift_reg[2] <= V_shift_reg[3];
			V_shift_reg[3] <= V_shift_reg[4];
			V_shift_reg[4] <= V_shift_reg[5];
			V_shift_reg[5] <= V_shift_reg[5];
			
			SRAM_we_n <= 1'b0;//enable write
			SRAM_address <= RGB_counter+RGB_OFFSET;
			RGB_counter <= RGB_counter + 18'd1;
         SRAM_write_data <= {R_out[0],G_out[0]};
			
			M1_state <= S_LO_14;
		end
		
		S_LO_14: begin
			Uprime_odd <= $signed(Mul_result_1 - Mul_result_2 + Mul_result_3 + Mul_result_4);
			
			Mul_op_1 <= 32'd21;
			Mul_op_2 <= V_32_unsigned[0];
			
			Mul_op_3 <= 32'd52;
			Mul_op_4 <= V_32_unsigned[1];
			
			Mul_op_5 <= 32'd159;
			Mul_op_6 <= V_32_unsigned[2];
			
			Mul_op_7 <= 32'd159;
			Mul_op_8 <= V_32_unsigned[3];
			
			SRAM_address <= RGB_counter+RGB_OFFSET;
			RGB_counter <= RGB_counter + 18'd1;
         SRAM_write_data <= {B_out[0],R_out[1]};
			
			M1_state <= S_LO_15;
		end
		
		S_LO_15: begin
			Vprime_odd <= $signed(Mul_result_1 - Mul_result_2 + Mul_result_3 + Mul_result_4);
		
			Mul_op_1 <= 32'd52;
			Mul_op_2 <= U_32_unsigned[4];
			
			Mul_op_3 <= 32'd21;
			Mul_op_4 <= U_32_unsigned[5];
			
			Mul_op_5 <= 32'd52;
			Mul_op_6 <= V_32_unsigned[4];
			
			Mul_op_7 <= 32'd21;
			Mul_op_8 <= V_32_unsigned[5];
			
			Uprime_even <= U_shift_reg[2];//U'[0]
			Vprime_even <= V_shift_reg[2];//V'[0]
			
			SRAM_address <= RGB_counter+RGB_OFFSET;
			RGB_counter <= RGB_counter + 18'd1;
         SRAM_write_data <= {G_out[1],B_out[1]};
			
			M1_state <= S_LO_16;
		end
		
		S_LO_16: begin
			//prepare for RGB even
         Mul_op_1 <= 32'd104595;
         Mul_op_2 <= Vprime_even - (32'd128);
			
			Mul_op_3 <= 32'd25624;
         Mul_op_4 <= Uprime_even - (32'd128);
			
			Mul_op_5 <= 32'd53281;
         Mul_op_6 <= Vprime_even - (32'd128);
			
			Mul_op_7 <= 32'd132251;
         Mul_op_8 <= Uprime_even - (32'd128);
			
			Uprime_odd <= $signed(Uprime_odd - Mul_result_1 + Mul_result_2 + 32'd128)>>>8;
			Vprime_odd <= $signed(Vprime_odd - Mul_result_3 + Mul_result_4 + 32'd128)>>>8;
			
			SRAM_we_n <= 1'b1;//enable read
			
			M1_state <= S_LO_17;
		end
		
		S_LO_17: begin
			//get R_0 G_0 B_0
			R_2 <= US_Y_buf_5 + Mul_result_1;
			G_2 <= US_Y_buf_5 - Mul_result_2 - Mul_result_3;
			B_2 <= US_Y_buf_5 + Mul_result_4;
			
			//prepare for RGB odd
         Mul_op_1 <= 32'd104595;
         Mul_op_2 <= Vprime_odd - (32'd128);
			
			Mul_op_3 <= 32'd25624;
         Mul_op_4 <= Uprime_odd - (32'd128);
			
			Mul_op_5 <= 32'd53281;
         Mul_op_6 <= Vprime_odd - (32'd128);
			
			Mul_op_7 <= 32'd132251;
         Mul_op_8 <= Uprime_odd - (32'd128);

			M1_state <= S_LO_18;
		end
		
		S_LO_18: begin
			//get R_1 G_1 B_1
			R_3 <= US_Y_buf_6 + Mul_result_1;
			G_3 <= US_Y_buf_6 - Mul_result_2 - Mul_result_3;
			B_3 <= US_Y_buf_6 + Mul_result_4;
			
			SRAM_we_n <= 1'b0;
			SRAM_address <= RGB_counter+RGB_OFFSET;
			RGB_counter <= RGB_counter + 18'd1;
         SRAM_write_data <= {R_out[2],G_out[2]};
			
			M1_state <= S_LO_19;
		end
		
		S_LO_19: begin
			SRAM_address <= RGB_counter+RGB_OFFSET;
			RGB_counter <= RGB_counter + 18'd1;
         SRAM_write_data <= {B_out[2],R_out[3]};
			
			M1_state <= S_LO_20;
		end
		
		S_LO_20: begin
			SRAM_address <= RGB_counter+RGB_OFFSET;
			RGB_counter <= RGB_counter + 18'd1;
         SRAM_write_data <= {G_out[3],B_out[3]};
			
			if(Y_counter == 18'd38400) begin // all values are readed and computed
				M1_state <= S_LO_21;
			end else begin
				M1_state <= S_M1_IDLE;
			end
		end
		
		S_LO_21: begin
			UV_counter <= 18'd0; 
			Y_counter <= 18'd0;
			LO_counter <= 18'd0;
			M1_finish <= 1'b1; // generate a finish flag to top level file
			M1_state <= S_M1_IDLE;
		end

       default: M1_state <= S_M1_IDLE;
       endcase
    end
end

endmodule
