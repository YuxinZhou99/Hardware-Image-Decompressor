# activate waveform simulation

view wave

# format signal names in waveform

configure wave -signalnamewidth 1
configure wave -timeline 0
configure wave -timelineunits us

# add signals to waveform

add wave -divider -height 20 {Top-level signals}
add wave -bin UUT/CLOCK_50_I
add wave -bin UUT/resetn
add wave UUT/top_state
add wave -uns UUT/UART_timer

add wave -divider -height 10 {SRAM signals}
add wave -uns UUT/SRAM_address
add wave -bin {UUT/milestone2_unit/write_enable_b_1}
add wave -decimal {UUT/milestone2_unit/S_final_result_buf_1}
add wave -decimal {UUT/milestone2_unit/S_final_result_buf_2}
add wave -decimal {UUT/milestone2_unit/S_result}
add wave -decimal {UUT/milestone2_unit/read_data_b_1}
add wave -decimal {UUT/milestone2_unit/write_data_b_1}

add wave -decimal {UUT/milestone2_unit/S_result}
add wave -decimal {UUT/milestone2_unit/S_result_buf_1}
add wave -decimal {UUT/milestone2_unit/S_result_buf_2}
add wave -decimal {UUT/milestone2_unit/S_result_buf_3}
add wave -decimal {UUT/milestone2_unit/S_result_buf_4}
add wave -decimal {UUT/milestone2_unit/S_result_buf_5}
add wave -decimal {UUT/milestone2_unit/S_result_buf_6}
add wave -decimal {UUT/milestone2_unit/S_result_buf_7}
add wave -decimal {UUT/milestone2_unit/S_result_buf_8}

# format signal names in waveform

configure wave -signalnamewidth 1
configure wave -timeline 0
configure wave -timelineunits us

# add signals to waveform

add wave -divider -height 20 {Top-level signals}
add wave -bin UUT/CLOCK_50_I
add wave -bin UUT/resetn
add wave UUT/top_state
add wave -uns UUT/UART_timer

add wave -divider -height 10 {SRAM signals}
add wave -uns UUT/SRAM_address
add wave -hex UUT/SRAM_write_data
add wave -bin UUT/SRAM_we_n
add wave -hex UUT/SRAM_read_data

add wave -divider -height 10 {VGA signals}
add wave -bin UUT/VGA_unit/VGA_HSYNC_O
add wave -bin UUT/VGA_unit/VGA_VSYNC_O
add wave -uns UUT/VGA_unit/pixel_X_pos
add wave -uns UUT/VGA_unit/pixel_Y_pos
add wave -hex UUT/VGA_unit/VGA_red
add wave -hex UUT/VGA_unit/VGA_green
add wave -hex UUT/VGA_unit/VGA_blue

add wave -divider -height 10 {M3}
add wave -decimal {UUT/milestone2_unit/S_write_done}
add wave -decimal {UUT/milestone2_unit/S_done_counter}
add wave -decimal {UUT/milestone2_unit/M3_to_M2_ctrl}
add wave -decimal {UUT/milestone2_unit/M2_state}
add wave -decimal {UUT/milestone2_unit/M3_state}
add wave -decimal {UUT/milestone2_unit/M2_enable}
add wave -decimal {UUT/milestone2_unit/M3_enable}
add wave -decimal {UUT/milestone2_unit/M2_finish}
add wave -bin {UUT/milestone2_unit/first_2bits}
add wave -decimal {UUT/milestone2_unit/zero_counter}
add wave -decimal {UUT/milestone2_unit/z_pos}
add wave -decimal {UUT/milestone2_unit/Q_pos}

add wave -decimal {UUT/milestone2_unit/bits_left}
add wave -decimal {UUT/milestone2_unit/shift_bits}

add wave -decimal {UUT/milestone2_unit/Q_selected}
add wave -decimal {UUT/milestone2_unit/BIST_read_counter}
add wave -decimal {UUT/milestone2_unit/Q_selected}
add wave -decimal -unsigned {UUT/milestone2_unit/address_a_3}
add wave -decimal {UUT/milestone2_unit/write_data_a_3}
add wave -decimal {UUT/milestone2_unit/read_data_a_3}
add wave -decimal {UUT/milestone2_unit/write_enable_a_3}
add wave -decimal -unsigned {UUT/milestone2_unit/address_b_3}
add wave -decimal {UUT/milestone2_unit/write_data_b_3}
add wave -decimal {UUT/milestone2_unit/read_data_b_3}
add wave -decimal {UUT/milestone2_unit/write_enable_b_3}
add wave -decimal {UUT/milestone2_unit/SRAM_BIST_addr}
add wave -decimal {UUT/milestone2_unit/ram3_read_counter}

add wave -decimal {UUT/milestone2_unit/SP_read_counter}
add wave -decimal {UUT/milestone2_unit/SP_read_offset}
add wave -decimal {UUT/milestone2_unit/SP_read_offset_ctrl}
add wave -decimal {UUT/milestone2_unit/SP_write_offset}
add wave -decimal {UUT/milestone2_unit/SP_write_offset_ctrl}

add wave -bin {UUT/milestone2_unit/BIST_read_buf}
add wave -decimal {UUT/milestone2_unit/write_data_a_buf_1}

# add wave -hex UUT/milestone1_unit/R_out
# add wave -hex UUT/milestone1_unit/G_out
# add wave -hex UUT/milestone1_unit/B_out

# add wave UUT/milestone1_unit/M1_state
# add wave UUT/milestone1_unit/Mul_result_1
# add wave UUT/milestone1_unit/Mul_result_2
# add wave UUT/milestone1_unit/Mul_result_3
# add wave UUT/milestone1_unit/Mul_result_4
# add wave -divider -height 10 {}
# add wave UUT/M2_finish
add wave -decimal {UUT/milestone2_unit/SP_read_addr}
add wave -decimal {UUT/milestone2_unit/S_counter}
add wave -decimal {UUT/milestone2_unit/S_section_counter}
add wave -hex {UUT/milestone2_unit/C_read_data}
add wave -divider -height 10 {}
# add wave -decimal {UUT/milestone2_unit/C_pos}
add wave -decimal {UUT/milestone2_unit/C_trans_pos}
# add wave -decimal UUT/milestone2_unit/T_counter
# add wave -decimal {UUT/milestone2_unit/T_section_counter}
# add wave -divider -height 10 {}

add wave -decimal {UUT/milestone2_unit/M2_state}
add wave -decimal {UUT/milestone2_unit/zero_counter}
add wave -decimal {UUT/milestone2_unit/write_enable_a_3}
add wave -decimal {UUT/milestone2_unit/write_enable_b_3}
add wave -decimal -unsigned {UUT/milestone2_unit/address_a_3}
add wave -decimal {UUT/milestone2_unit/write_data_a_3}
add wave -decimal {UUT/milestone2_unit/read_data_a_3}
add wave -decimal -unsigned {UUT/milestone2_unit/address_b_3}
add wave -decimal {UUT/milestone2_unit/write_data_b_3}
add wave -decimal {UUT/milestone2_unit/read_data_b_3}
add wave -hex {UUT/milestone2_unit/read_data_b_1}
add wave -decimal {UUT/milestone2_unit/address_b_1}
add wave -hex {UUT/milestone2_unit/write_data_b_1}
add wave -decimal {UUT/milestone2_unit/store_SP_buf_1}
add wave -decimal {UUT/milestone2_unit/store_SP_buf_2}
add wave -decimal {UUT/milestone2_unit/compute_T_in_S_buf_1[15:0]}
add wave -decimal {UUT/milestone2_unit/compute_T_in_S_buf_1[31:16]}
add wave -decimal {UUT/milestone2_unit/compute_T_in_S_buf_1[15:0]}
add wave -decimal {UUT/milestone2_unit/compute_T_in_S_buf_2[31:16]}
add wave -decimal {UUT/milestone2_unit/compute_T_in_S_buf_2[15:0]}
add wave -uns UUT/SRAM_address
add wave -hex UUT/SRAM_write_data
add wave -bin UUT/SRAM_we_n
add wave -decimal {UUT/milestone2_unit/op_col_1}
add wave -decimal {UUT/milestone2_unit/op_col_2}
add wave -decimal {UUT/milestone2_unit/op_col_3}
add wave -decimal {UUT/milestone2_unit/op_col_4}

add wave -decimal {UUT/milestone2_unit/op_row_1}
add wave -decimal {UUT/milestone2_unit/op_row_2}
add wave -decimal {UUT/milestone2_unit/op_row_3}
add wave -decimal {UUT/milestone2_unit/op_row_4}
add wave -decimal {UUT/milestone2_unit/op_col_T1}
add wave -decimal {UUT/milestone2_unit/op_col_T2}
add wave -decimal {UUT/milestone2_unit/op_col_T3}
add wave -decimal {UUT/milestone2_unit/op_col_T4}

add wave -decimal {UUT/milestone2_unit/S_write_counter}

# add wave -divider -height 10 {}
# add wave -decimal {UUT/milestone2_unit/SP_read_addr}
# add wave -decimal {UUT/milestone2_unit/S_counter}
# add wave -decimal {UUT/milestone2_unit/S_section_counter}

# add wave -uns UUT/SRAM_address
# add wave -hex UUT/SRAM_write_data
# add wave -bin UUT/SRAM_we_n
# add wave -hex UUT/SRAM_read_data
add wave -hex {UUT/milestone2_unit/write_data_a_1}
add wave -hex {UUT/milestone2_unit/read_data_a_1}
add wave -decimal {UUT/milestone2_unit/address_a_1}
# add wave -hex {UUT/milestone2_unit/read_data_b_1}
# add wave -decimal {UUT/milestone2_unit/address_b_1}
# add wave -hex {UUT/milestone2_unit/write_data_b_1}
# add wave -hex {UUT/milestone2_unit/compute_T_in_S_buf_1}
# add wave -hex {UUT/milestone2_unit/compute_T_in_S_buf_2}
# add wave UUT/milestone2_unit/M2_state
# add wave -hex {UUT/milestone2_unit/S_write_counter}
# add wave -hex {UUT/milestone2_unit/all_finished}
# add wave -hex {UUT/milestone2_unit/S_write_addr}
add wave -decimal -unsigned {UUT/milestone2_unit/ci}
add wave -decimal -unsigned {UUT/milestone2_unit/ri}
add wave -decimal -unsigned {UUT/milestone2_unit/cb}
add wave -decimal -unsigned {UUT/milestone2_unit/rb}
add wave -decimal -unsigned {UUT/milestone2_unit/ci_write}
add wave -decimal -unsigned {UUT/milestone2_unit/ri_write}
add wave -decimal -unsigned {UUT/milestone2_unit/cb_write}
add wave -decimal -unsigned {UUT/milestone2_unit/rb_write}
add wave -decimal {UUT/milestone2_unit/Y_write_ctrl}
add wave -decimal {UUT/milestone2_unit/U_write_ctrl}
add wave -decimal {UUT/milestone2_unit/V_write_ctrl}
# add wave -decimal {UUT/milestone2_unit/Y_write_addr}
# add wave -decimal {UUT/milestone2_unit/U_write_addr}
# add wave -decimal {UUT/milestone2_unit/V_write_addr}
# add wave -decimal {UUT/milestone2_unit/Y_read_ctrl}
# add wave -decimal {UUT/milestone2_unit/U_read_ctrl}
# add wave -decimal {UUT/milestone2_unit/V_read_ctrl}
# add wave -decimal {UUT/milestone2_unit/Y_read_addr}
# add wave -decimal {UUT/milestone2_unit/U_read_addr}
# add wave -decimal {UUT/milestone2_unit/V_read_addr}
# add wave -decimal {UUT/milestone2_unit/T_result_buf_1}
# add wave -decimal {UUT/milestone2_unit/T_result_buf_2}
# add wave -decimal {UUT/milestone2_unit/T_result_buf_3}
# add wave -decimal {UUT/milestone2_unit/T_result_buf_4}
# add wave -decimal {UUT/milestone2_unit/T_result_buf_5}
# add wave -decimal {UUT/milestone2_unit/T_result_buf_6}
# add wave -decimal {UUT/milestone2_unit/T_result_buf_7}
# add wave -decimal {UUT/milestone2_unit/T_result_buf_8}
# add wave -decimal {UUT/milestone2_unit/T_result}
add wave -decimal {UUT/milestone2_unit/address_a_0}
add wave -bin {UUT/milestone2_unit/write_enable_a_0}
add wave -decimal {UUT/milestone2_unit/write_data_a_0}
add wave -decimal {UUT/milestone2_unit/address_a_2}
add wave -bin {UUT/milestone2_unit/write_enable_a_2}
add wave -decimal {UUT/milestone2_unit/write_data_a_2}
# add wave -bin {UUT/milestone2_unit/write_enable_a_1}
# add wave -decimal {UUT/milestone2_unit/test}

add wave -decimal {UUT/milestone2_unit/store_SP_buf_1}
add wave -decimal {UUT/milestone2_unit/store_SP_buf_2}

# add wave -decimal {UUT/milestone2_unit/write_data_a_buf_1}
# add wave -decimal UUT/SRAM_read_data
# add wave -hex UUT/SRAM_write_data
# add wave -decimal {UUT/milestone2_unit/S_write_addr}
# add wave -decimal {UUT/milestone2_unit/Y_write_ctrl}
# add wave -decimal {UUT/milestone2_unit/U_write_ctrl}
# add wave -decimal {UUT/milestone2_unit/V_write_ctrl}
# add wave -decimal {UUT/milestone2_unit/Y_write_addr}
# add wave -decimal {UUT/milestone2_unit/U_write_addr}
# add wave -decimal {UUT/milestone2_unit/V_write_addr}

# add wave -decimal {UUT/milestone2_unit/S_write_counter}
# add wave -decimal {UUT/milestone2_unit/read_data_a_1}
# add wave -decimal {UUT/milestone2_unit/S_final_result_buf_1}
# add wave -decimal {UUT/milestone2_unit/S_final_result_buf_2}
# add wave -decimal {UUT/milestone2_unit/S_result}
# add wave -decimal {UUT/milestone2_unit/address_a_0}
# add wave -decimal {UUT/milestone2_unit/address_b_0}
# add wave -decimal {UUT/milestone2_unit/address_a_2}
# add wave -decimal {UUT/milestone2_unit/address_b_2}
# add wave -decimal {UUT/milestone2_unit/read_data_a_0}
# add wave -decimal {UUT/milestone2_unit/write_data_a_0}
# add wave -decimal {UUT/milestone2_unit/read_data_b_0}
# add wave -decimal {UUT/milestone2_unit/read_data_a_2}
# add wave -decimal {UUT/milestone2_unit/write_data_a_2}
# add wave -decimal {UUT/milestone2_unit/read_data_b_2}

# add wave -divider -height 10 {}
# add wave -decimal {UUT/milestone2_unit/S_result}
# add wave -decimal {UUT/milestone2_unit/S_result_buf_1}
# add wave -decimal {UUT/milestone2_unit/S_result_buf_2}
# add wave -decimal {UUT/milestone2_unit/S_result_buf_3}
# add wave -decimal {UUT/milestone2_unit/S_result_buf_4}
# add wave -decimal {UUT/milestone2_unit/S_result_buf_5}
# add wave -decimal {UUT/milestone2_unit/S_result_buf_6}
# add wave -decimal {UUT/milestone2_unit/S_result_buf_7}
# add wave -decimal {UUT/milestone2_unit/S_result_buf_8}

# add wave -divider -height 10 {}
# add wave -decimal {UUT/milestone2_unit/Mult_op_1}
# add wave -decimal {UUT/milestone2_unit/Mult_op_2}
# add wave -decimal {UUT/milestone2_unit/Mult_op_3}
# add wave -decimal {UUT/milestone2_unit/Mult_op_4}
# add wave -decimal {UUT/milestone2_unit/Mult_op_5}
# add wave -decimal {UUT/milestone2_unit/Mult_op_6}
# add wave -decimal {UUT/milestone2_unit/Mult_op_7}
# add wave -decimal {UUT/milestone2_unit/Mult_op_8}
# add wave -decimal {UUT/milestone2_unit/Mult_result_1}
# add wave -decimal {UUT/milestone2_unit/Mult_result_2}
# add wave -decimal {UUT/milestone2_unit/Mult_result_3}
# add wave -decimal {UUT/milestone2_unit/Mult_result_4}

# add wave -divider -height 10 {}
# add wave -decimal {UUT/milestone2_unit/T_result_buf_1}
# add wave -decimal {UUT/milestone2_unit/T_result_buf_2}
# add wave -decimal {UUT/milestone2_unit/T_result_buf_3}
# add wave -decimal {UUT/milestone2_unit/T_result_buf_4}
# add wave -decimal {UUT/milestone2_unit/T_result_buf_5}
# add wave -decimal {UUT/milestone2_unit/T_result_buf_6}
# add wave -decimal {UUT/milestone2_unit/T_result_buf_7}
# add wave -decimal {UUT/milestone2_unit/T_result_buf_8}
# add wave -decimal {UUT/milestone2_unit/T_result}

# add wave -divider -height 10 {}
# add wave -hex {UUT/milestone2_unit/S_final_result_buf_1}
# add wave -hex {UUT/milestone2_unit/S_final_result_buf_2}
# add wave -decimal {UUT/milestone2_unit/address_a_0}
# add wave -decimal {UUT/milestone2_unit/address_b_0}
# add wave -decimal {UUT/milestone2_unit/address_a_1}
# add wave -decimal {UUT/milestone2_unit/address_b_1}
# add wave -decimal {UUT/milestone2_unit/address_a_2}
# add wave -decimal {UUT/milestone2_unit/address_b_2}
# add wave -divider -height 10 {}

# add wave -hex {UUT/milestone2_unit/test}
# add wave -decimal {UUT/milestone2_unit/SP_read_counter}
# add wave -decimal -unsigned {UUT/milestone2_unit/sample_counter}
# add wave -decimal -unsigned {UUT/milestone2_unit/ci}
# add wave -decimal -unsigned {UUT/milestone2_unit/ri}
# add wave -decimal -unsigned {UUT/milestone2_unit/SRAM_read_data}
# add wave -divider -height 10 {}
# add wave -bin {UUT/milestone2_unit/write_enable_a_0}
# add wave -decimal {UUT/milestone2_unit/read_data_a_0}
# add wave -decimal {UUT/milestone2_unit/write_data_a_0}
# add wave -divider -height 10 {}
# add wave -bin {UUT/milestone2_unit/write_enable_b_0}
# add wave -decimal {UUT/milestone2_unit/read_data_b_0}
# add wave -decimal {UUT/milestone2_unit/write_data_b_0}
# add wave -divider -height 10 {}
# add wave -bin {UUT/milestone2_unit/write_enable_a_1}
# add wave -decimal {UUT/milestone2_unit/test}
# add wave -decimal {UUT/milestone2_unit/write_data_a_1}
# add wave -decimal {UUT/milestone2_unit/write_data_a_buf_1}
# add wave -decimal UUT/SRAM_read_data

# add wave -divider -height 10 {}
# add wave -bin {UUT/milestone2_unit/write_enable_b_1}
# add wave -decimal {UUT/milestone2_unit/read_data_b_1}
# add wave -decimal {UUT/milestone2_unit/write_data_b_1}
# add wave -divider -height 10 {}
# add wave -bin {UUT/milestone2_unit/write_enable_a_2}
# add wave -decimal {UUT/milestone2_unit/read_data_a_2}
# add wave -decimal {UUT/milestone2_unit/write_data_a_2}
# add wave -divider -height 10 {}
# add wave -bin {UUT/milestone2_unit/write_enable_b_2}
# add wave -decimal {UUT/milestone2_unit/read_data_b_2}
# add wave -decimal {UUT/milestone2_unit/write_data_b_2}
# add wave -divider -height 10 {}
