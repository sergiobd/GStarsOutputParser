# GStarsOutputParser


GSTARS ([Generalized Stream Tube computer models for Alluvial River Simulation](http://www.engr.colostate.edu/ce/facultystaff/yang/gstars.html)) was developed by the U.S. Bureau of Reclamation for studying steady and quasi-steady flows. 

GSTARS was written in FORTRAN and its output consists in a series of structured but complex data files containing both hydraulic, sediment transport, and cross-section data. Raw output files are difficult to use unless they are parsed into friendlier structures for analysis. The GSTARS Output Parser is a set of functions and scripts for [R](https://www.r-project.org/) that allow to parse and plot GSTARS output data. 

GSTARS has two main output files: 
- A .OUT file that has hydraulic and sediment data for each simulation step
- An .XPL file that contains cross-section data

This toolset assumes that the output level of GSTARS is 3. See page. 109 of the manual.

The GSTARS Output Parser allows to load data from one or several simulation runs into a single [R](https://www.r-project.org/) data frame. Therefore, simulation runs with different parameter sets can be compared. The toolset contains a series of functions for parsing .OUT (hydraulic and sediment routing data) and .XPL (cross-section data) files and several scripts for plotting hydraulic and sediment results.
.OUT files from Pamplonita River, in Santander, Colombia, are added as sample data. .XPL files are too large to be hosted in GitHub.
Please note that most of the plotting scripts require R's [ggplot2](http://ggplot2.org/) package.

This toolset was written for [Juliana Dimate's](https://www.linkedin.com/in/jdimate/) hydraulic assessment of the Pamplonita river in Santander, Colombia.  

These are some plots that can be drawn with the GSTARS Output Parser

## Reference - Functions

#### grab_output_data (output_filename, num_stations)
This function will parse output_filename (which is the output of GSTAR4 in level3 printout) and return a data frame containing:

  - timestep index
  - timestep time
  - discharge
  - station
  - accumulated deposition (tonnes)
  - accumulated deposition (m3)
  - accumulated deposition for group 1
  - accumulated deposition for group 2
  - accumulated deposition for group 3

  *output_filename:* The name of the .OUT file
  
  *num_stations:* The number of stations (cross-sections) that were used for the simulations.

  Sample:

  `data = grab_output_data("./GStarsOutputParser/sample_data/Pamplonita/2/NOBR_QS2_NT1_SE1_QRAB.OUT", 138)`


#### grab_hydraulics (output_filename, start_line, end_line)
A function that encapsulates a simple parse of a .OUT file.

  *output_filenames:* The name of the .OUT file

  *start_line:* The line before the desired reading line
  
  *end_line:* The last line to be read

  Sample:
  `data = grab_hydraulics("./GStarsOutputParser/sample_data/Pamplonita/2/NOBR_QS2_NT1_SE1_QRAB.OUT", 514,652)`
  
  Note: This function is intended for grabbing the hydraulics (backwater) results. Make sure the lines
  correspond to a backwater segment of the file.


#### grab_xs_input_data (xs_input_filename, x_offset, y_offset)
Grabs an input geometry file from HEC-RAS (with the geometry for each cross-section) and converts it to an R data frame.

  *xs_input_filename:* Name of the HEC-RAS geometry filename

  *x_offset:* An offset that will be substracted from the x value of the geometry.

  *y_offset:* An offset that will be substracted from the y value of the geometry.


#### grab_xs_output_data (xs_output_filename, output_timestep)
Allows to parse an .XPL file for cross section analysis. It will get "x" and "y" points for all cross sections in the run for a given timestep:

*xs_output_filename:* The name of the .XPL file

*output_timestep:* The index of the timestep that wants to be analyzed.

Sample:
`xs_data = grab_xs_output_data("./GStarsOutputParser/sample_data/Pamplonita/2/NOBR_QS2_NT1_SE1_QRAB.XPL", 138)`


## Reference - Scripts

#### append_data

This script appends data from several GSTARS runs (several .OUT files) and appends them in a single data frame.
It is therefore possible to compare the results from experiments with different parameters (namely: return period, sediment model, equation).

*filenames:* A character vector containing the names of .OUT files

*return_period:* A vector containing the return period of each run in filenames

*model:* A vector containing the model (equilibrium vs. sediment input)

*equations:* A vector containg the names (or accronyms) of the equation used for run (e.g. Meyer-Peter&Muller, Parker, etc... )

*num_stations:* The number of stations used in this run

Once the data has been appended to `output_data_frame`, the results can be compared with the plot scripts.


#### append_xs_data

This script is the equivalent of `append_data` but for cross-sections. It allows to append cross-section data (.XPL files) from different runs in order to compare the results with different simulation parameters (return period, equilibrium vs. sediment input model, and equation). `complete_xs_output_data` will contain the results for all cross-sections of the runs, for a given timestep.

*filenames:* A vector with the names of the .XPL files

*return_period:* A vector containing the return period of each run in filenames.

*model:* A vector containing the model (equilibrium vs. sediment input)

*equations:* A vector containing the names (or accronyms) of the equation used for run (e.g. Meyer-Peter&Muller, Parker, etc... )

*num_stations:* The number of stations used in this run

*timestep:* The timestep that wants to be analyzed.

Once the data has been appended to complete_xs_output_data the results can be compared with one of the plot scripts.


#### plot_matrix_cross_sections

Plots input and output (after simulation) cross sections in a distance range.
It will plot the profile of cross sections between min_distance and max_distance

*min_distance:* Inferior limit of distance range

*max_distance:* Superior limit of distance range

*input_xs_filename:* Name of the text file containing input cross section data (before simulation)

Assumes cross-section data has been appended to complete_xs_output_data. Please see comments in code.


#### plot_multi_hydraulics

Plot some hydraulic parameters from one or several runs

*vel_time:* The timestep_index where flow_velocity wants to be studied.

Requires ggplot2 and multiplot http://www.cookbook-r.com/Graphs/Multiple_graphs_on_one_page_(ggplot2)/ if you want to plot simultaneouly several parameters.
Assumes data has already been grabbed using `grab_output_data` and/or `append_data`.


#### plot_AccDep_vs_Distance

Compare accumulated deposition for several simulation runs.

*time_index:* The timestep_index where accumulated deposition should be studied.

*stations_up / stations_down:* Vector of stations that will be used as text labels

Assumes all output data has been appended to `complete_output_data`


#### plot_time_ev

Plots a time evolution of the velocoity at each station. Use as an example for studying the time evolution
of any paramter.

*timesteps:* A sequence of the timestep indices to be plotted.
Plots a time evolution of the velocoity at each station. Use as an example for studying the time evolution
of any paramter.

*timesteps:* A sequence of the timestep indices to be plotted.


#### plot_Thalweg_vel

A vertical profile of the reach colored by flow velocity

*timestep:* Timestep where flow_velocity wants to be studied

#### plot_Thalweg_energyGradeline_WaterSurface

Plots energy gradeline elevation, water surface elevation and thalweg for a given timestep.

*time_index:* The timestep_index that wants to be studied (water_surface_elevation, and water_surface_elevation are time varying."


####  plots_AccDep_StationDistance_Thalweg

Plots a vertical profile of the reach colored with accumulated depostions.
Therefore, this script allows to evaluate how the geometry of the reach is related to deposition.

*timestep:* `timestep_index` where deposition wants to be studied.

*stations_up / stations_down:* Vector of stations that will be used as text labels

Requires multiplot.R, http://www.cookbook-r.com/Graphs/Multiple_graphs_on_one_page_(ggplot2)/"


