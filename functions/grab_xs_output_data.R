grab_xs_output_data = function( xs_output_filename, output_timestep){ 
  
  
   #  This function allows to parse an .XPL file for cross section analysis. It will get "x" and "y" points for all cross sections in the run for a given timestep:
   # 
   #    - xs_output_filename:
   #    The name of the .XPL file
   # 
   #  - output_timestep:
   #    The index of the timestep that wants to be analyzed.
   # 
   #  There is an example plot script that allows to compare cross section geometries.
   #  Please note that this functions assumes that there are no comments in the first lines of the .XPL file.
   # 
   # Sample:
   # xs_data = grab_xs_output_data("./GStarsOutputParser/sample_data/Pamplonita/2/NOBR_QS2_NT1_SE1_QRAB.XPL", 138)
  
  
  #Example input file: [Yours should be similar, with no description line from GStars, and data starting at line 5]
  
  # * Run on  1/27/2018 At 22:58:43: 5
  # 
  # 
  # 
  # 138
  # 3882.68939435816              216           0
  # 2.86684E+02  4.82224E+03
  # 2.86734E+02  4.82415E+03
  # 2.86734E+02  4.82511E+03
  
  
  #Output data
  
  #xs_output_filename = "steady50012EQ.XPL"
  
  xs_output_aux_data = read.delim(xs_output_filename, header = FALSE, sep = "", skip = 1 )
  
  station_start_indices = which( xs_output_aux_data$V3 == output_timestep)
  
  xs_output_data = data.frame()
  
  filestart_line_offset = 4
  
  for( start_index in station_start_indices){
    
    xs_aux_data = xs_output_aux_data[(start_index + 1): (start_index + xs_output_aux_data$V2[start_index]),1:2]
    
    names(xs_aux_data) = c("y","x") 
    
    xs_aux_data$station_distance = xs_output_aux_data$V1[start_index]
    
    xs_output_data = rbind(xs_aux_data,xs_output_data)
    
  }
  
  return(xs_output_data)
  
}
