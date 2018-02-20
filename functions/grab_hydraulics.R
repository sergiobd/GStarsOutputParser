grab_hydraulics = function(output_filename, start_line, end_line){
  # A function that encapsulates a simple parse of a .OUT file. It allows to extract
  # 
  # - output_filenames:
  # The name of the .OUT file
  # 
  # - start_line:
  # The line before the desired reading line
  # 
  # Sample:
  # data = grab_hydraulics("./GStarsOutputParser/sample_data/Pamplonita/2/NOBR_QS2_NT1_SE1_QRAB.OUT", 514,652)
  # 
  # Notes: This function is intended for grabbing the hydraulics (backwater) results. Make sure the lines
  # correspond to a backwater segment of the file.

  num_rows = end_line - start_line
  
  hydraulic_section_names = c("station", "station_distance", "elevation", "flow_area", "flow_velocity", "energy_grade", "froude")
  
  d = read.delim(output_filename, header = FALSE, skip = start_line, nrows = num_rows, sep = "", col.names = hydraulic_section_names)
  
  return(d) 
  
}


