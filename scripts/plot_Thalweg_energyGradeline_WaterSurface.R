# Plots energy gradeline elevation, water surface elevation and thalweg for a given timestep.
# 
# - time_index:
# 
# The timestep_index that wants to be studied (water_surface_elevation, and water_surface_elevation are time varying."
# Assumes all output data has been appended to complete_output_data

require(ggplot2)
time_index = 42

# Use this line if you used append_data and therefore complete_output_data contains your data.
comp_eq_subset = subset( complete_output_data, timestep_index == time_index & equation == "SE1" & model == "EQ" & return_period == 100)

p_comp_eq = ggplot( data = comp_eq_subset, aes (x = station_distance ) ) +
  geom_line( aes( y = energy_gradeline_elevation, color = "Energy gradeline elevation")) +
  geom_line( aes( y = water_surf_elevation, color = "Water surface elevation")) +
  geom_line( aes(y = Thalweg, color = "Thalweg") ) +
  scale_color_manual("", breaks = c("Energy gradeline elevation", "Water surface elevation","Thalweg" ),
                     values = c("#1b9e77", "#d95f02", "#7570b3")
  )

p_comp_label_subset = subset( comp_eq_subset, station %in% c(94, 136, 138))

p_comp_eq  = p_comp_eq  + labs( title = "Thalweg, energy gradeline, and water surface elevation",
                                subtitle = "Return period 100, equilibrium model, EQ1, peak-time",
                                x = "Distance from downstream station (m)" ,
                                y = "meters",
                                color = "Legend")+
  geom_text( data = p_comp_label_subset, size = 3.5, aes( label = station, x = station_distance, y = Thalweg , 
                                              vjust = -c(1.2, 1.2,1.2), hjust = c(0, 0.4,0 )))


print(p_comp_eq)
