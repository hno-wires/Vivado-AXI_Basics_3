###############################################################################
 #  Copyright (c) 2018, Xilinx, Inc.
 #  All rights reserved.
 #
 #  Redistribution and use in source and binary forms, with or without
 #  modification, are permitted provided that the following conditions are met:
 #
 #  1.  Redistributions of source code must retain the above copyright notice,
 #     this list of conditions and the following disclaimer.
 #
 #  2.  Redistributions in binary form must reproduce the above copyright
 #      notice, this list of conditions and the following disclaimer in the
 #      documentation and/or other materials provided with the distribution.
 #
 #  3.  Neither the name of the copyright holder nor the names of its
 #      contributors may be used to endorse or promote products derived from
 #      this software without specific prior written permission.
 #
 #  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 #  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 #  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 #  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
 #  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 #  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 #  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 #  OR BUSINESS INTERRUPTION). HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 #  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 #  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 #  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 #
###############################################################################
 # @file create_proj.tcl
 #
 #	Tcl script for re-creating project AXI Basic Series 3
 # 
 #
###############################################################################

# Configuration - Can be modified by the user
set project_name 				AXI_Basics_3
set BD_name 					AXI_GPIO_Sim

# Create a new project
create_project ${project_name} ./${project_name} -part xc7z020clg484-1
set_property target_language Verilog [current_project]

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset -quiet constrs_1
}


# Create 'sim_1' fileset (if not found)
if {[string equal [get_filesets -quiet sim_1] ""]} {
  create_fileset -simset sim_1
}
# Add simulation files
add_files -fileset sim_1 -norecurse -scan_for_includes ./sim
import_files -fileset sim_1 -norecurse ./sim

set design_name 	$BD_name

# Build the Block Design
# Build the Block Design
source ./tcl/bd.tcl

# Validate the BD
regenerate_bd_layout
validate_bd_design 
save_bd_design

#Generate the wrapper
make_wrapper -files [get_files ${BD_name}.bd] -top

# Add the wrapper to the fileset
set obj [get_filesets sources_1]
set files [list "[file normalize [glob "./$project_name/$project_name.gen/sources_1/bd/$BD_name/hdl/${BD_name}_wrapper.v"]]"]
add_files -norecurse -fileset $obj $files

# Generate the output products
#generate_target all [get_files ./$project_name/$project_name.gen/sources_1/bd/$BD_name/$BD_name.bd]
#create_ip_run [get_files -of_objects [get_fileset sources_1] ./$project_name/$project_name.gen/sources_1/bd/$BD_name/$BD_name.bd]
#launch_runs -jobs 8 [get_runs $BD_name*synth_1]
