
`timescale 1ns/100ps

`ifndef DISABLE_DEFAULT_NET
`default_nettype none
`endif

`include "define_state.h"
module milestone2 (
   input logic Clock,                   // 50 MHz clock
	input logic resetn,
			
	input logic           M2_enable,
	output logic          M2_finish,
	
	input logic   [15:0]  SRAM_read_data,
	output logic          SRAM_we_n,
	output logic  [17:0]  SRAM_address,
	output logic  [15:0]  SRAM_write_data
	
);

milestone2_state_type M2_state;
milestone3_state_type M3_state;

//dual port0 to store part 2 of T = S'*C, one sample per location in first 32 memory locations
logic [6:0] address_a_0,address_b_0;
logic [31:0] write_data_a_0,write_data_b_0;
logic [31:0] read_data_a_0,read_data_b_0; //a to read S', b to read S
logic write_enable_a_0,write_enable_b_0;

// Instantiate RAM0
dual_port_RAM0 dual_port_RAM_inst0 (
	.address_a (address_a_0),
	.address_b (address_b_0),
	.clock (Clock),
	.data_a (write_data_a_0),
	.data_b (write_data_b_0),
	.wren_a (write_enable_a_0),
	.wren_b (write_enable_b_0),
	.q_a (read_data_a_0),
	.q_b (read_data_b_0)
);

//dual port1, stores S' and S, two samples per location, in the first 32 memory locations
logic [6:0] address_a_1,address_b_1;
logic [31:0] write_data_a_1,write_data_b_1;
logic [31:0] read_data_a_1,read_data_b_1;
logic write_enable_a_1,write_enable_b_1;

// Instantiate RAM1
dual_port_RAM1 dual_port_RAM_inst1 (
	.address_a (address_a_1),//read
	.address_b (address_b_1),//write
	.clock (Clock),
	.data_a (write_data_a_1),
	.data_b (write_data_b_1),
	.wren_a (write_enable_a_1),
	.wren_b (write_enable_b_1),
	.q_a (read_data_a_1),
	.q_b (read_data_b_1)
);

//dual port2, stores part 1 of T = S'*C, one sample per location in first 32 memory locations
logic [6:0] address_a_2,address_b_2;
logic [31:0] write_data_a_2,write_data_b_2;
logic [31:0] read_data_a_2,read_data_b_2;
logic write_enable_a_2,write_enable_b_2;

// Instantiate RAM2
dual_port_RAM2 dual_port_RAM_inst2 (
	.address_a (address_a_2),
	.address_b (address_b_2),
	.clock (Clock),
	.data_a (write_data_a_2),
	.data_b (write_data_b_2),
	.wren_a (write_enable_a_2),
	.wren_b (write_enable_b_2),
	.q_a (read_data_a_2),
	.q_b (read_data_b_2)
);

//dual port3, stores S' in milestone 3
logic [6:0] address_a_3,address_b_3;
logic [31:0] write_data_a_3,write_data_b_3;
logic [31:0] read_data_a_3,read_data_b_3;
logic write_enable_a_3,write_enable_b_3;

// Instantiate RAM3
dual_port_RAM3 dual_port_RAM_inst3 (
	.address_a (address_a_3),
	.address_b (address_b_3),
	.clock (Clock),
	.data_a (write_data_a_3),
	.data_b (write_data_b_3),
	.wren_a (write_enable_a_3),
	.wren_b (write_enable_b_3),
	.q_a (read_data_a_3),
	.q_b (read_data_b_3)
);

//logics for zig-zag scan in M3
logic [6:0] z_pos;
logic [6:0] z_addr;

always_comb begin
	z_addr = 7'd0;
	case (z_pos)
		7'd0:begin
			z_addr = 7'd0;
		end
		7'd1:begin
			z_addr = 7'd1;
		end
		7'd2:begin
			z_addr = 7'd8;
		end
		7'd3:begin
			z_addr = 7'd16;
		end
		7'd4:begin
			z_addr = 7'd9;
		end
		7'd5:begin
			z_addr = 7'd2;
		end
		7'd6:begin
			z_addr = 7'd3;
		end
		7'd7:begin
			z_addr = 7'd10;
		end
		7'd8:begin
			z_addr = 7'd17;
		end
		7'd9:begin
			z_addr = 7'd24;
		end
		7'd10:begin
			z_addr = 7'd32;
		end
		7'd11:begin
			z_addr = 7'd25;
		end
		7'd12:begin
			z_addr = 7'd18;
		end
		7'd13:begin
			z_addr = 7'd11;
		end
		7'd14:begin
			z_addr = 7'd4;
		end
		7'd15:begin
			z_addr = 7'd5;
		end
		7'd16:begin
			z_addr = 7'd12;
		end
		7'd17:begin
			z_addr = 7'd19;
		end
		7'd18:begin
			z_addr = 7'd26;
		end
		7'd19:begin
			z_addr = 7'd33;
		end
		7'd20:begin
			z_addr = 7'd40;
		end
		7'd21:begin
			z_addr = 7'd48;
		end
		7'd22:begin
			z_addr = 7'd41;
		end
		7'd23:begin
			z_addr = 7'd34;
		end
		7'd24:begin
			z_addr = 7'd27;
		end
		7'd25:begin
			z_addr = 7'd20;
		end
		7'd26:begin
			z_addr = 7'd13;
		end
		7'd27:begin
			z_addr = 7'd6;
		end
		7'd28:begin
			z_addr = 7'd7;
		end
		7'd29:begin
			z_addr = 7'd14;
		end
		7'd30:begin
			z_addr = 7'd21;
		end
		7'd31:begin
			z_addr = 7'd28;
		end
		7'd32:begin
			z_addr = 7'd35;
		end
		7'd33:begin
			z_addr = 7'd42;
		end
		7'd34:begin
			z_addr = 7'd49;
		end
		7'd35:begin
			z_addr = 7'd56;
		end
		7'd36:begin
			z_addr = 7'd57;
		end
		7'd37:begin
			z_addr = 7'd50;
		end
		7'd38:begin
			z_addr = 7'd43;
		end
		7'd39:begin
			z_addr = 7'd36;
		end
		7'd40:begin
			z_addr = 7'd29;
		end
		7'd41:begin
			z_addr = 7'd22;
		end
		7'd42:begin
			z_addr = 7'd15;
		end
		7'd43:begin
			z_addr = 7'd23;
		end
		7'd44:begin
			z_addr = 7'd30;
		end
		7'd45:begin
			z_addr = 7'd37;
		end
		7'd46:begin
			z_addr = 7'd44;
		end
		7'd47:begin
			z_addr = 7'd51;
		end
		7'd48:begin
			z_addr = 7'd58;
		end
		7'd49:begin
			z_addr = 7'd59;
		end
		7'd50:begin
			z_addr = 7'd52;
		end
		7'd51:begin
			z_addr = 7'd45;
		end
		7'd52:begin
			z_addr = 7'd38;
		end
		7'd53:begin
			z_addr = 7'd31;
		end
		7'd54:begin
			z_addr = 7'd39;
		end
		7'd55:begin
			z_addr = 7'd46;
		end
		7'd56:begin
			z_addr = 7'd53;
		end
		7'd57:begin
			z_addr = 7'd60;
		end
		7'd58:begin
			z_addr = 7'd61;
		end
		7'd59:begin
			z_addr = 7'd54;
		end
		7'd60:begin
			z_addr = 7'd47;
		end
		7'd61:begin
			z_addr = 7'd55;
		end
		7'd62:begin
			z_addr = 7'd62;
		end
		7'd63:begin
			z_addr = 7'd63;
		end
	endcase
end

//logics for Q0 matrix
logic [5:0] Q_pos;
logic [6:0] Q0_read;

always_comb begin
	Q0_read = 7'd0;
	case (Q_pos)
		6'd0:begin
			Q0_read = 7'd8;
		end
		6'd1,6'd2:begin
			Q0_read = 7'd4;
		end
		6'd3,6'd4,6'd5,6'd6,6'd7,6'd8,6'd9:begin
			Q0_read = 7'd8;
		end
		6'd10,6'd11,6'd12,6'd13,6'd14,6'd15,6'd16,6'd17,6'd18,6'd19,6'd20:begin
			Q0_read = 7'd16;
		end
		6'd21,6'd22,6'd23,6'd24,6'd25,6'd26,6'd27,6'd28,6'd29,6'd30,6'd31,6'd32,6'd33,6'd34,6'd35:begin
			Q0_read = 7'd32;
		end
		6'd36,6'd37,6'd38,6'd39,6'd40,6'd41,6'd42,6'd43,6'd44,6'd45,6'd46,6'd47,6'd48,6'd49,6'd50,6'd51,6'd52,6'd53,6'd54,6'd55,6'd56,6'd57,6'd58,6'd59,6'd60,6'd61,6'd62,6'd63:begin
			Q0_read = 7'd64;
		end
	endcase
end

//logics for Q1 matrix
logic [6:0] Q1_read;
always_comb begin
	Q1_read = 7'd0;
	case(Q_pos)
		6'd0:begin
			Q1_read = 7'd8;
		end
		6'd1,6'd2,6'd3,6'd4,6'd5,6'd6,6'd7,6'd8,6'd9:begin
			Q1_read = 7'd2;
		end
		6'd10,6'd11,6'd12,6'd13,6'd14,6'd15,6'd16,6'd17,6'd18,6'd19,6'd20:begin
			Q1_read = 7'd4;
		end
		6'd21,6'd22,6'd23,6'd24,6'd25,6'd26,6'd27,6'd28,6'd29,6'd30,6'd31,6'd32,6'd33,6'd34,6'd35:begin
			Q1_read = 7'd8;
		end
		6'd36,6'd37,6'd38,6'd39,6'd40,6'd41,6'd42,6'd43,6'd44,6'd45,6'd46,6'd47,6'd48,6'd49,6'd50,6'd51,6'd52,6'd53:begin
			Q1_read = 7'd16;
		end
		6'd54,6'd55,6'd56,6'd57,6'd58,6'd59,6'd60,6'd61,6'd62,6'd63:begin
			Q1_read = 7'd32;
		end
	endcase
end

//logics for Main FSM M3
logic M3_enable;
logic [17:0] SRAM_BIST_addr;
logic [6:0] BIST_read_counter;
logic Q_selected;
logic [31:0] BIST_read_buf;
logic [1:0] first_2bits;
logic [6:0] SP_write_offset, SP_read_offset;
logic SP_read_offset_ctrl, SP_write_offset_ctrl;
logic [5:0] bits_left;
logic [4:0] shift_bits;
logic [6:0] ram3_read_counter;
logic [3:0] zero_counter;
logic M3_done;

//to decide which location want to be read/write
assign SP_read_offset = SP_read_offset_ctrl ? 7'd64: 7'd0,
		 SP_write_offset = SP_write_offset_ctrl ? 7'd64: 7'd0;
			

//logics for Main FSM M2
logic [5:0] rb;//row counter, used to count the row indexes of blocks
logic [6:0] cb;//column counter, used to count the coloum indexes of block
logic [2:0] ri, ci;//row counter and column counter used to count the indexes inside each block
logic [1:0] ci_write;
logic [2:0] ri_write;
logic [5:0] rb_write;
logic [6:0] cb_write;
logic [7:0] RA_write;
logic [8:0] CA_write;
logic [5:0] sample_counter;//generate ri and ci to get the sample positions
logic [7:0] RA;//row address
logic [8:0] CA;//column address
logic [17:0] Y_read_addr, U_read_addr, V_read_addr;//Pre-IDCT address of Y, U, V segments
logic [17:0] Y_write_addr, U_write_addr, V_write_addr;
logic [17:0] SP_read_addr, S_write_addr;
logic Y_read_ctrl, U_read_ctrl, V_read_ctrl;//read S' controls
logic Y_write_ctrl, U_write_ctrl, V_write_ctrl;//write S controls
logic [1:0] delay_counter;//used to count the first 3 delay cc as fetching S'
logic [1:0] T_section_counter, S_section_counter;
logic [6:0] T_counter;//counts the cycles by computing 
logic [6:0] T_compted_counter;//counts the number of T computed
logic [7:0] S_counter;//counts how many S have been writen
logic signed [63:0] C_read_data;//the value of C transpose in MUX
logic [4:0] C_pos, C_trans_pos;//the position of C and C transpose values in MUX
logic [31:0] compute_T_in_S_buf_1, compute_T_in_S_buf_2;
logic [7:0] SP_read_counter;
logic all_finished, S_write_finished;//controller for MEGA states
logic [6:0] read_add_b_1_in_writeS;
logic Y_finished, U_finished;
logic S_write_done;
logic [1:0] S_done_counter;
logic M3_to_M2_ctrl;

logic [15:0] write_data_a_buf_1, store_SP_buf_1, store_SP_buf_2;//write S' into RAM 1
logic [31:0] test, test2, test_counter;

logic [31:0] T_result, T_result_buf_1, T_result_buf_2, T_result_buf_3, T_result_buf_4, T_result_buf_5, T_result_buf_6, T_result_buf_7, T_result_buf_8;
logic [31:0] S_result, S_result_buf_1, S_result_buf_2, S_result_buf_3, S_result_buf_4, S_result_buf_5, S_result_buf_6, S_result_buf_7, S_result_buf_8;
logic [31:0] S_final_result_buf_1, S_final_result_buf_2;
logic [7:0] S_out_0, S_out_1, S_out_3, S_out_4;
logic [6:0] S_write_counter;

//the address for writing the final result
logic [17:0] SRAM_final_S_addr;

assign	sample_counter = {ri,ci},
			RA = {rb,ri},
			CA = {cb,ci},
			Y_read_addr = Y_read_ctrl ? ({2'd0,RA,8'd0} + {4'd0,RA,6'd0} + {cb,ci}) : 17'd0,
			U_read_addr = U_read_ctrl ? ({3'd0,RA,7'd0} + {5'd0,RA,5'd0} + {cb,ci}) : 17'd0,
			V_read_addr = V_read_ctrl ? ({3'd0,RA,7'd0} + {5'd0,RA,5'd0} + {cb,ci}) : 17'd0,
			SP_read_addr = Y_read_ctrl ? Y_read_addr : | U_read_ctrl ? U_read_addr : | V_read_ctrl ? V_read_addr : 17'd0;

assign	RA_write = {rb_write,ri_write},
			CA_write = {cb_write,ci_write},
			Y_write_addr = Y_write_ctrl ? ({3'd0,RA_write,7'd0} + {5'd0,RA_write,5'd0} + {cb_write,ci_write} + Y_WRITE_OFFSET) : 17'd0,
			U_write_addr = U_write_ctrl ? ({4'd0,RA_write,6'd0} + {6'd0,RA_write,4'd0} + {cb_write,ci_write} + U_WRITE_OFFSET ) : 17'd0,
			V_write_addr = V_write_ctrl ? ({4'd0,RA_write,6'd0} + {6'd0,RA_write,4'd0} + {cb_write,ci_write} + V_WRITE_OFFSET ) : 17'd0,
			S_write_addr = Y_write_ctrl ? Y_write_addr : | U_write_ctrl ? U_write_addr : | V_write_ctrl ? V_write_addr : 17'd0;

assign	S_out_0 = S_final_result_buf_1[31] ? 8'd0 : |S_final_result_buf_1[30:24] ? 8'd255 : S_final_result_buf_1[23:16],
			S_out_1 = S_final_result_buf_2[31] ? 8'd0 : |S_final_result_buf_2[30:24] ? 8'd255 : S_final_result_buf_2[23:16];
		

//Multipliers
logic signed[31:0] Mult_op_1,Mult_op_2, Mult_op_3, Mult_op_4, Mult_op_5, Mult_op_6, Mult_op_7, Mult_op_8;
logic signed[31:0] Mult_result_1, Mult_result_2, Mult_result_3, Mult_result_4;
logic signed[63:0]Mult_result_long_1,Mult_result_long_2, Mult_result_long_3, Mult_result_long_4;

assign	Mult_result_long_1 = Mult_op_1*Mult_op_2,
			Mult_result_long_2 = Mult_op_3*Mult_op_4,
			Mult_result_long_3 = Mult_op_5*Mult_op_6,
			Mult_result_long_4 = Mult_op_7*Mult_op_8;
			
assign 	Mult_result_1 = Mult_result_long_1[31:0],
			Mult_result_2 = Mult_result_long_2[31:0],
			Mult_result_3 = Mult_result_long_3[31:0],
			Mult_result_4 = Mult_result_long_4[31:0];

//Matrix operands
logic [15:0] op_row_1,op_row_2,op_row_3,op_row_4,op_col_1,op_col_2,op_col_3,op_col_4;
logic signed [31:0] op_col_T1,op_col_T2,op_col_T3,op_col_T4; // T = S'*C		 
		 
always_comb begin
	op_row_1 = 16'd0;
	op_row_2 = 16'd0;
	op_row_3 = 16'd0;
	op_row_4 = 16'd0;
	
	op_col_1 = 16'd0;
	op_col_2 = 16'd0;
	op_col_3 = 16'd0;
	op_col_4 = 16'd0;
	
	op_col_T1 = 32'd0;
	op_col_T2 = 32'd0;
	op_col_T3 = 32'd0;
	op_col_T4 = 32'd0;
	
	Mult_op_1 = 32'd0;
	Mult_op_2 = 32'd0;
	Mult_op_3 = 32'd0;
	Mult_op_4 = 32'd0;
	Mult_op_5 = 32'd0;
	Mult_op_6 = 32'd0;
	Mult_op_7 = 32'd0;
	Mult_op_8 = 32'd0;
	
	if ((M2_state == S_M2_LI_FETCH_T_0) || (M2_state == S_M2_LI_FETCH_T_1) || (M2_state == S_M2_LI_FETCH_T_2) || (M2_state == S_M2_LI_FETCH_T_3 || (M2_state == S_M2_LI_FETCH_T_4) || (M2_state == S_M2_LI_FETCH_T_5) || (M2_state == S_M2_LI_FETCH_T_6) || (M2_state == S_M2_LI_FETCH_T_7))) begin
		//read S'
		op_row_1 = read_data_a_1[31:16];
		op_row_2 = read_data_a_1[15:0];
		op_row_3 = read_data_b_1[31:16];
		op_row_4 = read_data_b_1[15:0];
			
		//read C
		op_col_1 = C_read_data[63:48];
		op_col_2 = C_read_data[47:32];
		op_col_3 = C_read_data[31:16];
		op_col_4 = C_read_data[15:0];
		
		Mult_op_1 = {{16{op_row_1[15]}},op_row_1[15:0]};
		Mult_op_2 = {{16{op_col_1[15]}},op_col_1[15:0]};
		
		Mult_op_3 = {{16{op_row_2[15]}},op_row_2[15:0]};
		Mult_op_4 = {{16{op_col_2[15]}},op_col_2[15:0]};
		
		Mult_op_5 = {{16{op_row_3[15]}},op_row_3[15:0]};
		Mult_op_6 = {{16{op_col_3[15]}},op_col_3[15:0]};
		
		Mult_op_7 = {{16{op_row_4[15]}},op_row_4[15:0]};
		Mult_op_8 = {{16{op_col_4[15]}},op_col_4[15:0]};
	end else if ((M2_state == S_M2_OVERLAP_S_0) || (M2_state == S_M2_OVERLAP_S_1) || (M2_state == S_M2_OVERLAP_S_2) || (M2_state == S_M2_OVERLAP_S_3) || (M2_state == S_M2_OVERLAP_S_4) || (M2_state == S_M2_OVERLAP_S_5) || (M2_state == S_M2_OVERLAP_S_6) || (M2_state == S_M2_OVERLAP_S_7) ||
					 (M2_state == S_M2_LO_COMP_S_0) || (M2_state == S_M2_LO_COMP_S_1) || (M2_state == S_M2_LO_COMP_S_2) || (M2_state == S_M2_LO_COMP_S_3) || (M2_state == S_M2_LO_COMP_S_4) || (M2_state == S_M2_LO_COMP_S_5) || (M2_state == S_M2_LO_COMP_S_6) || (M2_state == S_M2_LO_COMP_S_7)) begin
		//read C_transpose
		op_row_1 = C_read_data[63:48];
		op_row_2 = C_read_data[47:32];
		op_row_3 = C_read_data[31:16];
		op_row_4 = C_read_data[15:0];
			
		//read T
		op_col_T1 = read_data_a_2;
		op_col_T2 = read_data_b_2;
		op_col_T3 = read_data_a_0;
		op_col_T4 = read_data_b_0;
		
		Mult_op_1 = {{16{op_row_1[15]}},op_row_1[15:0]};
		Mult_op_2 = op_col_T1;
		
		Mult_op_3 = {{16{op_row_2[15]}},op_row_2[15:0]};
		Mult_op_4 = op_col_T2;
		
		Mult_op_5 = {{16{op_row_3[15]}},op_row_3[15:0]};
		Mult_op_6 = op_col_T3;
		
		Mult_op_7 = {{16{op_row_4[15]}},op_row_4[15:0]};
		Mult_op_8 = op_col_T4;
	end else if ((M2_state == S_M2_OVERLAP_WRITE_S_0) || (M2_state == S_M2_OVERLAP_WRITE_S_1) || (M2_state == S_M2_OVERLAP_WRITE_S_2) || (M2_state == S_M2_OVERLAP_WRITE_S_3) || (M2_state == S_M2_OVERLAP_WRITE_S_4) || (M2_state == S_M2_OVERLAP_WRITE_S_5) || (M2_state == S_M2_OVERLAP_WRITE_S_6) || (M2_state == S_M2_OVERLAP_WRITE_S_7)) begin
		if (M2_state == S_M2_OVERLAP_WRITE_S_0) begin
			//read S'
			op_row_1 = read_data_a_1[31:16];
			op_row_2 = read_data_a_1[15:0];
			op_row_3 = read_data_b_1[31:16];
			op_row_4 = read_data_b_1[15:0];
			
			//read C
			op_col_1 = C_read_data[63:48];
			op_col_2 = C_read_data[47:32];
			op_col_3 = C_read_data[31:16];
			op_col_4 = C_read_data[15:0];
		
		end else begin
			//read S'
			op_row_1 = compute_T_in_S_buf_1[31:16];
			op_row_2 = compute_T_in_S_buf_1[15:0];
			op_row_3 = compute_T_in_S_buf_2[31:16];
			op_row_4 = compute_T_in_S_buf_2[15:0];
			
			//read C
			op_col_1 = C_read_data[63:48];
			op_col_2 = C_read_data[47:32];
			op_col_3 = C_read_data[31:16];
			op_col_4 = C_read_data[15:0];
		end
		
		Mult_op_1 = {{16{op_row_1[15]}},op_row_1[15:0]};
		Mult_op_2 = {{16{op_col_1[15]}},op_col_1[15:0]};
	
		Mult_op_3 = {{16{op_row_2[15]}},op_row_2[15:0]};
		Mult_op_4 = {{16{op_col_2[15]}},op_col_2[15:0]};
		
		Mult_op_5 = {{16{op_row_3[15]}},op_row_3[15:0]};
		Mult_op_6 = {{16{op_col_3[15]}},op_col_3[15:0]};
		
		Mult_op_7 = {{16{op_row_4[15]}},op_row_4[15:0]};
		Mult_op_8 = {{16{op_col_4[15]}},op_col_4[15:0]};
		
	end
end	

//MUX to read C_transpose
always_comb begin
	C_read_data = 64'h0;
	if ((M2_state == S_M2_OVERLAP_S_0) || (M2_state == S_M2_OVERLAP_S_1) || (M2_state == S_M2_OVERLAP_S_2) || (M2_state == S_M2_OVERLAP_S_3) || (M2_state == S_M2_OVERLAP_S_4)|| (M2_state == S_M2_OVERLAP_S_5) || (M2_state == S_M2_OVERLAP_S_6) || (M2_state == S_M2_OVERLAP_S_7) ||
		(M2_state == S_M2_LO_COMP_S_0) || (M2_state == S_M2_LO_COMP_S_1) || (M2_state == S_M2_LO_COMP_S_2) || (M2_state == S_M2_LO_COMP_S_3) || (M2_state == S_M2_LO_COMP_S_4)|| (M2_state == S_M2_LO_COMP_S_5) || (M2_state == S_M2_LO_COMP_S_6) || (M2_state == S_M2_LO_COMP_S_7)) begin
		case (C_trans_pos)
			4'd0: C_read_data = 64'h05A807D8076406A6;
			4'd1: C_read_data = 64'h05A80471030F018F;
			4'd2: C_read_data = 64'h05A806A6030FFE71;
			4'd3: C_read_data = 64'hFA58F828F89CFB8F;
			4'd4: C_read_data = 64'h05A80471FCF1F828;
			4'd5: C_read_data = 64'hFA58018F076406A6;
			4'd6: C_read_data = 64'h05A8018FF89CFB8F;
			4'd7: C_read_data = 64'h05A806A6FCF1F828;
			4'd8: C_read_data = 64'h05A8FE71F89C0471;
			4'd9: C_read_data = 64'h05A8F95AFCF107D8;
			4'd10: C_read_data = 64'h05A8FB8FFCF107D8;
			4'd11: C_read_data = 64'hFA58FE710764F95A;
			4'd12: C_read_data = 64'h05A8F95A030F018F;
			4'd13: C_read_data = 64'hFA5807D8F89C0471;
			4'd14: C_read_data = 64'h05A8F8280764F95A;
			4'd15: C_read_data = 64'h05A8FB8F030FFE71;
		endcase
	end
	
	if ((M2_state == S_M2_LI_FETCH_T_0) || (M2_state == S_M2_LI_FETCH_T_1) || (M2_state == S_M2_LI_FETCH_T_2) || (M2_state == S_M2_LI_FETCH_T_3) || (M2_state == S_M2_LI_FETCH_T_4)|| (M2_state == S_M2_LI_FETCH_T_5) || (M2_state == S_M2_LI_FETCH_T_6) || (M2_state == S_M2_LI_FETCH_T_7) ||
		(M2_state == S_M2_OVERLAP_WRITE_S_0) || (M2_state == S_M2_OVERLAP_WRITE_S_1) || (M2_state == S_M2_OVERLAP_WRITE_S_2) || (M2_state == S_M2_OVERLAP_WRITE_S_3) || (M2_state == S_M2_OVERLAP_WRITE_S_4)|| (M2_state == S_M2_OVERLAP_WRITE_S_5) || (M2_state == S_M2_OVERLAP_WRITE_S_6) || (M2_state == S_M2_OVERLAP_WRITE_S_7)) begin
		case (C_pos)
			4'd0: C_read_data = 64'h05A807D8076406A6;
			4'd1: C_read_data = 64'h05A80471030F018F;
			4'd2: C_read_data = 64'h05A806A6030FFE71;
			4'd3: C_read_data = 64'hFA58F828F89CFB8F;
			4'd4: C_read_data = 64'h05A80471FCF1F828;
			4'd5: C_read_data = 64'hFA58018F076406A6;
			4'd6: C_read_data = 64'h05A8018FF89CFB8F;
			4'd7: C_read_data = 64'h05A806A6FCF1F828;
			4'd8: C_read_data = 64'h05A8FE71F89C0471;
			4'd9: C_read_data = 64'h05A8F95AFCF107D8;
			4'd10: C_read_data = 64'h05A8FB8FFCF107D8;
			4'd11: C_read_data = 64'hFA58FE710764F95A;
			4'd12: C_read_data = 64'h05A8F95A030F018F;
			4'd13: C_read_data = 64'hFA5807D8F89C0471;
			4'd14: C_read_data = 64'h05A8F8280764F95A;
			4'd15: C_read_data = 64'h05A8FB8F030FFE71;
		endcase
	end
end	 


// FSM 
always_ff @ (posedge Clock or negedge resetn) begin
	if (resetn == 1'b0) begin
		
		M2_finish <= 1'b0;
		SRAM_we_n <= 1'b1;
      SRAM_write_data <= 16'd0;
		SRAM_address <= 18'd0;
		
		address_a_0 <= 7'd0;
		address_b_0 <= 7'd0;
		write_data_a_0 <= 32'd0;
		write_data_b_0 <= 32'd0;
		write_enable_a_0 <= 1'd0;
		write_enable_b_0 <= 1'd0;
		
		address_a_1 <= 7'd0;
		address_b_1 <= 7'd0;
		write_data_a_1 <= 32'd0;
		write_data_b_1 <= 32'd0;
		write_enable_a_1 <= 1'd0;
		write_enable_b_1 <= 1'd0;
		
		address_a_2 <= 7'd0;
		address_b_2 <= 7'd0;
		write_data_a_2 <= 32'd0;
		write_data_b_2 <= 32'd0;
		write_enable_a_2 <= 1'd0;
		write_enable_b_2 <= 1'd0;
		
		//--------------M3----------------------
		M3_enable <= 1'b0;
		
		address_a_3 <= 7'd0;
		address_b_3 <= 7'd0;
		write_data_a_3 <= 32'd0;
		write_data_b_3 <= 32'd0;
		write_enable_a_3 <= 1'd0;
		write_enable_b_3 <= 1'd0;
		
		SRAM_BIST_addr <= 18'd0;
		BIST_read_counter <= 7'd0;
		Q_selected <= 1'b0;
		Q_pos <= 6'd0;
		z_pos <= 7'd0;
		BIST_read_buf <= 32'd0;
		first_2bits <= 2'd0;
		bits_left <= 6'd0;
		shift_bits <= 5'd0;
		
		ram3_read_counter <= 7'd0;
		zero_counter <= 4'd0;
		
		//ctrl
		SP_read_offset_ctrl <= 1'b0;
		SP_write_offset_ctrl <= 1'b0;
		M3_to_M2_ctrl <= 1'b0;
		M3_done <= 1'b0;
		
		M3_state <= S_M3_IDLE;
		
		//---------------------------------------
		
		//initialize counters
		rb <= 6'd0;//up to 59, includes Y, U, V
		cb <= 6'd0;//up to 39
		ri <= 3'd0;
		ci <= 3'd0;
		delay_counter <= 2'd0;
		rb_write <= 6'd0;//up to 59
		cb_write <= 6'd0;//up to 39
		ri_write <= 3'd0;
		ci_write <= 2'd0;
		read_add_b_1_in_writeS <= 7'd0;
		
		//initialize controls
		Y_read_ctrl <= 1'd0;
		U_read_ctrl <= 1'd0;
		V_read_ctrl <= 1'd0;
		Y_write_ctrl <= 1'd0;
		U_write_ctrl <= 1'd0;
		V_write_ctrl <= 1'd0;
		Y_finished <= 1'b0;
		U_finished <= 1'b0;
		
		//initializes MUX positions
		C_trans_pos <= 4'd0;
		C_pos <= 4'd0;
		
		//
		SP_read_counter <= 8'd0;
		
		write_data_a_buf_1 <= 16'd0;
		store_SP_buf_1 <= 16'd0;
		store_SP_buf_2 <= 16'd0;
		test_counter <= 6'd0;
		test <= 6'd0;
		test2 <= 6'd0;
		
		//computed T results
		T_result <= 32'd0;
		T_result_buf_1 <= 32'd0;
		T_result_buf_2 <= 32'd0;
		T_result_buf_3 <= 32'd0;
		T_result_buf_4 <= 32'd0;
		T_result_buf_5 <= 32'd0;
		T_result_buf_6 <= 32'd0;
		T_result_buf_7 <= 32'd0;
		T_result_buf_8 <= 32'd0;
		T_counter <= 7'd0;
		T_compted_counter <= 7'd0;
		T_section_counter <= 1'b0;
		compute_T_in_S_buf_1 <= 32'd0;
		compute_T_in_S_buf_2 <= 32'd0;
		
		//computed S results
		S_result <= 32'd0;
		S_result_buf_1 <= 32'd0;
		S_result_buf_2 <= 32'd0;
		S_result_buf_3 <= 32'd0;
		S_result_buf_4 <= 32'd0;
		S_result_buf_5 <= 32'd0;
		S_result_buf_6 <= 32'd0;
		S_result_buf_7 <= 32'd0;
		S_result_buf_8 <= 32'd0;
		S_final_result_buf_1 <= 32'd0;
		S_final_result_buf_2 <= 32'd0;
		S_counter <= 7'd0;
		S_section_counter <= 1'b0;
		S_write_counter <= 7'd0;
		
		S_write_done <= 1'b0;
		S_done_counter <= 2'd0;
		//initialize the finial write address
		SRAM_final_S_addr <= 18'd0;
		
		//controller for the MEGA states
		all_finished <= 1'b0;
		S_write_finished <= 1'b0;
		
		M2_state <= S_M2_IDLE;
		
	end else begin
		case (M2_state)
		
		S_M2_IDLE: begin
			SRAM_we_n<= 1'b1;//enable read
			V_write_ctrl <= 1'b0;
			ci_write <= 3'd0;
			ri_write <= 4'd0;
			if(M2_finish!=1'b1) begin
				if(M2_enable==1'b1) begin
					Y_read_ctrl <= 1'd1;
					rb <= 5'd0;
					cb <= 6'd0;
					ri <= 3'd0;
					delay_counter <= 2'd0;
					write_enable_a_1 <= 1'b0;
					write_enable_b_1 <= 1'b0;
					address_a_1 <= 7'd0;
					address_b_1 <= 7'd0;
					SP_read_counter <= 8'd0;
					SRAM_we_n <= 1'b1;
					
					//provide address for S'[0][0]
					SRAM_address <= SP_read_addr + PRE_IDCT_OFFSET;
					ci <= ci + 3'd1;
					M2_state <= S_M3_in_M2;
					M3_enable <= 1'b1;
					
				end
			end
		end
		
		S_M3_in_M2: begin
			case (M3_state)
			S_M3_IDLE: begin
				if (M3_enable == 1'b1) begin
					M3_state <= S_M3_LI_0;
				end
			end
			
			S_M3_LI_0: begin
				//read from SRAM Bitstream, 2 bytes each time
				SRAM_we_n <= 1'b1;
				z_pos <= 7'd0;
				BIST_read_counter <= BIST_read_counter + 7'd1;
				if (BIST_read_counter < 7'd6) begin
					SRAM_address <= SRAM_BIST_addr + BIST_OFFSET;
					SRAM_BIST_addr <= SRAM_BIST_addr + 17'd1;
				end
				
				//to read the type of Q from the fifth byte, third time reading
				if (BIST_read_counter == 7'd5) begin
					Q_selected <= SRAM_read_data[15];
				end
				//read the main contents
				if (BIST_read_counter == 7'd7) begin
					BIST_read_buf[31:16] <= SRAM_read_data;
				end
				
				if (BIST_read_counter == 7'd8) begin
					BIST_read_buf[15:0] <= SRAM_read_data;
					BIST_read_counter <= 7'd0;
					shift_bits <= 5'd0;
					bits_left <= 6'd32;
					M3_state <= S_M3_FIRST_2BITS_0;
				end
			end
			
			S_M3_LI_1: begin
				z_pos <= z_pos + 7'd1;
				if (z_pos < 7'd63) begin
					write_enable_a_3 <= 1'b1;//enable write
					address_a_3 <= z_addr + SP_write_offset;
					write_data_a_3 <= 32'd0;
				end else if (z_pos == 7'd63) begin
					address_a_3 <= z_addr + SP_write_offset;
					write_data_a_3 <= 32'd0;
					z_pos <= 7'd0;
					M3_state <= S_M3_FIRST_2BITS_0;
				end
				
			end
			
			S_M3_FIRST_2BITS_0: begin
				first_2bits <= BIST_read_buf[31:30];
				M3_state <= S_M3_FIRST_2BITS_1;
				write_enable_a_3 <= 1'b1;//enable write
			end
			
			S_M3_FIRST_2BITS_1: begin
				case (first_2bits)
					
					2'b00: begin
						if (Q_selected == 1'b0) begin
							if (Q0_read == 7'd8) begin
								write_data_a_3 <= {{10{BIST_read_buf[29]}}, BIST_read_buf[29:27], 3'd0};
							end
							if (Q0_read == 7'd4) begin
								write_data_a_3 <= {{11{BIST_read_buf[29]}}, BIST_read_buf[29:27], 2'd0};
							end
							if (Q0_read == 7'd16) begin
								write_data_a_3 <= {{9{BIST_read_buf[29]}}, BIST_read_buf[29:27], 4'd0};
							end
							if (Q0_read == 7'd32) begin
								write_data_a_3 <= {{8{BIST_read_buf[29]}}, BIST_read_buf[29:27], 5'd0};
							end
							if (Q0_read == 7'd64) begin
								write_data_a_3 <= {{7{BIST_read_buf[29]}}, BIST_read_buf[29:27], 6'd0};
							end
						end else if (Q_selected == 1'b1) begin
							if (Q1_read == 7'd8) begin
								write_data_a_3 <= {{10{BIST_read_buf[29]}}, BIST_read_buf[29:27], 3'd0};
							end
							if (Q1_read == 7'd4) begin
								write_data_a_3 <= {{11{BIST_read_buf[29]}}, BIST_read_buf[29:27], 2'd0};
							end
							if (Q1_read == 7'd16) begin
								write_data_a_3 <= {{9{BIST_read_buf[29]}}, BIST_read_buf[29:27], 4'd0};
							end
							if (Q1_read == 7'd32) begin
								write_data_a_3 <= {{8{BIST_read_buf[29]}}, BIST_read_buf[29:27], 5'd0};
							end
							if (Q1_read == 7'd2) begin
								write_data_a_3 <= {{12{BIST_read_buf[29]}}, BIST_read_buf[29:27], 1'd0};
							end
						end
						address_a_3 <= z_addr + SP_write_offset;
						z_pos <= z_pos + 7'd1;
						Q_pos <= Q_pos + 6'd1;
						
						bits_left <= bits_left - 6'd5;
						shift_bits <= shift_bits + 5'd5;
					end
					
					2'b01: begin
						if (Q_selected == 1'b0) begin
							if (Q0_read == 7'd8) begin
								write_data_a_3 <= {{10{BIST_read_buf[29]}}, BIST_read_buf[29:27], 3'd0};
							end
							if (Q0_read == 7'd4) begin
								write_data_a_3 <= {{11{BIST_read_buf[29]}}, BIST_read_buf[29:27], 2'd0};
							end
							if (Q0_read == 7'd16) begin
								write_data_a_3 <= {{9{BIST_read_buf[29]}}, BIST_read_buf[29:27], 4'd0};
							end
							if (Q0_read == 7'd32) begin
								write_data_a_3 <= {{8{BIST_read_buf[29]}}, BIST_read_buf[29:27], 5'd0};
							end
							if (Q0_read == 7'd64) begin
								write_data_a_3 <= {{7{BIST_read_buf[29]}}, BIST_read_buf[29:27], 6'd0};
							end
						end else if (Q_selected == 1'b1) begin
							if (Q1_read == 7'd8) begin
								write_data_a_3 <= {{10{BIST_read_buf[29]}}, BIST_read_buf[29:27], 3'd0};
							end
							if (Q1_read == 7'd4) begin
								write_data_a_3 <= {{11{BIST_read_buf[29]}}, BIST_read_buf[29:27], 2'd0};
							end
							if (Q1_read == 7'd16) begin
								write_data_a_3 <= {{9{BIST_read_buf[29]}}, BIST_read_buf[29:27], 4'd0};
							end
							if (Q1_read == 7'd32) begin
								write_data_a_3 <= {{8{BIST_read_buf[29]}}, BIST_read_buf[29:27], 5'd0};
							end
							if (Q1_read == 7'd2) begin
								write_data_a_3 <= {{12{BIST_read_buf[29]}}, BIST_read_buf[29:27], 1'd0};
							end
						end
						address_a_3 <= z_addr + SP_write_offset;
						z_pos <= z_pos + 7'd1;
						Q_pos <= Q_pos + 6'd1;
						bits_left <= bits_left - 6'd5;
						shift_bits <= shift_bits + 5'd5;
					end
					
					2'b10: begin
						if (BIST_read_buf[29] == 1'b0) begin
							if (Q_selected == 1'b0) begin
								if (Q0_read == 7'd8) begin
									write_data_a_3 <= {{7{BIST_read_buf[28]}}, BIST_read_buf[28:23], 3'd0};
								end
								if (Q0_read == 7'd4) begin
									write_data_a_3 <= {{8{BIST_read_buf[28]}}, BIST_read_buf[28:23], 2'd0};
								end
								if (Q0_read == 7'd16) begin
									write_data_a_3 <= {{6{BIST_read_buf[28]}}, BIST_read_buf[28:23], 4'd0};
								end
								if (Q0_read == 7'd32) begin
									write_data_a_3 <= {{5{BIST_read_buf[28]}}, BIST_read_buf[28:23], 5'd0};
								end
								if (Q0_read == 7'd64) begin
									write_data_a_3 <= {{4{BIST_read_buf[28]}}, BIST_read_buf[28:23], 6'd0};
								end
							end else if (Q_selected == 1'b1) begin
								if (Q1_read == 7'd8) begin
									write_data_a_3 <= {{7{BIST_read_buf[28]}}, BIST_read_buf[28:23], 3'd0};
								end
								if (Q1_read == 7'd4) begin
									write_data_a_3 <= {{8{BIST_read_buf[28]}}, BIST_read_buf[28:23], 2'd0};
								end
								if (Q1_read == 7'd16) begin
									write_data_a_3 <= {{6{BIST_read_buf[28]}}, BIST_read_buf[28:23], 4'd0};
								end
								if (Q1_read == 7'd32) begin
									write_data_a_3 <= {{5{BIST_read_buf[28]}}, BIST_read_buf[28:23], 5'd0};
								end
								if (Q1_read == 7'd2) begin
									write_data_a_3 <= {{9{BIST_read_buf[28]}}, BIST_read_buf[28:23], 1'd0};
								end
							end
							
							address_a_3 <= z_addr + SP_write_offset;
							z_pos <= z_pos + 7'd1;
							Q_pos <= Q_pos + 6'd1;
							bits_left <= bits_left - 6'd9;
							shift_bits <= shift_bits + 5'd9;
							
						end else if (BIST_read_buf[29] == 1'b1) begin
							
							if (BIST_read_buf[28] == 1'b0) begin
								bits_left <= bits_left - 6'd4;
								shift_bits <= shift_bits + 5'd4;
								z_pos <= 7'd64;
							end else begin
								if (Q_selected == 1'b0) begin
									if (Q0_read == 7'd8) begin
										write_data_a_3 <= {{4{BIST_read_buf[27]}}, BIST_read_buf[27:19], 3'd0};
									end
									if (Q0_read == 7'd4) begin
										write_data_a_3 <= {{5{BIST_read_buf[27]}}, BIST_read_buf[27:19], 2'd0};
									end
									if (Q0_read == 7'd16) begin
										write_data_a_3 <= {{3{BIST_read_buf[27]}}, BIST_read_buf[27:19], 4'd0};
									end
									if (Q0_read == 7'd32) begin
										write_data_a_3 <= {{2{BIST_read_buf[27]}}, BIST_read_buf[27:19], 5'd0};
									end
									if (Q0_read == 7'd64) begin
										write_data_a_3 <= {{1{BIST_read_buf[27]}}, BIST_read_buf[27:19], 6'd0};
									end
								end else if (Q_selected == 1'b1) begin
									if (Q1_read == 7'd8) begin
										write_data_a_3 <= {{4{BIST_read_buf[27]}}, BIST_read_buf[27:19], 3'd0};
									end
									if (Q1_read == 7'd4) begin
										write_data_a_3 <= {{5{BIST_read_buf[27]}}, BIST_read_buf[27:19], 2'd0};
									end
									if (Q1_read == 7'd16) begin
										write_data_a_3 <= {{3{BIST_read_buf[27]}}, BIST_read_buf[27:19], 4'd0};
									end
									if (Q1_read == 7'd32) begin
										write_data_a_3 <= {{2{BIST_read_buf[27]}}, BIST_read_buf[27:19], 5'd0};
									end
									if (Q1_read == 7'd2) begin
										write_data_a_3 <= {{6{BIST_read_buf[27]}}, BIST_read_buf[27:19], 1'd0};
									end
								end
								
								address_a_3 <= z_addr + SP_write_offset;
								z_pos <= z_pos + 7'd1;
								Q_pos <= Q_pos + 6'd1;
								bits_left <= bits_left - 6'd13;
								shift_bits <= shift_bits + 5'd13;
							end
						end
					end
					
					2'b11: begin
						if (BIST_read_buf[29:27] == 3'b0) begin
							//write 8 zeroes, so skip 8 numbers
							z_pos <= z_pos + 7'd8;
							Q_pos <= Q_pos + 6'd8;
						end else if (BIST_read_buf[29:27] != 3'b0) begin
							z_pos <= z_pos + {4'd0, BIST_read_buf[29:27]};
							Q_pos <= Q_pos + {3'd0, BIST_read_buf[29:27]};
						end
						bits_left <= bits_left - 6'd5;
						shift_bits <= shift_bits + 5'd5;
					end
					
				endcase
				
				if (first_2bits == 2'b00) begin
					M3_state <= S_M3_READ_3_BITS;
				end else begin
					M3_state <= S_M3_SHIFT_BITS;
				end

			end
			
			S_M3_READ_3_BITS: begin
				if (Q_selected == 1'b0) begin
					if (Q0_read == 7'd8) begin
						write_data_a_3 <= {{10{BIST_read_buf[26]}}, BIST_read_buf[26:24], 3'd0};
					end
					if (Q0_read == 7'd4) begin
						write_data_a_3 <= {{11{BIST_read_buf[26]}}, BIST_read_buf[26:24], 2'd0};
					end
					if (Q0_read == 7'd16) begin
						write_data_a_3 <= {{9{BIST_read_buf[26]}}, BIST_read_buf[26:24], 4'd0};
					end
					if (Q0_read == 7'd32) begin
						write_data_a_3 <= {{8{BIST_read_buf[26]}}, BIST_read_buf[26:24], 5'd0};
					end
					if (Q0_read == 7'd64) begin
						write_data_a_3 <= {{7{BIST_read_buf[26]}}, BIST_read_buf[26:24], 6'd0};
					end
				end else if (Q_selected == 1'b1) begin
					if (Q1_read == 7'd8) begin
						write_data_a_3 <= {{10{BIST_read_buf[26]}}, BIST_read_buf[26:24], 3'd0};
					end
					if (Q1_read == 7'd4) begin
						write_data_a_3 <= {{11{BIST_read_buf[26]}}, BIST_read_buf[26:24], 2'd0};
					end
					if (Q1_read == 7'd16) begin
						write_data_a_3 <= {{9{BIST_read_buf[26]}}, BIST_read_buf[26:24], 4'd0};
					end
					if (Q1_read == 7'd32) begin
						write_data_a_3 <= {{8{BIST_read_buf[26]}}, BIST_read_buf[26:24], 5'd0};
					end
					if (Q1_read == 7'd2) begin
						write_data_a_3 <= {{12{BIST_read_buf[26]}}, BIST_read_buf[26:24], 1'd0};
					end
				end
				
				address_a_3 <= z_addr + SP_write_offset;
				z_pos <= z_pos + 7'd1;
				Q_pos <= Q_pos + 6'd1;
				bits_left <= bits_left - 6'd3;
				shift_bits <= shift_bits + 5'd3;
				M3_state <= S_M3_SHIFT_BITS;
			end
			
			S_M3_SHIFT_BITS: begin
				if (bits_left > 6'd16) begin
					case (shift_bits)
						5'd1: BIST_read_buf <= {BIST_read_buf[30:0], 1'd0};
						5'd2: BIST_read_buf <= {BIST_read_buf[29:0], 2'd0};
						5'd3: BIST_read_buf <= {BIST_read_buf[28:0], 3'd0};
						5'd4: BIST_read_buf <= {BIST_read_buf[27:0], 4'd0};
						5'd5: BIST_read_buf <= {BIST_read_buf[26:0], 5'd0};
						5'd6: BIST_read_buf <= {BIST_read_buf[25:0], 6'd0};
						5'd7: BIST_read_buf <= {BIST_read_buf[24:0], 7'd0};
						5'd8: BIST_read_buf <= {BIST_read_buf[23:0], 8'd0};
						5'd9: BIST_read_buf <= {BIST_read_buf[22:0], 9'd0};
						5'd10: BIST_read_buf <= {BIST_read_buf[21:0], 10'd0};
						5'd11: BIST_read_buf <= {BIST_read_buf[20:0], 11'd0};
						5'd12: BIST_read_buf <= {BIST_read_buf[19:0], 12'd0};
						5'd13: BIST_read_buf <= {BIST_read_buf[18:0], 13'd0};
						5'd14: BIST_read_buf <= {BIST_read_buf[17:0], 14'd0};
						5'd15: BIST_read_buf <= {BIST_read_buf[16:0], 15'd0};
						5'd16: BIST_read_buf <= {BIST_read_buf[15:0], 16'd0};
					endcase
					
					shift_bits <= 5'd0;
					if (z_pos == 7'd64) begin
						address_a_3 <= SP_write_offset;
						z_pos <= 7'd0;
						Q_pos <= 6'd0;
						write_enable_a_3 <= 1'b0;
						M3_enable <= 1'b0;
						M3_state <= S_M3_IDLE_COMMON;
						M2_state <= S_M2_LI_0;
						//M3_state <= S_M3_TEST;
					end else begin
						M3_state <= S_M3_FIRST_2BITS_0;
					end
				end
				if (bits_left <= 6'd16) begin
					SRAM_we_n <= 1'b1;
					BIST_read_counter <= BIST_read_counter + 7'd1;
					
					if (BIST_read_counter < 7'd1) begin
						SRAM_address <= SRAM_BIST_addr + BIST_OFFSET;
						SRAM_BIST_addr <= SRAM_BIST_addr + 17'd1;
					end
					
					if (BIST_read_counter == 7'd2) begin
						case (shift_bits)
							5'd1: BIST_read_buf <= {BIST_read_buf[30:0], 1'd0};
							5'd2: BIST_read_buf <= {BIST_read_buf[29:0], 2'd0};
							5'd3: BIST_read_buf <= {BIST_read_buf[28:0], 3'd0};
							5'd4: BIST_read_buf <= {BIST_read_buf[27:0], 4'd0};
							5'd5: BIST_read_buf <= {BIST_read_buf[26:0], 5'd0};
							5'd6: BIST_read_buf <= {BIST_read_buf[25:0], 6'd0};
							5'd7: BIST_read_buf <= {BIST_read_buf[24:0], 7'd0};
							5'd8: BIST_read_buf <= {BIST_read_buf[23:0], 8'd0};
							5'd9: BIST_read_buf <= {BIST_read_buf[22:0], 9'd0};
							5'd10: BIST_read_buf <= {BIST_read_buf[21:0], 10'd0};
							5'd11: BIST_read_buf <= {BIST_read_buf[20:0], 11'd0};
							5'd12: BIST_read_buf <= {BIST_read_buf[19:0], 12'd0};
							5'd13: BIST_read_buf <= {BIST_read_buf[18:0], 13'd0};
							5'd14: BIST_read_buf <= {BIST_read_buf[17:0], 14'd0};
							5'd15: BIST_read_buf <= {BIST_read_buf[16:0], 15'd0};
							5'd16: BIST_read_buf <= {BIST_read_buf[15:0], 16'd0};
						endcase
						shift_bits <= 5'd0;
					end
					
					if (BIST_read_counter == 7'd3) begin
						case (bits_left)
							6'd0: BIST_read_buf[31:16] <= SRAM_read_data;
							6'd1: BIST_read_buf[30:15] <= SRAM_read_data;
							6'd2: BIST_read_buf[29:14] <= SRAM_read_data;
							6'd3: BIST_read_buf[28:13] <= SRAM_read_data;
							6'd4: BIST_read_buf[27:12] <= SRAM_read_data;
							6'd5: BIST_read_buf[26:11] <= SRAM_read_data;
							6'd6: BIST_read_buf[25:10] <= SRAM_read_data;
							6'd7: BIST_read_buf[24:9] <= SRAM_read_data;
							6'd8: BIST_read_buf[23:8] <= SRAM_read_data;
							6'd9: BIST_read_buf[22:7] <= SRAM_read_data;
							6'd10: BIST_read_buf[21:6] <= SRAM_read_data;
							6'd11: BIST_read_buf[20:5] <= SRAM_read_data;
							6'd12: BIST_read_buf[19:4] <= SRAM_read_data;
							6'd13: BIST_read_buf[18:3] <= SRAM_read_data;
							6'd14: BIST_read_buf[17:2] <= SRAM_read_data;
							6'd15: BIST_read_buf[16:1] <= SRAM_read_data;
							6'd16: BIST_read_buf[15:0] <= SRAM_read_data;
						endcase
						
						bits_left <= bits_left + 6'd16;
						BIST_read_counter <= 7'd0;
						
						if (z_pos == 7'd64) begin
							z_pos <= 7'd0;
							write_enable_a_3 <= 1'b0;
							M3_enable <= 1'b0;
							M3_state <= S_M3_IDLE_COMMON;
							M2_state <= S_M2_LI_0;
							//M3_state <= S_M3_TEST;
						end else begin
							M3_state <= S_M3_FIRST_2BITS_0;
						end
					end
				end
			end
			
			endcase
		end
	
		
		S_M2_LI_0: begin
			ci <= ci + 3'd1;
			//address_a_3 <= SP_write_offset;
			address_b_3 <= ram3_read_counter + SP_read_offset;
			ram3_read_counter <= ram3_read_counter + 7'd1;
			
			M2_state <= S_M2_LI_1;
		end
		
		
		S_M2_LI_1: begin
			ci <= ci + 3'd1;
			address_a_1 <= 7'd0;
			
			address_b_3 <= ram3_read_counter + SP_read_offset;
			ram3_read_counter <= ram3_read_counter + 7'd1;
			
			//start M3 simutaneously
			M3_enable <= 1'b1;
			M2_state <= S_M2_LI_FETCH_SP;
		end
		
		
		// Fetch S' for Y 0,0
		S_M2_LI_FETCH_SP: begin
			if (SP_read_counter%8'd2 == 8'd0 && SP_read_counter < 8'd63) begin
				
				write_data_a_buf_1 <= read_data_b_3[15:0];
				write_enable_a_1 <= 1'b1;
				SP_read_counter <= SP_read_counter + 8'd1;
				test <= 2'd1;
			end else if (SP_read_counter%8'd2 == 8'd1) begin
				
				write_enable_a_1 <= 1'b0;
				write_data_a_1 <= {write_data_a_buf_1[15:0],read_data_b_3[15:0]};
				SP_read_counter <= SP_read_counter + 8'd1;
				test <= 2'd2;
				if (SP_read_counter <= 8'd63 && SP_read_counter != 8'd1) begin
					address_a_1 <= address_a_1 + 7'd1;
				end
			end
			
			if (address_b_3 < 7'd63) begin
				address_b_3 <= ram3_read_counter + SP_read_offset;
				ram3_read_counter <= ram3_read_counter + 7'd1;
			end
			
			if (write_enable_a_1 == 1'b0 && SP_read_counter == 8'd64) begin
				ci <= 3'd0;
				ri <= 3'd0;
				cb <= cb + 8'd1;
				
				//SP_read_offset_ctrl <= ~SP_read_offset_ctrl;
				ram3_read_counter <= 7'd0;
				
				address_a_1 <= 7'd0;//to provide S'
				address_b_1 <= 7'd1;//to provide S'
				address_a_0 <= 7'd0;//to store the T_part2 values
				address_a_2 <= 7'd0;//to store the T_part1 values
				T_result <= 32'd0;
				T_counter <= 7'd0;
				T_compted_counter <= 7'd0;
				T_section_counter <= 1'b0;
				SP_read_counter <= 8'd0;
				C_pos <= 4'd0;

				M2_state <= S_M2_LI_WAIT_T;
			end
			
			if (SP_read_counter < 8'd60) begin
				if (ci < 3'd7) begin
					ci <= ci + 3'd1;
				end else if (ci == 3'd7 && ri < 3'd7) begin
					ci <= 3'd0;
					ri <= ri + 3'd1;
				end else if (ci == 3'd7 && ri == 3'd7) begin
					cb <= cb + 6'd1;
				end
			end

		end
		
		// wait for one cc for getting the S' values in RAM 1
		S_M2_LI_WAIT_T: begin
			M2_state <= S_M2_LI_FETCH_T_0;
		end

		// Start computing T = S'*C
		S_M2_LI_FETCH_T_0: begin			
			if (T_counter != 7'd64) begin
				if (T_counter != 7'd0 && T_section_counter == 1'b0) begin
					T_result_buf_8 <= T_result;
					T_section_counter <= 1'b1;
					
					if (T_counter == 7'd4 || T_counter == 7'd12 || T_counter == 7'd36 || T_counter == 7'd44) begin
						write_enable_a_2 <= 1'b1;
					end else if (T_counter == 7'd20 || T_counter == 7'd28 || T_counter == 7'd52 || T_counter == 7'd60) begin
						write_enable_a_0 <= 1'b1;
						if (T_counter == 7'd52) begin
							write_enable_a_2 <= 1'b0;
						end
					end
				end else if (T_section_counter == 1'b1) begin
					if (T_counter == 7'd8 || T_counter == 7'd16 || T_counter == 7'd40 || T_counter == 7'd48) begin
						//T8
						//write_enable_a_2 <= 1'b0;
						write_data_a_2 <= $signed(T_result_buf_8 + T_result) >>>8;
						if (address_a_2 < 7'd31) begin
							address_a_2 <= address_a_2 + 7'd1;
						end
					end else if (T_counter == 7'd24 || T_counter == 7'd32 || T_counter == 7'd56) begin
						//write_enable_a_0 <= 1'b0;
						write_data_a_0 <= $signed(T_result_buf_8 + T_result) >>>8;
						address_a_0 <= address_a_0 + 7'd1;
					end
					
					T_section_counter <= 1'b0;
				end

				C_pos <= C_pos + 4'd2;
				T_result <= Mult_result_1 + Mult_result_2 + Mult_result_3 + Mult_result_4; 
				M2_state <= S_M2_LI_FETCH_T_1;
			end else if (T_counter == 7'd64) begin
				//T8
				//write_enable_a_0 <= 1'b0;
				write_data_a_0 <= $signed(T_result_buf_8 + T_result) >>>8;
				address_a_0 <= address_a_0 + 7'd1;
		
				//be ready to read C_transpose from MUX
				C_trans_pos <= 4'd0;
				
				T_counter <= 7'd0;
				S_counter <= 7'd0;
				T_section_counter <= 1'b0;
				S_section_counter <= 1'b0;
				S_result_buf_1 <= 32'd0;
				S_result_buf_2 <= 32'd0;
				S_result_buf_3 <= 32'd0; 
				S_result_buf_4 <= 32'd0;
				S_result_buf_5 <= 32'd0;
				S_result_buf_6 <= 32'd0;
				S_result_buf_7 <= 32'd0; 
				S_result_buf_8 <= 32'd0;
				T_compted_counter <= 7'd0;
				store_SP_buf_1 <= 16'd0;
				store_SP_buf_2 <= 16'd0;
				
				M2_state <= S_M2_DELAY_0;
			end		
		end
		
		S_M2_LI_FETCH_T_1: begin
			if (T_section_counter == 1'b0) begin
				T_result_buf_1 <= T_result;
				if (T_counter == 7'd8 || T_counter == 7'd16 || T_counter == 7'd40) begin
					write_enable_a_2 <= 1'b0;
					address_a_2 <= address_a_2 + 7'd1;
				end else if (T_counter == 7'd24 || T_counter == 7'd32 || T_counter == 7'd56) begin
					write_enable_a_0 <= 1'b0;
					address_a_0 <= address_a_0 + 7'd1;
				end
			end else if (write_enable_a_2 == 1'b1 && T_section_counter == 1'b1) begin
				//T1
				write_data_a_2 <= $signed(T_result_buf_1 + T_result)>>>8;
			end else if (write_enable_a_0 == 1'b1 && T_section_counter == 1'b1) begin
				write_data_a_0 <= $signed(T_result_buf_1 + T_result)>>>8;
			end
			
			T_result <= Mult_result_1 + Mult_result_2 + Mult_result_3 + Mult_result_4; 
			C_pos <= C_pos + 4'd2;
			
			M2_state <= S_M2_LI_FETCH_T_2;
		end
		
		S_M2_LI_FETCH_T_2: begin
			if (T_section_counter == 1'b0) begin
				T_result_buf_2 <= T_result;
			end else if (write_enable_a_2 == 1'b1) begin
				//T2
				write_data_a_2 <= $signed(T_result_buf_2 + T_result)>>>8;
				address_a_2 <= address_a_2 + 7'd1;
			end else if (write_enable_a_0 == 1'b1) begin
				write_data_a_0 <= $signed(T_result_buf_2 + T_result)>>>8;
				address_a_0 <= address_a_0 + 7'd1;
			end
		
			T_result <= Mult_result_1 + Mult_result_2 + Mult_result_3 + Mult_result_4; 
			C_pos <= C_pos + 4'd2;
		
			M2_state <= S_M2_LI_FETCH_T_3;
		end
		
		S_M2_LI_FETCH_T_3: begin
			if (T_section_counter == 1'b0) begin
				T_result_buf_3 <= T_result;
			end else if (write_enable_a_2 == 1'b1) begin
				write_data_a_2 <= $signed(T_result_buf_3 + T_result)>>>8;
				address_a_2 <= address_a_2 + 7'd1;
			end else if (write_enable_a_0 == 1'b1) begin
				write_data_a_0 <= $signed(T_result_buf_3 + T_result)>>>8;
				address_a_0 <= address_a_0 + 7'd1;
			end
			
			T_result <= Mult_result_1 + Mult_result_2 + Mult_result_3 + Mult_result_4; 
			C_pos <= C_pos + 4'd2;
		
			M2_state <= S_M2_LI_FETCH_T_4;
		end

		S_M2_LI_FETCH_T_4: begin
			if (T_section_counter == 1'b0) begin
				T_result_buf_4 <= T_result;
			end else if (write_enable_a_2 == 1'b1) begin
				//T4
				write_data_a_2 <= $signed(T_result_buf_4 + T_result)>>>8;
				address_a_2 <= address_a_2 + 7'd1;
			end else if (write_enable_a_0 == 1'b1) begin
				write_data_a_0 <= $signed(T_result_buf_4 + T_result)>>>8;
				address_a_0 <= address_a_0 + 7'd1;
			end
			
			T_result <= Mult_result_1 + Mult_result_2 + Mult_result_3 + Mult_result_4; 
			C_pos <= C_pos + 4'd2;
		
			M2_state <= S_M2_LI_FETCH_T_5;
		end
		
		S_M2_LI_FETCH_T_5: begin
			if (T_section_counter == 1'b0) begin
				T_result_buf_5 <= T_result;
			end else if (write_enable_a_2 == 1'b1) begin
				//T5
				write_data_a_2 <= $signed(T_result_buf_5 + T_result)>>>8;
				address_a_2 <= address_a_2 + 7'd1;
			end else if (write_enable_a_0 == 1'b1) begin
				write_data_a_0 <= $signed(T_result_buf_5 + T_result)>>>8;
				address_a_0 <= address_a_0 + 7'd1;
			end
			
			T_result <= Mult_result_1 + Mult_result_2 + Mult_result_3 + Mult_result_4; 
			C_pos <= C_pos + 4'd2;
		
			M2_state <= S_M2_LI_FETCH_T_6;
		end
		
		S_M2_LI_FETCH_T_6: begin
			if (T_section_counter == 1'b0) begin
				T_result_buf_6 <= T_result;
			end else if (write_enable_a_2 == 1'b1) begin
				//T6
				write_data_a_2 <= $signed(T_result_buf_6 + T_result)>>>8;
				if (address_a_2 < 7'd31) begin
					address_a_2 <= address_a_2 + 7'd1;
				end
			end else if (write_enable_a_0 == 1'b1) begin
				write_data_a_0 <= $signed(T_result_buf_6 + T_result)>>>8;
				if (address_a_0 < 7'd31) begin
				address_a_0 <= address_a_0 + 7'd1;
				end
			end
			
			if (address_a_1 < 7'd30) begin
				address_a_1 <= address_a_1 + 7'd2;
				address_b_1 <= address_b_1 + 7'd2;
			end
			
			T_result <= Mult_result_1 + Mult_result_2 + Mult_result_3 + Mult_result_4; 
			C_pos <= C_pos + 4'd2;
		
			M2_state <= S_M2_LI_FETCH_T_7;
		end
		
		S_M2_LI_FETCH_T_7: begin
			if (T_section_counter == 1'b0) begin
				T_result_buf_7 <= T_result;
				C_pos <= 4'd1;
			end else if (write_enable_a_2 == 1'b1) begin
				//T7
				write_data_a_2 <= $signed(T_result_buf_7 + T_result)>>>8;
				if (address_a_2 < 7'd31) begin
					address_a_2 <= address_a_2 + 7'd1;
				end
				C_pos <= 4'd0;
				T_compted_counter <= T_compted_counter + 7'd8;
			end else if (write_enable_a_0 == 1'b1) begin
				write_data_a_0 <= $signed(T_result_buf_7 + T_result)>>>8;
				if (address_a_0 < 7'd31) begin
					address_a_0 <= address_a_0 + 7'd1;
				end
				C_pos <= 4'd0;
				T_compted_counter <= T_compted_counter + 7'd8;
			end
			
			T_result <= Mult_result_1 + Mult_result_2 + Mult_result_3 + Mult_result_4; 
			T_counter <= T_counter + 7'd4;

			M2_state <= S_M2_LI_FETCH_T_0;
		end
		
		S_M2_DELAY_0: begin
			if (all_finished == 1'b0) begin
				M3_enable <= 1'b1;
			end
			M2_state <= S_M2_DELAY_1;
		end
		
		S_M2_DELAY_1: begin
			M2_state <= S_M2_DELAY_2;
		end
		
		S_M2_DELAY_2: begin
			M2_state <= S_M2_DELAY_3;
		end
		
		S_M2_DELAY_3: begin
			M2_state <= S_M2_DELAY_4;
		end
		
		S_M2_DELAY_4: begin
			M2_state <= S_M2_DELAY_5;
		end
		
		S_M2_DELAY_5: begin
			M2_state <= S_M2_DELAY_6;
		end
		
		S_M2_DELAY_6: begin
			M2_state <= S_M2_DELAY_7;
		end
		
		S_M2_DELAY_7: begin
			M2_state <= S_M2_DELAY_8;
		end
		
		S_M2_DELAY_8: begin
			M2_state <= S_M2_DELAY_9;
		end
		
		S_M2_DELAY_9: begin
			M2_state <= S_M2_DELAY_10;
		end
		
		S_M2_DELAY_10: begin
			M2_state <= S_M2_DELAY_11;
		end
		
		S_M2_DELAY_11: begin
			M2_state <= S_M2_DELAY_12;
		end
		
		S_M2_DELAY_12: begin
			M2_state <= S_M2_DELAY_13;
		end
		
		S_M2_DELAY_13: begin
			M2_state <= S_M2_DELAY_14;
		end
		
		S_M2_DELAY_14: begin
			M2_state <= S_M2_DELAY_15;
		end
		
		S_M2_DELAY_15: begin
			M2_state <= S_M2_DELAY_16;
		end
		
		S_M2_DELAY_16: begin
			M2_state <= S_M2_DELAY_17;
		end
		
		S_M2_DELAY_17: begin
			M2_state <= S_M2_DELAY_18;
		end
		
		S_M2_DELAY_18: begin
			M2_state <= S_M2_DELAY_19;
		end
		
		S_M2_DELAY_19: begin
			M2_state <= S_M2_DELAY_20;
		end
		
		S_M2_DELAY_20: begin
			M2_state <= S_M2_DELAY_21;
		end
		
		S_M2_DELAY_21: begin
			M2_state <= S_M2_DELAY_22;
		end
		
		S_M2_DELAY_22: begin
			M2_state <= S_M2_DELAY_23;
		end
		
		S_M2_DELAY_23: begin
			M2_state <= S_M2_DELAY_24;
		end
		
		S_M2_DELAY_24: begin
			M2_state <= S_M2_DELAY_25;
		end
		
		S_M2_DELAY_25: begin
			M2_state <= S_M2_DELAY_26;
		end
		
		S_M2_DELAY_26: begin
			M2_state <= S_M2_DELAY_27;
		end
		
		S_M2_DELAY_27: begin
			M2_state <= S_M2_DELAY_28;
		end
		
		S_M2_DELAY_28: begin
			M2_state <= S_M2_DELAY_29;
		end
		
		S_M2_DELAY_29: begin
			M2_state <= S_M2_DELAY_30;
		end
		
		S_M2_DELAY_30: begin
			M2_state <= S_M2_DELAY_31;
		end
		
		S_M2_DELAY_31: begin
			M2_state <= S_M2_DELAY_32;
		end
		
		S_M2_DELAY_32: begin
			M2_state <= S_M2_DELAY_33;
		end
		
		S_M2_DELAY_33: begin
			M2_state <= S_M2_DELAY_34;
		end
		
		S_M2_DELAY_34: begin
			M2_state <= S_M2_DELAY_35;
		end
		
		S_M2_DELAY_35: begin
			M2_state <= S_M2_DELAY_36;
		end
		
		S_M2_DELAY_36: begin
			M2_state <= S_M2_DELAY_37;
		end
		
		S_M2_DELAY_37: begin
			M2_state <= S_M2_DELAY_38;
		end
		
		S_M2_DELAY_38: begin
			M2_state <= S_M2_DELAY_39;
		end
		
		S_M2_DELAY_39: begin
			M2_state <= S_M2_DELAY_40;
		end
		
		S_M2_DELAY_40: begin
			M2_state <= S_M2_DELAY_41;
		end
		
		S_M2_DELAY_41: begin
			M2_state <= S_M2_DELAY_42;
		end
		
		S_M2_DELAY_42: begin
			M2_state <= S_M2_DELAY_43;
		end
		
		S_M2_DELAY_43: begin
			M2_state <= S_M2_DELAY_44;
		end
		
		S_M2_DELAY_44: begin
			M2_state <= S_M2_DELAY_45;
		end
		
		S_M2_DELAY_45: begin
			M2_state <= S_M2_DELAY_46;
		end
		
		S_M2_DELAY_46: begin
			M2_state <= S_M2_DELAY_47;
		end
		
		S_M2_DELAY_47: begin
			M2_state <= S_M2_DELAY_48;
		end
		
		S_M2_DELAY_48: begin
			M2_state <= S_M2_DELAY_49;
		end
		
		S_M2_DELAY_49: begin
			M2_state <= S_M2_DELAY_50;
		end
		
		S_M2_DELAY_50: begin
			M2_state <= S_M2_DELAY_51;
		end
		
		S_M2_DELAY_51: begin
			M2_state <= S_M2_DELAY_52;
		end
		
		S_M2_DELAY_52: begin
			M2_state <= S_M2_DELAY_53;
		end
		
		S_M2_DELAY_53: begin
			M2_state <= S_M2_DELAY_54;
		end
		
		S_M2_DELAY_54: begin
			M2_state <= S_M2_DELAY_55;
		end
		
		S_M2_DELAY_55: begin
			M2_state <= S_M2_DELAY_56;
		end
		
		S_M2_DELAY_56: begin
			M2_state <= S_M2_DELAY_57;
		end
		
		S_M2_DELAY_57: begin
			M2_state <= S_M2_DELAY_58;
		end
		
		S_M2_DELAY_58: begin
			M2_state <= S_M2_DELAY_59;
		end
		
		S_M2_DELAY_59: begin
			M2_state <= S_M2_DELAY_60;
		end
		
		S_M2_DELAY_60: begin
			M2_state <= S_M2_WAIT_S_0;
		end
		
		S_M2_WAIT_S_0: begin
			write_enable_a_0 <= 1'b0;
			// be ready to read C_trans and T in order to compute S
			address_a_2 <= 7'd0;//to provide first T
			address_b_2 <= 7'd8;//to provide second T
			address_a_0 <= 7'd0;//to provide third T
			address_b_0 <= 7'd8;//to provide fourth T
				
			// provide address for fetching new S'[0][0]
			if (all_finished == 1'b0) begin
				address_a_1 <= 7'd0;//to prepare for fetching S'
				// provide address for new S'[0][1]
				if (Y_read_ctrl == 1'b1) begin
					ci <= ci + 3'd1;
				end else if (U_read_ctrl == 1'b1) begin
					ci <= ci + 3'd1;
				end else if (V_read_ctrl == 1'b1) begin
					ci <= ci + 3'd1;
				end
			end 
			
			address_b_1 <= 7'd32;//to prepare for storing S
			SP_read_offset_ctrl <= ~SP_read_offset_ctrl;

			M2_state <= S_M2_WAIT_S_1;
		end
		
		S_M2_WAIT_S_1: begin
			
			address_a_2 <= address_a_2 + 7'd1;
			address_b_2 <= address_b_2 + 7'd1;
			address_a_0 <= address_a_0 + 7'd1;
			address_b_0 <= address_b_0 + 7'd1;
			
			if (all_finished == 1'b0) begin
				if (Y_read_ctrl == 1'b1) begin
					ci <= ci + 3'd1;
				end else if (U_read_ctrl == 1'b1) begin
					ci <= ci + 3'd1;
				end else if (V_read_ctrl == 1'b1) begin
					ci <= ci + 3'd1;
				end
				
				//Prepare for fetch S‘
				address_b_3 <= ram3_read_counter + SP_read_offset;
				ram3_read_counter <= ram3_read_counter + 8'd1;
				M2_state <= S_M2_OVERLAP_S_0;
			end else begin
				M2_state <= S_M2_LO_COMP_S_0;
			end
			
		end
		
		// -------------------------Compute S = C_transpose * T---------------------
		// -------------------------Fetch S' simutaneously--------------------------
		S_M2_OVERLAP_S_0: begin
			if (S_counter != 7'd64) begin
				// Compute S
				if (S_counter != 7'd0 && S_section_counter == 1'b0) begin
					S_result_buf_8 <= S_result;
					S_section_counter <= 1'b1;
				end else if (S_section_counter == 1'b1) begin
					//S8
					S_final_result_buf_2 <= $signed(S_result_buf_8 + S_result);
					write_enable_b_1 <= 1'b1;
					
					S_section_counter <= 1'b0;
				end
			
				S_result <= Mult_result_1 + Mult_result_2 + Mult_result_3 + Mult_result_4; 
				
				address_a_2 <= address_a_2 + 7'd1;
				address_b_2 <= address_b_2 + 7'd1;
				address_a_0 <= address_a_0 + 7'd1;
				address_b_0 <= address_b_0 + 7'd1;
				
				Y_write_ctrl <= 1'b0;
				U_write_ctrl <= 1'b0;
				V_write_ctrl <= 1'b0;
				
				address_b_3 <= ram3_read_counter + SP_read_offset;
				ram3_read_counter <= ram3_read_counter + 8'd1;
				
				M2_state <= S_M2_OVERLAP_S_1;
			end else if (S_counter == 7'd64) begin
				//S4_2
				S_final_result_buf_2 <= $signed(S_result_buf_8 + S_result);
				write_enable_b_1 <= 1'b1;
				
				M2_state <= S_M2_OVERLAP_WRITE_S_WAIT;	

			end
		end
		
		S_M2_OVERLAP_S_1: begin
			// Compute S
			if (S_section_counter == 1'b0) begin
				if (S_counter != 7'd0) begin
					write_data_b_1 <= {16'd0, S_out_0, S_out_1};
					address_b_1 <= address_b_1 + 7'd1;
					write_enable_b_1 <= 1'b0;
				end
				S_result_buf_1 <= S_result;
			end else	if (S_section_counter == 1'b1) begin
				S_final_result_buf_1 <= $signed(S_result_buf_1 + S_result);
			end
			
			S_result <= Mult_result_1 + Mult_result_2 + Mult_result_3 + Mult_result_4; 
			
			address_a_2 <= address_a_2 + 7'd1;
			address_b_2 <= address_b_2 + 7'd1;
			address_a_0 <= address_a_0 + 7'd1;
			address_b_0 <= address_b_0 + 7'd1;
			
			// Fetch S'[0][0]
			store_SP_buf_1 <= read_data_b_3[15:0];
			
			M2_state <= S_M2_OVERLAP_S_2;
		end
		
		S_M2_OVERLAP_S_2: begin
			// Compute S
			if (S_section_counter == 1'b0) begin
				S_result_buf_2 <= S_result;
			end else if (S_section_counter == 1'b1) begin
				//S2
				S_final_result_buf_2 <= $signed(S_result_buf_2 + S_result);
				write_enable_b_1 <= 1'b1;
			end
			
			S_result <= Mult_result_1 + Mult_result_2 + Mult_result_3 + Mult_result_4; 
			
			address_a_2 <= address_a_2 + 7'd1;
			address_b_2 <= address_b_2 + 7'd1;
			address_a_0 <= address_a_0 + 7'd1;
			address_b_0 <= address_b_0 + 7'd1;
			
			// Fetch S'[0][2]
			store_SP_buf_2 <= read_data_b_3[15:0];
			
			// provide address for new S'[0][2]
			if (Y_read_ctrl == 1'b1) begin
				ci <= ci + 3'd1;
			end else if (U_read_ctrl == 1'b1) begin
				ci <= ci + 3'd1;
			end else if (V_read_ctrl == 1'b1) begin
				ci <= ci + 3'd1;
			end
			write_enable_a_1 <= 1'b1;
			
			M2_state <= S_M2_OVERLAP_S_3;
		end
		
		S_M2_OVERLAP_S_3: begin
			// Compute S
			if (S_section_counter == 1'b0) begin
				S_result_buf_3 <= S_result;
			end else if (S_section_counter == 1'b1) begin
				//S3
				S_final_result_buf_1 <= $signed(S_result_buf_3 + S_result);
				write_data_b_1 <= {16'd0, S_out_0, S_out_1};
				if (address_b_1 != 7'd32) begin
					address_b_1 <= address_b_1 + 7'd1;
				end
				write_enable_b_1 <= 1'b0;
			end
			
			S_result <= Mult_result_1 + Mult_result_2 + Mult_result_3 + Mult_result_4; 
			
			address_a_2 <= address_a_2 + 7'd1;
			address_b_2 <= address_b_2 + 7'd1;
			address_a_0 <= address_a_0 + 7'd1;
			address_b_0 <= address_b_0 + 7'd1;
			
			// write S'[0][0]
			write_data_a_1 <= {store_SP_buf_1, store_SP_buf_2};
			write_enable_a_1 <= 1'b0;
			
			if (S_counter != 7'd0) begin
				address_a_1 <= address_a_1 + 7'd1;
			end
			
			// provide address for new S'[0][3]
			
			address_b_3 <= ram3_read_counter + SP_read_offset;
			ram3_read_counter <= ram3_read_counter + 8'd1;
			
			// reset ci
			if (ci < 3'd7) begin
				ci <= ci + 3'd1;
			end else if (ci == 3'd7) begin
				ci <= 3'd0;
				ri <= ri + 3'd1;
			end
		
			M2_state <= S_M2_OVERLAP_S_4;
		end
		
		S_M2_OVERLAP_S_4: begin
			// Compute S
			if (S_section_counter == 1'b0) begin
				S_result_buf_4 <= S_result;
			end else if (S_section_counter == 1'b1) begin
				//S4
				S_final_result_buf_2 <= $signed(S_result_buf_4 + S_result);
				write_enable_b_1 <= 1'b1;
			end
			
			S_result <= Mult_result_1 + Mult_result_2 + Mult_result_3 + Mult_result_4; 
			
			address_a_2 <= address_a_2 + 7'd1;
			address_b_2 <= address_b_2 + 7'd1;
			address_a_0 <= address_a_0 + 7'd1;
			address_b_0 <= address_b_0 + 7'd1;
			
			//Fetch S'
			address_b_3 <= ram3_read_counter + SP_read_offset;
			ram3_read_counter <= ram3_read_counter + 8'd1;
			
			M2_state <= S_M2_OVERLAP_S_5;
		end
		
		S_M2_OVERLAP_S_5: begin
			if (S_section_counter == 1'b0) begin
				S_result_buf_5 <= S_result;
			end else if (S_section_counter == 1'b1) begin
				//S5
				S_final_result_buf_1 <= $signed(S_result_buf_5 + S_result);
				write_data_b_1 <= {16'd0, S_out_0, S_out_1};
				address_b_1 <= address_b_1 + 7'd1;
				write_enable_b_1 <= 1'b0;
			end
			
			S_result <= Mult_result_1 + Mult_result_2 + Mult_result_3 + Mult_result_4; 
			
			address_a_2 <= address_a_2 + 7'd1;
			address_b_2 <= address_b_2 + 7'd1;
			address_a_0 <= address_a_0 + 7'd1;
			address_b_0 <= address_b_0 + 7'd1;
			
			S_counter <= S_counter + 7'd4;
			
			// Fetch S'[0][2]
			store_SP_buf_1 <= read_data_b_3[15:0];
			
			M2_state <= S_M2_OVERLAP_S_6;
		end
		
		S_M2_OVERLAP_S_6: begin
			if (S_section_counter == 1'b0) begin
				S_result_buf_6 <= S_result;
			end else if (S_section_counter == 1'b1) begin
				//S6
				S_final_result_buf_2 <= $signed(S_result_buf_6 + S_result);
				write_enable_b_1 <= 1'b1;
			end
			
			S_result <= Mult_result_1 + Mult_result_2 + Mult_result_3 + Mult_result_4; 
			
			if (S_counter%7'd8 == 7'd0 && S_counter != 7'd64) begin
				address_a_2 <= 7'd0;
				address_b_2 <= 7'd8;
				address_a_0 <= 7'd0;
				address_b_0 <= 7'd8;
			end else if (S_counter%7'd8 == 7'd4) begin
				address_a_2 <= 7'd16;
				address_b_2 <= 7'd24;
				address_a_0 <= 7'd16;
				address_b_0 <= 7'd24;
			end
			
			// Fetch S'[0][3]
			store_SP_buf_2 <= read_data_b_3[15:0];
			
			// provide address for new S'[0][5]
			if (S_counter < 7'd64) begin
				if (Y_read_ctrl == 1'b1) begin
					ci <= ci + 3'd1;
				end else if (U_read_ctrl == 1'b1) begin
					ci <= ci + 3'd1;
				end else if (V_read_ctrl == 1'b1) begin
					ci <= ci + 3'd1;
				end
			end
			write_enable_a_1 <= 1'b1;
			
			M2_state <= S_M2_OVERLAP_S_7;
		end
		
		S_M2_OVERLAP_S_7: begin
			if (S_section_counter == 1'b0) begin
				S_result_buf_7 <= S_result;
			end else if (S_section_counter == 1'b1) begin
				//S7
				S_final_result_buf_1 <= $signed(S_result_buf_7 + S_result);
				write_data_b_1 <= {16'd0, S_out_0, S_out_1};
				address_b_1 <= address_b_1 + 7'd1;
				write_enable_b_1 <= 1'b0;
			end
			
			S_result <= Mult_result_1 + Mult_result_2 + Mult_result_3 + Mult_result_4; 
			
			C_trans_pos <= C_trans_pos + 4'd1;
			
			if (S_counter != 7'd64) begin
				address_a_2 <= address_a_2 + 7'd1;
				address_b_2 <= address_b_2 + 7'd1;
				address_a_0 <= address_a_0 + 7'd1;
				address_b_0 <= address_b_0 + 7'd1;
			end
			
			// write S'[0][2]
			write_data_a_1 <= {store_SP_buf_1, store_SP_buf_2};
			address_a_1 <= address_a_1 + 7'd1;

			write_enable_a_1 <= 1'b0;
			
			// provide address for new S'[0][4]
			if (S_counter < 7'd64) begin
				if (Y_read_ctrl == 1'b1) begin
					ci <= ci + 3'd1;
				end else if (U_read_ctrl == 1'b1) begin
					ci <= ci + 3'd1;
				end else if (V_read_ctrl == 1'b1) begin
					ci <= ci + 3'd1;
				end
			end
			
			if (S_counter != 7'd64) begin
				address_b_3 <= ram3_read_counter + SP_read_offset;
				ram3_read_counter <= ram3_read_counter + 8'd1;
			end
			
			M2_state <= S_M2_OVERLAP_S_0;
		end
		
		//------------------------Write S---------------------------
		//-----------------Compute T simutaneously------------------
		S_M2_OVERLAP_WRITE_S_WAIT: begin
			write_data_b_1 <= {16'd0, S_out_0, S_out_1};
			address_b_1 <= address_b_1 + 7'd1;

			M2_state <= S_M2_OVERLAP_WRITE_S_WAIT_1;
		end
		
		S_M2_OVERLAP_WRITE_S_WAIT_1: begin
			write_enable_b_1 <= 1'b0;
			
			//Prepare for the next fetch S'
			ram3_read_counter <= 7'd0;
			
			M2_state <= S_M2_OVERLAP_WRITE_S_WAIT_2;
		end
		
		S_M2_OVERLAP_WRITE_S_WAIT_2: begin
			write_enable_a_1 <= 1'b1;
			
			M2_state <= S_M2_OVERLAP_WRITE_S_WAIT_3;
		end
		
		S_M2_OVERLAP_WRITE_S_WAIT_3: begin
			write_enable_a_1 <= 1'b0;
			
			read_add_b_1_in_writeS <= 7'd1;
			address_a_1 <= 7'd0;//to provide S'
			address_b_1 <= 7'd1;//to provide S'
			address_a_0 <= 7'd0;//to store the T_part2 values
			address_a_2 <= 7'd0;//to store the T_part1 values
			
			M2_state <= S_M2_OVERLAP_WRITE_S_WAIT_4;
		end
		
		S_M2_OVERLAP_WRITE_S_WAIT_4: begin
			
			// be ready to read C_trans and T in order to compute S
			compute_T_in_S_buf_1 <= 32'd0;
			compute_T_in_S_buf_2 <= 32'd0;
			C_trans_pos <= 4'd0;
			
			//S_result <= 32'd0;
			S_result_buf_1 <= 32'd0;
			S_result_buf_2 <= 32'd0;
			S_result_buf_3 <= 32'd0;
			S_result_buf_4 <= 32'd0;
			S_result_buf_5 <= 32'd0;
			S_result_buf_6 <= 32'd0;
			S_result_buf_7 <= 32'd0;
			S_result_buf_8 <= 32'd0;
			S_final_result_buf_1 <= 32'd0;
			S_final_result_buf_2 <= 32'd0;
			S_counter <= 6'd0;
			S_section_counter <= 1'b0;
			S_write_counter <= 6'd0;
			
			// Prepare for computing T
			T_result <= 32'd0;
			T_counter <= 7'd0;
			T_compted_counter <= 7'd0;
			T_section_counter <= 1'b0;
			SP_read_counter <= 8'd0;
			C_pos <= 4'd0;
			
			ci <= 3'd0;
			ri <= 3'd0;
			if (Y_read_ctrl == 1'b1) begin
				if (cb < 6'd39) begin
					cb <= cb + 6'd1;
				end else if (cb == 6'd39 && rb < 6'd29) begin
					cb <= 6'd0;
					rb <= rb + 6'd1;
				end else if (cb == 6'd39 && rb == 6'd29) begin
					cb <= 6'd0;
					rb <= 6'd0;
					Y_read_ctrl <= 1'b0;
					U_read_ctrl <= 1'b1;
				end
				Y_write_ctrl <= 1'b1;
				M2_state <= S_M2_OVERLAP_WRITE_S_0;
			end else if (U_read_ctrl == 1'b1) begin
				if (cb < 6'd19) begin
					cb <= cb + 6'd1;
				end else if (cb == 6'd19 && rb < 6'd29) begin
					cb <= 6'd0;
					rb <= rb + 6'd1;
				end else if (cb == 6'd19 && rb == 6'd29) begin
					cb <= 6'd0;
					rb <= 6'd0;
					U_read_ctrl <= 1'b0;
					V_read_ctrl <= 1'b1;
				end
				
				if (cb == 6'd0 && Y_finished == 1'b0) begin
					Y_write_ctrl <= 1'b1;
					Y_finished <= 1'b1;
				end else begin
					U_write_ctrl <= 1'b1;
				end
				M2_state <= S_M2_OVERLAP_WRITE_S_0;
			end else if (V_read_ctrl == 1'b1) begin
				if (cb < 6'd19) begin
					cb <= cb + 6'd1;
				end else if (cb == 6'd19 && rb < 6'd29) begin
					cb <= 6'd0;
					rb <= rb + 6'd1;
				end else if (cb == 6'd19 && rb == 6'd29) begin
					cb <= 6'd0;
					rb <= 6'd0;
					V_read_ctrl <= 1'b0;
				end
				
				if (cb == 6'd0 && U_finished == 1'b0) begin
					U_write_ctrl <= 1'b1;
					U_finished <= 1'b1;
				end else begin
					V_write_ctrl <= 1'b1;
				end
				M2_state <= S_M2_OVERLAP_WRITE_S_0;
			end
		end
		
		S_M2_OVERLAP_WRITE_S_0: begin
			SRAM_we_n<= 1'b1;//enable read
			if (M3_state == S_M3_IDLE_COMMON) begin
				M3_to_M2_ctrl <= 1'b1;
				if (S_write_counter < 7'd32) begin
					address_b_1 <= S_write_counter + 7'd32;
					S_write_counter <= S_write_counter + 1'd1;
				end
			end
			
			// Compute T
			if (T_counter != 7'd64) begin
				if (T_counter != 7'd0 && T_section_counter == 1'b0) begin
					T_result_buf_8 <= T_result;
					T_section_counter <= 1'b1;
					
					if (T_counter == 7'd4 || T_counter == 7'd12 || T_counter == 7'd36 || T_counter == 7'd44) begin
						write_enable_a_2 <= 1'b1;
					end else if (T_counter == 7'd20 || T_counter == 7'd28 || T_counter == 7'd52 || T_counter == 7'd60) begin
						write_enable_a_0 <= 1'b1;
						if (T_counter == 7'd52) begin
							write_enable_a_2 <= 1'b0;
						end
					end
				end else if (T_section_counter == 1'b1) begin
					if (T_counter == 7'd8 || T_counter == 7'd16 || T_counter == 7'd40 || T_counter == 7'd48) begin
						//T8
						write_data_a_2 <= $signed(T_result_buf_8 + T_result) >>>8;
						if (address_a_2 < 7'd31) begin
							address_a_2 <= address_a_2 + 7'd1;
						end
					end else if (T_counter == 7'd24 || T_counter == 7'd32 || T_counter == 7'd56) begin

						write_data_a_0 <= $signed(T_result_buf_8 + T_result) >>>8;
						address_a_0 <= address_a_0 + 7'd1;
					end
					
					T_section_counter <= 1'b0;
				end
				
				compute_T_in_S_buf_1 <= read_data_a_1;
				compute_T_in_S_buf_2 <= read_data_b_1;
				C_pos <= C_pos + 4'd2;
				
				T_result <= Mult_result_1 + Mult_result_2 + Mult_result_3 + Mult_result_4; 
				M2_state <= S_M2_OVERLAP_WRITE_S_1;
			end else if (T_counter == 7'd64) begin
				//T8
				//write_enable_a_0 <= 1'b0;
				write_data_a_0 <= $signed(T_result_buf_8 + T_result) >>>8;
				address_a_0 <= address_a_0 + 7'd1;
				
				//be ready to read C_transpose from MUX
				C_trans_pos <= 4'd0;
				
				T_counter <= 7'd0;
				S_counter <= 7'd0;
				T_section_counter <= 1'b0;
				S_section_counter <= 1'b0;
				S_result_buf_1 <= 32'd0;
				S_result_buf_2 <= 32'd0;
				S_result_buf_3 <= 32'd0; 
				S_result_buf_4 <= 32'd0;
				S_result_buf_5 <= 32'd0;
				S_result_buf_6 <= 32'd0;
				S_result_buf_7 <= 32'd0; 
				S_result_buf_8 <= 32'd0;
				T_compted_counter <= 7'd0;
				S_write_counter <= 7'd0;
				S_write_done <= 1'b0;
				S_done_counter <= 2'd0;
				
				store_SP_buf_1 <= 16'd0;
				store_SP_buf_2 <= 16'd0;
				M3_to_M2_ctrl <= 1'b0;
				
				if (Y_write_ctrl == 1'b1) begin
					ci_write <= 2'd0;
					ri_write <= 2'd0;
					Y_write_ctrl <= 1'b0;
					if (cb_write < 6'd39) begin
						cb_write <= cb_write + 6'd1;
					end else if (cb_write == 6'd39 && rb_write < 6'd29) begin
						cb_write <= 6'd0;
						rb_write <= rb_write + 6'd1;
					end else if (cb_write == 6'd39 && rb_write == 6'd29) begin
						cb_write <= 6'd0;
						rb_write <= 6'd0;
					end
				end else if (U_write_ctrl == 1'b1) begin
					ci_write <= 2'd0;
					ri_write <= 3'd0;
					U_write_ctrl <= 1'b0;
					if (cb_write < 6'd19) begin
						cb_write <= cb_write + 6'd1;
					end else if (cb_write == 6'd19 && rb_write < 6'd29) begin
						cb_write <= 6'd0;
						rb_write <= rb_write + 6'd1;
					end else if (cb_write == 6'd19 && rb_write == 6'd29) begin
						cb_write <= 6'd0;
						rb_write <= 6'd0;
					end
				end else if (V_write_ctrl == 1'b1) begin
					ci_write <= 2'd0;
					ri_write <= 3'd0;
					V_write_ctrl <= 1'b0;
					if ((cb_write < 6'd19 && rb_write < 6'd29) || (cb_write < 6'd18 && rb_write == 6'd29)) begin
						cb_write <= cb_write + 6'd1;
					end else if (cb_write == 6'd19 && rb_write < 6'd29) begin
						cb_write <= 6'd0;
						rb_write <= rb_write + 6'd1;
					end else if (cb_write == 6'd18 && rb_write == 6'd29) begin
						cb_write <= cb_write + 6'd1;
						all_finished <= 1'b1;
					end
				end
				
				//if (M3_done != 1'b1) begin
					M2_state <= S_M2_DELAY_0;
				//end else begin
					//M2_state <= S_M2_WAIT_S_0;
				//end
				
			end
		end
		
		S_M2_OVERLAP_WRITE_S_1: begin
			// Provide address for writing S
			if (M3_state == S_M3_IDLE_COMMON && M3_to_M2_ctrl == 1'b1) begin
				if (S_write_counter < 7'd32) begin
					address_b_1 <= S_write_counter + 7'd32;
					S_write_counter <= S_write_counter + 7'd1;
				end
			end
			
			//Compute T
			if (T_section_counter == 1'b0) begin
				T_result_buf_1 <= T_result;
				if (T_counter == 7'd8 || T_counter == 7'd16 || T_counter == 7'd40) begin
					write_enable_a_2 <= 1'b0;
					address_a_2 <= address_a_2 + 7'd1;
				end else if (T_counter == 7'd24 || T_counter == 7'd32 || T_counter == 7'd56) begin
					write_enable_a_0 <= 1'b0;
					address_a_0 <= address_a_0 + 7'd1;
				end
			end else if (write_enable_a_2 == 1'b1 && T_section_counter == 1'b1) begin
				//T1
				write_data_a_2 <= $signed(T_result_buf_1 + T_result)>>>8;
			end else if (write_enable_a_0 == 1'b1 && T_section_counter == 1'b1) begin
				write_data_a_0 <= $signed(T_result_buf_1 + T_result)>>>8;
			end
			
			T_result <= Mult_result_1 + Mult_result_2 + Mult_result_3 + Mult_result_4; 
			C_pos <= C_pos + 4'd2;
			
			M2_state <= S_M2_OVERLAP_WRITE_S_2;
		end
		
		S_M2_OVERLAP_WRITE_S_2: begin
			//Prepare for writing S
			if (M3_state == S_M3_IDLE_COMMON && M3_to_M2_ctrl == 1'b1) begin
				if (S_write_counter < 7'd32) begin
					address_b_1 <= S_write_counter + 7'd32;
					S_write_counter <= S_write_counter + 7'd1;
				end else if (S_write_counter == 7'd32 && S_done_counter < 2'd2) begin
					SRAM_we_n<= 1'b0;//enable write
					SRAM_write_data <= read_data_b_1[15:0];
					if (Y_write_ctrl == 1'b1) begin
					// provide address for new S'[0][1]
						SRAM_address <= S_write_addr;
					end else if (U_write_ctrl == 1'b1) begin
						SRAM_address <= S_write_addr;
					end else if (V_write_ctrl == 1'b1) begin
						SRAM_address <= S_write_addr;
					end
					S_write_done <= 1'b1;
				end
				
				if (S_write_counter < 7'd32) begin
					SRAM_we_n<= 1'b0;//enable write
					SRAM_write_data <= read_data_b_1[15:0];
					S_write_counter <= S_write_counter + 7'd1;
					address_b_1 <= S_write_counter + 7'd32;
			
					if (Y_write_ctrl == 1'b1) begin
					// provide address for new S'[0][1]
						SRAM_address <= S_write_addr;
					end else if (U_write_ctrl == 1'b1) begin
						SRAM_address <= S_write_addr;
					end else if (V_write_ctrl == 1'b1) begin
						SRAM_address <= S_write_addr;
					end
				end
			
				if (S_write_counter != 7'd0) begin
					if (Y_write_ctrl == 1'b1) begin
						if (ci_write < 2'd3) begin
							ci_write <= ci_write + 3'd1;
						end else if (ci_write == 2'd3 && ri_write < 3'd7) begin
							ci_write <= 2'd0;
							ri_write <= ri_write + 3'd1;
						end
					end else if (U_write_ctrl == 1'b1) begin
						if (ci_write < 2'd3) begin
							ci_write <= ci_write + 2'd1;
						end else if (ci_write == 2'd3 && ri_write < 3'd7) begin
							ci_write <= 2'd0;
							ri_write <= ri_write + 3'd1;
						end 
					end else if (V_write_ctrl == 1'b1) begin
						if (ci_write < 2'd3) begin
							ci_write <= ci_write + 2'd1;
						end else if (ci_write == 2'd3 && ri_write < 3'd7) begin
							ci_write <= 2'd0;
							ri_write <= ri_write + 3'd1;
						end
					end
				end
			end
			
			//Compute T
			if (T_section_counter == 1'b0) begin
				T_result_buf_2 <= T_result;
			end else if (write_enable_a_2 == 1'b1) begin
				//T2
				write_data_a_2 <= $signed(T_result_buf_2 + T_result)>>>8;
				address_a_2 <= address_a_2 + 7'd1;
			end else if (write_enable_a_0 == 1'b1) begin
				write_data_a_0 <= $signed(T_result_buf_2 + T_result)>>>8;
				address_a_0 <= address_a_0 + 7'd1;
			end
		
			T_result <= Mult_result_1 + Mult_result_2 + Mult_result_3 + Mult_result_4; 
			C_pos <= C_pos + 4'd2;
			
			M2_state <= S_M2_OVERLAP_WRITE_S_3;
		end
		
		S_M2_OVERLAP_WRITE_S_3: begin
			//Write S
			//provide address
			if (M3_state == S_M3_IDLE_COMMON && M3_to_M2_ctrl == 1'b1) begin
				if (S_write_done == 1'b1 && S_done_counter < 2'd2) begin
					SRAM_we_n<= 1'b0;//enable write
					S_done_counter <= S_done_counter + 2'd1;
					SRAM_write_data <= read_data_b_1[15:0];
					if (Y_write_ctrl == 1'b1) begin
					// provide address for new S'[0][1]
						SRAM_address <= S_write_addr;
					end else if (U_write_ctrl == 1'b1) begin
						SRAM_address <= S_write_addr;
					end else if (V_write_ctrl == 1'b1) begin
						SRAM_address <= S_write_addr;
					end
				end
			
				if (S_write_done != 1'b1) begin
					SRAM_write_data <= read_data_b_1[15:0];
					S_write_counter <= S_write_counter + 7'd1;
					address_b_1 <= S_write_counter + 7'd32;
			
					if (Y_write_ctrl == 1'b1) begin
						// provide address for new S'[0][1]
						SRAM_address <= S_write_addr;
					end else if (U_write_ctrl == 1'b1) begin
						SRAM_address <= S_write_addr;
					end else if (V_write_ctrl == 1'b1) begin
						SRAM_address <= S_write_addr;
					end
				end
			
				if (S_write_counter != 7'd0) begin
					if (Y_write_ctrl == 1'b1) begin
						if (ci_write < 2'd3) begin
							ci_write <= ci_write + 3'd1;
						end else if (ci_write == 2'd3 && ri_write < 3'd7) begin
							ci_write <= 2'd0;
							ri_write <= ri_write + 3'd1;
						end
					end else if (U_write_ctrl == 1'b1) begin
						if (ci_write < 2'd3) begin
							ci_write <= ci_write + 2'd1;
						end else if (ci_write == 2'd3 && ri_write < 3'd7) begin
							ci_write <= 2'd0;
							ri_write <= ri_write + 3'd1;
						end 
					end else if (V_write_ctrl == 1'b1) begin
						if (ci_write < 2'd3) begin
							ci_write <= ci_write + 2'd1;
						end else if (ci_write == 2'd3 && ri_write < 3'd7) begin
							ci_write <= 2'd0;
							ri_write <= ri_write + 3'd1;
						end
					end
				end
			end
			
			//Compute T
			if (T_section_counter == 1'b0) begin
				T_result_buf_3 <= T_result;
			end else if (write_enable_a_2 == 1'b1) begin
				write_data_a_2 <= $signed(T_result_buf_3 + T_result)>>>8;
				address_a_2 <= address_a_2 + 7'd1;
			end else if (write_enable_a_0 == 1'b1) begin
				write_data_a_0 <= $signed(T_result_buf_3 + T_result)>>>8;
				address_a_0 <= address_a_0 + 7'd1;
			end
			
			T_result <= Mult_result_1 + Mult_result_2 + Mult_result_3 + Mult_result_4; 
			C_pos <= C_pos + 4'd2;
			
			M2_state <= S_M2_OVERLAP_WRITE_S_4;
		end
		
		S_M2_OVERLAP_WRITE_S_4: begin
			//Write S
			if (M3_state == S_M3_IDLE_COMMON && M3_to_M2_ctrl == 1'b1) begin
				if (S_write_done == 1'b1 && S_done_counter < 2'd2) begin
					S_done_counter <= S_done_counter + 2'd1;
					SRAM_we_n<= 1'b1;
				end
			
				if (S_write_done != 1'b1) begin
					SRAM_write_data <= read_data_b_1[15:0];
					S_write_counter <= S_write_counter + 7'd1;
					address_b_1 <= S_write_counter + 7'd32;
				
					if (Y_write_ctrl == 1'b1) begin
						// provide address for new S'[0][1]
						SRAM_address <= S_write_addr;
					end else if (U_write_ctrl == 1'b1) begin
						SRAM_address <= S_write_addr;
					end else if (V_write_ctrl == 1'b1) begin
						SRAM_address <= S_write_addr;
					end
				end
			
				if (S_write_counter != 7'd0) begin
					if (Y_write_ctrl == 1'b1) begin
						if (ci_write < 2'd3) begin
							ci_write <= ci_write + 3'd1;
						end else if (ci_write == 2'd3 && ri_write < 3'd7) begin
							ci_write <= 2'd0;
							ri_write <= ri_write + 3'd1;
						end
					end else if (U_write_ctrl == 1'b1) begin
						if (ci_write < 2'd3) begin
							ci_write <= ci_write + 2'd1;
						end else if (ci_write == 2'd3 && ri_write < 3'd7) begin
							ci_write <= 2'd0;
							ri_write <= ri_write + 3'd1;
						end 
					end else if (V_write_ctrl == 1'b1) begin
						if (ci_write < 2'd3) begin
							ci_write <= ci_write + 2'd1;
						end else if (ci_write == 2'd3 && ri_write < 3'd7) begin
							ci_write <= 2'd0;
							ri_write <= ri_write + 3'd1;
						end
					end
				end
			end
			
			//Compute T
			if (T_section_counter == 1'b0) begin
				T_result_buf_4 <= T_result;
			end else if (write_enable_a_2 == 1'b1) begin
				//T4
				write_data_a_2 <= $signed(T_result_buf_4 + T_result)>>>8;
				address_a_2 <= address_a_2 + 7'd1;
			end else if (write_enable_a_0 == 1'b1) begin
				write_data_a_0 <= $signed(T_result_buf_4 + T_result)>>>8;
				address_a_0 <= address_a_0 + 7'd1;
			end
			
			T_result <= Mult_result_1 + Mult_result_2 + Mult_result_3 + Mult_result_4; 
			C_pos <= C_pos + 4'd2;
			
			M2_state <= S_M2_OVERLAP_WRITE_S_5;
		end
		
		S_M2_OVERLAP_WRITE_S_5: begin
			//Provide address for writing S
			if (M3_state == S_M3_IDLE_COMMON && M3_to_M2_ctrl == 1'b1) begin
				if (S_write_done != 1'b1) begin
					SRAM_write_data <= read_data_b_1[15:0];
					S_write_counter <= S_write_counter + 7'd1;
					address_b_1 <= S_write_counter + 7'd32;
			
					if (Y_write_ctrl == 1'b1) begin
						// provide address for new S'[0][1]
						SRAM_address <= S_write_addr;
					end else if (U_write_ctrl == 1'b1) begin
						SRAM_address <= S_write_addr;
					end else if (V_write_ctrl == 1'b1) begin
						SRAM_address <= S_write_addr;
					end
				end
			
				if (S_write_counter != 7'd0) begin
					if (Y_write_ctrl == 1'b1) begin
						if (ci_write < 2'd3) begin
							ci_write <= ci_write + 3'd1;
						end else if (ci_write == 2'd3 && ri_write < 3'd7) begin
							ci_write <= 2'd0;
							ri_write <= ri_write + 3'd1;
						end
					end else if (U_write_ctrl == 1'b1) begin
						if (ci_write < 2'd3) begin
							ci_write <= ci_write + 2'd1;
						end else if (ci_write == 2'd3 && ri_write < 3'd7) begin
							ci_write <= 2'd0;
							ri_write <= ri_write + 3'd1;
						end 
					end else if (V_write_ctrl == 1'b1) begin
						if (ci_write < 2'd3) begin
							ci_write <= ci_write + 2'd1;
						end else if (ci_write == 2'd3 && ri_write < 3'd7) begin
							ci_write <= 2'd0;
							ri_write <= ri_write + 3'd1;
						end
					end
				end
			end
			
			//Compute T
			if (T_section_counter == 1'b0) begin
				T_result_buf_5 <= T_result;
			end else if (write_enable_a_2 == 1'b1) begin
				//T5
				write_data_a_2 <= $signed(T_result_buf_5 + T_result)>>>8;
				address_a_2 <= address_a_2 + 7'd1;
			end else if (write_enable_a_0 == 1'b1) begin
				write_data_a_0 <= $signed(T_result_buf_5 + T_result)>>>8;
				address_a_0 <= address_a_0 + 7'd1;
			end
			
			T_result <= Mult_result_1 + Mult_result_2 + Mult_result_3 + Mult_result_4; 
			C_pos <= C_pos + 4'd2;
			
			M2_state <= S_M2_OVERLAP_WRITE_S_6;
		end
		
		S_M2_OVERLAP_WRITE_S_6: begin
			// Prepare for writing S
			if (M3_state == S_M3_IDLE_COMMON && M3_to_M2_ctrl == 1'b1) begin
				if (S_write_done != 1'b1) begin
					SRAM_write_data <= read_data_b_1[15:0];
			
					if (Y_write_ctrl == 1'b1) begin
						// provide address for new S'[0][1]
						SRAM_address <= S_write_addr;
					end else if (U_write_ctrl == 1'b1) begin
						SRAM_address <= S_write_addr;
					end else if (V_write_ctrl == 1'b1) begin
						SRAM_address <= S_write_addr;
					end
				end
			
				if (S_write_counter != 7'd0) begin
					if (Y_write_ctrl == 1'b1) begin
						if (ci_write < 2'd3) begin
							ci_write <= ci_write + 3'd1;
						end else if (ci_write == 2'd3 && ri_write < 3'd7) begin
							ci_write <= 2'd0;
							ri_write <= ri_write + 3'd1;
						end
					end else if (U_write_ctrl == 1'b1) begin
						if (ci_write < 2'd3) begin
							ci_write <= ci_write + 2'd1;
						end else if (ci_write == 2'd3 && ri_write < 3'd7) begin
							ci_write <= 2'd0;
							ri_write <= ri_write + 3'd1;
						end 
					end else if (V_write_ctrl == 1'b1) begin
						if (ci_write < 2'd3) begin
							ci_write <= ci_write + 2'd1;
						end else if (ci_write == 2'd3 && ri_write < 3'd7) begin
							ci_write <= 2'd0;
							ri_write <= ri_write + 3'd1;
						end
					end
				end
			end
			
			//Compute T
			if (T_section_counter == 1'b0) begin
				T_result_buf_6 <= T_result;
			end else if (write_enable_a_2 == 1'b1) begin
				//T6
				write_data_a_2 <= $signed(T_result_buf_6 + T_result)>>>8;
				if (address_a_2 < 7'd31) begin
					address_a_2 <= address_a_2 + 7'd1;
				end
			end else if (write_enable_a_0 == 1'b1) begin
				write_data_a_0 <= $signed(T_result_buf_6 + T_result)>>>8;
				if (address_a_0 < 7'd31) begin
				address_a_0 <= address_a_0 + 7'd1;
				end
			end
			
			if (address_a_1 < 7'd30) begin
				address_a_1 <= address_a_1 + 7'd2;
				address_b_1 <= read_add_b_1_in_writeS + 7'd2;
				read_add_b_1_in_writeS <= read_add_b_1_in_writeS + 7'd2;
			end
			
			T_result <= Mult_result_1 + Mult_result_2 + Mult_result_3 + Mult_result_4; 
			C_pos <= C_pos + 4'd2;
			
			M2_state <= S_M2_OVERLAP_WRITE_S_7;
		end
		
		S_M2_OVERLAP_WRITE_S_7: begin
			//Write S
			//provide address
			if (M3_state == S_M3_IDLE_COMMON && M3_to_M2_ctrl == 1'b1) begin
				if (S_done_counter != 2'd2) begin
					SRAM_write_data <= read_data_b_1[15:0];
			
					if (Y_write_ctrl == 1'b1) begin
						// provide address for new S'[0][1]
						SRAM_address <= S_write_addr;
					end else if (U_write_ctrl == 1'b1) begin
						SRAM_address <= S_write_addr;
					end else if (V_write_ctrl == 1'b1) begin
						SRAM_address <= S_write_addr;
					end
				end
			
				if (S_write_counter != 7'd0) begin
					if (Y_write_ctrl == 1'b1) begin
						if (ci_write < 2'd3) begin
							ci_write <= ci_write + 3'd1;
						end else if (ci_write == 2'd3 && ri_write < 3'd7) begin
							ci_write <= 2'd0;
							ri_write <= ri_write + 3'd1;
						end
					end else if (U_write_ctrl == 1'b1) begin
						if (ci_write < 2'd3) begin
							ci_write <= ci_write + 2'd1;
						end else if (ci_write == 2'd3 && ri_write < 3'd7) begin
							ci_write <= 2'd0;
							ri_write <= ri_write + 3'd1;
						end 
					end else if (V_write_ctrl == 1'b1) begin
						if (ci_write < 2'd3) begin
							ci_write <= ci_write + 2'd1;
						end else if (ci_write == 2'd3 && ri_write < 3'd7) begin
							ci_write <= 2'd0;
							ri_write <= ri_write + 3'd1;
						end
					end
				end
			end
			
			//Compute T
			if (T_section_counter == 1'b0) begin
				T_result_buf_7 <= T_result;
				C_pos <= 4'd1;
			end else if (write_enable_a_2 == 1'b1) begin
				//T7
				write_data_a_2 <= $signed(T_result_buf_7 + T_result)>>>8;
				if (address_a_2 < 7'd31) begin
					address_a_2 <= address_a_2 + 7'd1;
				end
				C_pos <= 4'd0;
				T_compted_counter <= T_compted_counter + 7'd8;
			end else if (write_enable_a_0 == 1'b1) begin
				write_data_a_0 <= $signed(T_result_buf_7 + T_result)>>>8;
				if (address_a_0 < 7'd31) begin
					address_a_0 <= address_a_0 + 7'd1;
				end
				C_pos <= 4'd0;
				T_compted_counter <= T_compted_counter + 7'd8;
			end
			
			T_result <= Mult_result_1 + Mult_result_2 + Mult_result_3 + Mult_result_4; 
			T_counter <= T_counter + 7'd4;
			
			M2_state <= S_M2_OVERLAP_WRITE_S_0;
		end
		
		//---------------------------LAST COMPUTE S STATE------------
		S_M2_LO_COMP_S_0: begin
			if (S_counter != 7'd64) begin
				// Compute S
				if (S_counter != 7'd0 && S_section_counter == 1'b0) begin
					S_result_buf_8 <= S_result;
					S_section_counter <= 1'b1;
				end else if (S_section_counter == 1'b1) begin
					//S8
					S_final_result_buf_2 <= $signed(S_result_buf_8 + S_result);
					write_enable_b_1 <= 1'b1;
					
					S_section_counter <= 1'b0;
				end
			
				S_result <= Mult_result_1 + Mult_result_2 + Mult_result_3 + Mult_result_4; 
				
				address_a_2 <= address_a_2 + 7'd1;
				address_b_2 <= address_b_2 + 7'd1;
				address_a_0 <= address_a_0 + 7'd1;
				address_b_0 <= address_b_0 + 7'd1;
				
				Y_write_ctrl <= 1'b0;
				U_write_ctrl <= 1'b0;
				V_write_ctrl <= 1'b0;
				
				M2_state <= S_M2_LO_COMP_S_1;
			end else if (S_counter == 7'd64) begin
				//S4_2
				S_final_result_buf_2 <= $signed(S_result_buf_8 + S_result);
				write_enable_b_1 <= 1'b1;
				
				M2_state <= S_M2_LO_WAIT_WRITE_S_0;	

			end
		end
		
		S_M2_LO_COMP_S_1: begin
			// Compute S
			if (S_section_counter == 1'b0) begin
				if (S_counter != 7'd0) begin
					write_data_b_1 <= {16'd0, S_out_0, S_out_1};
					address_b_1 <= address_b_1 + 7'd1;
					write_enable_b_1 <= 1'b0;
				end
				S_result_buf_1 <= S_result;
			end else	if (S_section_counter == 1'b1) begin
				S_final_result_buf_1 <= $signed(S_result_buf_1 + S_result);
			end
			
			S_result <= Mult_result_1 + Mult_result_2 + Mult_result_3 + Mult_result_4; 
			
			address_a_2 <= address_a_2 + 7'd1;
			address_b_2 <= address_b_2 + 7'd1;
			address_a_0 <= address_a_0 + 7'd1;
			address_b_0 <= address_b_0 + 7'd1;
			
			M2_state <= S_M2_LO_COMP_S_2;
		end
		
		S_M2_LO_COMP_S_2: begin
			// Compute S
			if (S_section_counter == 1'b0) begin
				S_result_buf_2 <= S_result;
			end else if (S_section_counter == 1'b1) begin
				//S2
				S_final_result_buf_2 <= $signed(S_result_buf_2 + S_result);
				write_enable_b_1 <= 1'b1;
			end
			
			S_result <= Mult_result_1 + Mult_result_2 + Mult_result_3 + Mult_result_4; 
			
			address_a_2 <= address_a_2 + 7'd1;
			address_b_2 <= address_b_2 + 7'd1;
			address_a_0 <= address_a_0 + 7'd1;
			address_b_0 <= address_b_0 + 7'd1;
			
			M2_state <= S_M2_LO_COMP_S_3;
		end
		
		S_M2_LO_COMP_S_3: begin
			// Compute S
			if (S_section_counter == 1'b0) begin
				S_result_buf_3 <= S_result;
			end else if (S_section_counter == 1'b1) begin
				//S3
				S_final_result_buf_1 <= $signed(S_result_buf_3 + S_result);
				write_data_b_1 <= {16'd0, S_out_0, S_out_1};
				if (address_b_1 != 7'd32) begin
					address_b_1 <= address_b_1 + 7'd1;
				end
				write_enable_b_1 <= 1'b0;
			end
			
			S_result <= Mult_result_1 + Mult_result_2 + Mult_result_3 + Mult_result_4; 
			
			address_a_2 <= address_a_2 + 7'd1;
			address_b_2 <= address_b_2 + 7'd1;
			address_a_0 <= address_a_0 + 7'd1;
			address_b_0 <= address_b_0 + 7'd1;
			
			if (S_counter != 7'd0) begin
				address_a_1 <= address_a_1 + 7'd1;
			end
			
			M2_state <= S_M2_LO_COMP_S_4;
		end
		
		S_M2_LO_COMP_S_4: begin
			// Compute S
			if (S_section_counter == 1'b0) begin
				S_result_buf_4 <= S_result;
			end else if (S_section_counter == 1'b1) begin
				//S4
				S_final_result_buf_2 <= $signed(S_result_buf_4 + S_result);
				write_enable_b_1 <= 1'b1;
			end
			
			S_result <= Mult_result_1 + Mult_result_2 + Mult_result_3 + Mult_result_4; 
			
			address_a_2 <= address_a_2 + 7'd1;
			address_b_2 <= address_b_2 + 7'd1;
			address_a_0 <= address_a_0 + 7'd1;
			address_b_0 <= address_b_0 + 7'd1;
			
			M2_state <= S_M2_LO_COMP_S_5;
		end
		
		S_M2_LO_COMP_S_5: begin
			if (S_section_counter == 1'b0) begin
				S_result_buf_5 <= S_result;
			end else if (S_section_counter == 1'b1) begin
				//S5
				S_final_result_buf_1 <= $signed(S_result_buf_5 + S_result);
				write_data_b_1 <= {16'd0, S_out_0, S_out_1};
				address_b_1 <= address_b_1 + 7'd1;
				write_enable_b_1 <= 1'b0;
			end
			
			S_result <= Mult_result_1 + Mult_result_2 + Mult_result_3 + Mult_result_4; 
			
			address_a_2 <= address_a_2 + 7'd1;
			address_b_2 <= address_b_2 + 7'd1;
			address_a_0 <= address_a_0 + 7'd1;
			address_b_0 <= address_b_0 + 7'd1;
			
			S_counter <= S_counter + 7'd4;
			
			M2_state <= S_M2_LO_COMP_S_6;
		end
		
		S_M2_LO_COMP_S_6: begin
			if (S_section_counter == 1'b0) begin
				S_result_buf_6 <= S_result;
			end else if (S_section_counter == 1'b1) begin
				//S6
				S_final_result_buf_2 <= $signed(S_result_buf_6 + S_result);
				write_enable_b_1 <= 1'b1;
			end
			
			S_result <= Mult_result_1 + Mult_result_2 + Mult_result_3 + Mult_result_4; 
			
			if (S_counter%7'd8 == 7'd0 && S_counter != 7'd64) begin
				address_a_2 <= 7'd0;
				address_b_2 <= 7'd8;
				address_a_0 <= 7'd0;
				address_b_0 <= 7'd8;
			end else if (S_counter%7'd8 == 7'd4) begin
				address_a_2 <= 7'd16;
				address_b_2 <= 7'd24;
				address_a_0 <= 7'd16;
				address_b_0 <= 7'd24;
			end
			
			M2_state <= S_M2_LO_COMP_S_7;
		end
		
		S_M2_LO_COMP_S_7: begin
			if (S_section_counter == 1'b0) begin
				S_result_buf_7 <= S_result;
			end else if (S_section_counter == 1'b1) begin
				//S7
				S_final_result_buf_1 <= $signed(S_result_buf_7 + S_result);
				write_data_b_1 <= {16'd0, S_out_0, S_out_1};
				address_b_1 <= address_b_1 + 7'd1;
				write_enable_b_1 <= 1'b0;
			end
			
			S_result <= Mult_result_1 + Mult_result_2 + Mult_result_3 + Mult_result_4; 
			
			C_trans_pos <= C_trans_pos + 4'd1;
			
			if (S_counter != 7'd64) begin
				address_a_2 <= address_a_2 + 7'd1;
				address_b_2 <= address_b_2 + 7'd1;
				address_a_0 <= address_a_0 + 7'd1;
				address_b_0 <= address_b_0 + 7'd1;
			end
			
			M2_state <= S_M2_LO_COMP_S_0;
		end
		
		//---------------------------LAST WRITE STATE----------------
		S_M2_LO_WAIT_WRITE_S_0: begin
			write_data_b_1 <= {16'd0, S_out_0, S_out_1};
			address_b_1 <= address_b_1 + 7'd1;
			M2_state <= S_M2_LO_WAIT_WRITE_S_1;
		end
		
		S_M2_LO_WAIT_WRITE_S_1: begin
			write_enable_b_1 <= 1'b0;
			
			// Provide address for writing S
			address_b_1 <= 7'd32;
			S_write_counter <= 6'd1;

			S_counter <= 6'd0;
			ci_write <= 3'd0;
			ri_write <= 3'd0;
			
			V_write_ctrl <= 1'b1;
			M2_state <= S_M2_LO_WAIT_WRITE_S_2;
		end
		
		S_M2_LO_WAIT_WRITE_S_2: begin
			address_b_1 <= address_b_1 + 7'd1;
			M2_state <= S_M2_LO_WRITE_S_0;
		end
		
		S_M2_LO_WRITE_S_0: begin
			ci_write <= ci_write + 2'd1;

			//Write S
			//provide address
			SRAM_we_n<= 1'b0;//enable write
			SRAM_write_data <= read_data_b_1[15:0];
			SRAM_address <= S_write_addr;
			
			M2_state <= S_M2_LO_WRITE_S_1;
			if (address_b_1 < 7'd63 ) begin
				address_b_1 <= address_b_1 + 7'd1;
			end
		
		end
		
		S_M2_LO_WRITE_S_1: begin
			//Write S
			//provide address
			SRAM_we_n<= 1'b0;//enable write
			SRAM_write_data <= read_data_b_1[15:0];
			
			if (ci_write < 2'd3) begin
				ci_write <= ci_write + 2'd1;
			end else if (ci_write == 2'd3 && ri_write < 3'd7) begin
				ci_write <= 2'd0;
				ri_write <= ri_write + 3'd1;
			end
			
			SRAM_address <= S_write_addr;
			
			if (address_b_1 < 7'd63) begin
				address_b_1 <= address_b_1 + 7'd1;
				M2_state <= S_M2_LO_WRITE_S_0;
			end else if (address_b_1 == 7'd63) begin
				M2_finish <= 1'b1;
				M2_state <= S_M2_IDLE;
			end
			
		end

		default: M2_state<=S_M2_IDLE;
		endcase	
		
		//--------------------------------------------------------
		//---------------------------------M3---------------------
		//--------------------------------------------------------
		case (M3_state)
			S_M3_IDLE_COMMON: begin
				if (M3_enable == 1'b1) begin
					SRAM_we_n <= 1'b1;
					SP_write_offset_ctrl <= ~SP_write_offset_ctrl;
					M3_state <= S_M3_LI_COMMON_0;
					write_enable_a_3 <= 1'b1;
					M3_done <= 1'b0;
				end
			end
			
			S_M3_LI_COMMON_0: begin
				z_pos <= z_pos + 7'd1;
				if (z_pos < 7'd63) begin
					write_enable_a_3 <= 1'b1;//enable write
					address_a_3 <= z_addr + SP_write_offset;
					write_data_a_3 <= 32'd0;
				end else if (z_pos == 7'd63) begin
					address_a_3 <= z_addr + SP_write_offset;
					write_data_a_3 <= 32'd0;
					z_pos <= 7'd0;
					M3_state <= S_M3_FIRST_2BITS_COMMON_0;
				end
				
			end
			
			S_M3_FIRST_2BITS_COMMON_0: begin
				first_2bits <= BIST_read_buf[31:30];
				M3_state <= S_M3_FIRST_2BITS_COMMON_1;
			end
			
			S_M3_FIRST_2BITS_COMMON_1: begin
				case (first_2bits)
					
					2'b00: begin
						if (Q_selected == 1'b0) begin
							if (Q0_read == 7'd8) begin
								write_data_a_3 <= {{10{BIST_read_buf[29]}}, BIST_read_buf[29:27], 3'd0};
							end
							if (Q0_read == 7'd4) begin
								write_data_a_3 <= {{11{BIST_read_buf[29]}}, BIST_read_buf[29:27], 2'd0};
							end
							if (Q0_read == 7'd16) begin
								write_data_a_3 <= {{9{BIST_read_buf[29]}}, BIST_read_buf[29:27], 4'd0};
							end
							if (Q0_read == 7'd32) begin
								write_data_a_3 <= {{8{BIST_read_buf[29]}}, BIST_read_buf[29:27], 5'd0};
							end
							if (Q0_read == 7'd64) begin
								write_data_a_3 <= {{7{BIST_read_buf[29]}}, BIST_read_buf[29:27], 6'd0};
							end
						end else if (Q_selected == 1'b1) begin
							if (Q1_read == 7'd8) begin
								write_data_a_3 <= {{10{BIST_read_buf[29]}}, BIST_read_buf[29:27], 3'd0};
							end
							if (Q1_read == 7'd4) begin
								write_data_a_3 <= {{11{BIST_read_buf[29]}}, BIST_read_buf[29:27], 2'd0};
							end
							if (Q1_read == 7'd16) begin
								write_data_a_3 <= {{9{BIST_read_buf[29]}}, BIST_read_buf[29:27], 4'd0};
							end
							if (Q1_read == 7'd32) begin
								write_data_a_3 <= {{8{BIST_read_buf[29]}}, BIST_read_buf[29:27], 5'd0};
							end
							if (Q1_read == 7'd2) begin
								write_data_a_3 <= {{12{BIST_read_buf[29]}}, BIST_read_buf[29:27], 1'd0};
							end
						end
						address_a_3 <= z_addr + SP_write_offset;
						z_pos <= z_pos + 7'd1;
						Q_pos <= Q_pos + 6'd1;
						
						bits_left <= bits_left - 6'd5;
						shift_bits <= shift_bits + 5'd5;
						
					end
					
					2'b01: begin
						if (Q_selected == 1'b0) begin
							if (Q0_read == 7'd8) begin
								write_data_a_3 <= {{10{BIST_read_buf[29]}}, BIST_read_buf[29:27], 3'd0};
							end
							if (Q0_read == 7'd4) begin
								write_data_a_3 <= {{11{BIST_read_buf[29]}}, BIST_read_buf[29:27], 2'd0};
							end
							if (Q0_read == 7'd16) begin
								write_data_a_3 <= {{9{BIST_read_buf[29]}}, BIST_read_buf[29:27], 4'd0};
							end
							if (Q0_read == 7'd32) begin
								write_data_a_3 <= {{8{BIST_read_buf[29]}}, BIST_read_buf[29:27], 5'd0};
							end
							if (Q0_read == 7'd64) begin
								write_data_a_3 <= {{7{BIST_read_buf[29]}}, BIST_read_buf[29:27], 6'd0};
							end
						end else if (Q_selected == 1'b1) begin
							if (Q1_read == 7'd8) begin
								write_data_a_3 <= {{10{BIST_read_buf[29]}}, BIST_read_buf[29:27], 3'd0};
							end
							if (Q1_read == 7'd4) begin
								write_data_a_3 <= {{11{BIST_read_buf[29]}}, BIST_read_buf[29:27], 2'd0};
							end
							if (Q1_read == 7'd16) begin
								write_data_a_3 <= {{9{BIST_read_buf[29]}}, BIST_read_buf[29:27], 4'd0};
							end
							if (Q1_read == 7'd32) begin
								write_data_a_3 <= {{8{BIST_read_buf[29]}}, BIST_read_buf[29:27], 5'd0};
							end
							if (Q1_read == 7'd2) begin
								write_data_a_3 <= {{12{BIST_read_buf[29]}}, BIST_read_buf[29:27], 1'd0};
							end
						end
						address_a_3 <= z_addr + SP_write_offset;
						z_pos <= z_pos + 7'd1;
						Q_pos <= Q_pos + 6'd1;
						bits_left <= bits_left - 6'd5;
						shift_bits <= shift_bits + 5'd5;

					end
					
					2'b10: begin
						if (BIST_read_buf[29] == 1'b0) begin
							if (Q_selected == 1'b0) begin
								if (Q0_read == 7'd8) begin
									write_data_a_3 <= {{7{BIST_read_buf[28]}}, BIST_read_buf[28:23], 3'd0};
								end
								if (Q0_read == 7'd4) begin
									write_data_a_3 <= {{8{BIST_read_buf[28]}}, BIST_read_buf[28:23], 2'd0};
								end
								if (Q0_read == 7'd16) begin
									write_data_a_3 <= {{6{BIST_read_buf[28]}}, BIST_read_buf[28:23], 4'd0};
								end
								if (Q0_read == 7'd32) begin
									write_data_a_3 <= {{5{BIST_read_buf[28]}}, BIST_read_buf[28:23], 5'd0};
								end
								if (Q0_read == 7'd64) begin
									write_data_a_3 <= {{4{BIST_read_buf[28]}}, BIST_read_buf[28:23], 6'd0};
								end
							end else if (Q_selected == 1'b1) begin
								if (Q1_read == 7'd8) begin
									write_data_a_3 <= {{7{BIST_read_buf[28]}}, BIST_read_buf[28:23], 3'd0};
								end
								if (Q1_read == 7'd4) begin
									write_data_a_3 <= {{8{BIST_read_buf[28]}}, BIST_read_buf[28:23], 2'd0};
								end
								if (Q1_read == 7'd16) begin
									write_data_a_3 <= {{6{BIST_read_buf[28]}}, BIST_read_buf[28:23], 4'd0};
								end
								if (Q1_read == 7'd32) begin
									write_data_a_3 <= {{5{BIST_read_buf[28]}}, BIST_read_buf[28:23], 5'd0};
								end
								if (Q1_read == 7'd2) begin
									write_data_a_3 <= {{9{BIST_read_buf[28]}}, BIST_read_buf[28:23], 1'd0};
								end
							end
							
							address_a_3 <= z_addr + SP_write_offset;
							z_pos <= z_pos + 7'd1;
							Q_pos <= Q_pos + 6'd1;
							bits_left <= bits_left - 6'd9;
							shift_bits <= shift_bits + 5'd9;
							
						end else if (BIST_read_buf[29] == 1'b1) begin
							
							if (BIST_read_buf[28] == 1'b0) begin
								bits_left <= bits_left - 6'd4;
								shift_bits <= shift_bits + 5'd4;
								z_pos <= 7'd64;
							end else begin
								if (Q_selected == 1'b0) begin
									if (Q0_read == 7'd8) begin
										write_data_a_3 <= {{4{BIST_read_buf[27]}}, BIST_read_buf[27:19], 3'd0};
									end
									if (Q0_read == 7'd4) begin
										write_data_a_3 <= {{5{BIST_read_buf[27]}}, BIST_read_buf[27:19], 2'd0};
									end
									if (Q0_read == 7'd16) begin
										write_data_a_3 <= {{3{BIST_read_buf[27]}}, BIST_read_buf[27:19], 4'd0};
									end
									if (Q0_read == 7'd32) begin
										write_data_a_3 <= {{2{BIST_read_buf[27]}}, BIST_read_buf[27:19], 5'd0};
									end
									if (Q0_read == 7'd64) begin
										write_data_a_3 <= {{1{BIST_read_buf[27]}}, BIST_read_buf[27:19], 6'd0};
									end
								end else if (Q_selected == 1'b1) begin
									if (Q1_read == 7'd8) begin
										write_data_a_3 <= {{4{BIST_read_buf[27]}}, BIST_read_buf[27:19], 3'd0};
									end
									if (Q1_read == 7'd4) begin
										write_data_a_3 <= {{5{BIST_read_buf[27]}}, BIST_read_buf[27:19], 2'd0};
									end
									if (Q1_read == 7'd16) begin
										write_data_a_3 <= {{3{BIST_read_buf[27]}}, BIST_read_buf[27:19], 4'd0};
									end
									if (Q1_read == 7'd32) begin
										write_data_a_3 <= {{2{BIST_read_buf[27]}}, BIST_read_buf[27:19], 5'd0};
									end
									if (Q1_read == 7'd2) begin
										write_data_a_3 <= {{6{BIST_read_buf[27]}}, BIST_read_buf[27:19], 1'd0};
									end
								end
								
								address_a_3 <= z_addr + SP_write_offset;
								z_pos <= z_pos + 7'd1;
								Q_pos <= Q_pos + 6'd1;
								bits_left <= bits_left - 6'd13;
								shift_bits <= shift_bits + 5'd13;

							end
						end
					end
					
					2'b11: begin
						if (BIST_read_buf[29:27] == 3'b0) begin
							//write 8 zeroes, so skip 8 numbers
							z_pos <= z_pos + 7'd8;
							Q_pos <= Q_pos + 6'd8;
						end else if (BIST_read_buf[29:27] != 3'b0) begin
							z_pos <= z_pos + {4'd0, BIST_read_buf[29:27]};
							Q_pos <= Q_pos + {3'd0, BIST_read_buf[29:27]};
						end
						bits_left <= bits_left - 6'd5;
						shift_bits <= shift_bits + 5'd5;
					end
					
				endcase
				
				if (first_2bits == 2'b00) begin
					M3_state <= S_M3_READ_3_BITS_COMMON;
				end else begin
					M3_state <= S_M3_SHIFT_BITS_COMMON;
				end

			end
			
			S_M3_READ_3_BITS_COMMON: begin
				if (Q_selected == 1'b0) begin
					if (Q0_read == 7'd8) begin
						write_data_a_3 <= {{26{BIST_read_buf[26]}}, BIST_read_buf[26:24], 3'd0};
					end
					if (Q0_read == 7'd4) begin
						write_data_a_3 <= {{27{BIST_read_buf[26]}}, BIST_read_buf[26:24], 2'd0};
					end
					if (Q0_read == 7'd16) begin
						write_data_a_3 <= {{25{BIST_read_buf[26]}}, BIST_read_buf[26:24], 4'd0};
					end
					if (Q0_read == 7'd32) begin
						write_data_a_3 <= {{24{BIST_read_buf[26]}}, BIST_read_buf[26:24], 5'd0};
					end
					if (Q0_read == 7'd64) begin
						write_data_a_3 <= {{23{BIST_read_buf[26]}}, BIST_read_buf[26:24], 6'd0};
					end
				end else if (Q_selected == 1'b1) begin
					if (Q1_read == 7'd8) begin
						write_data_a_3 <= {{26{BIST_read_buf[26]}}, BIST_read_buf[26:24], 3'd0};
					end
					if (Q1_read == 7'd4) begin
						write_data_a_3 <= {{27{BIST_read_buf[26]}}, BIST_read_buf[26:24], 2'd0};
					end
					if (Q1_read == 7'd16) begin
						write_data_a_3 <= {{25{BIST_read_buf[26]}}, BIST_read_buf[26:24], 4'd0};
					end
					if (Q1_read == 7'd32) begin
						write_data_a_3 <= {{24{BIST_read_buf[26]}}, BIST_read_buf[26:24], 5'd0};
					end
					if (Q1_read == 7'd2) begin
						write_data_a_3 <= {{28{BIST_read_buf[26]}}, BIST_read_buf[26:24], 1'd0};
					end
				end
				address_a_3 <= z_addr + SP_write_offset;
				z_pos <= z_pos + 7'd1;
				Q_pos <= Q_pos + 6'd1;
				bits_left <= bits_left - 6'd3;
				shift_bits <= shift_bits + 5'd3;
				M3_state <= S_M3_SHIFT_BITS_COMMON;
			end
			
			S_M3_SHIFT_BITS_COMMON: begin
				if (bits_left > 6'd16) begin
					case (shift_bits)
						5'd1: BIST_read_buf <= {BIST_read_buf[30:0], 1'd0};
						5'd2: BIST_read_buf <= {BIST_read_buf[29:0], 2'd0};
						5'd3: BIST_read_buf <= {BIST_read_buf[28:0], 3'd0};
						5'd4: BIST_read_buf <= {BIST_read_buf[27:0], 4'd0};
						5'd5: BIST_read_buf <= {BIST_read_buf[26:0], 5'd0};
						5'd6: BIST_read_buf <= {BIST_read_buf[25:0], 6'd0};
						5'd7: BIST_read_buf <= {BIST_read_buf[24:0], 7'd0};
						5'd8: BIST_read_buf <= {BIST_read_buf[23:0], 8'd0};
						5'd9: BIST_read_buf <= {BIST_read_buf[22:0], 9'd0};
						5'd10: BIST_read_buf <= {BIST_read_buf[21:0], 10'd0};
						5'd11: BIST_read_buf <= {BIST_read_buf[20:0], 11'd0};
						5'd12: BIST_read_buf <= {BIST_read_buf[19:0], 12'd0};
						5'd13: BIST_read_buf <= {BIST_read_buf[18:0], 13'd0};
						5'd14: BIST_read_buf <= {BIST_read_buf[17:0], 14'd0};
						5'd15: BIST_read_buf <= {BIST_read_buf[16:0], 15'd0};
						5'd16: BIST_read_buf <= {BIST_read_buf[15:0], 16'd0};
					endcase
					
					shift_bits <= 5'd0;
					if (z_pos == 7'd64) begin
						z_pos <= 7'd0;
						Q_pos <= 6'd0;
						M3_enable <= 1'b0;
						M3_done <= 1'b1;
						M3_state <= S_M3_IDLE_COMMON;
					end else begin
						M3_state <= S_M3_FIRST_2BITS_COMMON_0;
					end
				end
				
				if (bits_left <= 6'd16) begin
					SRAM_we_n <= 1'b1;
					
					BIST_read_counter <= BIST_read_counter + 7'd1;
					
					if (BIST_read_counter < 7'd1) begin
						SRAM_address <= SRAM_BIST_addr + BIST_OFFSET;
						SRAM_BIST_addr <= SRAM_BIST_addr + 17'd1;
					end
					
					if (BIST_read_counter == 7'd2) begin
						case (shift_bits)
							5'd1: BIST_read_buf <= {BIST_read_buf[30:0], 1'd0};
							5'd2: BIST_read_buf <= {BIST_read_buf[29:0], 2'd0};
							5'd3: BIST_read_buf <= {BIST_read_buf[28:0], 3'd0};
							5'd4: BIST_read_buf <= {BIST_read_buf[27:0], 4'd0};
							5'd5: BIST_read_buf <= {BIST_read_buf[26:0], 5'd0};
							5'd6: BIST_read_buf <= {BIST_read_buf[25:0], 6'd0};
							5'd7: BIST_read_buf <= {BIST_read_buf[24:0], 7'd0};
							5'd8: BIST_read_buf <= {BIST_read_buf[23:0], 8'd0};
							5'd9: BIST_read_buf <= {BIST_read_buf[22:0], 9'd0};
							5'd10: BIST_read_buf <= {BIST_read_buf[21:0], 10'd0};
							5'd11: BIST_read_buf <= {BIST_read_buf[20:0], 11'd0};
							5'd12: BIST_read_buf <= {BIST_read_buf[19:0], 12'd0};
							5'd13: BIST_read_buf <= {BIST_read_buf[18:0], 13'd0};
							5'd14: BIST_read_buf <= {BIST_read_buf[17:0], 14'd0};
							5'd15: BIST_read_buf <= {BIST_read_buf[16:0], 15'd0};
							5'd16: BIST_read_buf <= {BIST_read_buf[15:0], 16'd0};
						endcase
						shift_bits <= 5'd0;
					end
					
					if (BIST_read_counter == 7'd3) begin
						case (bits_left)
							6'd0: BIST_read_buf[31:16] <= SRAM_read_data;
							6'd1: BIST_read_buf[30:15] <= SRAM_read_data;
							6'd2: BIST_read_buf[29:14] <= SRAM_read_data;
							6'd3: BIST_read_buf[28:13] <= SRAM_read_data;
							6'd4: BIST_read_buf[27:12] <= SRAM_read_data;
							6'd5: BIST_read_buf[26:11] <= SRAM_read_data;
							6'd6: BIST_read_buf[25:10] <= SRAM_read_data;
							6'd7: BIST_read_buf[24:9] <= SRAM_read_data;
							6'd8: BIST_read_buf[23:8] <= SRAM_read_data;
							6'd9: BIST_read_buf[22:7] <= SRAM_read_data;
							6'd10: BIST_read_buf[21:6] <= SRAM_read_data;
							6'd11: BIST_read_buf[20:5] <= SRAM_read_data;
							6'd12: BIST_read_buf[19:4] <= SRAM_read_data;
							6'd13: BIST_read_buf[18:3] <= SRAM_read_data;
							6'd14: BIST_read_buf[17:2] <= SRAM_read_data;
							6'd15: BIST_read_buf[16:1] <= SRAM_read_data;
							6'd16: BIST_read_buf[15:0] <= SRAM_read_data;
						endcase
						
						bits_left <= bits_left + 6'd16;
						BIST_read_counter <= 7'd0;
						
						if (z_pos == 7'd64) begin
							z_pos <= 7'd0;
							Q_pos <= 6'd0;
							M3_enable <= 1'b0;
							write_enable_a_3 <= 1'b0;
							M3_state <= S_M3_IDLE_COMMON;
							M3_done <= 1'b1;
						end else begin
							M3_state <= S_M3_FIRST_2BITS_COMMON_0;
						end
					end
				end
			end
			
			endcase	
			
	end
end

endmodule