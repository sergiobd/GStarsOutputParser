# This script appends data from several GSTARS runs (several .OUT files) and appends them in a single data frame.
# It is therefore possible to compare the results from experiments with different parameters (namely: return period, sediment model, equation).
# 
# - filenames:
#   A character vector containing the names of .OUT files
# 
# - return_period:
#   A vector containing the return period of each run in filenames
# 
# - model:
#   A vector containing the model (equilibrium vs. sediment input)
# 
# - equations:
#   A vector containg the names (or accronyms) of the equation used for run (e.g. Meyer-Peter&Muller, Parker, etc... )
# 
# - num_stations:
#   The number of stations used in this run
# 
# Once the data has been appended to output_data_frame, the results can be compared with the plot scripts.




# Make sure filenames, return_period, model, and equation vectors are consistent!

filenames = c(
    "./corridas/2/NOBR_QS2_NT1_SE1_QREQ.OUT",
    "./corridas/25/NOBR_QS25_NT1_SE1_QREQ.OUT",
    "./corridas/100/NOBR_QS100_NT1_SE1_QREQ.OUT",
    "./corridas/500/NOBR_QS500_NT1_SE1_QREQ.OUT",
    
    "./corridas/2/NOBR_QS2_NT1_SE1_QRAB.OUT",
    "./corridas/25/NOBR_QS25_NT1_SE1_QRAB.OUT",
    "./corridas/100/NOBR_QS100_NT1_SE1_QRAB.OUT",
    "./corridas/500/NOBR_QS500_NT1_SE1_QRAB.OUT",
    
    
    "./corridas/2/NOBR_QS2_NT1_SE11_QREQ.OUT",
    "./corridas/25/NOBR_QS25_NT1_SE11_QREQ.OUT",
    "./corridas/100/NOBR_QS100_NT1_SE11_QREQ.OUT",
    "./corridas/500/NOBR_QS500_NT1_SE11_QREQ.OUT",
    
    "./corridas/2/NOBR_QS2_NT1_SE11_QRAB.OUT",
    "./corridas/25/NOBR_QS25_NT1_SE11_QRAB.OUT",
    "./corridas/100/NOBR_QS100_NT1_SE11_QRAB.OUT",
    "./corridas/500/NOBR_QS500_NT1_SE11_QRAB.OUT"
  )

return_period = c(2, 25, 100, 500,   2, 25, 100, 500,    2, 25, 100, 500,   2, 25, 100, 500)

model = c("EQ","EQ","EQ","EQ", "AB","AB","AB","AB",     "EQ","EQ","EQ","EQ",  "AB","AB","AB","AB"   )

equation = c("SE1", "SE1", "SE1", "SE1", "SE1", "SE1", "SE1", "SE1",    "SE11", "SE11", "SE11", "SE11", "SE11", "SE11", "SE11", "SE11")



#Set meta_data data frame

meta_data = data.frame (filename = character(), return_period = integer (), model = factor() , equation = factor() )
meta_data = data.frame()

# SET METADATA


num_stations = 138

meta_data[1:length(filenames), "filename"] = filenames
meta_data[1:length(filenames), "return_period"] = return_period
meta_data[1:length(filenames), "model"] = model
meta_data[1:length(filenames), "equation"] = equation


complete_output_data = data.frame(
  
  station = integer(),
  AccDep_tons = double(),
  AccDep_m3 = double(),

  AccDepG1 = double(),
  AccDepG2 = double(),
  AccDepG3 = double(),
  
  timestep_index = integer(),
  timestep_time = double(), 
  
  discharge = double(), 
  
  incoming_sediments_s1 = double(),
  incoming_sediments_s2 = double(),
  incoming_sediments_s3 = double(),
  
  station_distance = double(),
  
  water_surf_elevation = double(),
  flow_area = double(),
  flow_velocity = double(),
  energy_gradeline_elevation = double(),
  froude = double(), 
  Thalweg = double(),
  
  model = character(),
  return_period = integer(),
  equation = character(),
  
  stringsAsFactors = TRUE
  
  )

for( i in 1:nrow(meta_data)){
  
  temp_output = grab_output_data( meta_data$filename[i], num_stations)
  
  temp_output$model = meta_data$model[i]
  temp_output$return_period = meta_data$return_period[i]
  temp_output$equation = meta_data$equation[i]
  
  complete_output_data = rbind( complete_output_data, temp_output)
  
}
  
  
  
  



