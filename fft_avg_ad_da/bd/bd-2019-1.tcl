
################################################################
# This is a generated script based on design: d_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2019.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source d_1_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xczu28dr-ffvg1517-2-e
   set_property BOARD_PART xilinx.com:zcu111:part0:1.1 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name d_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:axi_dma:7.1\
xilinx.com:ip:smartconnect:1.0\
user.org:user:axis_buffer_uram:1.0\
user.org:user:axis_chsel_pfb_x1:1.0\
user.org:user:axis_combiner_nb:1.0\
user.org:user:axis_constant_iq:1.0\
user.org:user:axis_pimod_pfb_x1:1.0\
xilinx.com:ip:axis_broadcaster:1.1\
user.org:user:axis_ssrfft_16x16:1.0\
user.org:user:axis_switch_pfb_x1:1.0\
user.org:user:axis_xfft_16x32768:1.0\
user.org:user:axis_z1_nb:1.0\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:axis_combiner:1.1\
xilinx.com:ip:fir_compiler:7.2\
xilinx.com:ip:axis_register_slice:1.1\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:usp_rf_data_converter:2.1\
xilinx.com:ip:zynq_ultra_ps_e:3.3\
"

   set list_ips_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set adc2_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 adc2_clk ]

  set dac1_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 dac1_clk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {384000000.0} \
   ] $dac1_clk

  set sysref_in [ create_bd_intf_port -mode Slave -vlnv xilinx.com:display_usp_rf_data_converter:diff_pins_rtl:1.0 sysref_in ]

  set vin2_01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin2_01 ]

  set vin2_23 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin2_23 ]

  set vout13 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vout13 ]


  # Create ports

  # Create instance: axi_dma_1, and set properties
  set axi_dma_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_1 ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $axi_dma_1

  # Create instance: axi_smc, and set properties
  set axi_smc [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_smc ]
  set_property -dict [ list \
   CONFIG.NUM_SI {2} \
 ] $axi_smc

  # Create instance: axis_buffer_uram_0, and set properties
  set axis_buffer_uram_0 [ create_bd_cell -type ip -vlnv user.org:user:axis_buffer_uram:1.0 axis_buffer_uram_0 ]
  set_property -dict [ list \
   CONFIG.N {16} \
 ] $axis_buffer_uram_0

  # Create instance: axis_chsel_pfb_x1_0, and set properties
  set axis_chsel_pfb_x1_0 [ create_bd_cell -type ip -vlnv user.org:user:axis_chsel_pfb_x1:1.0 axis_chsel_pfb_x1_0 ]
  set_property -dict [ list \
   CONFIG.N {16} \
 ] $axis_chsel_pfb_x1_0

  # Create instance: axis_combiner_nb_0, and set properties
  set axis_combiner_nb_0 [ create_bd_cell -type ip -vlnv user.org:user:axis_combiner_nb:1.0 axis_combiner_nb_0 ]
  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.N {16} \
 ] $axis_combiner_nb_0

  # Create instance: axis_constant_iq_0, and set properties
  set axis_constant_iq_0 [ create_bd_cell -type ip -vlnv user.org:user:axis_constant_iq:1.0 axis_constant_iq_0 ]
  set_property -dict [ list \
   CONFIG.N {8} \
 ] $axis_constant_iq_0

  # Create instance: axis_pimod_pfb_x1_0, and set properties
  set axis_pimod_pfb_x1_0 [ create_bd_cell -type ip -vlnv user.org:user:axis_pimod_pfb_x1:1.0 axis_pimod_pfb_x1_0 ]
  set_property -dict [ list \
   CONFIG.N {16} \
 ] $axis_pimod_pfb_x1_0

  # Create instance: axis_split_iq, and set properties
  set axis_split_iq [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_broadcaster:1.1 axis_split_iq ]
  set_property -dict [ list \
   CONFIG.M00_TDATA_REMAP {tdata[143:128],tdata[15:0]} \
   CONFIG.M01_TDATA_REMAP {tdata[159:144],tdata[31:16]} \
   CONFIG.M02_TDATA_REMAP {tdata[175:160],tdata[47:32]} \
   CONFIG.M03_TDATA_REMAP {tdata[191:176],tdata[63:48]} \
   CONFIG.M04_TDATA_REMAP {tdata[207:192],tdata[79:64]} \
   CONFIG.M05_TDATA_REMAP {tdata[223:208],tdata[95:80]} \
   CONFIG.M06_TDATA_REMAP {tdata[239:224],tdata[111:96]} \
   CONFIG.M07_TDATA_REMAP {tdata[255:240],tdata[127:112]} \
   CONFIG.M_TDATA_NUM_BYTES {4} \
   CONFIG.NUM_MI {8} \
   CONFIG.S_TDATA_NUM_BYTES {32} \
 ] $axis_split_iq

  # Create instance: axis_ssrfft_16x16_0, and set properties
  set axis_ssrfft_16x16_0 [ create_bd_cell -type ip -vlnv user.org:user:axis_ssrfft_16x16:1.0 axis_ssrfft_16x16_0 ]

  # Create instance: axis_switch_pfb_x1_0, and set properties
  set axis_switch_pfb_x1_0 [ create_bd_cell -type ip -vlnv user.org:user:axis_switch_pfb_x1:1.0 axis_switch_pfb_x1_0 ]
  set_property -dict [ list \
   CONFIG.L {8} \
 ] $axis_switch_pfb_x1_0

  # Create instance: axis_xfft_16x32768_0, and set properties
  set axis_xfft_16x32768_0 [ create_bd_cell -type ip -vlnv user.org:user:axis_xfft_16x32768:1.0 axis_xfft_16x32768_0 ]

  # Create instance: axis_z1_nb_0, and set properties
  set axis_z1_nb_0 [ create_bd_cell -type ip -vlnv user.org:user:axis_z1_nb:1.0 axis_z1_nb_0 ]
  set_property -dict [ list \
   CONFIG.B {32} \
 ] $axis_z1_nb_0

  # Create instance: axis_z1_nb_1, and set properties
  set axis_z1_nb_1 [ create_bd_cell -type ip -vlnv user.org:user:axis_z1_nb:1.0 axis_z1_nb_1 ]
  set_property -dict [ list \
   CONFIG.B {32} \
 ] $axis_z1_nb_1

  # Create instance: axis_z1_nb_2, and set properties
  set axis_z1_nb_2 [ create_bd_cell -type ip -vlnv user.org:user:axis_z1_nb:1.0 axis_z1_nb_2 ]
  set_property -dict [ list \
   CONFIG.B {32} \
 ] $axis_z1_nb_2

  # Create instance: axis_z1_nb_3, and set properties
  set axis_z1_nb_3 [ create_bd_cell -type ip -vlnv user.org:user:axis_z1_nb:1.0 axis_z1_nb_3 ]
  set_property -dict [ list \
   CONFIG.B {32} \
 ] $axis_z1_nb_3

  # Create instance: axis_z1_nb_4, and set properties
  set axis_z1_nb_4 [ create_bd_cell -type ip -vlnv user.org:user:axis_z1_nb:1.0 axis_z1_nb_4 ]
  set_property -dict [ list \
   CONFIG.B {32} \
 ] $axis_z1_nb_4

  # Create instance: axis_z1_nb_5, and set properties
  set axis_z1_nb_5 [ create_bd_cell -type ip -vlnv user.org:user:axis_z1_nb:1.0 axis_z1_nb_5 ]
  set_property -dict [ list \
   CONFIG.B {32} \
 ] $axis_z1_nb_5

  # Create instance: axis_z1_nb_6, and set properties
  set axis_z1_nb_6 [ create_bd_cell -type ip -vlnv user.org:user:axis_z1_nb:1.0 axis_z1_nb_6 ]
  set_property -dict [ list \
   CONFIG.B {32} \
 ] $axis_z1_nb_6

  # Create instance: axis_z1_nb_7, and set properties
  set axis_z1_nb_7 [ create_bd_cell -type ip -vlnv user.org:user:axis_z1_nb:1.0 axis_z1_nb_7 ]
  set_property -dict [ list \
   CONFIG.B {32} \
 ] $axis_z1_nb_7

  # Create instance: clk_adc2_x2, and set properties
  set clk_adc2_x2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_adc2_x2 ]
  set_property -dict [ list \
   CONFIG.CLKOUT1_JITTER {81.938} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {384} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {3.125} \
 ] $clk_adc2_x2

  # Create instance: combiner_iq, and set properties
  set combiner_iq [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_combiner:1.1 combiner_iq ]

  # Create instance: fir_0, and set properties
  set fir_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 fir_0 ]
  set_property -dict [ list \
   CONFIG.BestPrecision {false} \
   CONFIG.Clock_Frequency {300.0} \
   CONFIG.CoefficientSource {COE_File} \
   CONFIG.CoefficientVector {6,0,-4,-3,5,6,-6,-13,7,44,64,44,7,-13,-6,6,5,-3,-4,0,6} \
   CONFIG.Coefficient_File {../../../../../../../coe/hp_fir_0.coe} \
   CONFIG.Coefficient_Fractional_Bits {0} \
   CONFIG.Coefficient_Sets {1} \
   CONFIG.Coefficient_Sign {Signed} \
   CONFIG.Coefficient_Structure {Inferred} \
   CONFIG.Coefficient_Width {16} \
   CONFIG.ColumnConfig {7} \
   CONFIG.DATA_Has_TLAST {Not_Required} \
   CONFIG.Data_Width {16} \
   CONFIG.Decimation_Rate {1} \
   CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
   CONFIG.Filter_Selection {1} \
   CONFIG.Filter_Type {Interpolated} \
   CONFIG.Interpolation_Rate {1} \
   CONFIG.M_DATA_Has_TUSER {Not_Required} \
   CONFIG.Number_Channels {1} \
   CONFIG.Number_Paths {2} \
   CONFIG.Output_Rounding_Mode {Symmetric_Rounding_to_Zero} \
   CONFIG.Output_Width {16} \
   CONFIG.Quantization {Integer_Coefficients} \
   CONFIG.RateSpecification {Input_Sample_Period} \
   CONFIG.S_CONFIG_Method {Single} \
   CONFIG.S_DATA_Has_TUSER {Not_Required} \
   CONFIG.SamplePeriod {1} \
   CONFIG.Sample_Frequency {0.001} \
   CONFIG.Select_Pattern {All} \
   CONFIG.Zero_Pack_Factor {2} \
 ] $fir_0

  # Create instance: fir_1, and set properties
  set fir_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 fir_1 ]
  set_property -dict [ list \
   CONFIG.BestPrecision {false} \
   CONFIG.Clock_Frequency {300.0} \
   CONFIG.CoefficientSource {COE_File} \
   CONFIG.CoefficientVector {6,0,-4,-3,5,6,-6,-13,7,44,64,44,7,-13,-6,6,5,-3,-4,0,6} \
   CONFIG.Coefficient_File {../../../../../../../coe/hp_fir_1.coe} \
   CONFIG.Coefficient_Fractional_Bits {0} \
   CONFIG.Coefficient_Sets {1} \
   CONFIG.Coefficient_Sign {Signed} \
   CONFIG.Coefficient_Structure {Inferred} \
   CONFIG.Coefficient_Width {16} \
   CONFIG.ColumnConfig {7} \
   CONFIG.DATA_Has_TLAST {Not_Required} \
   CONFIG.Data_Width {16} \
   CONFIG.Decimation_Rate {1} \
   CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
   CONFIG.Filter_Selection {1} \
   CONFIG.Filter_Type {Interpolated} \
   CONFIG.Interpolation_Rate {1} \
   CONFIG.M_DATA_Has_TUSER {Not_Required} \
   CONFIG.Number_Channels {1} \
   CONFIG.Number_Paths {2} \
   CONFIG.Output_Rounding_Mode {Symmetric_Rounding_to_Zero} \
   CONFIG.Output_Width {16} \
   CONFIG.Quantization {Integer_Coefficients} \
   CONFIG.RateSpecification {Input_Sample_Period} \
   CONFIG.S_CONFIG_Method {Single} \
   CONFIG.S_DATA_Has_TUSER {Not_Required} \
   CONFIG.SamplePeriod {1} \
   CONFIG.Sample_Frequency {0.001} \
   CONFIG.Select_Pattern {All} \
   CONFIG.Zero_Pack_Factor {2} \
 ] $fir_1

  # Create instance: fir_2, and set properties
  set fir_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 fir_2 ]
  set_property -dict [ list \
   CONFIG.BestPrecision {false} \
   CONFIG.Clock_Frequency {300.0} \
   CONFIG.CoefficientSource {COE_File} \
   CONFIG.CoefficientVector {6,0,-4,-3,5,6,-6,-13,7,44,64,44,7,-13,-6,6,5,-3,-4,0,6} \
   CONFIG.Coefficient_File {../../../../../../../coe/hp_fir_2.coe} \
   CONFIG.Coefficient_Fractional_Bits {0} \
   CONFIG.Coefficient_Sets {1} \
   CONFIG.Coefficient_Sign {Signed} \
   CONFIG.Coefficient_Structure {Inferred} \
   CONFIG.Coefficient_Width {16} \
   CONFIG.ColumnConfig {7} \
   CONFIG.DATA_Has_TLAST {Not_Required} \
   CONFIG.Data_Width {16} \
   CONFIG.Decimation_Rate {1} \
   CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
   CONFIG.Filter_Selection {1} \
   CONFIG.Filter_Type {Interpolated} \
   CONFIG.Interpolation_Rate {1} \
   CONFIG.M_DATA_Has_TUSER {Not_Required} \
   CONFIG.Number_Channels {1} \
   CONFIG.Number_Paths {2} \
   CONFIG.Output_Rounding_Mode {Symmetric_Rounding_to_Zero} \
   CONFIG.Output_Width {16} \
   CONFIG.Quantization {Integer_Coefficients} \
   CONFIG.RateSpecification {Input_Sample_Period} \
   CONFIG.S_CONFIG_Method {Single} \
   CONFIG.S_DATA_Has_TUSER {Not_Required} \
   CONFIG.SamplePeriod {1} \
   CONFIG.Sample_Frequency {0.001} \
   CONFIG.Select_Pattern {All} \
   CONFIG.Zero_Pack_Factor {2} \
 ] $fir_2

  # Create instance: fir_3, and set properties
  set fir_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 fir_3 ]
  set_property -dict [ list \
   CONFIG.BestPrecision {false} \
   CONFIG.Clock_Frequency {300.0} \
   CONFIG.CoefficientSource {COE_File} \
   CONFIG.CoefficientVector {6,0,-4,-3,5,6,-6,-13,7,44,64,44,7,-13,-6,6,5,-3,-4,0,6} \
   CONFIG.Coefficient_File {../../../../../../../coe/hp_fir_3.coe} \
   CONFIG.Coefficient_Fractional_Bits {0} \
   CONFIG.Coefficient_Sets {1} \
   CONFIG.Coefficient_Sign {Signed} \
   CONFIG.Coefficient_Structure {Inferred} \
   CONFIG.Coefficient_Width {16} \
   CONFIG.ColumnConfig {7} \
   CONFIG.DATA_Has_TLAST {Not_Required} \
   CONFIG.Data_Width {16} \
   CONFIG.Decimation_Rate {1} \
   CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
   CONFIG.Filter_Selection {1} \
   CONFIG.Filter_Type {Interpolated} \
   CONFIG.Interpolation_Rate {1} \
   CONFIG.M_DATA_Has_TUSER {Not_Required} \
   CONFIG.Number_Channels {1} \
   CONFIG.Number_Paths {2} \
   CONFIG.Output_Rounding_Mode {Symmetric_Rounding_to_Zero} \
   CONFIG.Output_Width {16} \
   CONFIG.Quantization {Integer_Coefficients} \
   CONFIG.RateSpecification {Input_Sample_Period} \
   CONFIG.S_CONFIG_Method {Single} \
   CONFIG.S_DATA_Has_TUSER {Not_Required} \
   CONFIG.SamplePeriod {1} \
   CONFIG.Sample_Frequency {0.001} \
   CONFIG.Select_Pattern {All} \
   CONFIG.Zero_Pack_Factor {2} \
 ] $fir_3

  # Create instance: fir_4, and set properties
  set fir_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 fir_4 ]
  set_property -dict [ list \
   CONFIG.BestPrecision {false} \
   CONFIG.Clock_Frequency {300.0} \
   CONFIG.CoefficientSource {COE_File} \
   CONFIG.CoefficientVector {6,0,-4,-3,5,6,-6,-13,7,44,64,44,7,-13,-6,6,5,-3,-4,0,6} \
   CONFIG.Coefficient_File {../../../../../../../coe/hp_fir_4.coe} \
   CONFIG.Coefficient_Fractional_Bits {0} \
   CONFIG.Coefficient_Sets {1} \
   CONFIG.Coefficient_Sign {Signed} \
   CONFIG.Coefficient_Structure {Inferred} \
   CONFIG.Coefficient_Width {16} \
   CONFIG.ColumnConfig {7} \
   CONFIG.DATA_Has_TLAST {Not_Required} \
   CONFIG.Data_Width {16} \
   CONFIG.Decimation_Rate {1} \
   CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
   CONFIG.Filter_Selection {1} \
   CONFIG.Filter_Type {Interpolated} \
   CONFIG.Interpolation_Rate {1} \
   CONFIG.M_DATA_Has_TUSER {Not_Required} \
   CONFIG.Number_Channels {1} \
   CONFIG.Number_Paths {2} \
   CONFIG.Output_Rounding_Mode {Symmetric_Rounding_to_Zero} \
   CONFIG.Output_Width {16} \
   CONFIG.Quantization {Integer_Coefficients} \
   CONFIG.RateSpecification {Input_Sample_Period} \
   CONFIG.S_CONFIG_Method {Single} \
   CONFIG.S_DATA_Has_TUSER {Not_Required} \
   CONFIG.SamplePeriod {1} \
   CONFIG.Sample_Frequency {0.001} \
   CONFIG.Select_Pattern {All} \
   CONFIG.Zero_Pack_Factor {2} \
 ] $fir_4

  # Create instance: fir_5, and set properties
  set fir_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 fir_5 ]
  set_property -dict [ list \
   CONFIG.BestPrecision {false} \
   CONFIG.Clock_Frequency {300.0} \
   CONFIG.CoefficientSource {COE_File} \
   CONFIG.CoefficientVector {6,0,-4,-3,5,6,-6,-13,7,44,64,44,7,-13,-6,6,5,-3,-4,0,6} \
   CONFIG.Coefficient_File {../../../../../../../coe/hp_fir_5.coe} \
   CONFIG.Coefficient_Fractional_Bits {0} \
   CONFIG.Coefficient_Sets {1} \
   CONFIG.Coefficient_Sign {Signed} \
   CONFIG.Coefficient_Structure {Inferred} \
   CONFIG.Coefficient_Width {16} \
   CONFIG.ColumnConfig {7} \
   CONFIG.DATA_Has_TLAST {Not_Required} \
   CONFIG.Data_Width {16} \
   CONFIG.Decimation_Rate {1} \
   CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
   CONFIG.Filter_Selection {1} \
   CONFIG.Filter_Type {Interpolated} \
   CONFIG.Interpolation_Rate {1} \
   CONFIG.M_DATA_Has_TUSER {Not_Required} \
   CONFIG.Number_Channels {1} \
   CONFIG.Number_Paths {2} \
   CONFIG.Output_Rounding_Mode {Symmetric_Rounding_to_Zero} \
   CONFIG.Output_Width {16} \
   CONFIG.Quantization {Integer_Coefficients} \
   CONFIG.RateSpecification {Input_Sample_Period} \
   CONFIG.S_CONFIG_Method {Single} \
   CONFIG.S_DATA_Has_TUSER {Not_Required} \
   CONFIG.SamplePeriod {1} \
   CONFIG.Sample_Frequency {0.001} \
   CONFIG.Select_Pattern {All} \
   CONFIG.Zero_Pack_Factor {2} \
 ] $fir_5

  # Create instance: fir_6, and set properties
  set fir_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 fir_6 ]
  set_property -dict [ list \
   CONFIG.BestPrecision {false} \
   CONFIG.Clock_Frequency {300.0} \
   CONFIG.CoefficientSource {COE_File} \
   CONFIG.CoefficientVector {6,0,-4,-3,5,6,-6,-13,7,44,64,44,7,-13,-6,6,5,-3,-4,0,6} \
   CONFIG.Coefficient_File {../../../../../../../coe/hp_fir_6.coe} \
   CONFIG.Coefficient_Fractional_Bits {0} \
   CONFIG.Coefficient_Sets {1} \
   CONFIG.Coefficient_Sign {Signed} \
   CONFIG.Coefficient_Structure {Inferred} \
   CONFIG.Coefficient_Width {16} \
   CONFIG.ColumnConfig {7} \
   CONFIG.DATA_Has_TLAST {Not_Required} \
   CONFIG.Data_Width {16} \
   CONFIG.Decimation_Rate {1} \
   CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
   CONFIG.Filter_Selection {1} \
   CONFIG.Filter_Type {Interpolated} \
   CONFIG.Interpolation_Rate {1} \
   CONFIG.M_DATA_Has_TUSER {Not_Required} \
   CONFIG.Number_Channels {1} \
   CONFIG.Number_Paths {2} \
   CONFIG.Output_Rounding_Mode {Symmetric_Rounding_to_Zero} \
   CONFIG.Output_Width {16} \
   CONFIG.Quantization {Integer_Coefficients} \
   CONFIG.RateSpecification {Input_Sample_Period} \
   CONFIG.S_CONFIG_Method {Single} \
   CONFIG.S_DATA_Has_TUSER {Not_Required} \
   CONFIG.SamplePeriod {1} \
   CONFIG.Sample_Frequency {0.001} \
   CONFIG.Select_Pattern {All} \
   CONFIG.Zero_Pack_Factor {2} \
 ] $fir_6

  # Create instance: fir_7, and set properties
  set fir_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 fir_7 ]
  set_property -dict [ list \
   CONFIG.BestPrecision {false} \
   CONFIG.Clock_Frequency {300.0} \
   CONFIG.CoefficientSource {COE_File} \
   CONFIG.CoefficientVector {6,0,-4,-3,5,6,-6,-13,7,44,64,44,7,-13,-6,6,5,-3,-4,0,6} \
   CONFIG.Coefficient_File {../../../../../../../coe/hp_fir_7.coe} \
   CONFIG.Coefficient_Fractional_Bits {0} \
   CONFIG.Coefficient_Sets {1} \
   CONFIG.Coefficient_Sign {Signed} \
   CONFIG.Coefficient_Structure {Inferred} \
   CONFIG.Coefficient_Width {16} \
   CONFIG.ColumnConfig {7} \
   CONFIG.DATA_Has_TLAST {Not_Required} \
   CONFIG.Data_Width {16} \
   CONFIG.Decimation_Rate {1} \
   CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
   CONFIG.Filter_Selection {1} \
   CONFIG.Filter_Type {Interpolated} \
   CONFIG.Interpolation_Rate {1} \
   CONFIG.M_DATA_Has_TUSER {Not_Required} \
   CONFIG.Number_Channels {1} \
   CONFIG.Number_Paths {2} \
   CONFIG.Output_Rounding_Mode {Symmetric_Rounding_to_Zero} \
   CONFIG.Output_Width {16} \
   CONFIG.Quantization {Integer_Coefficients} \
   CONFIG.RateSpecification {Input_Sample_Period} \
   CONFIG.S_CONFIG_Method {Single} \
   CONFIG.S_DATA_Has_TUSER {Not_Required} \
   CONFIG.SamplePeriod {1} \
   CONFIG.Sample_Frequency {0.001} \
   CONFIG.Select_Pattern {All} \
   CONFIG.Zero_Pack_Factor {2} \
 ] $fir_7

  # Create instance: fir_8, and set properties
  set fir_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 fir_8 ]
  set_property -dict [ list \
   CONFIG.BestPrecision {false} \
   CONFIG.Clock_Frequency {300.0} \
   CONFIG.CoefficientSource {COE_File} \
   CONFIG.CoefficientVector {6,0,-4,-3,5,6,-6,-13,7,44,64,44,7,-13,-6,6,5,-3,-4,0,6} \
   CONFIG.Coefficient_File {../../../../../../../coe/hp_fir_8.coe} \
   CONFIG.Coefficient_Fractional_Bits {0} \
   CONFIG.Coefficient_Sets {1} \
   CONFIG.Coefficient_Sign {Signed} \
   CONFIG.Coefficient_Structure {Inferred} \
   CONFIG.Coefficient_Width {16} \
   CONFIG.ColumnConfig {7} \
   CONFIG.DATA_Has_TLAST {Not_Required} \
   CONFIG.Data_Width {16} \
   CONFIG.Decimation_Rate {1} \
   CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
   CONFIG.Filter_Selection {1} \
   CONFIG.Filter_Type {Interpolated} \
   CONFIG.Interpolation_Rate {1} \
   CONFIG.M_DATA_Has_TUSER {Not_Required} \
   CONFIG.Number_Channels {1} \
   CONFIG.Number_Paths {2} \
   CONFIG.Output_Rounding_Mode {Symmetric_Rounding_to_Zero} \
   CONFIG.Output_Width {16} \
   CONFIG.Quantization {Integer_Coefficients} \
   CONFIG.RateSpecification {Input_Sample_Period} \
   CONFIG.S_CONFIG_Method {Single} \
   CONFIG.S_DATA_Has_TUSER {Not_Required} \
   CONFIG.SamplePeriod {1} \
   CONFIG.Sample_Frequency {0.001} \
   CONFIG.Select_Pattern {All} \
   CONFIG.Zero_Pack_Factor {2} \
 ] $fir_8

  # Create instance: fir_9, and set properties
  set fir_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 fir_9 ]
  set_property -dict [ list \
   CONFIG.Clock_Frequency {300.0} \
   CONFIG.CoefficientSource {COE_File} \
   CONFIG.CoefficientVector {6,0,-4,-3,5,6,-6,-13,7,44,64,44,7,-13,-6,6,5,-3,-4,0,6} \
   CONFIG.Coefficient_File {../../../../../../../coe/hp_fir_9.coe} \
   CONFIG.Coefficient_Fractional_Bits {0} \
   CONFIG.Coefficient_Sets {1} \
   CONFIG.Coefficient_Sign {Signed} \
   CONFIG.Coefficient_Structure {Inferred} \
   CONFIG.Coefficient_Width {16} \
   CONFIG.ColumnConfig {7} \
   CONFIG.DATA_Has_TLAST {Not_Required} \
   CONFIG.Data_Width {16} \
   CONFIG.Decimation_Rate {1} \
   CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
   CONFIG.Filter_Selection {1} \
   CONFIG.Filter_Type {Interpolated} \
   CONFIG.Interpolation_Rate {1} \
   CONFIG.M_DATA_Has_TUSER {Not_Required} \
   CONFIG.Number_Channels {1} \
   CONFIG.Number_Paths {2} \
   CONFIG.Output_Rounding_Mode {Symmetric_Rounding_to_Zero} \
   CONFIG.Output_Width {16} \
   CONFIG.Quantization {Integer_Coefficients} \
   CONFIG.RateSpecification {Input_Sample_Period} \
   CONFIG.S_CONFIG_Method {Single} \
   CONFIG.S_DATA_Has_TUSER {Not_Required} \
   CONFIG.SamplePeriod {1} \
   CONFIG.Sample_Frequency {0.001} \
   CONFIG.Select_Pattern {All} \
   CONFIG.Zero_Pack_Factor {2} \
 ] $fir_9

  # Create instance: fir_10, and set properties
  set fir_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 fir_10 ]
  set_property -dict [ list \
   CONFIG.Clock_Frequency {300.0} \
   CONFIG.CoefficientSource {COE_File} \
   CONFIG.CoefficientVector {6,0,-4,-3,5,6,-6,-13,7,44,64,44,7,-13,-6,6,5,-3,-4,0,6} \
   CONFIG.Coefficient_File {../../../../../../../coe/hp_fir_10.coe} \
   CONFIG.Coefficient_Fractional_Bits {0} \
   CONFIG.Coefficient_Sets {1} \
   CONFIG.Coefficient_Sign {Signed} \
   CONFIG.Coefficient_Structure {Inferred} \
   CONFIG.Coefficient_Width {16} \
   CONFIG.ColumnConfig {7} \
   CONFIG.DATA_Has_TLAST {Not_Required} \
   CONFIG.Data_Width {16} \
   CONFIG.Decimation_Rate {1} \
   CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
   CONFIG.Filter_Selection {1} \
   CONFIG.Filter_Type {Interpolated} \
   CONFIG.Interpolation_Rate {1} \
   CONFIG.M_DATA_Has_TUSER {Not_Required} \
   CONFIG.Number_Channels {1} \
   CONFIG.Number_Paths {2} \
   CONFIG.Output_Rounding_Mode {Symmetric_Rounding_to_Zero} \
   CONFIG.Output_Width {16} \
   CONFIG.Quantization {Integer_Coefficients} \
   CONFIG.RateSpecification {Input_Sample_Period} \
   CONFIG.S_CONFIG_Method {Single} \
   CONFIG.S_DATA_Has_TUSER {Not_Required} \
   CONFIG.SamplePeriod {1} \
   CONFIG.Sample_Frequency {0.001} \
   CONFIG.Select_Pattern {All} \
   CONFIG.Zero_Pack_Factor {2} \
 ] $fir_10

  # Create instance: fir_11, and set properties
  set fir_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 fir_11 ]
  set_property -dict [ list \
   CONFIG.Clock_Frequency {300.0} \
   CONFIG.CoefficientSource {COE_File} \
   CONFIG.CoefficientVector {6,0,-4,-3,5,6,-6,-13,7,44,64,44,7,-13,-6,6,5,-3,-4,0,6} \
   CONFIG.Coefficient_File {../../../../../../../coe/hp_fir_11.coe} \
   CONFIG.Coefficient_Fractional_Bits {0} \
   CONFIG.Coefficient_Sets {1} \
   CONFIG.Coefficient_Sign {Signed} \
   CONFIG.Coefficient_Structure {Inferred} \
   CONFIG.Coefficient_Width {16} \
   CONFIG.ColumnConfig {7} \
   CONFIG.DATA_Has_TLAST {Not_Required} \
   CONFIG.Data_Width {16} \
   CONFIG.Decimation_Rate {1} \
   CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
   CONFIG.Filter_Selection {1} \
   CONFIG.Filter_Type {Interpolated} \
   CONFIG.Interpolation_Rate {1} \
   CONFIG.M_DATA_Has_TUSER {Not_Required} \
   CONFIG.Number_Channels {1} \
   CONFIG.Number_Paths {2} \
   CONFIG.Output_Rounding_Mode {Symmetric_Rounding_to_Zero} \
   CONFIG.Output_Width {16} \
   CONFIG.Quantization {Integer_Coefficients} \
   CONFIG.RateSpecification {Input_Sample_Period} \
   CONFIG.S_CONFIG_Method {Single} \
   CONFIG.S_DATA_Has_TUSER {Not_Required} \
   CONFIG.SamplePeriod {1} \
   CONFIG.Sample_Frequency {0.001} \
   CONFIG.Select_Pattern {All} \
   CONFIG.Zero_Pack_Factor {2} \
 ] $fir_11

  # Create instance: fir_12, and set properties
  set fir_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 fir_12 ]
  set_property -dict [ list \
   CONFIG.Clock_Frequency {300.0} \
   CONFIG.CoefficientSource {COE_File} \
   CONFIG.CoefficientVector {6,0,-4,-3,5,6,-6,-13,7,44,64,44,7,-13,-6,6,5,-3,-4,0,6} \
   CONFIG.Coefficient_File {../../../../../../../coe/hp_fir_12.coe} \
   CONFIG.Coefficient_Fractional_Bits {0} \
   CONFIG.Coefficient_Sets {1} \
   CONFIG.Coefficient_Sign {Signed} \
   CONFIG.Coefficient_Structure {Inferred} \
   CONFIG.Coefficient_Width {16} \
   CONFIG.ColumnConfig {7} \
   CONFIG.DATA_Has_TLAST {Not_Required} \
   CONFIG.Data_Width {16} \
   CONFIG.Decimation_Rate {1} \
   CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
   CONFIG.Filter_Selection {1} \
   CONFIG.Filter_Type {Interpolated} \
   CONFIG.Interpolation_Rate {1} \
   CONFIG.M_DATA_Has_TUSER {Not_Required} \
   CONFIG.Number_Channels {1} \
   CONFIG.Number_Paths {2} \
   CONFIG.Output_Rounding_Mode {Symmetric_Rounding_to_Zero} \
   CONFIG.Output_Width {16} \
   CONFIG.Quantization {Integer_Coefficients} \
   CONFIG.RateSpecification {Input_Sample_Period} \
   CONFIG.S_CONFIG_Method {Single} \
   CONFIG.S_DATA_Has_TUSER {Not_Required} \
   CONFIG.SamplePeriod {1} \
   CONFIG.Sample_Frequency {0.001} \
   CONFIG.Select_Pattern {All} \
   CONFIG.Zero_Pack_Factor {2} \
 ] $fir_12

  # Create instance: fir_13, and set properties
  set fir_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 fir_13 ]
  set_property -dict [ list \
   CONFIG.Clock_Frequency {300.0} \
   CONFIG.CoefficientSource {COE_File} \
   CONFIG.CoefficientVector {6,0,-4,-3,5,6,-6,-13,7,44,64,44,7,-13,-6,6,5,-3,-4,0,6} \
   CONFIG.Coefficient_File {../../../../../../../coe/hp_fir_13.coe} \
   CONFIG.Coefficient_Fractional_Bits {0} \
   CONFIG.Coefficient_Sets {1} \
   CONFIG.Coefficient_Sign {Signed} \
   CONFIG.Coefficient_Structure {Inferred} \
   CONFIG.Coefficient_Width {16} \
   CONFIG.ColumnConfig {7} \
   CONFIG.DATA_Has_TLAST {Not_Required} \
   CONFIG.Data_Width {16} \
   CONFIG.Decimation_Rate {1} \
   CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
   CONFIG.Filter_Selection {1} \
   CONFIG.Filter_Type {Interpolated} \
   CONFIG.Interpolation_Rate {1} \
   CONFIG.M_DATA_Has_TUSER {Not_Required} \
   CONFIG.Number_Channels {1} \
   CONFIG.Number_Paths {2} \
   CONFIG.Output_Rounding_Mode {Symmetric_Rounding_to_Zero} \
   CONFIG.Output_Width {16} \
   CONFIG.Quantization {Integer_Coefficients} \
   CONFIG.RateSpecification {Input_Sample_Period} \
   CONFIG.S_CONFIG_Method {Single} \
   CONFIG.S_DATA_Has_TUSER {Not_Required} \
   CONFIG.SamplePeriod {1} \
   CONFIG.Sample_Frequency {0.001} \
   CONFIG.Select_Pattern {All} \
   CONFIG.Zero_Pack_Factor {2} \
 ] $fir_13

  # Create instance: fir_14, and set properties
  set fir_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 fir_14 ]
  set_property -dict [ list \
   CONFIG.Clock_Frequency {300.0} \
   CONFIG.CoefficientSource {COE_File} \
   CONFIG.CoefficientVector {6,0,-4,-3,5,6,-6,-13,7,44,64,44,7,-13,-6,6,5,-3,-4,0,6} \
   CONFIG.Coefficient_File {../../../../../../../coe/hp_fir_14.coe} \
   CONFIG.Coefficient_Fractional_Bits {0} \
   CONFIG.Coefficient_Sets {1} \
   CONFIG.Coefficient_Sign {Signed} \
   CONFIG.Coefficient_Structure {Inferred} \
   CONFIG.Coefficient_Width {16} \
   CONFIG.ColumnConfig {7} \
   CONFIG.DATA_Has_TLAST {Not_Required} \
   CONFIG.Data_Width {16} \
   CONFIG.Decimation_Rate {1} \
   CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
   CONFIG.Filter_Selection {1} \
   CONFIG.Filter_Type {Interpolated} \
   CONFIG.Interpolation_Rate {1} \
   CONFIG.M_DATA_Has_TUSER {Not_Required} \
   CONFIG.Number_Channels {1} \
   CONFIG.Number_Paths {2} \
   CONFIG.Output_Rounding_Mode {Symmetric_Rounding_to_Zero} \
   CONFIG.Output_Width {16} \
   CONFIG.Quantization {Integer_Coefficients} \
   CONFIG.RateSpecification {Input_Sample_Period} \
   CONFIG.S_CONFIG_Method {Single} \
   CONFIG.S_DATA_Has_TUSER {Not_Required} \
   CONFIG.SamplePeriod {1} \
   CONFIG.Sample_Frequency {0.001} \
   CONFIG.Select_Pattern {All} \
   CONFIG.Zero_Pack_Factor {2} \
 ] $fir_14

  # Create instance: fir_15, and set properties
  set fir_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 fir_15 ]
  set_property -dict [ list \
   CONFIG.Clock_Frequency {300.0} \
   CONFIG.CoefficientSource {COE_File} \
   CONFIG.CoefficientVector {6,0,-4,-3,5,6,-6,-13,7,44,64,44,7,-13,-6,6,5,-3,-4,0,6} \
   CONFIG.Coefficient_File {../../../../../../../coe/hp_fir_15.coe} \
   CONFIG.Coefficient_Fractional_Bits {0} \
   CONFIG.Coefficient_Sets {1} \
   CONFIG.Coefficient_Sign {Signed} \
   CONFIG.Coefficient_Structure {Inferred} \
   CONFIG.Coefficient_Width {16} \
   CONFIG.ColumnConfig {7} \
   CONFIG.DATA_Has_TLAST {Not_Required} \
   CONFIG.Data_Width {16} \
   CONFIG.Decimation_Rate {1} \
   CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
   CONFIG.Filter_Selection {1} \
   CONFIG.Filter_Type {Interpolated} \
   CONFIG.Interpolation_Rate {1} \
   CONFIG.M_DATA_Has_TUSER {Not_Required} \
   CONFIG.Number_Channels {1} \
   CONFIG.Number_Paths {2} \
   CONFIG.Output_Rounding_Mode {Symmetric_Rounding_to_Zero} \
   CONFIG.Output_Width {16} \
   CONFIG.Quantization {Integer_Coefficients} \
   CONFIG.RateSpecification {Input_Sample_Period} \
   CONFIG.S_CONFIG_Method {Single} \
   CONFIG.S_DATA_Has_TUSER {Not_Required} \
   CONFIG.SamplePeriod {1} \
   CONFIG.Sample_Frequency {0.001} \
   CONFIG.Select_Pattern {All} \
   CONFIG.Zero_Pack_Factor {2} \
 ] $fir_15

  # Create instance: ps8_0_axi_periph, and set properties
  set ps8_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps8_0_axi_periph ]
  set_property -dict [ list \
   CONFIG.NUM_MI {7} \
 ] $ps8_0_axi_periph

  # Create instance: reg_0, and set properties
  set reg_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 reg_0 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $reg_0

  # Create instance: reg_1, and set properties
  set reg_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 reg_1 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $reg_1

  # Create instance: reg_2, and set properties
  set reg_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 reg_2 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $reg_2

  # Create instance: reg_3, and set properties
  set reg_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 reg_3 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $reg_3

  # Create instance: reg_4, and set properties
  set reg_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 reg_4 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $reg_4

  # Create instance: reg_5, and set properties
  set reg_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 reg_5 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $reg_5

  # Create instance: reg_6, and set properties
  set reg_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 reg_6 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $reg_6

  # Create instance: reg_7, and set properties
  set reg_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 reg_7 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $reg_7

  # Create instance: reg_8, and set properties
  set reg_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 reg_8 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $reg_8

  # Create instance: reg_9, and set properties
  set reg_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 reg_9 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {1} \
 ] $reg_9

  # Create instance: reg_10, and set properties
  set reg_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 reg_10 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {1} \
 ] $reg_10

  # Create instance: reg_11, and set properties
  set reg_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 reg_11 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {1} \
 ] $reg_11

  # Create instance: reg_12, and set properties
  set reg_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 reg_12 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {1} \
 ] $reg_12

  # Create instance: reg_13, and set properties
  set reg_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 reg_13 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {1} \
 ] $reg_13

  # Create instance: rst_100, and set properties
  set rst_100 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_100 ]

  # Create instance: rst_adc2, and set properties
  set rst_adc2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_adc2 ]

  # Create instance: rst_adc2_x2, and set properties
  set rst_adc2_x2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_adc2_x2 ]

  # Create instance: rst_dac1, and set properties
  set rst_dac1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_dac1 ]

  # Create instance: usp_rf_data_converter_0, and set properties
  set usp_rf_data_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:usp_rf_data_converter:2.1 usp_rf_data_converter_0 ]
  set_property -dict [ list \
   CONFIG.ADC0_Enable {1} \
   CONFIG.ADC0_Fabric_Freq {384.000} \
   CONFIG.ADC0_Outclk_Freq {192.000} \
   CONFIG.ADC0_PLL_Enable {true} \
   CONFIG.ADC0_Refclk_Freq {204.800} \
   CONFIG.ADC0_Sampling_Rate {3.072} \
   CONFIG.ADC2_Enable {0} \
   CONFIG.ADC2_Fabric_Freq {0.0} \
   CONFIG.ADC2_Outclk_Freq {192.000} \
   CONFIG.ADC2_PLL_Enable {false} \
   CONFIG.ADC2_Refclk_Freq {3072.000} \
   CONFIG.ADC2_Sampling_Rate {3.072} \
   CONFIG.ADC_Coarse_Mixer_Freq00 {2} \
   CONFIG.ADC_Coarse_Mixer_Freq01 {2} \
   CONFIG.ADC_Data_Type00 {0} \
   CONFIG.ADC_Data_Type01 {0} \
   CONFIG.ADC_Data_Type02 {0} \
   CONFIG.ADC_Data_Type03 {0} \
   CONFIG.ADC_Decimation_Mode00 {1} \
   CONFIG.ADC_Decimation_Mode01 {1} \
   CONFIG.ADC_Decimation_Mode02 {1} \
   CONFIG.ADC_Decimation_Mode03 {1} \
   CONFIG.ADC_Decimation_Mode20 {0} \
   CONFIG.ADC_Decimation_Mode21 {0} \
   CONFIG.ADC_Decimation_Mode22 {0} \
   CONFIG.ADC_Decimation_Mode23 {0} \
   CONFIG.ADC_Mixer_Mode00 {2} \
   CONFIG.ADC_Mixer_Mode01 {2} \
   CONFIG.ADC_Mixer_Mode02 {2} \
   CONFIG.ADC_Mixer_Mode03 {2} \
   CONFIG.ADC_Mixer_Type00 {0} \
   CONFIG.ADC_Mixer_Type01 {0} \
   CONFIG.ADC_Mixer_Type02 {0} \
   CONFIG.ADC_Mixer_Type03 {0} \
   CONFIG.ADC_Mixer_Type20 {3} \
   CONFIG.ADC_Mixer_Type21 {3} \
   CONFIG.ADC_Mixer_Type22 {3} \
   CONFIG.ADC_Mixer_Type23 {3} \
   CONFIG.ADC_Slice00_Enable {true} \
   CONFIG.ADC_Slice01_Enable {true} \
   CONFIG.ADC_Slice02_Enable {true} \
   CONFIG.ADC_Slice03_Enable {true} \
   CONFIG.ADC_Slice20_Enable {false} \
   CONFIG.ADC_Slice21_Enable {false} \
   CONFIG.ADC_Slice22_Enable {false} \
   CONFIG.ADC_Slice23_Enable {false} \
   CONFIG.DAC0_Enable {0} \
   CONFIG.DAC0_Fabric_Freq {0.0} \
   CONFIG.DAC0_Outclk_Freq {384.000} \
   CONFIG.DAC0_PLL_Enable {false} \
   CONFIG.DAC0_Refclk_Freq {6144.000} \
   CONFIG.DAC0_Sampling_Rate {6.144} \
   CONFIG.DAC1_Enable {1} \
   CONFIG.DAC1_Fabric_Freq {384.000} \
   CONFIG.DAC1_Outclk_Freq {384.000} \
   CONFIG.DAC1_PLL_Enable {true} \
   CONFIG.DAC1_Refclk_Freq {204.800} \
   CONFIG.DAC1_Sampling_Rate {6.144} \
   CONFIG.DAC_Interpolation_Mode00 {0} \
   CONFIG.DAC_Interpolation_Mode01 {0} \
   CONFIG.DAC_Interpolation_Mode13 {2} \
   CONFIG.DAC_Mixer_Mode13 {0} \
   CONFIG.DAC_Mixer_Type00 {3} \
   CONFIG.DAC_Mixer_Type01 {3} \
   CONFIG.DAC_Mixer_Type13 {2} \
   CONFIG.DAC_NCO_Freq13 {1} \
   CONFIG.DAC_Slice00_Enable {false} \
   CONFIG.DAC_Slice01_Enable {false} \
   CONFIG.DAC_Slice13_Enable {true} \
 ] $usp_rf_data_converter_0

  # Create instance: zynq_ultra_ps_e_0, and set properties
  set zynq_ultra_ps_e_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.3 zynq_ultra_ps_e_0 ]
  set_property -dict [ list \
   CONFIG.PSU_BANK_0_IO_STANDARD {LVCMOS18} \
   CONFIG.PSU_BANK_1_IO_STANDARD {LVCMOS18} \
   CONFIG.PSU_BANK_2_IO_STANDARD {LVCMOS18} \
   CONFIG.PSU_DDR_RAM_HIGHADDR {0xFFFFFFFF} \
   CONFIG.PSU_DDR_RAM_HIGHADDR_OFFSET {0x800000000} \
   CONFIG.PSU_DDR_RAM_LOWADDR_OFFSET {0x80000000} \
   CONFIG.PSU_DYNAMIC_DDR_CONFIG_EN {0} \
   CONFIG.PSU_MIO_0_DIRECTION {out} \
   CONFIG.PSU_MIO_0_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_0_POLARITY {Default} \
   CONFIG.PSU_MIO_10_DIRECTION {inout} \
   CONFIG.PSU_MIO_10_POLARITY {Default} \
   CONFIG.PSU_MIO_11_DIRECTION {inout} \
   CONFIG.PSU_MIO_11_POLARITY {Default} \
   CONFIG.PSU_MIO_12_DIRECTION {out} \
   CONFIG.PSU_MIO_12_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_12_POLARITY {Default} \
   CONFIG.PSU_MIO_13_DIRECTION {inout} \
   CONFIG.PSU_MIO_13_POLARITY {Default} \
   CONFIG.PSU_MIO_14_DIRECTION {inout} \
   CONFIG.PSU_MIO_14_POLARITY {Default} \
   CONFIG.PSU_MIO_15_DIRECTION {inout} \
   CONFIG.PSU_MIO_15_POLARITY {Default} \
   CONFIG.PSU_MIO_16_DIRECTION {inout} \
   CONFIG.PSU_MIO_16_POLARITY {Default} \
   CONFIG.PSU_MIO_17_DIRECTION {inout} \
   CONFIG.PSU_MIO_17_POLARITY {Default} \
   CONFIG.PSU_MIO_18_DIRECTION {in} \
   CONFIG.PSU_MIO_18_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_18_POLARITY {Default} \
   CONFIG.PSU_MIO_18_SLEW {fast} \
   CONFIG.PSU_MIO_19_DIRECTION {out} \
   CONFIG.PSU_MIO_19_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_19_POLARITY {Default} \
   CONFIG.PSU_MIO_1_DIRECTION {inout} \
   CONFIG.PSU_MIO_1_POLARITY {Default} \
   CONFIG.PSU_MIO_20_DIRECTION {inout} \
   CONFIG.PSU_MIO_20_POLARITY {Default} \
   CONFIG.PSU_MIO_21_DIRECTION {inout} \
   CONFIG.PSU_MIO_21_POLARITY {Default} \
   CONFIG.PSU_MIO_22_DIRECTION {inout} \
   CONFIG.PSU_MIO_22_POLARITY {Default} \
   CONFIG.PSU_MIO_23_DIRECTION {inout} \
   CONFIG.PSU_MIO_23_POLARITY {Default} \
   CONFIG.PSU_MIO_24_DIRECTION {inout} \
   CONFIG.PSU_MIO_24_POLARITY {Default} \
   CONFIG.PSU_MIO_25_DIRECTION {inout} \
   CONFIG.PSU_MIO_25_POLARITY {Default} \
   CONFIG.PSU_MIO_26_DIRECTION {inout} \
   CONFIG.PSU_MIO_26_POLARITY {Default} \
   CONFIG.PSU_MIO_27_DIRECTION {out} \
   CONFIG.PSU_MIO_27_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_27_POLARITY {Default} \
   CONFIG.PSU_MIO_28_DIRECTION {in} \
   CONFIG.PSU_MIO_28_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_28_POLARITY {Default} \
   CONFIG.PSU_MIO_28_SLEW {fast} \
   CONFIG.PSU_MIO_29_DIRECTION {out} \
   CONFIG.PSU_MIO_29_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_29_POLARITY {Default} \
   CONFIG.PSU_MIO_2_DIRECTION {inout} \
   CONFIG.PSU_MIO_2_POLARITY {Default} \
   CONFIG.PSU_MIO_30_DIRECTION {in} \
   CONFIG.PSU_MIO_30_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_30_POLARITY {Default} \
   CONFIG.PSU_MIO_30_SLEW {fast} \
   CONFIG.PSU_MIO_31_DIRECTION {inout} \
   CONFIG.PSU_MIO_31_POLARITY {Default} \
   CONFIG.PSU_MIO_32_DIRECTION {out} \
   CONFIG.PSU_MIO_32_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_32_POLARITY {Default} \
   CONFIG.PSU_MIO_33_DIRECTION {out} \
   CONFIG.PSU_MIO_33_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_33_POLARITY {Default} \
   CONFIG.PSU_MIO_34_DIRECTION {out} \
   CONFIG.PSU_MIO_34_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_34_POLARITY {Default} \
   CONFIG.PSU_MIO_35_DIRECTION {out} \
   CONFIG.PSU_MIO_35_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_35_POLARITY {Default} \
   CONFIG.PSU_MIO_36_DIRECTION {out} \
   CONFIG.PSU_MIO_36_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_36_POLARITY {Default} \
   CONFIG.PSU_MIO_37_DIRECTION {out} \
   CONFIG.PSU_MIO_37_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_37_POLARITY {Default} \
   CONFIG.PSU_MIO_38_DIRECTION {inout} \
   CONFIG.PSU_MIO_38_POLARITY {Default} \
   CONFIG.PSU_MIO_39_DIRECTION {inout} \
   CONFIG.PSU_MIO_39_POLARITY {Default} \
   CONFIG.PSU_MIO_3_DIRECTION {inout} \
   CONFIG.PSU_MIO_3_POLARITY {Default} \
   CONFIG.PSU_MIO_40_DIRECTION {inout} \
   CONFIG.PSU_MIO_40_POLARITY {Default} \
   CONFIG.PSU_MIO_41_DIRECTION {inout} \
   CONFIG.PSU_MIO_41_POLARITY {Default} \
   CONFIG.PSU_MIO_42_DIRECTION {inout} \
   CONFIG.PSU_MIO_42_POLARITY {Default} \
   CONFIG.PSU_MIO_43_DIRECTION {inout} \
   CONFIG.PSU_MIO_43_POLARITY {Default} \
   CONFIG.PSU_MIO_44_DIRECTION {inout} \
   CONFIG.PSU_MIO_44_POLARITY {Default} \
   CONFIG.PSU_MIO_45_DIRECTION {in} \
   CONFIG.PSU_MIO_45_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_45_POLARITY {Default} \
   CONFIG.PSU_MIO_45_SLEW {fast} \
   CONFIG.PSU_MIO_46_DIRECTION {inout} \
   CONFIG.PSU_MIO_46_POLARITY {Default} \
   CONFIG.PSU_MIO_47_DIRECTION {inout} \
   CONFIG.PSU_MIO_47_POLARITY {Default} \
   CONFIG.PSU_MIO_48_DIRECTION {inout} \
   CONFIG.PSU_MIO_48_POLARITY {Default} \
   CONFIG.PSU_MIO_49_DIRECTION {inout} \
   CONFIG.PSU_MIO_49_POLARITY {Default} \
   CONFIG.PSU_MIO_4_DIRECTION {inout} \
   CONFIG.PSU_MIO_4_POLARITY {Default} \
   CONFIG.PSU_MIO_50_DIRECTION {inout} \
   CONFIG.PSU_MIO_50_POLARITY {Default} \
   CONFIG.PSU_MIO_51_DIRECTION {out} \
   CONFIG.PSU_MIO_51_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_51_POLARITY {Default} \
   CONFIG.PSU_MIO_52_DIRECTION {in} \
   CONFIG.PSU_MIO_52_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_52_POLARITY {Default} \
   CONFIG.PSU_MIO_52_SLEW {fast} \
   CONFIG.PSU_MIO_53_DIRECTION {in} \
   CONFIG.PSU_MIO_53_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_53_POLARITY {Default} \
   CONFIG.PSU_MIO_53_SLEW {fast} \
   CONFIG.PSU_MIO_54_DIRECTION {inout} \
   CONFIG.PSU_MIO_54_POLARITY {Default} \
   CONFIG.PSU_MIO_55_DIRECTION {in} \
   CONFIG.PSU_MIO_55_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_55_POLARITY {Default} \
   CONFIG.PSU_MIO_55_SLEW {fast} \
   CONFIG.PSU_MIO_56_DIRECTION {inout} \
   CONFIG.PSU_MIO_56_POLARITY {Default} \
   CONFIG.PSU_MIO_57_DIRECTION {inout} \
   CONFIG.PSU_MIO_57_POLARITY {Default} \
   CONFIG.PSU_MIO_58_DIRECTION {out} \
   CONFIG.PSU_MIO_58_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_58_POLARITY {Default} \
   CONFIG.PSU_MIO_59_DIRECTION {inout} \
   CONFIG.PSU_MIO_59_POLARITY {Default} \
   CONFIG.PSU_MIO_5_DIRECTION {out} \
   CONFIG.PSU_MIO_5_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_5_POLARITY {Default} \
   CONFIG.PSU_MIO_60_DIRECTION {inout} \
   CONFIG.PSU_MIO_60_POLARITY {Default} \
   CONFIG.PSU_MIO_61_DIRECTION {inout} \
   CONFIG.PSU_MIO_61_POLARITY {Default} \
   CONFIG.PSU_MIO_62_DIRECTION {inout} \
   CONFIG.PSU_MIO_62_POLARITY {Default} \
   CONFIG.PSU_MIO_63_DIRECTION {inout} \
   CONFIG.PSU_MIO_63_POLARITY {Default} \
   CONFIG.PSU_MIO_64_DIRECTION {out} \
   CONFIG.PSU_MIO_64_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_64_POLARITY {Default} \
   CONFIG.PSU_MIO_65_DIRECTION {out} \
   CONFIG.PSU_MIO_65_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_65_POLARITY {Default} \
   CONFIG.PSU_MIO_66_DIRECTION {out} \
   CONFIG.PSU_MIO_66_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_66_POLARITY {Default} \
   CONFIG.PSU_MIO_67_DIRECTION {out} \
   CONFIG.PSU_MIO_67_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_67_POLARITY {Default} \
   CONFIG.PSU_MIO_68_DIRECTION {out} \
   CONFIG.PSU_MIO_68_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_68_POLARITY {Default} \
   CONFIG.PSU_MIO_69_DIRECTION {out} \
   CONFIG.PSU_MIO_69_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_69_POLARITY {Default} \
   CONFIG.PSU_MIO_6_DIRECTION {out} \
   CONFIG.PSU_MIO_6_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_6_POLARITY {Default} \
   CONFIG.PSU_MIO_70_DIRECTION {in} \
   CONFIG.PSU_MIO_70_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_70_POLARITY {Default} \
   CONFIG.PSU_MIO_70_SLEW {fast} \
   CONFIG.PSU_MIO_71_DIRECTION {in} \
   CONFIG.PSU_MIO_71_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_71_POLARITY {Default} \
   CONFIG.PSU_MIO_71_SLEW {fast} \
   CONFIG.PSU_MIO_72_DIRECTION {in} \
   CONFIG.PSU_MIO_72_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_72_POLARITY {Default} \
   CONFIG.PSU_MIO_72_SLEW {fast} \
   CONFIG.PSU_MIO_73_DIRECTION {in} \
   CONFIG.PSU_MIO_73_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_73_POLARITY {Default} \
   CONFIG.PSU_MIO_73_SLEW {fast} \
   CONFIG.PSU_MIO_74_DIRECTION {in} \
   CONFIG.PSU_MIO_74_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_74_POLARITY {Default} \
   CONFIG.PSU_MIO_74_SLEW {fast} \
   CONFIG.PSU_MIO_75_DIRECTION {in} \
   CONFIG.PSU_MIO_75_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_75_POLARITY {Default} \
   CONFIG.PSU_MIO_75_SLEW {fast} \
   CONFIG.PSU_MIO_76_DIRECTION {out} \
   CONFIG.PSU_MIO_76_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_76_POLARITY {Default} \
   CONFIG.PSU_MIO_77_DIRECTION {inout} \
   CONFIG.PSU_MIO_77_POLARITY {Default} \
   CONFIG.PSU_MIO_7_DIRECTION {out} \
   CONFIG.PSU_MIO_7_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_7_POLARITY {Default} \
   CONFIG.PSU_MIO_8_DIRECTION {inout} \
   CONFIG.PSU_MIO_8_POLARITY {Default} \
   CONFIG.PSU_MIO_9_DIRECTION {inout} \
   CONFIG.PSU_MIO_9_POLARITY {Default} \
   CONFIG.PSU_MIO_TREE_PERIPHERALS {Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Feedback Clk#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#GPIO0 MIO#I2C 0#I2C 0#I2C 1#I2C 1#UART 0#UART 0#GPIO0 MIO#GPIO0 MIO#GPIO0 MIO#GPIO0 MIO#GPIO0 MIO#GPIO0 MIO#GPIO1 MIO#DPAUX#DPAUX#DPAUX#DPAUX#GPIO1 MIO#PMU GPO 0#PMU GPO 1#PMU GPO 2#PMU GPO 3#PMU GPO 4#PMU GPO 5#GPIO1 MIO#SD 1#SD 1#SD 1#SD 1#GPIO1 MIO#GPIO1 MIO#SD 1#SD 1#SD 1#SD 1#SD 1#SD 1#SD 1#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#MDIO 3#MDIO 3} \
   CONFIG.PSU_MIO_TREE_SIGNALS {sclk_out#miso_mo1#mo2#mo3#mosi_mi0#n_ss_out#clk_for_lpbk#n_ss_out_upper#mo_upper[0]#mo_upper[1]#mo_upper[2]#mo_upper[3]#sclk_out_upper#gpio0[13]#scl_out#sda_out#scl_out#sda_out#rxd#txd#gpio0[20]#gpio0[21]#gpio0[22]#gpio0[23]#gpio0[24]#gpio0[25]#gpio1[26]#dp_aux_data_out#dp_hot_plug_detect#dp_aux_data_oe#dp_aux_data_in#gpio1[31]#gpo[0]#gpo[1]#gpo[2]#gpo[3]#gpo[4]#gpo[5]#gpio1[38]#sdio1_data_out[4]#sdio1_data_out[5]#sdio1_data_out[6]#sdio1_data_out[7]#gpio1[43]#gpio1[44]#sdio1_cd_n#sdio1_data_out[0]#sdio1_data_out[1]#sdio1_data_out[2]#sdio1_data_out[3]#sdio1_cmd_out#sdio1_clk_out#ulpi_clk_in#ulpi_dir#ulpi_tx_data[2]#ulpi_nxt#ulpi_tx_data[0]#ulpi_tx_data[1]#ulpi_stp#ulpi_tx_data[3]#ulpi_tx_data[4]#ulpi_tx_data[5]#ulpi_tx_data[6]#ulpi_tx_data[7]#rgmii_tx_clk#rgmii_txd[0]#rgmii_txd[1]#rgmii_txd[2]#rgmii_txd[3]#rgmii_tx_ctl#rgmii_rx_clk#rgmii_rxd[0]#rgmii_rxd[1]#rgmii_rxd[2]#rgmii_rxd[3]#rgmii_rx_ctl#gem3_mdc#gem3_mdio_out} \
   CONFIG.PSU_SD1_INTERNAL_BUS_WIDTH {8} \
   CONFIG.PSU_USB3__DUAL_CLOCK_ENABLE {1} \
   CONFIG.PSU__ACT_DDR_FREQ_MHZ {1066.656006} \
   CONFIG.PSU__AFI0_COHERENCY {0} \
   CONFIG.PSU__CAN1__GRP_CLK__ENABLE {0} \
   CONFIG.PSU__CAN1__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__ACT_FREQMHZ {1199.988037} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__DIVISOR0 {1} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__FREQMHZ {1200} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__SRCSEL {APLL} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__FBDIV {72} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRF_APB__APLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRF_APB__APLL_TO_LPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__ACT_FREQMHZ {249.997498} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__ACT_FREQMHZ {249.997498} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__ACT_FREQMHZ {533.328003} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__FREQMHZ {1067} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__ACT_FREQMHZ {599.994019} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__FREQMHZ {600} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__SRCSEL {APLL} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__FBDIV {64} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRF_APB__DPLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRF_APB__DPLL_TO_LPD_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__ACT_FREQMHZ {24.999750} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRF_APB__DP_AUDIO__FRAC_ENABLED {0} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__ACT_FREQMHZ {26.785446} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__DIVISOR0 {14} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__ACT_FREQMHZ {299.997009} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__SRCSEL {VPLL} \
   CONFIG.PSU__CRF_APB__DP_VIDEO__FRAC_ENABLED {0} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__ACT_FREQMHZ {599.994019} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__FREQMHZ {600} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__SRCSEL {APLL} \
   CONFIG.PSU__CRF_APB__GPU_REF_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRF_APB__GPU_REF_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRF_APB__GPU_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__ACT_FREQMHZ {249.997498} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__ACT_FREQMHZ {533.328003} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__FREQMHZ {533.33} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__FBDIV {90} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRF_APB__VPLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRF_APB__VPLL_TO_LPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__ACT_FREQMHZ {499.994995} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__AFI6_REF_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__ACT_FREQMHZ {49.999500} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__DIVISOR0 {30} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__ACT_FREQMHZ {499.994995} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__ACT_FREQMHZ {249.997498} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__DLL_REF_CTRL__ACT_FREQMHZ {1499.984985} \
   CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__ACT_FREQMHZ {124.998749} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__FREQMHZ {125} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__ACT_FREQMHZ {249.997498} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__FBDIV {90} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRL_APB__IOPLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRL_APB__IOPLL_TO_FPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__ACT_FREQMHZ {249.997498} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__ACT_FREQMHZ {499.994995} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__NAND_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__NAND_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__ACT_FREQMHZ {187.498123} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__DIVISOR0 {8} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__FREQMHZ {200} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__DIVISOR0 {4} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PL2_REF_CTRL__DIVISOR0 {4} \
   CONFIG.PSU__CRL_APB__PL2_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PL3_REF_CTRL__DIVISOR0 {4} \
   CONFIG.PSU__CRL_APB__PL3_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__ACT_FREQMHZ {124.998749} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__FREQMHZ {125} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__FBDIV {45} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRL_APB__RPLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRL_APB__RPLL_TO_FPD_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__DIVISOR0 {7} \
   CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__ACT_FREQMHZ {187.498123} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__DIVISOR0 {8} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__FREQMHZ {200} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__DIVISOR0 {7} \
   CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__DIVISOR0 {7} \
   CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__ACT_FREQMHZ {249.997498} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__ACT_FREQMHZ {19.999800} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__DIVISOR0 {25} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__DIVISOR1 {3} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__FREQMHZ {20} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__USB3__ENABLE {1} \
   CONFIG.PSU__CSUPMU__PERIPHERAL__VALID {1} \
   CONFIG.PSU__DDRC__ADDR_MIRROR {0} \
   CONFIG.PSU__DDRC__BANK_ADDR_COUNT {2} \
   CONFIG.PSU__DDRC__BG_ADDR_COUNT {1} \
   CONFIG.PSU__DDRC__BRC_MAPPING {ROW_BANK_COL} \
   CONFIG.PSU__DDRC__BUS_WIDTH {64 Bit} \
   CONFIG.PSU__DDRC__CL {15} \
   CONFIG.PSU__DDRC__CLOCK_STOP_EN {0} \
   CONFIG.PSU__DDRC__COL_ADDR_COUNT {10} \
   CONFIG.PSU__DDRC__COMPONENTS {UDIMM} \
   CONFIG.PSU__DDRC__CWL {14} \
   CONFIG.PSU__DDRC__DDR3L_T_REF_RANGE {NA} \
   CONFIG.PSU__DDRC__DDR3_T_REF_RANGE {NA} \
   CONFIG.PSU__DDRC__DDR4_ADDR_MAPPING {0} \
   CONFIG.PSU__DDRC__DDR4_CAL_MODE_ENABLE {0} \
   CONFIG.PSU__DDRC__DDR4_CRC_CONTROL {0} \
   CONFIG.PSU__DDRC__DDR4_T_REF_MODE {0} \
   CONFIG.PSU__DDRC__DDR4_T_REF_RANGE {Normal (0-85)} \
   CONFIG.PSU__DDRC__DEEP_PWR_DOWN_EN {0} \
   CONFIG.PSU__DDRC__DEVICE_CAPACITY {8192 MBits} \
   CONFIG.PSU__DDRC__DIMM_ADDR_MIRROR {0} \
   CONFIG.PSU__DDRC__DM_DBI {DM_NO_DBI} \
   CONFIG.PSU__DDRC__DQMAP_0_3 {0} \
   CONFIG.PSU__DDRC__DQMAP_12_15 {0} \
   CONFIG.PSU__DDRC__DQMAP_16_19 {0} \
   CONFIG.PSU__DDRC__DQMAP_20_23 {0} \
   CONFIG.PSU__DDRC__DQMAP_24_27 {0} \
   CONFIG.PSU__DDRC__DQMAP_28_31 {0} \
   CONFIG.PSU__DDRC__DQMAP_32_35 {0} \
   CONFIG.PSU__DDRC__DQMAP_36_39 {0} \
   CONFIG.PSU__DDRC__DQMAP_40_43 {0} \
   CONFIG.PSU__DDRC__DQMAP_44_47 {0} \
   CONFIG.PSU__DDRC__DQMAP_48_51 {0} \
   CONFIG.PSU__DDRC__DQMAP_4_7 {0} \
   CONFIG.PSU__DDRC__DQMAP_52_55 {0} \
   CONFIG.PSU__DDRC__DQMAP_56_59 {0} \
   CONFIG.PSU__DDRC__DQMAP_60_63 {0} \
   CONFIG.PSU__DDRC__DQMAP_64_67 {0} \
   CONFIG.PSU__DDRC__DQMAP_68_71 {0} \
   CONFIG.PSU__DDRC__DQMAP_8_11 {0} \
   CONFIG.PSU__DDRC__DRAM_WIDTH {16 Bits} \
   CONFIG.PSU__DDRC__ECC {Disabled} \
   CONFIG.PSU__DDRC__ENABLE_LP4_HAS_ECC_COMP {0} \
   CONFIG.PSU__DDRC__ENABLE_LP4_SLOWBOOT {0} \
   CONFIG.PSU__DDRC__FGRM {1X} \
   CONFIG.PSU__DDRC__LPDDR3_T_REF_RANGE {NA} \
   CONFIG.PSU__DDRC__LPDDR4_T_REF_RANGE {NA} \
   CONFIG.PSU__DDRC__LP_ASR {manual normal} \
   CONFIG.PSU__DDRC__MEMORY_TYPE {DDR 4} \
   CONFIG.PSU__DDRC__PARITY_ENABLE {0} \
   CONFIG.PSU__DDRC__PER_BANK_REFRESH {0} \
   CONFIG.PSU__DDRC__PHY_DBI_MODE {0} \
   CONFIG.PSU__DDRC__RANK_ADDR_COUNT {0} \
   CONFIG.PSU__DDRC__ROW_ADDR_COUNT {16} \
   CONFIG.PSU__DDRC__SB_TARGET {15-15-15} \
   CONFIG.PSU__DDRC__SELF_REF_ABORT {0} \
   CONFIG.PSU__DDRC__SPEED_BIN {DDR4_2133P} \
   CONFIG.PSU__DDRC__STATIC_RD_MODE {0} \
   CONFIG.PSU__DDRC__TRAIN_DATA_EYE {1} \
   CONFIG.PSU__DDRC__TRAIN_READ_GATE {1} \
   CONFIG.PSU__DDRC__TRAIN_WRITE_LEVEL {1} \
   CONFIG.PSU__DDRC__T_FAW {30.0} \
   CONFIG.PSU__DDRC__T_RAS_MIN {33} \
   CONFIG.PSU__DDRC__T_RC {47.06} \
   CONFIG.PSU__DDRC__T_RCD {15} \
   CONFIG.PSU__DDRC__T_RP {15} \
   CONFIG.PSU__DDRC__VENDOR_PART {OTHERS} \
   CONFIG.PSU__DDRC__VREF {1} \
   CONFIG.PSU__DDR_HIGH_ADDRESS_GUI_ENABLE {1} \
   CONFIG.PSU__DDR__INTERFACE__FREQMHZ {533.500} \
   CONFIG.PSU__DISPLAYPORT__LANE0__ENABLE {1} \
   CONFIG.PSU__DISPLAYPORT__LANE0__IO {GT Lane1} \
   CONFIG.PSU__DISPLAYPORT__LANE1__ENABLE {1} \
   CONFIG.PSU__DISPLAYPORT__LANE1__IO {GT Lane0} \
   CONFIG.PSU__DISPLAYPORT__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__DLL__ISUSED {1} \
   CONFIG.PSU__DPAUX__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__DPAUX__PERIPHERAL__IO {MIO 27 .. 30} \
   CONFIG.PSU__DP__LANE_SEL {Dual Lower} \
   CONFIG.PSU__DP__REF_CLK_FREQ {27} \
   CONFIG.PSU__DP__REF_CLK_SEL {Ref Clk1} \
   CONFIG.PSU__ENET3__FIFO__ENABLE {0} \
   CONFIG.PSU__ENET3__GRP_MDIO__ENABLE {1} \
   CONFIG.PSU__ENET3__GRP_MDIO__IO {MIO 76 .. 77} \
   CONFIG.PSU__ENET3__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__ENET3__PERIPHERAL__IO {MIO 64 .. 75} \
   CONFIG.PSU__ENET3__PTP__ENABLE {0} \
   CONFIG.PSU__ENET3__TSU__ENABLE {0} \
   CONFIG.PSU__FPDMASTERS_COHERENCY {0} \
   CONFIG.PSU__FPD_SLCR__WDT1__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__FPD_SLCR__WDT1__FREQMHZ {99.999001} \
   CONFIG.PSU__FPD_SLCR__WDT_CLK_SEL__SELECT {APB} \
   CONFIG.PSU__FPGA_PL0_ENABLE {1} \
   CONFIG.PSU__GEM3_COHERENCY {0} \
   CONFIG.PSU__GEM3_ROUTE_THROUGH_FPD {0} \
   CONFIG.PSU__GEM__TSU__ENABLE {0} \
   CONFIG.PSU__GPIO0_MIO__IO {MIO 0 .. 25} \
   CONFIG.PSU__GPIO0_MIO__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__GPIO1_MIO__IO {MIO 26 .. 51} \
   CONFIG.PSU__GPIO1_MIO__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__GT__LINK_SPEED {HBR} \
   CONFIG.PSU__GT__PRE_EMPH_LVL_4 {0} \
   CONFIG.PSU__GT__VLT_SWNG_LVL_4 {0} \
   CONFIG.PSU__HIGH_ADDRESS__ENABLE {1} \
   CONFIG.PSU__I2C0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__I2C0__PERIPHERAL__IO {MIO 14 .. 15} \
   CONFIG.PSU__I2C1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__I2C1__PERIPHERAL__IO {MIO 16 .. 17} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC0_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC1_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC2_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC3_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__TTC0__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC0__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC1__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC1__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC2__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC2__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC3__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC3__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__WDT0__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__IOU_SLCR__WDT0__FREQMHZ {99.999001} \
   CONFIG.PSU__IOU_SLCR__WDT_CLK_SEL__SELECT {APB} \
   CONFIG.PSU__LPD_SLCR__CSUPMU__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__LPD_SLCR__CSUPMU__FREQMHZ {100.000000} \
   CONFIG.PSU__MAXIGP0__DATA_WIDTH {128} \
   CONFIG.PSU__MAXIGP1__DATA_WIDTH {128} \
   CONFIG.PSU__MAXIGP2__DATA_WIDTH {32} \
   CONFIG.PSU__OVERRIDE__BASIC_CLOCK {0} \
   CONFIG.PSU__PL_CLK0_BUF {TRUE} \
   CONFIG.PSU__PMU_COHERENCY {0} \
   CONFIG.PSU__PMU__AIBACK__ENABLE {0} \
   CONFIG.PSU__PMU__EMIO_GPI__ENABLE {0} \
   CONFIG.PSU__PMU__EMIO_GPO__ENABLE {0} \
   CONFIG.PSU__PMU__GPI0__ENABLE {0} \
   CONFIG.PSU__PMU__GPI1__ENABLE {0} \
   CONFIG.PSU__PMU__GPI2__ENABLE {0} \
   CONFIG.PSU__PMU__GPI3__ENABLE {0} \
   CONFIG.PSU__PMU__GPI4__ENABLE {0} \
   CONFIG.PSU__PMU__GPI5__ENABLE {0} \
   CONFIG.PSU__PMU__GPO0__ENABLE {1} \
   CONFIG.PSU__PMU__GPO0__IO {MIO 32} \
   CONFIG.PSU__PMU__GPO1__ENABLE {1} \
   CONFIG.PSU__PMU__GPO1__IO {MIO 33} \
   CONFIG.PSU__PMU__GPO2__ENABLE {1} \
   CONFIG.PSU__PMU__GPO2__IO {MIO 34} \
   CONFIG.PSU__PMU__GPO2__POLARITY {low} \
   CONFIG.PSU__PMU__GPO3__ENABLE {1} \
   CONFIG.PSU__PMU__GPO3__IO {MIO 35} \
   CONFIG.PSU__PMU__GPO3__POLARITY {low} \
   CONFIG.PSU__PMU__GPO4__ENABLE {1} \
   CONFIG.PSU__PMU__GPO4__IO {MIO 36} \
   CONFIG.PSU__PMU__GPO4__POLARITY {low} \
   CONFIG.PSU__PMU__GPO5__ENABLE {1} \
   CONFIG.PSU__PMU__GPO5__IO {MIO 37} \
   CONFIG.PSU__PMU__GPO5__POLARITY {low} \
   CONFIG.PSU__PMU__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__PMU__PLERROR__ENABLE {0} \
   CONFIG.PSU__PRESET_APPLIED {1} \
   CONFIG.PSU__PROTECTION__MASTERS {USB1:NonSecure;0|USB0:NonSecure;1|S_AXI_LPD:NA;0|S_AXI_HPC1_FPD:NA;0|S_AXI_HPC0_FPD:NA;1|S_AXI_HP3_FPD:NA;0|S_AXI_HP2_FPD:NA;0|S_AXI_HP1_FPD:NA;0|S_AXI_HP0_FPD:NA;0|S_AXI_ACP:NA;0|S_AXI_ACE:NA;0|SD1:NonSecure;1|SD0:NonSecure;0|SATA1:NonSecure;1|SATA0:NonSecure;1|RPU1:Secure;1|RPU0:Secure;1|QSPI:NonSecure;1|PMU:NA;1|PCIe:NonSecure;0|NAND:NonSecure;0|LDMA:NonSecure;1|GPU:NonSecure;1|GEM3:NonSecure;1|GEM2:NonSecure;0|GEM1:NonSecure;0|GEM0:NonSecure;0|FDMA:NonSecure;1|DP:NonSecure;1|DAP:NA;1|Coresight:NA;1|CSU:NA;1|APU:NA;1} \
   CONFIG.PSU__PROTECTION__SLAVES {LPD;USB3_1_XHCI;FE300000;FE3FFFFF;0|LPD;USB3_1;FF9E0000;FF9EFFFF;0|LPD;USB3_0_XHCI;FE200000;FE2FFFFF;1|LPD;USB3_0;FF9D0000;FF9DFFFF;1|LPD;UART1;FF010000;FF01FFFF;1|LPD;UART0;FF000000;FF00FFFF;1|LPD;TTC3;FF140000;FF14FFFF;1|LPD;TTC2;FF130000;FF13FFFF;1|LPD;TTC1;FF120000;FF12FFFF;1|LPD;TTC0;FF110000;FF11FFFF;1|FPD;SWDT1;FD4D0000;FD4DFFFF;1|LPD;SWDT0;FF150000;FF15FFFF;1|LPD;SPI1;FF050000;FF05FFFF;0|LPD;SPI0;FF040000;FF04FFFF;0|FPD;SMMU_REG;FD5F0000;FD5FFFFF;1|FPD;SMMU;FD800000;FDFFFFFF;1|FPD;SIOU;FD3D0000;FD3DFFFF;1|FPD;SERDES;FD400000;FD47FFFF;1|LPD;SD1;FF170000;FF17FFFF;1|LPD;SD0;FF160000;FF16FFFF;0|FPD;SATA;FD0C0000;FD0CFFFF;1|LPD;RTC;FFA60000;FFA6FFFF;1|LPD;RSA_CORE;FFCE0000;FFCEFFFF;1|LPD;RPU;FF9A0000;FF9AFFFF;1|LPD;R5_TCM_RAM_GLOBAL;FFE00000;FFE3FFFF;1|LPD;R5_1_Instruction_Cache;FFEC0000;FFECFFFF;1|LPD;R5_1_Data_Cache;FFED0000;FFEDFFFF;1|LPD;R5_1_BTCM_GLOBAL;FFEB0000;FFEBFFFF;1|LPD;R5_1_ATCM_GLOBAL;FFE90000;FFE9FFFF;1|LPD;R5_0_Instruction_Cache;FFE40000;FFE4FFFF;1|LPD;R5_0_Data_Cache;FFE50000;FFE5FFFF;1|LPD;R5_0_BTCM_GLOBAL;FFE20000;FFE2FFFF;1|LPD;R5_0_ATCM_GLOBAL;FFE00000;FFE0FFFF;1|LPD;QSPI_Linear_Address;C0000000;DFFFFFFF;1|LPD;QSPI;FF0F0000;FF0FFFFF;1|LPD;PMU_RAM;FFDC0000;FFDDFFFF;1|LPD;PMU_GLOBAL;FFD80000;FFDBFFFF;1|FPD;PCIE_MAIN;FD0E0000;FD0EFFFF;0|FPD;PCIE_LOW;E0000000;EFFFFFFF;0|FPD;PCIE_HIGH2;8000000000;BFFFFFFFFF;0|FPD;PCIE_HIGH1;600000000;7FFFFFFFF;0|FPD;PCIE_DMA;FD0F0000;FD0FFFFF;0|FPD;PCIE_ATTRIB;FD480000;FD48FFFF;0|LPD;OCM_XMPU_CFG;FFA70000;FFA7FFFF;1|LPD;OCM_SLCR;FF960000;FF96FFFF;1|OCM;OCM;FFFC0000;FFFFFFFF;1|LPD;NAND;FF100000;FF10FFFF;0|LPD;MBISTJTAG;FFCF0000;FFCFFFFF;1|LPD;LPD_XPPU_SINK;FF9C0000;FF9CFFFF;1|LPD;LPD_XPPU;FF980000;FF98FFFF;1|LPD;LPD_SLCR_SECURE;FF4B0000;FF4DFFFF;1|LPD;LPD_SLCR;FF410000;FF4AFFFF;1|LPD;LPD_GPV;FE100000;FE1FFFFF;1|LPD;LPD_DMA_7;FFAF0000;FFAFFFFF;1|LPD;LPD_DMA_6;FFAE0000;FFAEFFFF;1|LPD;LPD_DMA_5;FFAD0000;FFADFFFF;1|LPD;LPD_DMA_4;FFAC0000;FFACFFFF;1|LPD;LPD_DMA_3;FFAB0000;FFABFFFF;1|LPD;LPD_DMA_2;FFAA0000;FFAAFFFF;1|LPD;LPD_DMA_1;FFA90000;FFA9FFFF;1|LPD;LPD_DMA_0;FFA80000;FFA8FFFF;1|LPD;IPI_CTRL;FF380000;FF3FFFFF;1|LPD;IOU_SLCR;FF180000;FF23FFFF;1|LPD;IOU_SECURE_SLCR;FF240000;FF24FFFF;1|LPD;IOU_SCNTRS;FF260000;FF26FFFF;1|LPD;IOU_SCNTR;FF250000;FF25FFFF;1|LPD;IOU_GPV;FE000000;FE0FFFFF;1|LPD;I2C1;FF030000;FF03FFFF;1|LPD;I2C0;FF020000;FF02FFFF;1|FPD;GPU;FD4B0000;FD4BFFFF;0|LPD;GPIO;FF0A0000;FF0AFFFF;1|LPD;GEM3;FF0E0000;FF0EFFFF;1|LPD;GEM2;FF0D0000;FF0DFFFF;0|LPD;GEM1;FF0C0000;FF0CFFFF;0|LPD;GEM0;FF0B0000;FF0BFFFF;0|FPD;FPD_XMPU_SINK;FD4F0000;FD4FFFFF;1|FPD;FPD_XMPU_CFG;FD5D0000;FD5DFFFF;1|FPD;FPD_SLCR_SECURE;FD690000;FD6CFFFF;1|FPD;FPD_SLCR;FD610000;FD68FFFF;1|FPD;FPD_GPV;FD700000;FD7FFFFF;1|FPD;FPD_DMA_CH7;FD570000;FD57FFFF;1|FPD;FPD_DMA_CH6;FD560000;FD56FFFF;1|FPD;FPD_DMA_CH5;FD550000;FD55FFFF;1|FPD;FPD_DMA_CH4;FD540000;FD54FFFF;1|FPD;FPD_DMA_CH3;FD530000;FD53FFFF;1|FPD;FPD_DMA_CH2;FD520000;FD52FFFF;1|FPD;FPD_DMA_CH1;FD510000;FD51FFFF;1|FPD;FPD_DMA_CH0;FD500000;FD50FFFF;1|LPD;EFUSE;FFCC0000;FFCCFFFF;1|FPD;Display Port;FD4A0000;FD4AFFFF;1|FPD;DPDMA;FD4C0000;FD4CFFFF;1|FPD;DDR_XMPU5_CFG;FD050000;FD05FFFF;1|FPD;DDR_XMPU4_CFG;FD040000;FD04FFFF;1|FPD;DDR_XMPU3_CFG;FD030000;FD03FFFF;1|FPD;DDR_XMPU2_CFG;FD020000;FD02FFFF;1|FPD;DDR_XMPU1_CFG;FD010000;FD01FFFF;1|FPD;DDR_XMPU0_CFG;FD000000;FD00FFFF;1|FPD;DDR_QOS_CTRL;FD090000;FD09FFFF;1|FPD;DDR_PHY;FD080000;FD08FFFF;1|DDR;DDR_LOW;0;7FFFFFFF;1|DDR;DDR_HIGH;800000000;87FFFFFFF;1|FPD;DDDR_CTRL;FD070000;FD070FFF;1|LPD;Coresight;FE800000;FEFFFFFF;1|LPD;CSU_DMA;FFC80000;FFC9FFFF;1|LPD;CSU;FFCA0000;FFCAFFFF;0|LPD;CRL_APB;FF5E0000;FF85FFFF;1|FPD;CRF_APB;FD1A0000;FD2DFFFF;1|FPD;CCI_REG;FD5E0000;FD5EFFFF;1|FPD;CCI_GPV;FD6E0000;FD6EFFFF;1|LPD;CAN1;FF070000;FF07FFFF;0|LPD;CAN0;FF060000;FF06FFFF;0|FPD;APU;FD5C0000;FD5CFFFF;1|LPD;APM_INTC_IOU;FFA20000;FFA2FFFF;1|LPD;APM_FPD_LPD;FFA30000;FFA3FFFF;1|FPD;APM_5;FD490000;FD49FFFF;1|FPD;APM_0;FD0B0000;FD0BFFFF;1|LPD;APM2;FFA10000;FFA1FFFF;1|LPD;APM1;FFA00000;FFA0FFFF;1|LPD;AMS;FFA50000;FFA5FFFF;1|FPD;AFI_5;FD3B0000;FD3BFFFF;1|FPD;AFI_4;FD3A0000;FD3AFFFF;1|FPD;AFI_3;FD390000;FD39FFFF;1|FPD;AFI_2;FD380000;FD38FFFF;1|FPD;AFI_1;FD370000;FD37FFFF;1|FPD;AFI_0;FD360000;FD36FFFF;1|LPD;AFIFM6;FF9B0000;FF9BFFFF;1|FPD;ACPU_GIC;F9010000;F907FFFF;1} \
   CONFIG.PSU__PSS_REF_CLK__FREQMHZ {33.333} \
   CONFIG.PSU__QSPI_COHERENCY {0} \
   CONFIG.PSU__QSPI_ROUTE_THROUGH_FPD {0} \
   CONFIG.PSU__QSPI__GRP_FBCLK__ENABLE {1} \
   CONFIG.PSU__QSPI__GRP_FBCLK__IO {MIO 6} \
   CONFIG.PSU__QSPI__PERIPHERAL__DATA_MODE {x4} \
   CONFIG.PSU__QSPI__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__QSPI__PERIPHERAL__IO {MIO 0 .. 12} \
   CONFIG.PSU__QSPI__PERIPHERAL__MODE {Dual Parallel} \
   CONFIG.PSU__SATA__LANE0__ENABLE {0} \
   CONFIG.PSU__SATA__LANE1__ENABLE {1} \
   CONFIG.PSU__SATA__LANE1__IO {GT Lane3} \
   CONFIG.PSU__SATA__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SATA__REF_CLK_FREQ {125} \
   CONFIG.PSU__SATA__REF_CLK_SEL {Ref Clk3} \
   CONFIG.PSU__SAXIGP0__DATA_WIDTH {128} \
   CONFIG.PSU__SD1_COHERENCY {0} \
   CONFIG.PSU__SD1_ROUTE_THROUGH_FPD {0} \
   CONFIG.PSU__SD1__DATA_TRANSFER_MODE {8Bit} \
   CONFIG.PSU__SD1__GRP_CD__ENABLE {1} \
   CONFIG.PSU__SD1__GRP_CD__IO {MIO 45} \
   CONFIG.PSU__SD1__GRP_POW__ENABLE {0} \
   CONFIG.PSU__SD1__GRP_WP__ENABLE {0} \
   CONFIG.PSU__SD1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SD1__PERIPHERAL__IO {MIO 39 .. 51} \
   CONFIG.PSU__SD1__RESET__ENABLE {0} \
   CONFIG.PSU__SD1__SLOT_TYPE {SD 3.0} \
   CONFIG.PSU__SWDT0__CLOCK__ENABLE {0} \
   CONFIG.PSU__SWDT0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SWDT0__RESET__ENABLE {0} \
   CONFIG.PSU__SWDT1__CLOCK__ENABLE {0} \
   CONFIG.PSU__SWDT1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SWDT1__RESET__ENABLE {0} \
   CONFIG.PSU__TSU__BUFG_PORT_PAIR {0} \
   CONFIG.PSU__TTC0__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__TTC0__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__TTC1__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__TTC1__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__TTC2__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC2__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__TTC2__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__TTC3__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC3__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__TTC3__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__UART0__BAUD_RATE {115200} \
   CONFIG.PSU__UART0__MODEM__ENABLE {0} \
   CONFIG.PSU__UART0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__UART0__PERIPHERAL__IO {MIO 18 .. 19} \
   CONFIG.PSU__UART1__BAUD_RATE {115200} \
   CONFIG.PSU__UART1__MODEM__ENABLE {0} \
   CONFIG.PSU__UART1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__UART1__PERIPHERAL__IO {EMIO} \
   CONFIG.PSU__USB0_COHERENCY {0} \
   CONFIG.PSU__USB0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__USB0__PERIPHERAL__IO {MIO 52 .. 63} \
   CONFIG.PSU__USB0__REF_CLK_FREQ {26} \
   CONFIG.PSU__USB0__REF_CLK_SEL {Ref Clk2} \
   CONFIG.PSU__USB0__RESET__ENABLE {0} \
   CONFIG.PSU__USB1__RESET__ENABLE {0} \
   CONFIG.PSU__USB2_0__EMIO__ENABLE {0} \
   CONFIG.PSU__USB3_0__EMIO__ENABLE {0} \
   CONFIG.PSU__USB3_0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__USB3_0__PERIPHERAL__IO {GT Lane2} \
   CONFIG.PSU__USB__RESET__MODE {Boot Pin} \
   CONFIG.PSU__USB__RESET__POLARITY {Active Low} \
   CONFIG.PSU__USE__IRQ0 {1} \
   CONFIG.PSU__USE__M_AXI_GP0 {1} \
   CONFIG.PSU__USE__M_AXI_GP1 {0} \
   CONFIG.PSU__USE__M_AXI_GP2 {0} \
   CONFIG.PSU__USE__S_AXI_GP0 {1} \
   CONFIG.SUBPRESET1 {Custom} \
 ] $zynq_ultra_ps_e_0

  # Create interface connections
  connect_bd_intf_net -intf_net adc2_clk_1 [get_bd_intf_ports adc2_clk] [get_bd_intf_pins usp_rf_data_converter_0/adc0_clk]
  connect_bd_intf_net -intf_net axi_dma_1_M_AXI_S2MM [get_bd_intf_pins axi_dma_1/M_AXI_S2MM] [get_bd_intf_pins axi_smc/S01_AXI]
  connect_bd_intf_net -intf_net axi_smc_M00_AXI [get_bd_intf_pins axi_smc/M00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HPC0_FPD]
  connect_bd_intf_net -intf_net axis_buffer_uram_0_m_axis [get_bd_intf_pins axi_dma_1/S_AXIS_S2MM] [get_bd_intf_pins axis_buffer_uram_0/m_axis]
  connect_bd_intf_net -intf_net axis_chsel_pfb_x1_0_m_axis [get_bd_intf_pins axis_chsel_pfb_x1_0/m_axis] [get_bd_intf_pins reg_13/S_AXIS]
  connect_bd_intf_net -intf_net axis_combiner_nb_0_m_axis [get_bd_intf_pins axis_combiner_nb_0/m_axis] [get_bd_intf_pins axis_switch_pfb_x1_0/s_axis]
  connect_bd_intf_net -intf_net axis_constant_iq_0_m_axis [get_bd_intf_pins axis_constant_iq_0/m_axis] [get_bd_intf_pins usp_rf_data_converter_0/s13_axis]
  connect_bd_intf_net -intf_net axis_pimod_pfb_x1_0_m_axis [get_bd_intf_pins axis_pimod_pfb_x1_0/m_axis] [get_bd_intf_pins reg_11/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS [get_bd_intf_pins axis_split_iq/S_AXIS] [get_bd_intf_pins reg_0/M_AXIS]
  connect_bd_intf_net -intf_net axis_split_iq_M00_AXIS [get_bd_intf_pins axis_split_iq/M00_AXIS] [get_bd_intf_pins reg_1/S_AXIS]
  connect_bd_intf_net -intf_net axis_split_iq_M01_AXIS [get_bd_intf_pins axis_split_iq/M01_AXIS] [get_bd_intf_pins reg_2/S_AXIS]
  connect_bd_intf_net -intf_net axis_split_iq_M02_AXIS [get_bd_intf_pins axis_split_iq/M02_AXIS] [get_bd_intf_pins reg_3/S_AXIS]
  connect_bd_intf_net -intf_net axis_split_iq_M03_AXIS [get_bd_intf_pins axis_split_iq/M03_AXIS] [get_bd_intf_pins reg_4/S_AXIS]
  connect_bd_intf_net -intf_net axis_split_iq_M04_AXIS [get_bd_intf_pins axis_split_iq/M04_AXIS] [get_bd_intf_pins reg_5/S_AXIS]
  connect_bd_intf_net -intf_net axis_split_iq_M05_AXIS [get_bd_intf_pins axis_split_iq/M05_AXIS] [get_bd_intf_pins reg_6/S_AXIS]
  connect_bd_intf_net -intf_net axis_split_iq_M06_AXIS [get_bd_intf_pins axis_split_iq/M06_AXIS] [get_bd_intf_pins reg_7/S_AXIS]
  connect_bd_intf_net -intf_net axis_split_iq_M07_AXIS [get_bd_intf_pins axis_split_iq/M07_AXIS] [get_bd_intf_pins reg_8/S_AXIS]
  connect_bd_intf_net -intf_net axis_ssrfft_16x16_0_m_axis [get_bd_intf_pins axis_ssrfft_16x16_0/m_axis] [get_bd_intf_pins reg_10/S_AXIS]
  connect_bd_intf_net -intf_net axis_switch_pfb_x1_0_m_axis [get_bd_intf_pins axis_switch_pfb_x1_0/m_axis] [get_bd_intf_pins reg_9/S_AXIS]
  connect_bd_intf_net -intf_net axis_xfft_16x32768_0_m_axis [get_bd_intf_pins axis_xfft_16x32768_0/m_axis] [get_bd_intf_pins reg_12/S_AXIS]
  connect_bd_intf_net -intf_net axis_z1_nb_0_m0_axis [get_bd_intf_pins axis_z1_nb_0/m0_axis] [get_bd_intf_pins fir_0/S_AXIS_DATA]
  connect_bd_intf_net -intf_net axis_z1_nb_0_m1_axis [get_bd_intf_pins axis_z1_nb_0/m1_axis] [get_bd_intf_pins fir_1/S_AXIS_DATA]
  connect_bd_intf_net -intf_net axis_z1_nb_1_m0_axis [get_bd_intf_pins axis_z1_nb_1/m0_axis] [get_bd_intf_pins fir_2/S_AXIS_DATA]
  connect_bd_intf_net -intf_net axis_z1_nb_1_m1_axis [get_bd_intf_pins axis_z1_nb_1/m1_axis] [get_bd_intf_pins fir_3/S_AXIS_DATA]
  connect_bd_intf_net -intf_net axis_z1_nb_2_m0_axis [get_bd_intf_pins axis_z1_nb_2/m0_axis] [get_bd_intf_pins fir_4/S_AXIS_DATA]
  connect_bd_intf_net -intf_net axis_z1_nb_2_m1_axis [get_bd_intf_pins axis_z1_nb_2/m1_axis] [get_bd_intf_pins fir_5/S_AXIS_DATA]
  connect_bd_intf_net -intf_net axis_z1_nb_3_m0_axis [get_bd_intf_pins axis_z1_nb_3/m0_axis] [get_bd_intf_pins fir_6/S_AXIS_DATA]
  connect_bd_intf_net -intf_net axis_z1_nb_3_m1_axis [get_bd_intf_pins axis_z1_nb_3/m1_axis] [get_bd_intf_pins fir_7/S_AXIS_DATA]
  connect_bd_intf_net -intf_net axis_z1_nb_4_m0_axis [get_bd_intf_pins axis_z1_nb_4/m0_axis] [get_bd_intf_pins fir_8/S_AXIS_DATA]
  connect_bd_intf_net -intf_net axis_z1_nb_4_m1_axis [get_bd_intf_pins axis_z1_nb_4/m1_axis] [get_bd_intf_pins fir_9/S_AXIS_DATA]
  connect_bd_intf_net -intf_net axis_z1_nb_5_m0_axis [get_bd_intf_pins axis_z1_nb_5/m0_axis] [get_bd_intf_pins fir_10/S_AXIS_DATA]
  connect_bd_intf_net -intf_net axis_z1_nb_5_m1_axis [get_bd_intf_pins axis_z1_nb_5/m1_axis] [get_bd_intf_pins fir_11/S_AXIS_DATA]
  connect_bd_intf_net -intf_net axis_z1_nb_6_m0_axis [get_bd_intf_pins axis_z1_nb_6/m0_axis] [get_bd_intf_pins fir_12/S_AXIS_DATA]
  connect_bd_intf_net -intf_net axis_z1_nb_6_m1_axis [get_bd_intf_pins axis_z1_nb_6/m1_axis] [get_bd_intf_pins fir_13/S_AXIS_DATA]
  connect_bd_intf_net -intf_net axis_z1_nb_7_m0_axis [get_bd_intf_pins axis_z1_nb_7/m0_axis] [get_bd_intf_pins fir_14/S_AXIS_DATA]
  connect_bd_intf_net -intf_net axis_z1_nb_7_m1_axis [get_bd_intf_pins axis_z1_nb_7/m1_axis] [get_bd_intf_pins fir_15/S_AXIS_DATA]
  connect_bd_intf_net -intf_net combiner_iq_M_AXIS [get_bd_intf_pins combiner_iq/M_AXIS] [get_bd_intf_pins reg_0/S_AXIS]
  connect_bd_intf_net -intf_net dac1_clk_1 [get_bd_intf_ports dac1_clk] [get_bd_intf_pins usp_rf_data_converter_0/dac1_clk]
  connect_bd_intf_net -intf_net fir_0_M_AXIS_DATA [get_bd_intf_pins axis_combiner_nb_0/s00_axis] [get_bd_intf_pins fir_0/M_AXIS_DATA]
  connect_bd_intf_net -intf_net fir_10_M_AXIS_DATA [get_bd_intf_pins axis_combiner_nb_0/s10_axis] [get_bd_intf_pins fir_10/M_AXIS_DATA]
  connect_bd_intf_net -intf_net fir_11_M_AXIS_DATA [get_bd_intf_pins axis_combiner_nb_0/s11_axis] [get_bd_intf_pins fir_11/M_AXIS_DATA]
  connect_bd_intf_net -intf_net fir_12_M_AXIS_DATA [get_bd_intf_pins axis_combiner_nb_0/s12_axis] [get_bd_intf_pins fir_12/M_AXIS_DATA]
  connect_bd_intf_net -intf_net fir_13_M_AXIS_DATA [get_bd_intf_pins axis_combiner_nb_0/s13_axis] [get_bd_intf_pins fir_13/M_AXIS_DATA]
  connect_bd_intf_net -intf_net fir_14_M_AXIS_DATA [get_bd_intf_pins axis_combiner_nb_0/s14_axis] [get_bd_intf_pins fir_14/M_AXIS_DATA]
  connect_bd_intf_net -intf_net fir_15_M_AXIS_DATA [get_bd_intf_pins axis_combiner_nb_0/s15_axis] [get_bd_intf_pins fir_15/M_AXIS_DATA]
  connect_bd_intf_net -intf_net fir_1_M_AXIS_DATA [get_bd_intf_pins axis_combiner_nb_0/s01_axis] [get_bd_intf_pins fir_1/M_AXIS_DATA]
  connect_bd_intf_net -intf_net fir_2_M_AXIS_DATA [get_bd_intf_pins axis_combiner_nb_0/s02_axis] [get_bd_intf_pins fir_2/M_AXIS_DATA]
  connect_bd_intf_net -intf_net fir_3_M_AXIS_DATA [get_bd_intf_pins axis_combiner_nb_0/s03_axis] [get_bd_intf_pins fir_3/M_AXIS_DATA]
  connect_bd_intf_net -intf_net fir_4_M_AXIS_DATA [get_bd_intf_pins axis_combiner_nb_0/s04_axis] [get_bd_intf_pins fir_4/M_AXIS_DATA]
  connect_bd_intf_net -intf_net fir_5_M_AXIS_DATA [get_bd_intf_pins axis_combiner_nb_0/s05_axis] [get_bd_intf_pins fir_5/M_AXIS_DATA]
  connect_bd_intf_net -intf_net fir_6_M_AXIS_DATA [get_bd_intf_pins axis_combiner_nb_0/s06_axis] [get_bd_intf_pins fir_6/M_AXIS_DATA]
  connect_bd_intf_net -intf_net fir_7_M_AXIS_DATA [get_bd_intf_pins axis_combiner_nb_0/s07_axis] [get_bd_intf_pins fir_7/M_AXIS_DATA]
  connect_bd_intf_net -intf_net fir_8_M_AXIS_DATA [get_bd_intf_pins axis_combiner_nb_0/s08_axis] [get_bd_intf_pins fir_8/M_AXIS_DATA]
  connect_bd_intf_net -intf_net fir_9_M_AXIS_DATA [get_bd_intf_pins axis_combiner_nb_0/s09_axis] [get_bd_intf_pins fir_9/M_AXIS_DATA]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M00_AXI [get_bd_intf_pins axi_dma_1/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M01_AXI [get_bd_intf_pins axis_buffer_uram_0/s_axi] [get_bd_intf_pins ps8_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M02_AXI [get_bd_intf_pins axis_ssrfft_16x16_0/s_axi] [get_bd_intf_pins ps8_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M03_AXI [get_bd_intf_pins ps8_0_axi_periph/M03_AXI] [get_bd_intf_pins usp_rf_data_converter_0/s_axi]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M04_AXI [get_bd_intf_pins axis_xfft_16x32768_0/s_axi] [get_bd_intf_pins ps8_0_axi_periph/M04_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M05_AXI [get_bd_intf_pins axis_chsel_pfb_x1_0/s_axi] [get_bd_intf_pins ps8_0_axi_periph/M05_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M06_AXI [get_bd_intf_pins axis_constant_iq_0/s_axi] [get_bd_intf_pins ps8_0_axi_periph/M06_AXI]
  connect_bd_intf_net -intf_net reg_10_M_AXIS [get_bd_intf_pins axis_pimod_pfb_x1_0/s_axis] [get_bd_intf_pins reg_10/M_AXIS]
  connect_bd_intf_net -intf_net reg_11_M_AXIS [get_bd_intf_pins axis_xfft_16x32768_0/s_axis] [get_bd_intf_pins reg_11/M_AXIS]
  connect_bd_intf_net -intf_net reg_12_M_AXIS [get_bd_intf_pins axis_chsel_pfb_x1_0/s_axis] [get_bd_intf_pins reg_12/M_AXIS]
  connect_bd_intf_net -intf_net reg_13_M_AXIS [get_bd_intf_pins axis_buffer_uram_0/s_axis] [get_bd_intf_pins reg_13/M_AXIS]
  connect_bd_intf_net -intf_net reg_1_M_AXIS [get_bd_intf_pins axis_z1_nb_0/s_axis] [get_bd_intf_pins reg_1/M_AXIS]
  connect_bd_intf_net -intf_net reg_2_M_AXIS [get_bd_intf_pins axis_z1_nb_1/s_axis] [get_bd_intf_pins reg_2/M_AXIS]
  connect_bd_intf_net -intf_net reg_3_M_AXIS [get_bd_intf_pins axis_z1_nb_2/s_axis] [get_bd_intf_pins reg_3/M_AXIS]
  connect_bd_intf_net -intf_net reg_4_M_AXIS [get_bd_intf_pins axis_z1_nb_3/s_axis] [get_bd_intf_pins reg_4/M_AXIS]
  connect_bd_intf_net -intf_net reg_5_M_AXIS [get_bd_intf_pins axis_z1_nb_4/s_axis] [get_bd_intf_pins reg_5/M_AXIS]
  connect_bd_intf_net -intf_net reg_6_M_AXIS [get_bd_intf_pins axis_z1_nb_5/s_axis] [get_bd_intf_pins reg_6/M_AXIS]
  connect_bd_intf_net -intf_net reg_7_M_AXIS [get_bd_intf_pins axis_z1_nb_6/s_axis] [get_bd_intf_pins reg_7/M_AXIS]
  connect_bd_intf_net -intf_net reg_8_M_AXIS [get_bd_intf_pins axis_z1_nb_7/s_axis] [get_bd_intf_pins reg_8/M_AXIS]
  connect_bd_intf_net -intf_net reg_9_M_AXIS [get_bd_intf_pins axis_ssrfft_16x16_0/s_axis] [get_bd_intf_pins reg_9/M_AXIS]
  connect_bd_intf_net -intf_net sysref_in_1 [get_bd_intf_ports sysref_in] [get_bd_intf_pins usp_rf_data_converter_0/sysref_in]
  connect_bd_intf_net -intf_net usp_rf_data_converter_0_m00_axis [get_bd_intf_pins combiner_iq/S00_AXIS] [get_bd_intf_pins usp_rf_data_converter_0/m00_axis]
  connect_bd_intf_net -intf_net usp_rf_data_converter_0_m02_axis [get_bd_intf_pins combiner_iq/S01_AXIS] [get_bd_intf_pins usp_rf_data_converter_0/m02_axis]
  connect_bd_intf_net -intf_net usp_rf_data_converter_0_vout13 [get_bd_intf_ports vout13] [get_bd_intf_pins usp_rf_data_converter_0/vout13]
  connect_bd_intf_net -intf_net vin2_01_1 [get_bd_intf_ports vin2_01] [get_bd_intf_pins usp_rf_data_converter_0/vin0_01]
  connect_bd_intf_net -intf_net vin2_23_1 [get_bd_intf_ports vin2_23] [get_bd_intf_pins usp_rf_data_converter_0/vin0_23]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_M_AXI_HPM0_FPD [get_bd_intf_pins ps8_0_axi_periph/S00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM0_FPD]

  # Create port connections
  connect_bd_net -net clk_adc2_x2_clk_out1 [get_bd_pins axis_buffer_uram_0/s_axis_aclk] [get_bd_pins axis_chsel_pfb_x1_0/aclk] [get_bd_pins axis_combiner_nb_0/aclk] [get_bd_pins axis_pimod_pfb_x1_0/aclk] [get_bd_pins axis_split_iq/aclk] [get_bd_pins axis_ssrfft_16x16_0/aclk] [get_bd_pins axis_switch_pfb_x1_0/aclk] [get_bd_pins axis_xfft_16x32768_0/aclk] [get_bd_pins axis_z1_nb_0/aclk] [get_bd_pins axis_z1_nb_1/aclk] [get_bd_pins axis_z1_nb_2/aclk] [get_bd_pins axis_z1_nb_3/aclk] [get_bd_pins axis_z1_nb_4/aclk] [get_bd_pins axis_z1_nb_5/aclk] [get_bd_pins axis_z1_nb_6/aclk] [get_bd_pins axis_z1_nb_7/aclk] [get_bd_pins clk_adc2_x2/clk_out1] [get_bd_pins combiner_iq/aclk] [get_bd_pins fir_0/aclk] [get_bd_pins fir_1/aclk] [get_bd_pins fir_10/aclk] [get_bd_pins fir_11/aclk] [get_bd_pins fir_12/aclk] [get_bd_pins fir_13/aclk] [get_bd_pins fir_14/aclk] [get_bd_pins fir_15/aclk] [get_bd_pins fir_2/aclk] [get_bd_pins fir_3/aclk] [get_bd_pins fir_4/aclk] [get_bd_pins fir_5/aclk] [get_bd_pins fir_6/aclk] [get_bd_pins fir_7/aclk] [get_bd_pins fir_8/aclk] [get_bd_pins fir_9/aclk] [get_bd_pins reg_0/aclk] [get_bd_pins reg_1/aclk] [get_bd_pins reg_10/aclk] [get_bd_pins reg_11/aclk] [get_bd_pins reg_12/aclk] [get_bd_pins reg_13/aclk] [get_bd_pins reg_2/aclk] [get_bd_pins reg_3/aclk] [get_bd_pins reg_4/aclk] [get_bd_pins reg_5/aclk] [get_bd_pins reg_6/aclk] [get_bd_pins reg_7/aclk] [get_bd_pins reg_8/aclk] [get_bd_pins reg_9/aclk] [get_bd_pins rst_adc2_x2/slowest_sync_clk] [get_bd_pins usp_rf_data_converter_0/m0_axis_aclk]
  connect_bd_net -net clk_adc2_x2_locked [get_bd_pins clk_adc2_x2/locked] [get_bd_pins rst_adc2_x2/dcm_locked]
  connect_bd_net -net rst_100_peripheral_aresetn [get_bd_pins axi_dma_1/axi_resetn] [get_bd_pins axi_smc/aresetn] [get_bd_pins axis_buffer_uram_0/m_axis_aresetn] [get_bd_pins axis_buffer_uram_0/s_axi_aresetn] [get_bd_pins axis_chsel_pfb_x1_0/s_axi_aresetn] [get_bd_pins axis_constant_iq_0/s_axi_aresetn] [get_bd_pins axis_ssrfft_16x16_0/s_axi_aresetn] [get_bd_pins axis_xfft_16x32768_0/s_axi_aresetn] [get_bd_pins ps8_0_axi_periph/ARESETN] [get_bd_pins ps8_0_axi_periph/M00_ARESETN] [get_bd_pins ps8_0_axi_periph/M01_ARESETN] [get_bd_pins ps8_0_axi_periph/M02_ARESETN] [get_bd_pins ps8_0_axi_periph/M03_ARESETN] [get_bd_pins ps8_0_axi_periph/M04_ARESETN] [get_bd_pins ps8_0_axi_periph/M05_ARESETN] [get_bd_pins ps8_0_axi_periph/M06_ARESETN] [get_bd_pins ps8_0_axi_periph/S00_ARESETN] [get_bd_pins rst_100/peripheral_aresetn] [get_bd_pins usp_rf_data_converter_0/s_axi_aresetn]
  connect_bd_net -net rst_adc0_peripheral_aresetn [get_bd_pins axis_buffer_uram_0/s_axis_aresetn] [get_bd_pins axis_chsel_pfb_x1_0/aresetn] [get_bd_pins axis_combiner_nb_0/aresetn] [get_bd_pins axis_pimod_pfb_x1_0/aresetn] [get_bd_pins axis_split_iq/aresetn] [get_bd_pins axis_ssrfft_16x16_0/aresetn] [get_bd_pins axis_switch_pfb_x1_0/aresetn] [get_bd_pins axis_xfft_16x32768_0/aresetn] [get_bd_pins axis_z1_nb_0/aresetn] [get_bd_pins axis_z1_nb_1/aresetn] [get_bd_pins axis_z1_nb_2/aresetn] [get_bd_pins axis_z1_nb_3/aresetn] [get_bd_pins axis_z1_nb_4/aresetn] [get_bd_pins axis_z1_nb_5/aresetn] [get_bd_pins axis_z1_nb_6/aresetn] [get_bd_pins axis_z1_nb_7/aresetn] [get_bd_pins combiner_iq/aresetn] [get_bd_pins reg_0/aresetn] [get_bd_pins reg_1/aresetn] [get_bd_pins reg_10/aresetn] [get_bd_pins reg_11/aresetn] [get_bd_pins reg_12/aresetn] [get_bd_pins reg_13/aresetn] [get_bd_pins reg_2/aresetn] [get_bd_pins reg_3/aresetn] [get_bd_pins reg_4/aresetn] [get_bd_pins reg_5/aresetn] [get_bd_pins reg_6/aresetn] [get_bd_pins reg_7/aresetn] [get_bd_pins reg_8/aresetn] [get_bd_pins reg_9/aresetn] [get_bd_pins rst_adc2_x2/peripheral_aresetn] [get_bd_pins usp_rf_data_converter_0/m0_axis_aresetn]
  connect_bd_net -net rst_adc2_peripheral_reset [get_bd_pins clk_adc2_x2/reset] [get_bd_pins rst_adc2/peripheral_reset]
  connect_bd_net -net rst_dac1_peripheral_aresetn [get_bd_pins axis_constant_iq_0/m_axis_aresetn] [get_bd_pins rst_dac1/peripheral_aresetn] [get_bd_pins usp_rf_data_converter_0/s1_axis_aresetn]
  connect_bd_net -net usp_rf_data_converter_0_clk_adc0 [get_bd_pins clk_adc2_x2/clk_in1] [get_bd_pins rst_adc2/slowest_sync_clk] [get_bd_pins usp_rf_data_converter_0/clk_adc0]
  connect_bd_net -net usp_rf_data_converter_0_clk_dac1 [get_bd_pins axis_constant_iq_0/m_axis_aclk] [get_bd_pins rst_dac1/slowest_sync_clk] [get_bd_pins usp_rf_data_converter_0/clk_dac1] [get_bd_pins usp_rf_data_converter_0/s1_axis_aclk]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins axi_dma_1/m_axi_s2mm_aclk] [get_bd_pins axi_dma_1/s_axi_lite_aclk] [get_bd_pins axi_smc/aclk] [get_bd_pins axis_buffer_uram_0/m_axis_aclk] [get_bd_pins axis_buffer_uram_0/s_axi_aclk] [get_bd_pins axis_chsel_pfb_x1_0/s_axi_aclk] [get_bd_pins axis_constant_iq_0/s_axi_aclk] [get_bd_pins axis_ssrfft_16x16_0/s_axi_aclk] [get_bd_pins axis_xfft_16x32768_0/s_axi_aclk] [get_bd_pins ps8_0_axi_periph/ACLK] [get_bd_pins ps8_0_axi_periph/M00_ACLK] [get_bd_pins ps8_0_axi_periph/M01_ACLK] [get_bd_pins ps8_0_axi_periph/M02_ACLK] [get_bd_pins ps8_0_axi_periph/M03_ACLK] [get_bd_pins ps8_0_axi_periph/M04_ACLK] [get_bd_pins ps8_0_axi_periph/M05_ACLK] [get_bd_pins ps8_0_axi_periph/M06_ACLK] [get_bd_pins ps8_0_axi_periph/S00_ACLK] [get_bd_pins rst_100/slowest_sync_clk] [get_bd_pins usp_rf_data_converter_0/s_axi_aclk] [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_fpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins zynq_ultra_ps_e_0/saxihpc0_fpd_aclk]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_resetn0 [get_bd_pins rst_100/ext_reset_in] [get_bd_pins rst_adc2/ext_reset_in] [get_bd_pins rst_adc2_x2/ext_reset_in] [get_bd_pins rst_dac1/ext_reset_in] [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0]

  # Create address segments
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_1/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HPC0_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_1/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_QSPI] SEG_zynq_ultra_ps_e_0_HPC0_QSPI
  create_bd_addr_seg -range 0x00001000 -offset 0xA0005000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_1/S_AXI_LITE/Reg] SEG_axi_dma_1_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0xA0000000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axis_buffer_uram_0/s_axi/reg0] SEG_axis_buffer_uram_0_reg0
  create_bd_addr_seg -range 0x00001000 -offset 0xA0002000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axis_chsel_pfb_x1_0/s_axi/reg0] SEG_axis_chsel_pfb_x1_0_reg0
  create_bd_addr_seg -range 0x00001000 -offset 0xA0004000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axis_constant_iq_0/s_axi/reg0] SEG_axis_constant_iq_0_reg0
  create_bd_addr_seg -range 0x00001000 -offset 0xA0001000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axis_ssrfft_16x16_0/s_axi/reg0] SEG_axis_ssrfft_16x16_0_reg0
  create_bd_addr_seg -range 0x00001000 -offset 0xA0003000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axis_xfft_16x32768_0/s_axi/reg0] SEG_axis_xfft_16x32768_0_reg0
  create_bd_addr_seg -range 0x00040000 -offset 0xA0040000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs usp_rf_data_converter_0/s_axi/Reg] SEG_usp_rf_data_converter_0_Reg

  # Exclude Address Segments
  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_1/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HPC0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_1/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC0_LPS_OCM]


  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   "ExpandedHierarchyInLayout":"",
   "guistr":"# # String gsaved with Nlview 7.0.19  2019-03-26 bk=1.5019 VDI=41 GEI=35 GUI=JA:9.0 TLS
#  -string -flagsOSRD
preplace port sysref_in -pg 1 -lvl 0 -x -980 -y 4100 -defaultsOSRD
preplace port adc2_clk -pg 1 -lvl 0 -x -980 -y 4020 -defaultsOSRD
preplace port vin2_01 -pg 1 -lvl 0 -x -980 -y 4060 -defaultsOSRD
preplace port vin2_23 -pg 1 -lvl 0 -x -980 -y 4080 -defaultsOSRD
preplace port dac1_clk -pg 1 -lvl 0 -x -980 -y 4040 -defaultsOSRD
preplace port vout13 -pg 1 -lvl 21 -x 5940 -y 4090 -defaultsOSRD
preplace inst axi_dma_1 -pg 1 -lvl 20 -x 5740 -y 3770 -defaultsOSRD
preplace inst axi_smc -pg 1 -lvl 5 -x 1150 -y 940 -defaultsOSRD
preplace inst axis_combiner_nb_0 -pg 1 -lvl 8 -x 2650 -y 3390 -defaultsOSRD
preplace inst axis_pimod_pfb_x1_0 -pg 1 -lvl 13 -x 3840 -y 3520 -defaultsOSRD
preplace inst axis_split_iq -pg 1 -lvl 3 -x 390 -y 1750 -defaultsOSRD
preplace inst axis_ssrfft_16x16_0 -pg 1 -lvl 11 -x 3370 -y 3480 -defaultsOSRD
preplace inst axis_switch_pfb_x1_0 -pg 1 -lvl 9 -x 2880 -y 3410 -defaultsOSRD
preplace inst combiner_iq -pg 1 -lvl 1 -x -230 -y 1710 -defaultsOSRD
preplace inst fir_0 -pg 1 -lvl 7 -x 2220 -y 1720 -defaultsOSRD
preplace inst fir_1 -pg 1 -lvl 7 -x 2220 -y 1840 -defaultsOSRD
preplace inst fir_2 -pg 1 -lvl 7 -x 2220 -y 1960 -defaultsOSRD
preplace inst fir_3 -pg 1 -lvl 7 -x 2220 -y 2080 -defaultsOSRD
preplace inst fir_4 -pg 1 -lvl 7 -x 2220 -y 2200 -defaultsOSRD
preplace inst fir_5 -pg 1 -lvl 7 -x 2220 -y 2320 -defaultsOSRD
preplace inst fir_6 -pg 1 -lvl 7 -x 2220 -y 2440 -defaultsOSRD
preplace inst fir_7 -pg 1 -lvl 7 -x 2220 -y 2560 -defaultsOSRD
preplace inst fir_8 -pg 1 -lvl 7 -x 2220 -y 2680 -defaultsOSRD
preplace inst fir_9 -pg 1 -lvl 7 -x 2220 -y 2800 -defaultsOSRD
preplace inst fir_10 -pg 1 -lvl 7 -x 2220 -y 2920 -defaultsOSRD -resize 260 98
preplace inst fir_11 -pg 1 -lvl 7 -x 2220 -y 3040 -defaultsOSRD -resize 260 98
preplace inst fir_12 -pg 1 -lvl 7 -x 2220 -y 3160 -defaultsOSRD
preplace inst fir_13 -pg 1 -lvl 7 -x 2220 -y 3280 -defaultsOSRD -resize 260 98
preplace inst fir_14 -pg 1 -lvl 7 -x 2220 -y 3400 -defaultsOSRD -resize 260 96
preplace inst fir_15 -pg 1 -lvl 7 -x 2220 -y 3520 -defaultsOSRD -resize 260 98
preplace inst reg_0 -pg 1 -lvl 2 -x 80 -y 1730 -defaultsOSRD
preplace inst reg_1 -pg 1 -lvl 4 -x 860 -y 1700 -defaultsOSRD -resize 180 116
preplace inst reg_2 -pg 1 -lvl 4 -x 860 -y 1940 -defaultsOSRD -resize 180 116
preplace inst reg_3 -pg 1 -lvl 4 -x 860 -y 2180 -defaultsOSRD -resize 180 116
preplace inst reg_4 -pg 1 -lvl 4 -x 860 -y 2420 -defaultsOSRD -resize 180 116
preplace inst reg_5 -pg 1 -lvl 4 -x 860 -y 2660 -defaultsOSRD -resize 180 116
preplace inst reg_6 -pg 1 -lvl 4 -x 860 -y 2900 -defaultsOSRD -resize 180 116
preplace inst reg_7 -pg 1 -lvl 4 -x 860 -y 3140 -defaultsOSRD -resize 180 116
preplace inst reg_8 -pg 1 -lvl 4 -x 860 -y 3380 -defaultsOSRD -resize 180 116
preplace inst reg_9 -pg 1 -lvl 10 -x 3110 -y 3430 -defaultsOSRD -resize 180 116
preplace inst reg_10 -pg 1 -lvl 12 -x 3610 -y 3500 -defaultsOSRD -resize 180 116
preplace inst reg_11 -pg 1 -lvl 14 -x 4070 -y 3540 -defaultsOSRD -resize 180 116
preplace inst reg_12 -pg 1 -lvl 16 -x 4560 -y 3610 -defaultsOSRD -resize 180 116
preplace inst rst_100 -pg 1 -lvl 6 -x 1690 -y 1210 -defaultsOSRD
preplace inst rst_adc2 -pg 1 -lvl 6 -x 1690 -y 4660 -defaultsOSRD
preplace inst usp_rf_data_converter_0 -pg 1 -lvl 6 -x 1690 -y 4100 -defaultsOSRD
preplace inst zynq_ultra_ps_e_0 -pg 1 -lvl 6 -x 1690 -y 970 -defaultsOSRD
preplace inst axis_z1_nb_0 -pg 1 -lvl 6 -x 1690 -y 1720 -defaultsOSRD
preplace inst axis_z1_nb_1 -pg 1 -lvl 6 -x 1690 -y 1960 -defaultsOSRD -resize 180 116
preplace inst axis_z1_nb_2 -pg 1 -lvl 6 -x 1690 -y 2200 -defaultsOSRD -resize 180 116
preplace inst axis_z1_nb_3 -pg 1 -lvl 6 -x 1690 -y 2440 -defaultsOSRD -resize 180 116
preplace inst axis_z1_nb_4 -pg 1 -lvl 6 -x 1690 -y 2680 -defaultsOSRD -resize 180 116
preplace inst axis_z1_nb_5 -pg 1 -lvl 6 -x 1690 -y 2920 -defaultsOSRD -resize 180 116
preplace inst axis_z1_nb_6 -pg 1 -lvl 6 -x 1690 -y 3160 -defaultsOSRD -resize 180 116
preplace inst axis_z1_nb_7 -pg 1 -lvl 6 -x 1690 -y 3400 -defaultsOSRD -resize 180 116
preplace inst clk_adc2_x2 -pg 1 -lvl 6 -x 1690 -y 4810 -defaultsOSRD
preplace inst rst_adc2_x2 -pg 1 -lvl 6 -x 1690 -y 4960 -defaultsOSRD -resize 320 156
preplace inst ps8_0_axi_periph -pg 1 -lvl 7 -x 2220 -y 1100 -defaultsOSRD
preplace inst reg_13 -pg 1 -lvl 18 -x 5090 -y 3680 -defaultsOSRD -resize 180 116
preplace inst axis_xfft_16x32768_0 -pg 1 -lvl 15 -x 4320 -y 3590 -defaultsOSRD
preplace inst axis_chsel_pfb_x1_0 -pg 1 -lvl 17 -x 4810 -y 3660 -defaultsOSRD
preplace inst axis_buffer_uram_0 -pg 1 -lvl 19 -x 5410 -y 3750 -defaultsOSRD
preplace inst rst_dac1 -pg 1 -lvl 6 -x 1690 -y 4370 -defaultsOSRD -resize 320 156
preplace inst axis_constant_iq_0 -pg 1 -lvl 4 -x 860 -y 3840 -defaultsOSRD
preplace netloc rst_100_peripheral_aresetn 1 3 17 670 3620 1000J 3620 1310J 3620 2070 3620 N 3620 N 3620 N 3620 3250 3630 N 3630 N 3630 N 3630 4190 3720 N 3720 4680 3790 N 3790 5210 3620 5540
preplace netloc rst_adc0_peripheral_aresetn 1 0 19 -930 1800 -70 1650 190 1900 630 1780 N 1780 1340 3650 2050 3650 2470 3160 2760 3320 3000 3340 3230 3600 3500 3580 3720 3610 3960 3640 4180 3710 4450 3710 4670 3780 4940 3780 N
preplace netloc zynq_ultra_ps_e_0_pl_clk0 1 3 17 660 1030 990 1030 1330 1060 2060 1360 N 1360 N 1360 N 1360 3240 3370 N 3370 N 3370 N 3370 4180 3480 N 3480 4670 3550 N 3550 5200 3610 5550
preplace netloc zynq_ultra_ps_e_0_pl_resetn0 1 5 2 1360 1090 2020
preplace netloc rst_adc2_peripheral_reset 1 5 2 1370 5070 2010
preplace netloc clk_adc2_x2_clk_out1 1 0 19 -940 1810 -60 1810 200 1910 620 1790 N 1790 1290 1800 2060 3590 2450 3150 2770 3330 2990 3350 3220 3590 3490 3590 3730 3600 3950 3620 4200 3700 4440 3700 4690 3770 4930 3760 N
preplace netloc clk_adc2_x2_locked 1 5 2 1380 5060 2000
preplace netloc usp_rf_data_converter_0_clk_adc0 1 5 2 1330 5080 2040
preplace netloc usp_rf_data_converter_0_clk_dac1 1 3 4 670 4010 N 4010 1350 3920 2000
preplace netloc rst_dac1_peripheral_aresetn 1 3 4 680 4000 N 4000 1300 3910 2030
preplace netloc adc2_clk_1 1 0 6 NJ 4020 NJ 4020 NJ 4020 NJ 4020 NJ 4020 N
preplace netloc reg_11_M_AXIS 1 14 1 N 3540
preplace netloc ps8_0_axi_periph_M04_AXI 1 7 8 NJ 1120 NJ 1120 NJ 1120 NJ 1120 NJ 1120 NJ 1120 NJ 1120 4200
preplace netloc ps8_0_axi_periph_M01_AXI 1 7 12 NJ 1060 NJ 1060 NJ 1060 NJ 1060 NJ 1060 NJ 1060 NJ 1060 NJ 1060 NJ 1060 NJ 1060 NJ 1060 5220
preplace netloc reg_12_M_AXIS 1 16 1 N 3610
preplace netloc axis_split_iq_M02_AXIS 1 3 1 560 1720n
preplace netloc axis_split_iq_M00_AXIS 1 3 1 N 1680
preplace netloc axis_register_slice_0_M_AXIS 1 2 1 N 1730
preplace netloc axis_z1_nb_3_m1_axis 1 6 1 2050 2450n
preplace netloc axis_pimod_pfb_x1_0_m_axis 1 13 1 N 3520
preplace netloc axis_split_iq_M05_AXIS 1 3 1 590 1780n
preplace netloc axis_z1_nb_4_m1_axis 1 6 1 2050 2690n
preplace netloc reg_6_M_AXIS 1 4 2 N 2900 NJ
preplace netloc axi_smc_M00_AXI 1 5 1 N 940
preplace netloc axi_dma_1_M_AXI_S2MM 1 4 17 1010 1340 NJ 1340 NJ 1340 NJ 1340 NJ 1340 N 1340 N 1340 N 1340 N 1340 N 1340 N 1340 N 1340 N 1340 N 1340 N 1340 N 1340 5920
preplace netloc axis_z1_nb_1_m1_axis 1 6 1 2050 1970n
preplace netloc axis_split_iq_M03_AXIS 1 3 1 650 1740n
preplace netloc axis_split_iq_M01_AXIS 1 3 1 580 1700n
preplace netloc axis_combiner_nb_0_m_axis 1 8 1 N 3390
preplace netloc axis_split_iq_M06_AXIS 1 3 1 570 1800n
preplace netloc axis_split_iq_M04_AXIS 1 3 1 610 1760n
preplace netloc fir_6_M_AXIS_DATA 1 7 1 2460 2440n
preplace netloc fir_4_M_AXIS_DATA 1 7 1 2490 2200n
preplace netloc fir_5_M_AXIS_DATA 1 7 1 2480 2320n
preplace netloc fir_2_M_AXIS_DATA 1 7 1 2510 1960n
preplace netloc fir_13_M_AXIS_DATA 1 7 1 2380 3280n
preplace netloc fir_15_M_AXIS_DATA 1 7 1 N 3520
preplace netloc fir_11_M_AXIS_DATA 1 7 1 2400 3040n
preplace netloc fir_3_M_AXIS_DATA 1 7 1 2500 2080n
preplace netloc fir_0_M_AXIS_DATA 1 7 1 2530 1720n
preplace netloc fir_1_M_AXIS_DATA 1 7 1 2520 1840n
preplace netloc fir_14_M_AXIS_DATA 1 7 1 2370 3400n
preplace netloc fir_10_M_AXIS_DATA 1 7 1 2410 2920n
preplace netloc fir_12_M_AXIS_DATA 1 7 1 2390 3160n
preplace netloc fir_7_M_AXIS_DATA 1 7 1 2440 2560n
preplace netloc axis_switch_pfb_x1_0_m_axis 1 9 1 N 3410
preplace netloc axis_ssrfft_16x16_0_m_axis 1 11 1 N 3480
preplace netloc axis_split_iq_M07_AXIS 1 3 1 550 1820n
preplace netloc reg_3_M_AXIS 1 4 2 N 2180 NJ
preplace netloc reg_9_M_AXIS 1 10 1 N 3430
preplace netloc reg_10_M_AXIS 1 12 1 N 3500
preplace netloc sysref_in_1 1 0 6 NJ 4100 NJ 4100 NJ 4100 NJ 4100 NJ 4100 NJ
preplace netloc fir_8_M_AXIS_DATA 1 7 1 2430 2680n
preplace netloc fir_9_M_AXIS_DATA 1 7 1 2420 2800n
preplace netloc axis_z1_nb_2_m1_axis 1 6 1 2050 2210n
preplace netloc reg_5_M_AXIS 1 4 2 N 2660 NJ
preplace netloc reg_4_M_AXIS 1 4 2 N 2420 NJ
preplace netloc axis_z1_nb_4_m0_axis 1 6 1 N 2670
preplace netloc axis_z1_nb_2_m0_axis 1 6 1 N 2190
preplace netloc axis_z1_nb_6_m0_axis 1 6 1 N 3150
preplace netloc reg_7_M_AXIS 1 4 2 NJ 3140 N
preplace netloc reg_8_M_AXIS 1 4 2 N 3380 NJ
preplace netloc axis_z1_nb_7_m1_axis 1 6 1 2050 3410n
preplace netloc reg_1_M_AXIS 1 4 2 N 1700 NJ
preplace netloc reg_2_M_AXIS 1 4 2 N 1940 NJ
preplace netloc axis_z1_nb_1_m0_axis 1 6 1 N 1950
preplace netloc axis_z1_nb_6_m1_axis 1 6 1 2050 3170n
preplace netloc axis_z1_nb_0_m0_axis 1 6 1 N 1710
preplace netloc combiner_iq_M_AXIS 1 1 1 NJ 1710
preplace netloc ps8_0_axi_periph_M00_AXI 1 7 13 N 1040 NJ 1040 NJ 1040 NJ 1040 NJ 1040 NJ 1040 NJ 1040 NJ 1040 NJ 1040 NJ 1040 N 1040 N 1040 5560
preplace netloc zynq_ultra_ps_e_0_M_AXI_HPM0_FPD 1 6 1 2020 920n
preplace netloc ps8_0_axi_periph_M02_AXI 1 7 4 2530 1110 NJ 1110 NJ 1110 3250J
preplace netloc axis_buffer_uram_0_m_axis 1 19 1 N 3750
preplace netloc ps8_0_axi_periph_M03_AXI 1 5 3 1370 1380 NJ 1380 2520
preplace netloc axis_z1_nb_5_m0_axis 1 6 1 N 2910
preplace netloc axis_z1_nb_7_m0_axis 1 6 1 N 3390
preplace netloc axis_z1_nb_5_m1_axis 1 6 1 2050 2930n
preplace netloc axis_z1_nb_3_m0_axis 1 6 1 N 2430
preplace netloc axis_z1_nb_0_m1_axis 1 6 1 2020 1730n
preplace netloc reg_13_M_AXIS 1 18 1 N 3680
preplace netloc axis_chsel_pfb_x1_0_m_axis 1 17 1 N 3660
preplace netloc usp_rf_data_converter_0_m02_axis 1 0 7 -950 1890 NJ 1890 NJ 1890 640J 1860 NJ 1860 NJ 1860 2010
preplace netloc vin2_01_1 1 0 6 NJ 4060 NJ 4060 NJ 4060 NJ 4060 NJ 4060 N
preplace netloc usp_rf_data_converter_0_m00_axis 1 0 7 -960 1880 NJ 1880 NJ 1880 600J 1850 NJ 1850 NJ 1850 2020
preplace netloc axis_xfft_16x32768_0_m_axis 1 15 1 N 3590
preplace netloc vin2_23_1 1 0 6 NJ 4080 NJ 4080 NJ 4080 NJ 4080 NJ 4080 N
preplace netloc ps8_0_axi_periph_M05_AXI 1 7 10 NJ 1140 NJ 1140 NJ 1140 NJ 1140 NJ 1140 NJ 1140 NJ 1140 NJ 1140 NJ 1140 4690
preplace netloc dac1_clk_1 1 0 6 NJ 4040 NJ 4040 NJ 4040 NJ 4040 NJ 4040 N
preplace netloc axis_constant_iq_0_m_axis 1 4 2 1000 3990 1320J
preplace netloc ps8_0_axi_periph_M06_AXI 1 3 5 680 1390 NJ 1390 NJ 1390 NJ 1390 2510
preplace netloc usp_rf_data_converter_0_vout13 1 6 15 NJ 4090 NJ 4090 NJ 4090 NJ 4090 NJ 4090 NJ 4090 NJ 4090 NJ 4090 NJ 4090 NJ 4090 NJ 4090 NJ 4090 NJ 4090 NJ 4090 N
levelinfo -pg 1 -980 -230 80 390 860 1150 1690 2220 2650 2880 3110 3370 3610 3840 4070 4320 4560 4810 5090 5410 5740 5940
pagesize -pg 1 -db -bbox -sgen -1100 -570 6040 5320
"
}

  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


