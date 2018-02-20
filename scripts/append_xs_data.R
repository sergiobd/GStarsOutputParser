
# This script is the equivalent of append_data but for cross-sections. It allows to append cross-section data (.XPL files) from different runs in order to compare the results with different simulation parameters (return period, equilibrium vs. sediment input model, and equation). "complete_xs_output_data" will contain the results for all cross-sections of the runs, for a given timestep.
# 
# - filenames:
#   A vector with the names of the .XPL files
# 
# - return_period:
#   A vector containing the return period of each run in filenames.
# 
# - model:
#   A vector containing the model (equilibrium vs. sediment input)
# 
# - equations:
#   A vector containing the names (or accronyms) of the equation used for run (e.g. Meyer-Peter&Muller, Parker, etc... )
# 
# - num_stations:
#   The number of stations used in this run
# 
# - timestep:
#   The timestep that wants to be analyzed.
# 
# Once the data has been appended to complete_xs_output_data the results can be compared with one of the plot scripts.
# 

meta_data = data.frame (filename = character(), return_period = integer (), model = factor() , equation = factor() )
meta_data = data.frame()


num_stations = 138

timestep = 140

filenames = c(
  "./corridas/2/NOBR_QS2_NT1_SE1_QREQ.XPL",
  "./corridas/25/NOBR_QS25_NT1_SE1_QREQ.XPL",
  "./corridas/100/NOBR_QS100_NT1_SE1_QREQ.XPL",
  "./corridas/500/NOBR_QS500_NT1_SE1_QREQ.XPL",
  
  "./corridas/2/NOBR_QS2_NT1_SE1_QRAB.XPL",
  "./corridas/25/NOBR_QS25_NT1_SE1_QRAB.XPL",
  "./corridas/100/NOBR_QS100_NT1_SE1_QRAB.XPL",
  "./corridas/500/NOBR_QS500_NT1_SE1_QRAB.XPL",
  
  
  "./corridas/2/NOBR_QS2_NT1_SE11_QREQ.XPL",
  "./corridas/25/NOBR_QS25_NT1_SE11_QREQ.XPL",
  "./corridas/100/NOBR_QS100_NT1_SE11_QREQ.XPL",
  "./corridas/500/NOBR_QS500_NT1_SE11_QREQ.XPL",
  
  "./corridas/2/NOBR_QS2_NT1_SE11_QRAB.XPL",
  "./corridas/25/NOBR_QS25_NT1_SE11_QRAB.XPL",
  "./corridas/100/NOBR_QS100_NT1_SE11_QRAB.XPL",
  "./corridas/500/NOBR_QS500_NT1_SE11_QRAB.XPL"
)


# Make sure this is consistent with your filenames!

return_period = c(2, 25, 100, 500,   2, 25, 100, 500,    2, 25, 100, 500,   2, 25, 100, 500)

model = c("EQ","EQ","EQ","EQ", "AB","AB","AB","AB",     "EQ","EQ","EQ","EQ",  "AB","AB","AB","AB"   )

equation = c("SE1", "SE1", "SE1", "SE1", "SE1", "SE1", "SE1", "SE1",    "SE11", "SE11", "SE11", "SE11", "SE11", "SE11", "SE11", "SE11")

meta_data[1:length(filenames), "filename"] = filenames
meta_data[1:length(filenames), "return_period"] = return_period
meta_data[1:length(filenames), "model"] = model
meta_data[1:length(filenames), "equation"] = equation



complete_xs_output_data = data.frame(
  station_distance = double(),
  x = double(),
  y = double(),
  type = character(),
  model = character(),
  return_period = integer(),
  equation = character(),
  
  stringsAsFactors = FALSE
  
)

for( i in 1:nrow(meta_data) ){
  
  temp_output = grab_xs_output_data( meta_data$filename[i], timestep )
  
  temp_output$model = meta_data$model[i]
  temp_output$return_period = meta_data$return_period[i]
  temp_output$equation = meta_data$equation[i]
  
  complete_xs_output_data = rbind( complete_xs_output_data, temp_output)
  
}

