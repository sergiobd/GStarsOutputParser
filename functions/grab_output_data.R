grab_output_data = function(output_filename, num_stations){ 
  # This function will parse output_filename (which is the output of GSTAR4 in level3 printout) and return a data frame containing:
  # 
  # - timestep index
  # - timestep time
  # - discharge
  # - station
  # - accumulated deposition (tonnes)
  # - accumulated deposition (m3)
  # - accumulated deposition for group 1
  # - accumulated deposition for group 2
  # - accumulated deposition for group 3
  # 
  # 
  # Input:
  # 
  # - output_filename:
  # The name of the .OUT file
  # 
  # -num_stations:
  # The number of stations (cross-sections) that were used for the simulations.
  # 
  # Sample:
  # 
  # data = grab_output_data("./GStarsOutputParser/sample_data/Pamplonita/2/NOBR_QS2_NT1_SE1_QRAB.OUT", 138)

  #setwd( "C:/Users/Sergio/Documents/R/juliana" )
  
  #output_filename = "steady50012EQ.OUT"
  
  
  
  
  ##### GRAB THALWEG
  
  thalweg_headers = c("station", "Location" ,  "ISWITCH"  ,
                      "ITYP",   "Thalweg",     "Bed slope",   "Loss",  "NDIVI", "NPOINTS")
  
  thalweg_data = read.delim(output_filename, header = FALSE, skip = 48, nrows = num_stations, sep = "", col.names = thalweg_headers)
  
  
  
  
  
  #####  GRAB TIMESTAMPS / DISCHARGES LOCATION
  
  timestep_text = "   TIME STEP NO."
  
  input_file_text = readLines(output_filename)
  
  # get line indices of timestep_text occurrences
  timestep_location = grep(timestep_text, input_file_text)
  
  # get whole lines
  ts_lines = input_file_text[timestep_location]
  
  # get indices
  timestep_indices = type.convert( substr(ts_lines, 18,23))
  
  #get timestamps
  timestep_times = type.convert(substr(ts_lines,31,40 ))
  
  #get discharges
  timestep_discharges = type.convert(substr(ts_lines,62,71))
  
  
  
  
  
  #####  GRAB SEDIMENT ROUTING DATA LOCATION
  
  #get indices of occurences of *       SEDIMENT ROUTING RESULTS FOR TIME STEP "
  sediment_text = "SEDIMENT ROUTING RESULTS FOR TIME STEP"
  
  sediment_results_location = grep(sediment_text, input_file_text)
  
  
  # num_stations = 15
  # get starting line of "accumulated deposition for whole stream"
  # [Constants are line-offsets, etc, in GSTARS output file]
  output_data_location = sediment_results_location + 23 + 3*(num_stations + 6 + 2) + 8
  
  #backwater data lines
  backwater_results_location = timestep_location +  12
  backwater_results_headers = c("station_distance", "water_surf_elevation", "flow_area", "flow_velocity", "energy_gradeline_elevation", "froude")
  
  
  #header names for accumulated deposition
  output_data_headers = c("station", "AccDep_tons", "AccDep_m3","AccDepG1","AccDepG2","AccDepG3")
  
  output_data = data.frame()

  
  #Extract data using output_data_location and append it to the output_data data frame
  for( i in seq(1:length(timestep_indices) ) ){
    
    #sediments
    temp_data_frame = read.delim(output_filename, header = FALSE, skip = output_data_location[i], nrows = num_stations+1, sep = "", col.names = output_data_headers)
    temp_data_frame$timestep_index = timestep_indices[i]
    temp_data_frame$timestep_time = timestep_times[i]
    temp_data_frame$discharge = timestep_discharges[i]
    
    incoming_sediments_s1_string = as.character( read.delim(output_filename, header = FALSE, skip = sediment_results_location[i] + 9 , nrows = 1)$V1 )
    incoming_sediments_s1_value = as.numeric( substr( incoming_sediments_s1_string, 41, 63))
    
    incoming_sediments_s2_string = as.character( read.delim(output_filename, header = FALSE, skip = sediment_results_location[i] + 14 , nrows = 1)$V1 )
    incoming_sediments_s2_value = as.numeric( substr( incoming_sediments_s2_string, 41, 63))
    
    incoming_sediments_s3_string = as.character( read.delim(output_filename, header = FALSE, skip = sediment_results_location[i] + 19 , nrows = 1)$V1 )
    incoming_sediments_s3_value = as.numeric( substr( incoming_sediments_s3_string, 41, 63))
    
    temp_data_frame$incoming_sediments_s1 = incoming_sediments_s1_value
    temp_data_frame$incoming_sediments_s2 = incoming_sediments_s2_value
    temp_data_frame$incoming_sediments_s3 = incoming_sediments_s3_value
    
    
    
    #Backwater
    temp_data_frame2 = read.delim(output_filename, header = FALSE, skip = backwater_results_location[i], 
                                  nrows = num_stations + 1, sep = "", col.names = c("backwater_station",backwater_results_headers)) 
    temp_data_frame[backwater_results_headers] = temp_data_frame2[backwater_results_headers]
    
    output_data = rbind(output_data, temp_data_frame)
    
  }
  
  output_data = merge(output_data, thalweg_data[c("station", "Thalweg")])

  return(output_data)
  
}














