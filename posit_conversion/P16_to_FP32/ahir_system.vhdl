-- VHDL produced by vc2vhdl from virtual circuit (vc) description 
library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library aHiR_ieee_proposed;
use aHiR_ieee_proposed.math_utility_pkg.all;
use aHiR_ieee_proposed.fixed_pkg.all;
use aHiR_ieee_proposed.float_pkg.all;
library ahir;
use ahir.memory_subsystem_package.all;
use ahir.types.all;
use ahir.subprograms.all;
use ahir.components.all;
use ahir.basecomponents.all;
use ahir.operatorpackage.all;
use ahir.floatoperatorpackage.all;
use ahir.utilities.all;
library work;
use work.ahir_system_global_package.all;
entity Posit16_to_FP32 is -- 
  generic (tag_length : integer); 
  port ( -- 
    P : in  std_logic_vector(15 downto 0);
    F : out  std_logic_vector(31 downto 0);
    tag_in: in std_logic_vector(tag_length-1 downto 0);
    tag_out: out std_logic_vector(tag_length-1 downto 0) ;
    clk : in std_logic;
    reset : in std_logic;
    start_req : in std_logic;
    start_ack : out std_logic;
    fin_req : in std_logic;
    fin_ack   : out std_logic-- 
  );
  -- 
end entity Posit16_to_FP32;
architecture Posit16_to_FP32_arch of Posit16_to_FP32 is -- 
  -- always true...
  signal always_true_symbol: Boolean;
  signal in_buffer_data_in, in_buffer_data_out: std_logic_vector((tag_length + 16)-1 downto 0);
  signal default_zero_sig: std_logic;
  signal in_buffer_write_req: std_logic;
  signal in_buffer_write_ack: std_logic;
  signal in_buffer_unload_req_symbol: Boolean;
  signal in_buffer_unload_ack_symbol: Boolean;
  signal out_buffer_data_in, out_buffer_data_out: std_logic_vector((tag_length + 32)-1 downto 0);
  signal out_buffer_read_req: std_logic;
  signal out_buffer_read_ack: std_logic;
  signal out_buffer_write_req_symbol: Boolean;
  signal out_buffer_write_ack_symbol: Boolean;
  signal tag_ub_out, tag_ilock_out: std_logic_vector(tag_length-1 downto 0);
  signal tag_push_req, tag_push_ack, tag_pop_req, tag_pop_ack: std_logic;
  signal tag_unload_req_symbol, tag_unload_ack_symbol, tag_write_req_symbol, tag_write_ack_symbol: Boolean;
  signal tag_ilock_write_req_symbol, tag_ilock_write_ack_symbol, tag_ilock_read_req_symbol, tag_ilock_read_ack_symbol: Boolean;
  signal start_req_sig, fin_req_sig, start_ack_sig, fin_ack_sig: std_logic; 
  signal input_sample_reenable_symbol: Boolean;
  -- input port buffer signals
  signal P_buffer :  std_logic_vector(15 downto 0);
  signal P_update_enable: Boolean;
  -- output port buffer signals
  signal F_buffer :  std_logic_vector(31 downto 0);
  signal F_update_enable: Boolean;
  signal Posit16_to_FP32_CP_24_start: Boolean;
  signal Posit16_to_FP32_CP_24_symbol: Boolean;
  -- volatile/operator module components. 
  component classify_posit_Volatile is -- 
    port ( -- 
      num : in  std_logic_vector(15 downto 0);
      zero : out  std_logic_vector(0 downto 0);
      normal : out  std_logic_vector(0 downto 0);
      inf : out  std_logic_vector(0 downto 0)-- 
    );
    -- 
  end component; 
  component split_posit_Volatile is -- 
    port ( -- 
      num : in  std_logic_vector(15 downto 0);
      sign : out  std_logic_vector(0 downto 0);
      exp : out  std_logic_vector(5 downto 0);
      fraction : out  std_logic_vector(11 downto 0)-- 
    );
    -- 
  end component; 
  component complement_Volatile is -- 
    port ( -- 
      num : in  std_logic_vector(15 downto 0);
      result : out  std_logic_vector(15 downto 0)-- 
    );
    -- 
  end component; 
  -- links between control-path and data-path
  signal MUX_461_inst_req_0 : boolean;
  signal MUX_461_inst_ack_0 : boolean;
  signal MUX_461_inst_req_1 : boolean;
  signal MUX_461_inst_ack_1 : boolean;
  -- 
begin --  
  -- input handling ------------------------------------------------
  in_buffer: UnloadBuffer -- 
    generic map(name => "Posit16_to_FP32_input_buffer", -- 
      buffer_size => 1,
      bypass_flag => false,
      data_width => tag_length + 16) -- 
    port map(write_req => in_buffer_write_req, -- 
      write_ack => in_buffer_write_ack, 
      write_data => in_buffer_data_in,
      unload_req => in_buffer_unload_req_symbol, 
      unload_ack => in_buffer_unload_ack_symbol, 
      read_data => in_buffer_data_out,
      clk => clk, reset => reset); -- 
  in_buffer_data_in(15 downto 0) <= P;
  P_buffer <= in_buffer_data_out(15 downto 0);
  in_buffer_data_in(tag_length + 15 downto 16) <= tag_in;
  tag_ub_out <= in_buffer_data_out(tag_length + 15 downto 16);
  in_buffer_write_req <= start_req;
  start_ack <= in_buffer_write_ack;
  in_buffer_unload_req_symbol_join: block -- 
    constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
    constant place_markings: IntegerArray(0 to 1)  := (0 => 1,1 => 1);
    constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 1);
    constant joinName: string(1 to 32) := "in_buffer_unload_req_symbol_join"; 
    signal preds: BooleanArray(1 to 2); -- 
  begin -- 
    preds <= in_buffer_unload_ack_symbol & input_sample_reenable_symbol;
    gj_in_buffer_unload_req_symbol_join : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
      port map(preds => preds, symbol_out => in_buffer_unload_req_symbol, clk => clk, reset => reset); --
  end block;
  -- join of all unload_ack_symbols.. used to trigger CP.
  Posit16_to_FP32_CP_24_start <= in_buffer_unload_ack_symbol;
  -- output handling  -------------------------------------------------------
  out_buffer: ReceiveBuffer -- 
    generic map(name => "Posit16_to_FP32_out_buffer", -- 
      buffer_size => 1,
      full_rate => false,
      data_width => tag_length + 32) --
    port map(write_req => out_buffer_write_req_symbol, -- 
      write_ack => out_buffer_write_ack_symbol, 
      write_data => out_buffer_data_in,
      read_req => out_buffer_read_req, 
      read_ack => out_buffer_read_ack, 
      read_data => out_buffer_data_out,
      clk => clk, reset => reset); -- 
  out_buffer_data_in(31 downto 0) <= F_buffer;
  F <= out_buffer_data_out(31 downto 0);
  out_buffer_data_in(tag_length + 31 downto 32) <= tag_ilock_out;
  tag_out <= out_buffer_data_out(tag_length + 31 downto 32);
  out_buffer_write_req_symbol_join: block -- 
    constant place_capacities: IntegerArray(0 to 2) := (0 => 1,1 => 1,2 => 1);
    constant place_markings: IntegerArray(0 to 2)  := (0 => 0,1 => 1,2 => 0);
    constant place_delays: IntegerArray(0 to 2) := (0 => 0,1 => 1,2 => 0);
    constant joinName: string(1 to 32) := "out_buffer_write_req_symbol_join"; 
    signal preds: BooleanArray(1 to 3); -- 
  begin -- 
    preds <= Posit16_to_FP32_CP_24_symbol & out_buffer_write_ack_symbol & tag_ilock_read_ack_symbol;
    gj_out_buffer_write_req_symbol_join : generic_join generic map(name => joinName, number_of_predecessors => 3, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
      port map(preds => preds, symbol_out => out_buffer_write_req_symbol, clk => clk, reset => reset); --
  end block;
  -- write-to output-buffer produces  reenable input sampling
  input_sample_reenable_symbol <= out_buffer_write_ack_symbol;
  -- fin-req/ack level protocol..
  out_buffer_read_req <= fin_req;
  fin_ack <= out_buffer_read_ack;
  ----- tag-queue --------------------------------------------------
  -- interlock buffer for TAG.. to provide required buffering.
  tagIlock: InterlockBuffer -- 
    generic map(name => "tag-interlock-buffer", -- 
      buffer_size => 1,
      bypass_flag => false,
      in_data_width => tag_length,
      out_data_width => tag_length) -- 
    port map(write_req => tag_ilock_write_req_symbol, -- 
      write_ack => tag_ilock_write_ack_symbol, 
      write_data => tag_ub_out,
      read_req => tag_ilock_read_req_symbol, 
      read_ack => tag_ilock_read_ack_symbol, 
      read_data => tag_ilock_out, 
      clk => clk, reset => reset); -- 
  -- tag ilock-buffer control logic. 
  tag_ilock_write_req_symbol_join: block -- 
    constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
    constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
    constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 1);
    constant joinName: string(1 to 31) := "tag_ilock_write_req_symbol_join"; 
    signal preds: BooleanArray(1 to 2); -- 
  begin -- 
    preds <= Posit16_to_FP32_CP_24_start & tag_ilock_write_ack_symbol;
    gj_tag_ilock_write_req_symbol_join : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
      port map(preds => preds, symbol_out => tag_ilock_write_req_symbol, clk => clk, reset => reset); --
  end block;
  tag_ilock_read_req_symbol_join: block -- 
    constant place_capacities: IntegerArray(0 to 2) := (0 => 1,1 => 1,2 => 1);
    constant place_markings: IntegerArray(0 to 2)  := (0 => 0,1 => 1,2 => 1);
    constant place_delays: IntegerArray(0 to 2) := (0 => 0,1 => 0,2 => 0);
    constant joinName: string(1 to 30) := "tag_ilock_read_req_symbol_join"; 
    signal preds: BooleanArray(1 to 3); -- 
  begin -- 
    preds <= Posit16_to_FP32_CP_24_start & tag_ilock_read_ack_symbol & out_buffer_write_ack_symbol;
    gj_tag_ilock_read_req_symbol_join : generic_join generic map(name => joinName, number_of_predecessors => 3, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
      port map(preds => preds, symbol_out => tag_ilock_read_req_symbol, clk => clk, reset => reset); --
  end block;
  -- the control path --------------------------------------------------
  always_true_symbol <= true; 
  default_zero_sig <= '0';
  Posit16_to_FP32_CP_24: Block -- control-path 
    signal Posit16_to_FP32_CP_24_elements: BooleanArray(2 downto 0);
    -- 
  begin -- 
    Posit16_to_FP32_CP_24_elements(0) <= Posit16_to_FP32_CP_24_start;
    Posit16_to_FP32_CP_24_symbol <= Posit16_to_FP32_CP_24_elements(2);
    -- CP-element group 0:  fork  transition  output  bypass 
    -- CP-element group 0: predecessors 
    -- CP-element group 0: successors 
    -- CP-element group 0: 	1 
    -- CP-element group 0: 	2 
    -- CP-element group 0:  members (8) 
      -- CP-element group 0: 	 $entry
      -- CP-element group 0: 	 call_stmt_402_to_assign_stmt_462/$entry
      -- CP-element group 0: 	 call_stmt_402_to_assign_stmt_462/MUX_461_sample_start_
      -- CP-element group 0: 	 call_stmt_402_to_assign_stmt_462/MUX_461_update_start_
      -- CP-element group 0: 	 call_stmt_402_to_assign_stmt_462/MUX_461_start/$entry
      -- CP-element group 0: 	 call_stmt_402_to_assign_stmt_462/MUX_461_start/req
      -- CP-element group 0: 	 call_stmt_402_to_assign_stmt_462/MUX_461_complete/$entry
      -- CP-element group 0: 	 call_stmt_402_to_assign_stmt_462/MUX_461_complete/req
      -- 
    req_42_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_42_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => Posit16_to_FP32_CP_24_elements(0), ack => MUX_461_inst_req_1); -- 
    req_37_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_37_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => Posit16_to_FP32_CP_24_elements(0), ack => MUX_461_inst_req_0); -- 
    -- CP-element group 1:  transition  input  bypass 
    -- CP-element group 1: predecessors 
    -- CP-element group 1: 	0 
    -- CP-element group 1: successors 
    -- CP-element group 1:  members (3) 
      -- CP-element group 1: 	 call_stmt_402_to_assign_stmt_462/MUX_461_sample_completed_
      -- CP-element group 1: 	 call_stmt_402_to_assign_stmt_462/MUX_461_start/$exit
      -- CP-element group 1: 	 call_stmt_402_to_assign_stmt_462/MUX_461_start/ack
      -- 
    ack_38_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 1_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => MUX_461_inst_ack_0, ack => Posit16_to_FP32_CP_24_elements(1)); -- 
    -- CP-element group 2:  transition  input  bypass 
    -- CP-element group 2: predecessors 
    -- CP-element group 2: 	0 
    -- CP-element group 2: successors 
    -- CP-element group 2:  members (5) 
      -- CP-element group 2: 	 $exit
      -- CP-element group 2: 	 call_stmt_402_to_assign_stmt_462/$exit
      -- CP-element group 2: 	 call_stmt_402_to_assign_stmt_462/MUX_461_update_completed_
      -- CP-element group 2: 	 call_stmt_402_to_assign_stmt_462/MUX_461_complete/$exit
      -- CP-element group 2: 	 call_stmt_402_to_assign_stmt_462/MUX_461_complete/ack
      -- 
    ack_43_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 2_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => MUX_461_inst_ack_1, ack => Posit16_to_FP32_CP_24_elements(2)); -- 
    --  hookup: inputs to control-path 
    -- hookup: output from control-path 
    -- 
  end Block; -- control-path
  -- the data path
  data_path: Block -- 
    signal CONCAT_u1_u9_447_wire : std_logic_vector(8 downto 0);
    signal CONCAT_u1_u9_453_wire : std_logic_vector(8 downto 0);
    signal CONCAT_u9_u32_449_wire : std_logic_vector(31 downto 0);
    signal CONCAT_u9_u32_455_wire : std_logic_vector(31 downto 0);
    signal MUX_456_wire : std_logic_vector(31 downto 0);
    signal MUX_460_wire : std_logic_vector(31 downto 0);
    signal P_c_410 : std_logic_vector(15 downto 0);
    signal R_INF_32_459_wire_constant : std_logic_vector(31 downto 0);
    signal R_ZERO_32_458_wire_constant : std_logic_vector(31 downto 0);
    signal exp_32_421 : std_logic_vector(7 downto 0);
    signal exp_32_c_434 : std_logic_vector(7 downto 0);
    signal exp_407 : std_logic_vector(5 downto 0);
    signal exp_c_415 : std_logic_vector(5 downto 0);
    signal frac_32_428 : std_logic_vector(22 downto 0);
    signal frac_32_c_440 : std_logic_vector(22 downto 0);
    signal fraction_407 : std_logic_vector(11 downto 0);
    signal fraction_c_415 : std_logic_vector(11 downto 0);
    signal inf_402 : std_logic_vector(0 downto 0);
    signal konst_417_wire_constant : std_logic_vector(7 downto 0);
    signal konst_432_wire_constant : std_logic_vector(7 downto 0);
    signal normal_402 : std_logic_vector(0 downto 0);
    signal sign_407 : std_logic_vector(0 downto 0);
    signal sign_c_415 : std_logic_vector(0 downto 0);
    signal type_cast_419_wire : std_logic_vector(7 downto 0);
    signal type_cast_426_wire_constant : std_logic_vector(10 downto 0);
    signal type_cast_431_wire : std_logic_vector(7 downto 0);
    signal type_cast_438_wire_constant : std_logic_vector(10 downto 0);
    signal type_cast_445_wire_constant : std_logic_vector(0 downto 0);
    signal type_cast_451_wire_constant : std_logic_vector(0 downto 0);
    signal xxPosit16_to_FP32xxINF_32 : std_logic_vector(31 downto 0);
    signal xxPosit16_to_FP32xxZERO_32 : std_logic_vector(31 downto 0);
    signal zero_402 : std_logic_vector(0 downto 0);
    -- 
  begin -- 
    R_INF_32_459_wire_constant <= "11011111000000000000000000000000";
    R_ZERO_32_458_wire_constant <= "01011111000000000000000000000000";
    konst_417_wire_constant <= "01100011";
    konst_432_wire_constant <= "01100011";
    type_cast_426_wire_constant <= "00000000000";
    type_cast_438_wire_constant <= "00000000000";
    type_cast_445_wire_constant <= "1";
    type_cast_451_wire_constant <= "0";
    xxPosit16_to_FP32xxINF_32 <= "11011111000000000000000000000000";
    xxPosit16_to_FP32xxZERO_32 <= "01011111000000000000000000000000";
    -- flow-through select operator MUX_456_inst
    MUX_456_wire <= CONCAT_u9_u32_449_wire when (sign_407(0) /=  '0') else CONCAT_u9_u32_455_wire;
    -- flow-through select operator MUX_460_inst
    MUX_460_wire <= R_ZERO_32_458_wire_constant when (zero_402(0) /=  '0') else R_INF_32_459_wire_constant;
    MUX_461_inst_block : block -- 
      signal sample_req, sample_ack, update_req, update_ack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      sample_req(0) <= MUX_461_inst_req_0;
      MUX_461_inst_ack_0<= sample_ack(0);
      update_req(0) <= MUX_461_inst_req_1;
      MUX_461_inst_ack_1<= update_ack(0);
      MUX_461_inst: SelectSplitProtocol generic map(name => "MUX_461_inst", data_width => 32, buffering => 1, flow_through => false, full_rate => false) -- 
        port map( x => MUX_456_wire, y => MUX_460_wire, sel => normal_402, z => F_buffer, sample_req => sample_req(0), sample_ack => sample_ack(0), update_req => update_req(0), update_ack => update_ack(0), clk => clk, reset => reset); -- 
      -- 
    end block;
    -- interlock type_cast_419_inst
    process(exp_407) -- 
      variable tmp_var : std_logic_vector(7 downto 0); -- 
    begin -- 
      tmp_var := (others => '0'); 
      tmp_var( 5 downto 0) := exp_407(5 downto 0);
      type_cast_419_wire <= tmp_var; -- 
    end process;
    -- interlock type_cast_431_inst
    process(exp_c_415) -- 
      variable tmp_var : std_logic_vector(7 downto 0); -- 
    begin -- 
      tmp_var := (others => '0'); 
      tmp_var( 5 downto 0) := exp_c_415(5 downto 0);
      type_cast_431_wire <= tmp_var; -- 
    end process;
    -- binary operator ADD_u8_u8_420_inst
    process(type_cast_419_wire) -- 
      variable tmp_var : std_logic_vector(7 downto 0); -- 
    begin -- 
      ApIntAdd_proc(type_cast_419_wire, konst_417_wire_constant, tmp_var);
      exp_32_421 <= tmp_var; --
    end process;
    -- binary operator ADD_u8_u8_433_inst
    process(type_cast_431_wire) -- 
      variable tmp_var : std_logic_vector(7 downto 0); -- 
    begin -- 
      ApIntAdd_proc(type_cast_431_wire, konst_432_wire_constant, tmp_var);
      exp_32_c_434 <= tmp_var; --
    end process;
    -- binary operator CONCAT_u12_u23_427_inst
    process(fraction_407) -- 
      variable tmp_var : std_logic_vector(22 downto 0); -- 
    begin -- 
      ApConcat_proc(fraction_407, type_cast_426_wire_constant, tmp_var);
      frac_32_428 <= tmp_var; --
    end process;
    -- binary operator CONCAT_u12_u23_439_inst
    process(fraction_c_415) -- 
      variable tmp_var : std_logic_vector(22 downto 0); -- 
    begin -- 
      ApConcat_proc(fraction_c_415, type_cast_438_wire_constant, tmp_var);
      frac_32_c_440 <= tmp_var; --
    end process;
    -- binary operator CONCAT_u1_u9_447_inst
    process(type_cast_445_wire_constant, exp_32_c_434) -- 
      variable tmp_var : std_logic_vector(8 downto 0); -- 
    begin -- 
      ApConcat_proc(type_cast_445_wire_constant, exp_32_c_434, tmp_var);
      CONCAT_u1_u9_447_wire <= tmp_var; --
    end process;
    -- binary operator CONCAT_u1_u9_453_inst
    process(type_cast_451_wire_constant, exp_32_421) -- 
      variable tmp_var : std_logic_vector(8 downto 0); -- 
    begin -- 
      ApConcat_proc(type_cast_451_wire_constant, exp_32_421, tmp_var);
      CONCAT_u1_u9_453_wire <= tmp_var; --
    end process;
    -- binary operator CONCAT_u9_u32_449_inst
    process(CONCAT_u1_u9_447_wire, frac_32_c_440) -- 
      variable tmp_var : std_logic_vector(31 downto 0); -- 
    begin -- 
      ApConcat_proc(CONCAT_u1_u9_447_wire, frac_32_c_440, tmp_var);
      CONCAT_u9_u32_449_wire <= tmp_var; --
    end process;
    -- binary operator CONCAT_u9_u32_455_inst
    process(CONCAT_u1_u9_453_wire, frac_32_428) -- 
      variable tmp_var : std_logic_vector(31 downto 0); -- 
    begin -- 
      ApConcat_proc(CONCAT_u1_u9_453_wire, frac_32_428, tmp_var);
      CONCAT_u9_u32_455_wire <= tmp_var; --
    end process;
    volatile_operator_classify_posit_393: classify_posit_Volatile port map(num => P_buffer, zero => zero_402, normal => normal_402, inf => inf_402); 
    volatile_operator_split_posit_394: split_posit_Volatile port map(num => P_buffer, sign => sign_407, exp => exp_407, fraction => fraction_407); 
    volatile_operator_complement_395: complement_Volatile port map(num => P_buffer, result => P_c_410); 
    volatile_operator_split_posit_396: split_posit_Volatile port map(num => P_c_410, sign => sign_c_415, exp => exp_c_415, fraction => fraction_c_415); 
    -- 
  end Block; -- data_path
  -- 
end Posit16_to_FP32_arch;
library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library aHiR_ieee_proposed;
use aHiR_ieee_proposed.math_utility_pkg.all;
use aHiR_ieee_proposed.fixed_pkg.all;
use aHiR_ieee_proposed.float_pkg.all;
library ahir;
use ahir.memory_subsystem_package.all;
use ahir.types.all;
use ahir.subprograms.all;
use ahir.components.all;
use ahir.basecomponents.all;
use ahir.operatorpackage.all;
use ahir.floatoperatorpackage.all;
use ahir.utilities.all;
library work;
use work.ahir_system_global_package.all;
entity classify_posit_Volatile is -- 
  port ( -- 
    num : in  std_logic_vector(15 downto 0);
    zero : out  std_logic_vector(0 downto 0);
    normal : out  std_logic_vector(0 downto 0);
    inf : out  std_logic_vector(0 downto 0)-- 
  );
  -- 
end entity classify_posit_Volatile;
architecture classify_posit_Volatile_arch of classify_posit_Volatile is -- 
  -- always true...
  signal always_true_symbol: Boolean;
  signal in_buffer_data_in, in_buffer_data_out: std_logic_vector(16-1 downto 0);
  signal default_zero_sig: std_logic;
  -- input port buffer signals
  signal num_buffer :  std_logic_vector(15 downto 0);
  -- output port buffer signals
  signal zero_buffer :  std_logic_vector(0 downto 0);
  signal normal_buffer :  std_logic_vector(0 downto 0);
  signal inf_buffer :  std_logic_vector(0 downto 0);
  -- volatile/operator module components. 
  -- 
begin --  
  -- input handling ------------------------------------------------
  num_buffer <= num;
  -- output handling  -------------------------------------------------------
  zero <= zero_buffer;
  normal <= normal_buffer;
  inf <= inf_buffer;
  -- the control path --------------------------------------------------
  default_zero_sig <= '0';
  -- volatile module, no control path
  -- the data path
  data_path: Block -- 
    signal BITSEL_u16_u1_21_wire : std_logic_vector(0 downto 0);
    signal BITSEL_u16_u1_29_wire : std_logic_vector(0 downto 0);
    signal NOT_u1_u1_22_wire : std_logic_vector(0 downto 0);
    signal exp_all_zero_13 : std_logic_vector(0 downto 0);
    signal konst_11_wire_constant : std_logic_vector(14 downto 0);
    signal konst_20_wire_constant : std_logic_vector(15 downto 0);
    signal konst_28_wire_constant : std_logic_vector(15 downto 0);
    signal slice_10_wire : std_logic_vector(14 downto 0);
    -- 
  begin -- 
    konst_11_wire_constant <= "000000000000000";
    konst_20_wire_constant <= "0000000000001111";
    konst_28_wire_constant <= "0000000000001111";
    -- flow-through slice operator slice_10_inst
    slice_10_wire <= num_buffer(14 downto 0);
    -- binary operator AND_u1_u1_24_inst
    process(NOT_u1_u1_22_wire, exp_all_zero_13) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntAnd_proc(NOT_u1_u1_22_wire, exp_all_zero_13, tmp_var);
      zero_buffer <= tmp_var; --
    end process;
    -- binary operator AND_u1_u1_31_inst
    process(BITSEL_u16_u1_29_wire, exp_all_zero_13) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntAnd_proc(BITSEL_u16_u1_29_wire, exp_all_zero_13, tmp_var);
      inf_buffer <= tmp_var; --
    end process;
    -- binary operator BITSEL_u16_u1_21_inst
    process(num_buffer) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApBitsel_proc(num_buffer, konst_20_wire_constant, tmp_var);
      BITSEL_u16_u1_21_wire <= tmp_var; --
    end process;
    -- binary operator BITSEL_u16_u1_29_inst
    process(num_buffer) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApBitsel_proc(num_buffer, konst_28_wire_constant, tmp_var);
      BITSEL_u16_u1_29_wire <= tmp_var; --
    end process;
    -- binary operator EQ_u15_u1_12_inst
    process(slice_10_wire) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntEq_proc(slice_10_wire, konst_11_wire_constant, tmp_var);
      exp_all_zero_13 <= tmp_var; --
    end process;
    -- unary operator NOT_u1_u1_16_inst
    process(exp_all_zero_13) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      SingleInputOperation("ApIntNot", exp_all_zero_13, tmp_var);
      normal_buffer <= tmp_var; -- 
    end process;
    -- unary operator NOT_u1_u1_22_inst
    process(BITSEL_u16_u1_21_wire) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      SingleInputOperation("ApIntNot", BITSEL_u16_u1_21_wire, tmp_var);
      NOT_u1_u1_22_wire <= tmp_var; -- 
    end process;
    -- 
  end Block; -- data_path
  -- 
end classify_posit_Volatile_arch;
library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library aHiR_ieee_proposed;
use aHiR_ieee_proposed.math_utility_pkg.all;
use aHiR_ieee_proposed.fixed_pkg.all;
use aHiR_ieee_proposed.float_pkg.all;
library ahir;
use ahir.memory_subsystem_package.all;
use ahir.types.all;
use ahir.subprograms.all;
use ahir.components.all;
use ahir.basecomponents.all;
use ahir.operatorpackage.all;
use ahir.floatoperatorpackage.all;
use ahir.utilities.all;
library work;
use work.ahir_system_global_package.all;
entity complement_Volatile is -- 
  port ( -- 
    num : in  std_logic_vector(15 downto 0);
    result : out  std_logic_vector(15 downto 0)-- 
  );
  -- 
end entity complement_Volatile;
architecture complement_Volatile_arch of complement_Volatile is -- 
  -- always true...
  signal always_true_symbol: Boolean;
  signal in_buffer_data_in, in_buffer_data_out: std_logic_vector(16-1 downto 0);
  signal default_zero_sig: std_logic;
  -- input port buffer signals
  signal num_buffer :  std_logic_vector(15 downto 0);
  -- output port buffer signals
  signal result_buffer :  std_logic_vector(15 downto 0);
  -- volatile/operator module components. 
  -- 
begin --  
  -- input handling ------------------------------------------------
  num_buffer <= num;
  -- output handling  -------------------------------------------------------
  result <= result_buffer;
  -- the control path --------------------------------------------------
  default_zero_sig <= '0';
  -- volatile module, no control path
  -- the data path
  data_path: Block -- 
    signal CONCAT_u1_u17_380_wire : std_logic_vector(16 downto 0);
    signal convert_374 : std_logic_vector(16 downto 0);
    signal res_temp_382 : std_logic_vector(16 downto 0);
    signal type_cast_378_wire_constant : std_logic_vector(0 downto 0);
    -- 
  begin -- 
    convert_374 <= "10000000000000000";
    type_cast_378_wire_constant <= "0";
    -- flow-through slice operator slice_385_inst
    result_buffer <= res_temp_382(15 downto 0);
    -- binary operator CONCAT_u1_u17_380_inst
    process(type_cast_378_wire_constant, num_buffer) -- 
      variable tmp_var : std_logic_vector(16 downto 0); -- 
    begin -- 
      ApConcat_proc(type_cast_378_wire_constant, num_buffer, tmp_var);
      CONCAT_u1_u17_380_wire <= tmp_var; --
    end process;
    -- binary operator SUB_u17_u17_381_inst
    process(convert_374, CONCAT_u1_u17_380_wire) -- 
      variable tmp_var : std_logic_vector(16 downto 0); -- 
    begin -- 
      ApIntSub_proc(convert_374, CONCAT_u1_u17_380_wire, tmp_var);
      res_temp_382 <= tmp_var; --
    end process;
    -- 
  end Block; -- data_path
  -- 
end complement_Volatile_arch;
library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library aHiR_ieee_proposed;
use aHiR_ieee_proposed.math_utility_pkg.all;
use aHiR_ieee_proposed.fixed_pkg.all;
use aHiR_ieee_proposed.float_pkg.all;
library ahir;
use ahir.memory_subsystem_package.all;
use ahir.types.all;
use ahir.subprograms.all;
use ahir.components.all;
use ahir.basecomponents.all;
use ahir.operatorpackage.all;
use ahir.floatoperatorpackage.all;
use ahir.utilities.all;
library work;
use work.ahir_system_global_package.all;
entity find_leftmost_bit_16_Volatile is -- 
  port ( -- 
    num : in  std_logic_vector(15 downto 0);
    bit : in  std_logic_vector(0 downto 0);
    index : out  std_logic_vector(5 downto 0);
    not_found : out  std_logic_vector(0 downto 0)-- 
  );
  -- 
end entity find_leftmost_bit_16_Volatile;
architecture find_leftmost_bit_16_Volatile_arch of find_leftmost_bit_16_Volatile is -- 
  -- always true...
  signal always_true_symbol: Boolean;
  signal in_buffer_data_in, in_buffer_data_out: std_logic_vector(17-1 downto 0);
  signal default_zero_sig: std_logic;
  -- input port buffer signals
  signal num_buffer :  std_logic_vector(15 downto 0);
  signal bit_buffer :  std_logic_vector(0 downto 0);
  -- output port buffer signals
  signal index_buffer :  std_logic_vector(5 downto 0);
  signal not_found_buffer :  std_logic_vector(0 downto 0);
  -- volatile/operator module components. 
  component find_leftmost_bit_8_Volatile is -- 
    port ( -- 
      num : in  std_logic_vector(7 downto 0);
      bit : in  std_logic_vector(0 downto 0);
      index : out  std_logic_vector(5 downto 0);
      not_found : out  std_logic_vector(0 downto 0)-- 
    );
    -- 
  end component; 
  -- 
begin --  
  -- input handling ------------------------------------------------
  num_buffer <= num;
  bit_buffer <= bit;
  -- output handling  -------------------------------------------------------
  index <= index_buffer;
  not_found <= not_found_buffer;
  -- the control path --------------------------------------------------
  default_zero_sig <= '0';
  -- volatile module, no control path
  -- the data path
  data_path: Block -- 
    signal BITSEL_u1_u1_175_wire : std_logic_vector(0 downto 0);
    signal BITSEL_u1_u1_182_wire : std_logic_vector(0 downto 0);
    signal MUX_200_wire : std_logic_vector(5 downto 0);
    signal ind_h_190 : std_logic_vector(5 downto 0);
    signal index_h_178 : std_logic_vector(5 downto 0);
    signal index_l_185 : std_logic_vector(5 downto 0);
    signal konst_174_wire_constant : std_logic_vector(0 downto 0);
    signal konst_181_wire_constant : std_logic_vector(0 downto 0);
    signal konst_188_wire_constant : std_logic_vector(5 downto 0);
    signal not_found_h_178 : std_logic_vector(0 downto 0);
    signal not_found_l_185 : std_logic_vector(0 downto 0);
    signal num_h_167 : std_logic_vector(7 downto 0);
    signal num_l_171 : std_logic_vector(7 downto 0);
    -- 
  begin -- 
    konst_174_wire_constant <= "0";
    konst_181_wire_constant <= "0";
    konst_188_wire_constant <= "001000";
    -- flow-through select operator MUX_200_inst
    MUX_200_wire <= index_l_185 when (not_found_h_178(0) /=  '0') else ind_h_190;
    -- flow-through slice operator slice_166_inst
    num_h_167 <= num_buffer(15 downto 8);
    -- flow-through slice operator slice_170_inst
    num_l_171 <= num_buffer(7 downto 0);
    -- interlock type_cast_201_inst
    process(MUX_200_wire) -- 
      variable tmp_var : std_logic_vector(5 downto 0); -- 
    begin -- 
      tmp_var := (others => '0'); 
      tmp_var( 5 downto 0) := MUX_200_wire(5 downto 0);
      index_buffer <= tmp_var; -- 
    end process;
    -- binary operator ADD_u6_u6_189_inst
    process(index_h_178) -- 
      variable tmp_var : std_logic_vector(5 downto 0); -- 
    begin -- 
      ApIntAdd_proc(index_h_178, konst_188_wire_constant, tmp_var);
      ind_h_190 <= tmp_var; --
    end process;
    -- binary operator AND_u1_u1_194_inst
    process(not_found_h_178, not_found_l_185) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntAnd_proc(not_found_h_178, not_found_l_185, tmp_var);
      not_found_buffer <= tmp_var; --
    end process;
    -- binary operator BITSEL_u1_u1_175_inst
    process(bit_buffer) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApBitsel_proc(bit_buffer, konst_174_wire_constant, tmp_var);
      BITSEL_u1_u1_175_wire <= tmp_var; --
    end process;
    -- binary operator BITSEL_u1_u1_182_inst
    process(bit_buffer) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApBitsel_proc(bit_buffer, konst_181_wire_constant, tmp_var);
      BITSEL_u1_u1_182_wire <= tmp_var; --
    end process;
    volatile_operator_find_leftmost_bit_8_157: find_leftmost_bit_8_Volatile port map(num => num_h_167, bit => BITSEL_u1_u1_175_wire, index => index_h_178, not_found => not_found_h_178); 
    volatile_operator_find_leftmost_bit_8_159: find_leftmost_bit_8_Volatile port map(num => num_l_171, bit => BITSEL_u1_u1_182_wire, index => index_l_185, not_found => not_found_l_185); 
    -- 
  end Block; -- data_path
  -- 
end find_leftmost_bit_16_Volatile_arch;
library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library aHiR_ieee_proposed;
use aHiR_ieee_proposed.math_utility_pkg.all;
use aHiR_ieee_proposed.fixed_pkg.all;
use aHiR_ieee_proposed.float_pkg.all;
library ahir;
use ahir.memory_subsystem_package.all;
use ahir.types.all;
use ahir.subprograms.all;
use ahir.components.all;
use ahir.basecomponents.all;
use ahir.operatorpackage.all;
use ahir.floatoperatorpackage.all;
use ahir.utilities.all;
library work;
use work.ahir_system_global_package.all;
entity find_leftmost_bit_2_Volatile is -- 
  port ( -- 
    num : in  std_logic_vector(1 downto 0);
    bit : in  std_logic_vector(0 downto 0);
    index : out  std_logic_vector(5 downto 0);
    not_found : out  std_logic_vector(0 downto 0)-- 
  );
  -- 
end entity find_leftmost_bit_2_Volatile;
architecture find_leftmost_bit_2_Volatile_arch of find_leftmost_bit_2_Volatile is -- 
  -- always true...
  signal always_true_symbol: Boolean;
  signal in_buffer_data_in, in_buffer_data_out: std_logic_vector(3-1 downto 0);
  signal default_zero_sig: std_logic;
  -- input port buffer signals
  signal num_buffer :  std_logic_vector(1 downto 0);
  signal bit_buffer :  std_logic_vector(0 downto 0);
  -- output port buffer signals
  signal index_buffer :  std_logic_vector(5 downto 0);
  signal not_found_buffer :  std_logic_vector(0 downto 0);
  -- volatile/operator module components. 
  -- 
begin --  
  -- input handling ------------------------------------------------
  num_buffer <= num;
  bit_buffer <= bit;
  -- output handling  -------------------------------------------------------
  index <= index_buffer;
  not_found <= not_found_buffer;
  -- the control path --------------------------------------------------
  default_zero_sig <= '0';
  -- volatile module, no control path
  -- the data path
  data_path: Block -- 
    signal BITSEL_u1_u1_47_wire : std_logic_vector(0 downto 0);
    signal BITSEL_u1_u1_56_wire : std_logic_vector(0 downto 0);
    signal BITSEL_u2_u1_44_wire : std_logic_vector(0 downto 0);
    signal BITSEL_u2_u1_53_wire : std_logic_vector(0 downto 0);
    signal MUX_71_wire : std_logic_vector(0 downto 0);
    signal OR_u1_u1_62_wire : std_logic_vector(0 downto 0);
    signal first_bit_49 : std_logic_vector(0 downto 0);
    signal konst_43_wire_constant : std_logic_vector(1 downto 0);
    signal konst_46_wire_constant : std_logic_vector(0 downto 0);
    signal konst_52_wire_constant : std_logic_vector(1 downto 0);
    signal konst_55_wire_constant : std_logic_vector(0 downto 0);
    signal second_bit_58 : std_logic_vector(0 downto 0);
    signal type_cast_68_wire_constant : std_logic_vector(0 downto 0);
    signal type_cast_70_wire_constant : std_logic_vector(0 downto 0);
    -- 
  begin -- 
    konst_43_wire_constant <= "00";
    konst_46_wire_constant <= "0";
    konst_52_wire_constant <= "01";
    konst_55_wire_constant <= "0";
    type_cast_68_wire_constant <= "1";
    type_cast_70_wire_constant <= "0";
    -- flow-through select operator MUX_71_inst
    MUX_71_wire <= type_cast_68_wire_constant when (second_bit_58(0) /=  '0') else type_cast_70_wire_constant;
    -- interlock type_cast_72_inst
    process(MUX_71_wire) -- 
      variable tmp_var : std_logic_vector(5 downto 0); -- 
    begin -- 
      tmp_var := (others => '0'); 
      tmp_var( 0 downto 0) := MUX_71_wire(0 downto 0);
      index_buffer <= tmp_var; -- 
    end process;
    -- binary operator BITSEL_u1_u1_47_inst
    process(bit_buffer) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApBitsel_proc(bit_buffer, konst_46_wire_constant, tmp_var);
      BITSEL_u1_u1_47_wire <= tmp_var; --
    end process;
    -- binary operator BITSEL_u1_u1_56_inst
    process(bit_buffer) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApBitsel_proc(bit_buffer, konst_55_wire_constant, tmp_var);
      BITSEL_u1_u1_56_wire <= tmp_var; --
    end process;
    -- binary operator BITSEL_u2_u1_44_inst
    process(num_buffer) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApBitsel_proc(num_buffer, konst_43_wire_constant, tmp_var);
      BITSEL_u2_u1_44_wire <= tmp_var; --
    end process;
    -- binary operator BITSEL_u2_u1_53_inst
    process(num_buffer) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApBitsel_proc(num_buffer, konst_52_wire_constant, tmp_var);
      BITSEL_u2_u1_53_wire <= tmp_var; --
    end process;
    -- binary operator EQ_u1_u1_48_inst
    process(BITSEL_u2_u1_44_wire, BITSEL_u1_u1_47_wire) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntEq_proc(BITSEL_u2_u1_44_wire, BITSEL_u1_u1_47_wire, tmp_var);
      first_bit_49 <= tmp_var; --
    end process;
    -- binary operator EQ_u1_u1_57_inst
    process(BITSEL_u2_u1_53_wire, BITSEL_u1_u1_56_wire) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntEq_proc(BITSEL_u2_u1_53_wire, BITSEL_u1_u1_56_wire, tmp_var);
      second_bit_58 <= tmp_var; --
    end process;
    -- unary operator NOT_u1_u1_63_inst
    process(OR_u1_u1_62_wire) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      SingleInputOperation("ApIntNot", OR_u1_u1_62_wire, tmp_var);
      not_found_buffer <= tmp_var; -- 
    end process;
    -- binary operator OR_u1_u1_62_inst
    process(first_bit_49, second_bit_58) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntOr_proc(first_bit_49, second_bit_58, tmp_var);
      OR_u1_u1_62_wire <= tmp_var; --
    end process;
    -- 
  end Block; -- data_path
  -- 
end find_leftmost_bit_2_Volatile_arch;
library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library aHiR_ieee_proposed;
use aHiR_ieee_proposed.math_utility_pkg.all;
use aHiR_ieee_proposed.fixed_pkg.all;
use aHiR_ieee_proposed.float_pkg.all;
library ahir;
use ahir.memory_subsystem_package.all;
use ahir.types.all;
use ahir.subprograms.all;
use ahir.components.all;
use ahir.basecomponents.all;
use ahir.operatorpackage.all;
use ahir.floatoperatorpackage.all;
use ahir.utilities.all;
library work;
use work.ahir_system_global_package.all;
entity find_leftmost_bit_4_Volatile is -- 
  port ( -- 
    num : in  std_logic_vector(3 downto 0);
    bit : in  std_logic_vector(0 downto 0);
    index : out  std_logic_vector(5 downto 0);
    not_found : out  std_logic_vector(0 downto 0)-- 
  );
  -- 
end entity find_leftmost_bit_4_Volatile;
architecture find_leftmost_bit_4_Volatile_arch of find_leftmost_bit_4_Volatile is -- 
  -- always true...
  signal always_true_symbol: Boolean;
  signal in_buffer_data_in, in_buffer_data_out: std_logic_vector(5-1 downto 0);
  signal default_zero_sig: std_logic;
  -- input port buffer signals
  signal num_buffer :  std_logic_vector(3 downto 0);
  signal bit_buffer :  std_logic_vector(0 downto 0);
  -- output port buffer signals
  signal index_buffer :  std_logic_vector(5 downto 0);
  signal not_found_buffer :  std_logic_vector(0 downto 0);
  -- volatile/operator module components. 
  component find_leftmost_bit_2_Volatile is -- 
    port ( -- 
      num : in  std_logic_vector(1 downto 0);
      bit : in  std_logic_vector(0 downto 0);
      index : out  std_logic_vector(5 downto 0);
      not_found : out  std_logic_vector(0 downto 0)-- 
    );
    -- 
  end component; 
  -- 
begin --  
  -- input handling ------------------------------------------------
  num_buffer <= num;
  bit_buffer <= bit;
  -- output handling  -------------------------------------------------------
  index <= index_buffer;
  not_found <= not_found_buffer;
  -- the control path --------------------------------------------------
  default_zero_sig <= '0';
  -- volatile module, no control path
  -- the data path
  data_path: Block -- 
    signal MUX_113_wire : std_logic_vector(5 downto 0);
    signal ind_h_103 : std_logic_vector(5 downto 0);
    signal index_h_93 : std_logic_vector(5 downto 0);
    signal index_l_98 : std_logic_vector(5 downto 0);
    signal konst_101_wire_constant : std_logic_vector(5 downto 0);
    signal not_found_h_93 : std_logic_vector(0 downto 0);
    signal not_found_l_98 : std_logic_vector(0 downto 0);
    signal num_h_84 : std_logic_vector(1 downto 0);
    signal num_l_88 : std_logic_vector(1 downto 0);
    -- 
  begin -- 
    konst_101_wire_constant <= "000010";
    -- flow-through select operator MUX_113_inst
    MUX_113_wire <= index_l_98 when (not_found_h_93(0) /=  '0') else ind_h_103;
    -- flow-through slice operator slice_83_inst
    num_h_84 <= num_buffer(3 downto 2);
    -- flow-through slice operator slice_87_inst
    num_l_88 <= num_buffer(1 downto 0);
    -- interlock type_cast_114_inst
    process(MUX_113_wire) -- 
      variable tmp_var : std_logic_vector(5 downto 0); -- 
    begin -- 
      tmp_var := (others => '0'); 
      tmp_var( 5 downto 0) := MUX_113_wire(5 downto 0);
      index_buffer <= tmp_var; -- 
    end process;
    -- binary operator ADD_u6_u6_102_inst
    process(index_h_93) -- 
      variable tmp_var : std_logic_vector(5 downto 0); -- 
    begin -- 
      ApIntAdd_proc(index_h_93, konst_101_wire_constant, tmp_var);
      ind_h_103 <= tmp_var; --
    end process;
    -- binary operator AND_u1_u1_107_inst
    process(not_found_h_93, not_found_l_98) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntAnd_proc(not_found_h_93, not_found_l_98, tmp_var);
      not_found_buffer <= tmp_var; --
    end process;
    volatile_operator_find_leftmost_bit_2_95: find_leftmost_bit_2_Volatile port map(num => num_h_84, bit => bit_buffer, index => index_h_93, not_found => not_found_h_93); 
    volatile_operator_find_leftmost_bit_2_96: find_leftmost_bit_2_Volatile port map(num => num_l_88, bit => bit_buffer, index => index_l_98, not_found => not_found_l_98); 
    -- 
  end Block; -- data_path
  -- 
end find_leftmost_bit_4_Volatile_arch;
library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library aHiR_ieee_proposed;
use aHiR_ieee_proposed.math_utility_pkg.all;
use aHiR_ieee_proposed.fixed_pkg.all;
use aHiR_ieee_proposed.float_pkg.all;
library ahir;
use ahir.memory_subsystem_package.all;
use ahir.types.all;
use ahir.subprograms.all;
use ahir.components.all;
use ahir.basecomponents.all;
use ahir.operatorpackage.all;
use ahir.floatoperatorpackage.all;
use ahir.utilities.all;
library work;
use work.ahir_system_global_package.all;
entity find_leftmost_bit_8_Volatile is -- 
  port ( -- 
    num : in  std_logic_vector(7 downto 0);
    bit : in  std_logic_vector(0 downto 0);
    index : out  std_logic_vector(5 downto 0);
    not_found : out  std_logic_vector(0 downto 0)-- 
  );
  -- 
end entity find_leftmost_bit_8_Volatile;
architecture find_leftmost_bit_8_Volatile_arch of find_leftmost_bit_8_Volatile is -- 
  -- always true...
  signal always_true_symbol: Boolean;
  signal in_buffer_data_in, in_buffer_data_out: std_logic_vector(9-1 downto 0);
  signal default_zero_sig: std_logic;
  -- input port buffer signals
  signal num_buffer :  std_logic_vector(7 downto 0);
  signal bit_buffer :  std_logic_vector(0 downto 0);
  -- output port buffer signals
  signal index_buffer :  std_logic_vector(5 downto 0);
  signal not_found_buffer :  std_logic_vector(0 downto 0);
  -- volatile/operator module components. 
  component find_leftmost_bit_4_Volatile is -- 
    port ( -- 
      num : in  std_logic_vector(3 downto 0);
      bit : in  std_logic_vector(0 downto 0);
      index : out  std_logic_vector(5 downto 0);
      not_found : out  std_logic_vector(0 downto 0)-- 
    );
    -- 
  end component; 
  -- 
begin --  
  -- input handling ------------------------------------------------
  num_buffer <= num;
  bit_buffer <= bit;
  -- output handling  -------------------------------------------------------
  index <= index_buffer;
  not_found <= not_found_buffer;
  -- the control path --------------------------------------------------
  default_zero_sig <= '0';
  -- volatile module, no control path
  -- the data path
  data_path: Block -- 
    signal MUX_155_wire : std_logic_vector(5 downto 0);
    signal ind_h_145 : std_logic_vector(5 downto 0);
    signal index_h_135 : std_logic_vector(5 downto 0);
    signal index_l_140 : std_logic_vector(5 downto 0);
    signal konst_143_wire_constant : std_logic_vector(5 downto 0);
    signal not_found_h_135 : std_logic_vector(0 downto 0);
    signal not_found_l_140 : std_logic_vector(0 downto 0);
    signal num_h_126 : std_logic_vector(3 downto 0);
    signal num_l_130 : std_logic_vector(3 downto 0);
    -- 
  begin -- 
    konst_143_wire_constant <= "000100";
    -- flow-through select operator MUX_155_inst
    MUX_155_wire <= index_l_140 when (not_found_h_135(0) /=  '0') else ind_h_145;
    -- flow-through slice operator slice_125_inst
    num_h_126 <= num_buffer(7 downto 4);
    -- flow-through slice operator slice_129_inst
    num_l_130 <= num_buffer(3 downto 0);
    -- interlock type_cast_156_inst
    process(MUX_155_wire) -- 
      variable tmp_var : std_logic_vector(5 downto 0); -- 
    begin -- 
      tmp_var := (others => '0'); 
      tmp_var( 5 downto 0) := MUX_155_wire(5 downto 0);
      index_buffer <= tmp_var; -- 
    end process;
    -- binary operator ADD_u6_u6_144_inst
    process(index_h_135) -- 
      variable tmp_var : std_logic_vector(5 downto 0); -- 
    begin -- 
      ApIntAdd_proc(index_h_135, konst_143_wire_constant, tmp_var);
      ind_h_145 <= tmp_var; --
    end process;
    -- binary operator AND_u1_u1_149_inst
    process(not_found_h_135, not_found_l_140) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntAnd_proc(not_found_h_135, not_found_l_140, tmp_var);
      not_found_buffer <= tmp_var; --
    end process;
    volatile_operator_find_leftmost_bit_4_123: find_leftmost_bit_4_Volatile port map(num => num_h_126, bit => bit_buffer, index => index_h_135, not_found => not_found_h_135); 
    volatile_operator_find_leftmost_bit_4_124: find_leftmost_bit_4_Volatile port map(num => num_l_130, bit => bit_buffer, index => index_l_140, not_found => not_found_l_140); 
    -- 
  end Block; -- data_path
  -- 
end find_leftmost_bit_8_Volatile_arch;
library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library aHiR_ieee_proposed;
use aHiR_ieee_proposed.math_utility_pkg.all;
use aHiR_ieee_proposed.fixed_pkg.all;
use aHiR_ieee_proposed.float_pkg.all;
library ahir;
use ahir.memory_subsystem_package.all;
use ahir.types.all;
use ahir.subprograms.all;
use ahir.components.all;
use ahir.basecomponents.all;
use ahir.operatorpackage.all;
use ahir.floatoperatorpackage.all;
use ahir.utilities.all;
library work;
use work.ahir_system_global_package.all;
entity sll_16_Volatile is -- 
  port ( -- 
    num : in  std_logic_vector(15 downto 0);
    shift : in  std_logic_vector(3 downto 0);
    shifted : out  std_logic_vector(15 downto 0)-- 
  );
  -- 
end entity sll_16_Volatile;
architecture sll_16_Volatile_arch of sll_16_Volatile is -- 
  -- always true...
  signal always_true_symbol: Boolean;
  signal in_buffer_data_in, in_buffer_data_out: std_logic_vector(20-1 downto 0);
  signal default_zero_sig: std_logic;
  -- input port buffer signals
  signal num_buffer :  std_logic_vector(15 downto 0);
  signal shift_buffer :  std_logic_vector(3 downto 0);
  -- output port buffer signals
  signal shifted_buffer :  std_logic_vector(15 downto 0);
  -- volatile/operator module components. 
  -- 
begin --  
  -- input handling ------------------------------------------------
  num_buffer <= num;
  shift_buffer <= shift;
  -- output handling  -------------------------------------------------------
  shifted <= shifted_buffer;
  -- the control path --------------------------------------------------
  default_zero_sig <= '0';
  -- volatile module, no control path
  -- the data path
  data_path: Block -- 
    signal BITSEL_u4_u1_211_wire : std_logic_vector(0 downto 0);
    signal BITSEL_u4_u1_223_wire : std_logic_vector(0 downto 0);
    signal BITSEL_u4_u1_236_wire : std_logic_vector(0 downto 0);
    signal BITSEL_u4_u1_249_wire : std_logic_vector(0 downto 0);
    signal CONCAT_u12_u16_242_wire : std_logic_vector(15 downto 0);
    signal CONCAT_u14_u16_229_wire : std_logic_vector(15 downto 0);
    signal CONCAT_u15_u16_216_wire : std_logic_vector(15 downto 0);
    signal CONCAT_u8_u16_254_wire : std_logic_vector(15 downto 0);
    signal X0_219 : std_logic_vector(15 downto 0);
    signal X1_232 : std_logic_vector(15 downto 0);
    signal X2_245 : std_logic_vector(15 downto 0);
    signal X3_257 : std_logic_vector(15 downto 0);
    signal konst_210_wire_constant : std_logic_vector(3 downto 0);
    signal konst_222_wire_constant : std_logic_vector(3 downto 0);
    signal konst_235_wire_constant : std_logic_vector(3 downto 0);
    signal konst_248_wire_constant : std_logic_vector(3 downto 0);
    signal slice_213_wire : std_logic_vector(14 downto 0);
    signal slice_226_wire : std_logic_vector(13 downto 0);
    signal slice_239_wire : std_logic_vector(11 downto 0);
    signal slice_251_wire : std_logic_vector(7 downto 0);
    signal type_cast_215_wire_constant : std_logic_vector(0 downto 0);
    signal type_cast_228_wire_constant : std_logic_vector(1 downto 0);
    signal type_cast_241_wire_constant : std_logic_vector(3 downto 0);
    signal type_cast_253_wire_constant : std_logic_vector(7 downto 0);
    -- 
  begin -- 
    konst_210_wire_constant <= "0000";
    konst_222_wire_constant <= "0001";
    konst_235_wire_constant <= "0010";
    konst_248_wire_constant <= "0011";
    type_cast_215_wire_constant <= "0";
    type_cast_228_wire_constant <= "00";
    type_cast_241_wire_constant <= "0000";
    type_cast_253_wire_constant <= "00000000";
    -- flow-through select operator MUX_218_inst
    X0_219 <= CONCAT_u15_u16_216_wire when (BITSEL_u4_u1_211_wire(0) /=  '0') else num_buffer;
    -- flow-through select operator MUX_231_inst
    X1_232 <= CONCAT_u14_u16_229_wire when (BITSEL_u4_u1_223_wire(0) /=  '0') else X0_219;
    -- flow-through select operator MUX_244_inst
    X2_245 <= CONCAT_u12_u16_242_wire when (BITSEL_u4_u1_236_wire(0) /=  '0') else X1_232;
    -- flow-through select operator MUX_256_inst
    X3_257 <= CONCAT_u8_u16_254_wire when (BITSEL_u4_u1_249_wire(0) /=  '0') else X2_245;
    -- flow-through slice operator slice_213_inst
    slice_213_wire <= num_buffer(14 downto 0);
    -- flow-through slice operator slice_226_inst
    slice_226_wire <= X0_219(13 downto 0);
    -- flow-through slice operator slice_239_inst
    slice_239_wire <= X1_232(11 downto 0);
    -- flow-through slice operator slice_251_inst
    slice_251_wire <= X2_245(7 downto 0);
    -- interlock W_shifted_258_inst
    process(X3_257) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      tmp_var := (others => '0'); 
      tmp_var( 15 downto 0) := X3_257(15 downto 0);
      shifted_buffer <= tmp_var; -- 
    end process;
    -- binary operator BITSEL_u4_u1_211_inst
    process(shift_buffer) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApBitsel_proc(shift_buffer, konst_210_wire_constant, tmp_var);
      BITSEL_u4_u1_211_wire <= tmp_var; --
    end process;
    -- binary operator BITSEL_u4_u1_223_inst
    process(shift_buffer) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApBitsel_proc(shift_buffer, konst_222_wire_constant, tmp_var);
      BITSEL_u4_u1_223_wire <= tmp_var; --
    end process;
    -- binary operator BITSEL_u4_u1_236_inst
    process(shift_buffer) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApBitsel_proc(shift_buffer, konst_235_wire_constant, tmp_var);
      BITSEL_u4_u1_236_wire <= tmp_var; --
    end process;
    -- binary operator BITSEL_u4_u1_249_inst
    process(shift_buffer) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApBitsel_proc(shift_buffer, konst_248_wire_constant, tmp_var);
      BITSEL_u4_u1_249_wire <= tmp_var; --
    end process;
    -- binary operator CONCAT_u12_u16_242_inst
    process(slice_239_wire) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApConcat_proc(slice_239_wire, type_cast_241_wire_constant, tmp_var);
      CONCAT_u12_u16_242_wire <= tmp_var; --
    end process;
    -- binary operator CONCAT_u14_u16_229_inst
    process(slice_226_wire) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApConcat_proc(slice_226_wire, type_cast_228_wire_constant, tmp_var);
      CONCAT_u14_u16_229_wire <= tmp_var; --
    end process;
    -- binary operator CONCAT_u15_u16_216_inst
    process(slice_213_wire) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApConcat_proc(slice_213_wire, type_cast_215_wire_constant, tmp_var);
      CONCAT_u15_u16_216_wire <= tmp_var; --
    end process;
    -- binary operator CONCAT_u8_u16_254_inst
    process(slice_251_wire) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApConcat_proc(slice_251_wire, type_cast_253_wire_constant, tmp_var);
      CONCAT_u8_u16_254_wire <= tmp_var; --
    end process;
    -- 
  end Block; -- data_path
  -- 
end sll_16_Volatile_arch;
library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library aHiR_ieee_proposed;
use aHiR_ieee_proposed.math_utility_pkg.all;
use aHiR_ieee_proposed.fixed_pkg.all;
use aHiR_ieee_proposed.float_pkg.all;
library ahir;
use ahir.memory_subsystem_package.all;
use ahir.types.all;
use ahir.subprograms.all;
use ahir.components.all;
use ahir.basecomponents.all;
use ahir.operatorpackage.all;
use ahir.floatoperatorpackage.all;
use ahir.utilities.all;
library work;
use work.ahir_system_global_package.all;
entity split_posit_Volatile is -- 
  port ( -- 
    num : in  std_logic_vector(15 downto 0);
    sign : out  std_logic_vector(0 downto 0);
    exp : out  std_logic_vector(5 downto 0);
    fraction : out  std_logic_vector(11 downto 0)-- 
  );
  -- 
end entity split_posit_Volatile;
architecture split_posit_Volatile_arch of split_posit_Volatile is -- 
  -- always true...
  signal always_true_symbol: Boolean;
  signal in_buffer_data_in, in_buffer_data_out: std_logic_vector(16-1 downto 0);
  signal default_zero_sig: std_logic;
  -- input port buffer signals
  signal num_buffer :  std_logic_vector(15 downto 0);
  -- output port buffer signals
  signal sign_buffer :  std_logic_vector(0 downto 0);
  signal exp_buffer :  std_logic_vector(5 downto 0);
  signal fraction_buffer :  std_logic_vector(11 downto 0);
  -- volatile/operator module components. 
  component find_leftmost_bit_16_Volatile is -- 
    port ( -- 
      num : in  std_logic_vector(15 downto 0);
      bit : in  std_logic_vector(0 downto 0);
      index : out  std_logic_vector(5 downto 0);
      not_found : out  std_logic_vector(0 downto 0)-- 
    );
    -- 
  end component; 
  component sll_16_Volatile is -- 
    port ( -- 
      num : in  std_logic_vector(15 downto 0);
      shift : in  std_logic_vector(3 downto 0);
      shifted : out  std_logic_vector(15 downto 0)-- 
    );
    -- 
  end component; 
  -- 
begin --  
  -- input handling ------------------------------------------------
  num_buffer <= num;
  -- output handling  -------------------------------------------------------
  sign <= sign_buffer;
  exp <= exp_buffer;
  fraction <= fraction_buffer;
  -- the control path --------------------------------------------------
  default_zero_sig <= '0';
  -- volatile module, no control path
  -- the data path
  data_path: Block -- 
    signal ADD_u6_u6_338_wire : std_logic_vector(5 downto 0);
    signal BITSEL_u16_u1_331_wire : std_logic_vector(0 downto 0);
    signal MUX_342_wire : std_logic_vector(5 downto 0);
    signal NOT_u1_u1_290_wire : std_logic_vector(0 downto 0);
    signal R_ONE_2_277_wire_constant : std_logic_vector(1 downto 0);
    signal SUB_u6_u6_297_wire : std_logic_vector(5 downto 0);
    signal SUB_u6_u6_303_wire : std_logic_vector(5 downto 0);
    signal SUB_u6_u6_315_wire : std_logic_vector(5 downto 0);
    signal SUB_u6_u6_341_wire : std_logic_vector(5 downto 0);
    signal exp_biased_345 : std_logic_vector(5 downto 0);
    signal exp_bit_333 : std_logic_vector(5 downto 0);
    signal exp_shift_305 : std_logic_vector(3 downto 0);
    signal frac_shift_299 : std_logic_vector(3 downto 0);
    signal index_293 : std_logic_vector(5 downto 0);
    signal konst_272_wire_constant : std_logic_vector(15 downto 0);
    signal konst_295_wire_constant : std_logic_vector(5 downto 0);
    signal konst_301_wire_constant : std_logic_vector(5 downto 0);
    signal konst_307_wire_constant : std_logic_vector(5 downto 0);
    signal konst_314_wire_constant : std_logic_vector(5 downto 0);
    signal konst_320_wire_constant : std_logic_vector(5 downto 0);
    signal konst_330_wire_constant : std_logic_vector(15 downto 0);
    signal konst_336_wire_constant : std_logic_vector(5 downto 0);
    signal konst_339_wire_constant : std_logic_vector(5 downto 0);
    signal konst_356_wire_constant : std_logic_vector(15 downto 0);
    signal not_found_293 : std_logic_vector(0 downto 0);
    signal reg_cnt_310 : std_logic_vector(5 downto 0);
    signal reg_cnt_gen_318 : std_logic_vector(5 downto 0);
    signal reg_mul2_323 : std_logic_vector(5 downto 0);
    signal regime_bit_274 : std_logic_vector(0 downto 0);
    signal shifted_frac_349 : std_logic_vector(15 downto 0);
    signal shifted_to_find_exp_327 : std_logic_vector(15 downto 0);
    signal slice_285_wire : std_logic_vector(13 downto 0);
    signal start_2_bits_281 : std_logic_vector(1 downto 0);
    signal temp_num_287 : std_logic_vector(15 downto 0);
    signal type_cast_279_wire_constant : std_logic_vector(1 downto 0);
    signal xxsplit_positxxONE_2 : std_logic_vector(1 downto 0);
    -- 
  begin -- 
    R_ONE_2_277_wire_constant <= "11";
    konst_272_wire_constant <= "0000000000001110";
    konst_295_wire_constant <= "010001";
    konst_301_wire_constant <= "010000";
    konst_307_wire_constant <= "001110";
    konst_314_wire_constant <= "000001";
    konst_320_wire_constant <= "000010";
    konst_330_wire_constant <= "0000000000001111";
    konst_336_wire_constant <= "011100";
    konst_339_wire_constant <= "011100";
    konst_356_wire_constant <= "0000000000001111";
    type_cast_279_wire_constant <= "00";
    xxsplit_positxxONE_2 <= "11";
    -- flow-through select operator MUX_280_inst
    start_2_bits_281 <= R_ONE_2_277_wire_constant when (regime_bit_274(0) /=  '0') else type_cast_279_wire_constant;
    -- flow-through select operator MUX_317_inst
    reg_cnt_gen_318 <= SUB_u6_u6_315_wire when (regime_bit_274(0) /=  '0') else reg_cnt_310;
    -- flow-through select operator MUX_342_inst
    MUX_342_wire <= ADD_u6_u6_338_wire when (regime_bit_274(0) /=  '0') else SUB_u6_u6_341_wire;
    -- flow-through slice operator slice_285_inst
    slice_285_wire <= num_buffer(13 downto 0);
    -- flow-through slice operator slice_361_inst
    fraction_buffer <= shifted_frac_349(15 downto 4);
    -- interlock type_cast_298_inst
    process(SUB_u6_u6_297_wire) -- 
      variable tmp_var : std_logic_vector(3 downto 0); -- 
    begin -- 
      tmp_var := (others => '0'); 
      tmp_var( 3 downto 0) := SUB_u6_u6_297_wire(3 downto 0);
      frac_shift_299 <= tmp_var; -- 
    end process;
    -- interlock type_cast_304_inst
    process(SUB_u6_u6_303_wire) -- 
      variable tmp_var : std_logic_vector(3 downto 0); -- 
    begin -- 
      tmp_var := (others => '0'); 
      tmp_var( 3 downto 0) := SUB_u6_u6_303_wire(3 downto 0);
      exp_shift_305 <= tmp_var; -- 
    end process;
    -- interlock type_cast_332_inst
    process(BITSEL_u16_u1_331_wire) -- 
      variable tmp_var : std_logic_vector(5 downto 0); -- 
    begin -- 
      tmp_var := (others => '0'); 
      tmp_var( 0 downto 0) := BITSEL_u16_u1_331_wire(0 downto 0);
      exp_bit_333 <= tmp_var; -- 
    end process;
    -- interlock type_cast_352_inst
    process(exp_biased_345) -- 
      variable tmp_var : std_logic_vector(5 downto 0); -- 
    begin -- 
      tmp_var := (others => '0'); 
      tmp_var( 5 downto 0) := exp_biased_345(5 downto 0);
      exp_buffer <= tmp_var; -- 
    end process;
    -- binary operator ADD_u6_u6_338_inst
    process(reg_mul2_323) -- 
      variable tmp_var : std_logic_vector(5 downto 0); -- 
    begin -- 
      ApIntAdd_proc(reg_mul2_323, konst_336_wire_constant, tmp_var);
      ADD_u6_u6_338_wire <= tmp_var; --
    end process;
    -- binary operator ADD_u6_u6_344_inst
    process(MUX_342_wire, exp_bit_333) -- 
      variable tmp_var : std_logic_vector(5 downto 0); -- 
    begin -- 
      ApIntAdd_proc(MUX_342_wire, exp_bit_333, tmp_var);
      exp_biased_345 <= tmp_var; --
    end process;
    -- binary operator BITSEL_u16_u1_273_inst
    process(num_buffer) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApBitsel_proc(num_buffer, konst_272_wire_constant, tmp_var);
      regime_bit_274 <= tmp_var; --
    end process;
    -- binary operator BITSEL_u16_u1_331_inst
    process(shifted_to_find_exp_327) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApBitsel_proc(shifted_to_find_exp_327, konst_330_wire_constant, tmp_var);
      BITSEL_u16_u1_331_wire <= tmp_var; --
    end process;
    -- binary operator BITSEL_u16_u1_357_inst
    process(num_buffer) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApBitsel_proc(num_buffer, konst_356_wire_constant, tmp_var);
      sign_buffer <= tmp_var; --
    end process;
    -- binary operator CONCAT_u2_u16_286_inst
    process(start_2_bits_281, slice_285_wire) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApConcat_proc(start_2_bits_281, slice_285_wire, tmp_var);
      temp_num_287 <= tmp_var; --
    end process;
    -- binary operator MUL_u6_u6_322_inst
    process(reg_cnt_gen_318) -- 
      variable tmp_var : std_logic_vector(5 downto 0); -- 
    begin -- 
      ApIntMul_proc(reg_cnt_gen_318, konst_320_wire_constant, tmp_var);
      reg_mul2_323 <= tmp_var; --
    end process;
    -- unary operator NOT_u1_u1_290_inst
    process(regime_bit_274) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      SingleInputOperation("ApIntNot", regime_bit_274, tmp_var);
      NOT_u1_u1_290_wire <= tmp_var; -- 
    end process;
    -- binary operator SUB_u6_u6_297_inst
    process(konst_295_wire_constant, index_293) -- 
      variable tmp_var : std_logic_vector(5 downto 0); -- 
    begin -- 
      ApIntSub_proc(konst_295_wire_constant, index_293, tmp_var);
      SUB_u6_u6_297_wire <= tmp_var; --
    end process;
    -- binary operator SUB_u6_u6_303_inst
    process(konst_301_wire_constant, index_293) -- 
      variable tmp_var : std_logic_vector(5 downto 0); -- 
    begin -- 
      ApIntSub_proc(konst_301_wire_constant, index_293, tmp_var);
      SUB_u6_u6_303_wire <= tmp_var; --
    end process;
    -- binary operator SUB_u6_u6_309_inst
    process(konst_307_wire_constant, index_293) -- 
      variable tmp_var : std_logic_vector(5 downto 0); -- 
    begin -- 
      ApIntSub_proc(konst_307_wire_constant, index_293, tmp_var);
      reg_cnt_310 <= tmp_var; --
    end process;
    -- binary operator SUB_u6_u6_315_inst
    process(reg_cnt_310) -- 
      variable tmp_var : std_logic_vector(5 downto 0); -- 
    begin -- 
      ApIntSub_proc(reg_cnt_310, konst_314_wire_constant, tmp_var);
      SUB_u6_u6_315_wire <= tmp_var; --
    end process;
    -- binary operator SUB_u6_u6_341_inst
    process(konst_339_wire_constant, reg_mul2_323) -- 
      variable tmp_var : std_logic_vector(5 downto 0); -- 
    begin -- 
      ApIntSub_proc(konst_339_wire_constant, reg_mul2_323, tmp_var);
      SUB_u6_u6_341_wire <= tmp_var; --
    end process;
    volatile_operator_find_leftmost_bit_16_286: find_leftmost_bit_16_Volatile port map(num => temp_num_287, bit => NOT_u1_u1_290_wire, index => index_293, not_found => not_found_293); 
    volatile_operator_sll_16_295: sll_16_Volatile port map(num => num_buffer, shift => exp_shift_305, shifted => shifted_to_find_exp_327); 
    volatile_operator_sll_16_302: sll_16_Volatile port map(num => num_buffer, shift => frac_shift_299, shifted => shifted_frac_349); 
    -- 
  end Block; -- data_path
  -- 
end split_posit_Volatile_arch;
library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library aHiR_ieee_proposed;
use aHiR_ieee_proposed.math_utility_pkg.all;
use aHiR_ieee_proposed.fixed_pkg.all;
use aHiR_ieee_proposed.float_pkg.all;
library ahir;
use ahir.memory_subsystem_package.all;
use ahir.types.all;
use ahir.subprograms.all;
use ahir.components.all;
use ahir.basecomponents.all;
use ahir.operatorpackage.all;
use ahir.floatoperatorpackage.all;
use ahir.utilities.all;
library work;
use work.ahir_system_global_package.all;
entity ahir_system is  -- system 
  port (-- 
    Posit16_to_FP32_P : in  std_logic_vector(15 downto 0);
    Posit16_to_FP32_F : out  std_logic_vector(31 downto 0);
    Posit16_to_FP32_tag_in: in std_logic_vector(1 downto 0);
    Posit16_to_FP32_tag_out: out std_logic_vector(1 downto 0);
    Posit16_to_FP32_start_req : in std_logic;
    Posit16_to_FP32_start_ack : out std_logic;
    Posit16_to_FP32_fin_req   : in std_logic;
    Posit16_to_FP32_fin_ack   : out std_logic;
    clk : in std_logic;
    reset : in std_logic); -- 
  -- 
end entity; 
architecture ahir_system_arch  of ahir_system is -- system-architecture 
  -- declarations related to module Posit16_to_FP32
  component Posit16_to_FP32 is -- 
    generic (tag_length : integer); 
    port ( -- 
      P : in  std_logic_vector(15 downto 0);
      F : out  std_logic_vector(31 downto 0);
      tag_in: in std_logic_vector(tag_length-1 downto 0);
      tag_out: out std_logic_vector(tag_length-1 downto 0) ;
      clk : in std_logic;
      reset : in std_logic;
      start_req : in std_logic;
      start_ack : out std_logic;
      fin_req : in std_logic;
      fin_ack   : out std_logic-- 
    );
    -- 
  end component;
  -- declarations related to module classify_posit
  -- declarations related to module complement
  -- declarations related to module find_leftmost_bit_16
  -- declarations related to module find_leftmost_bit_2
  -- declarations related to module find_leftmost_bit_4
  -- declarations related to module find_leftmost_bit_8
  -- declarations related to module sll_16
  -- declarations related to module split_posit
  -- gated clock signal declarations.
  -- 
begin -- 
  -- module Posit16_to_FP32
  Posit16_to_FP32_instance:Posit16_to_FP32-- 
    generic map(tag_length => 2)
    port map(-- 
      P => Posit16_to_FP32_P,
      F => Posit16_to_FP32_F,
      start_req => Posit16_to_FP32_start_req,
      start_ack => Posit16_to_FP32_start_ack,
      fin_req => Posit16_to_FP32_fin_req,
      fin_ack => Posit16_to_FP32_fin_ack,
      clk => clk,
      reset => reset,
      tag_in => Posit16_to_FP32_tag_in,
      tag_out => Posit16_to_FP32_tag_out-- 
    ); -- 
  -- gated clock generators 
  -- 
end ahir_system_arch;
