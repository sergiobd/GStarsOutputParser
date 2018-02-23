# Compare accumulated deposition for several simulation runs.
# 
# - time_index:
#   The timestep_index where accumulated deposition should be studied.
# 
# - stations_up / stations_down:
#   Vector of stations that will be used as text labels
# 
# Assumes all output data has been appended to complete_output_data

require(ggplot2)
time_index = 140

# You may want to do this for the last timestep
# time_index = max ( complete_output_data$timestep_index )


# Filter at will. E.g. if you use this line, and uncomment line add linetype aesthetics to de plot, you can compare results for different models ("Equilibrium" vs. "sediment input")
comp_eq_subset = subset( complete_output_data, timestep_index == time_index & model == "EQ" & equation == "SE1" & as.numeric(station) > 1)

# comp_eq_subset = subset( complete_output_data, timestep_index == time_index & model == "EQ" & as.numeric(station) > 1 & return_period == 100 )

# comp_eq_subset = subset( complete_output_data, timestep_index == time_index & equation == "SE1" & model == "EQ")

p_comp_eq = ggplot( data = comp_eq_subset, aes (x = station_distance, y = AccDep_tons, color = factor(return_period)))
# p_comp_eq = ggplot( data = comp_eq_subset, aes (x = station_distance, y = AccDep_tons , color = factor(equation)))

# p_comp_eq = p_comp_eq + geom_line(size = 1, aes(linetype = model))  #Uncomment if you want to add linetype aesthetics.

p_comp_eq = p_comp_eq + geom_line(size = 1)
p_comp_eq  = p_comp_eq  + labs( title = "Accumulated deposition for last timestep (29h)",
                                subtitle = "Peak-time, EQ1, sediments in equilibrium",
                                x = "Distance from downstream station (m)" ,
                                y = "Accumulated deposition (tons)", color = "Return period")
# Matrix plot:
# p_comp_eq = p_comp_eq + facet_grid(  return_period ~ ., switch = "y")


# LABELS 

# station labels are on top and below the lines
stations_up = c( 17, 28, 40, 47, 54, 60, 72, 95, 99, 104, 112)
label_data_up = subset( comp_eq_subset ,
                      return_period == 500 & station %in% stations_up )

stations_down = c(8, 12, 16, 19, 36, 44, 49, 57, 67, 94, 101, 106, 137)
label_data_down = subset( comp_eq_subset ,
                        return_period == 500 & station %in% stations_down )

p_comp_eq = p_comp_eq +
  geom_text(data = label_data_up , size = 3, color = "black",
          aes(x = station_distance, y = AccDep_tons, label= station, vjust = -3.5) ) +
  geom_text(data = label_data_down , size = 3, color = "black",
            aes(x = station_distance, y = AccDep_tons, label= station, vjust = 3.5) ) +
  coord_cartesian(ylim = c(-6500,9000))
  #geom_segment(data = label_data,
   #            aes(x = station_distance, y = Thalweg + 0.5, yend = Thalweg + 1, xend = station_distance )) #Uncomment for line segments


print(p_comp_eq)
