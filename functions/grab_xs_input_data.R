grab_xs_input_data = function( xs_input_filename, x_offset, y_offset){
  # Grabs an input geometry file from HEC-RAS (which has the geometry for each cross-section) and converts it to an R data frame.
  # 
  # - xs_input_filename
  # Name of the HEC-RAS geometry filename
  # 
  # - x_offset:
  # An offset that will be substracted from the x value of the geometry.
  # 
  # - y_offset:
  # An offset that will be substracted from the y value of the geometry.
  
  
  input_header = c("station_distance","Shape_Leng","station",  "x", "z", "y")
  xs_input_data =  read.delim(xs_input_filename, header = TRUE, sep = "", col.names = input_header)
  
  xs_input_data$x = xs_input_data$x - x_offset
  xs_input_data$y = xs_input_data$y - y_offset
  
  return(xs_input_data)
   
}