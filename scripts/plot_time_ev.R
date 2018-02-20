# Plots a time evolution of the velocoity at each station. Use as an example for studying the time evolution
# of any paramter.
# 
# - timesteps:
# A sequence of the timestep indices to be plotted.


timesteps = seq(10, max(complete_output_data$timestep_index), 15)

# If you used append_data
time_ev_subset = subset(complete_output_data, timestep_index %in% timesteps & model == "EQ" & return_period == 100 & equation == "SE1" )

# Or if you used grab_output_data
# time_ev_subset = subset(output_data, timestep_index %in% timesteps)

p_time_ev = ggplot( time_ev_subset, aes(x = station_distance, y = flow_velocity)) + 
  geom_line( aes(color = timestep_time, group = timestep_time )) +
  scale_color_distiller(palette = "Greys", direction = 1) + 
  theme(panel.background = element_rect(fill = "lightblue")) +
  labs(title = "Flow velocity for different timesteps",
       subtitle = "Equilibrium model, Return period 100, EQ1", 
       x = "Distance to downstream station",
       y = "Flow velocity (m/s)", color = "Time (days)")
  #coord_cartesian( xlim = c(800, 1200))


# LABELS
# Here, labels are on top of one the stations (filtered with station_distance)
label_data_subset = subset( time_ev_subset, station_distance == 250.5 )
p_time_ev = p_time_ev + geom_text( data = label_data_subset, size = 2,
                                   aes(x = station_distance, y = flow_velocity, label = timestep_index))
print(p_time_ev)
