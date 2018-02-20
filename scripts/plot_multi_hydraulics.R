# Plot some hydraulic parameters from one or several runs
# 
# - vel_time:
#   The timestep_index where flow_velocity wants to be studied.
# 
# Requires ggplot2 and multiplot http://www.cookbook-r.com/Graphs/Multiple_graphs_on_one_page_(ggplot2)/ if you want to plot simultaneouly several parameters.
# Assumes data has already been grabbed using grab_output_data and/or append_data


require( ggplot2)




#### FLOW VELOCITY


vel_time = 42 
station_labels = c(28,36, 45, 49, 60, 64, 94, 99)

# Use this line if you used append_output_data and therefore you have data from different runs in complete_output_data
vel_subset = subset (complete_output_data, timestep_index == vel_time & equation == "SE1" & model == "EQ" & return_period == 100  & station_distance < 3880)

vel_label_subset = subset( vel_subset, station %in% station_labels)

# Use this line if you grabbed data from only one run using grab_output_data and you have in output_data
#vel_subset = subset (output_data, timestep_index == vel_time )
  

p_flow_vel = ggplot( data = vel_subset, aes (x = station_distance, y  = flow_velocity ) ) +
  geom_line() + 
  labs(title = "Flow velocity, flow area and water level", x = "Distance to downstream station", y = "Flow velocity (m/s)",
       subtitle = "Peak time, Return period 100, Equilibrium model, EQ11") +
  geom_text( data = vel_label_subset, size = 3, aes(label = station, x = station_distance, y = flow_velocity, vjust = 3)) +
  geom_segment( data = vel_label_subset, aes(xend = station_distance, y = flow_velocity - 0.05 , yend = flow_velocity - 0.2)) #+
  #scale_color_distiller(palette = "RdBu") + theme_dark()

# Use this if you dont want to plot several variables in a single window.
# print(p_flow_vel)

 

### FLOW AREA

p_flow_area = ggplot( data = vel_subset, aes (x = station_distance, y = flow_area ) ) +
  geom_line(   ) + 
  labs(x = "Distance to downstream station", y =  expression(  paste("Flow area - " , m^{2} ) ) ) +
  geom_text( data = vel_label_subset, size = 3, aes(label = station, x = station_distance, y = flow_area, vjust = -2)) +
  geom_segment( data = vel_label_subset, aes(xend = station_distance, y = flow_area + 10 , yend = flow_area + 20))


#Uncomment this line for changing axis limits
# p_flow_area = p_flow_area + coord_cartesian(ylim = c( 50, 600))


p_height = ggplot( data = vel_subset, aes (x = station_distance, y = water_surf_elevation - Thalweg ) ) +
  geom_line(   ) + 
  labs(x = "Distance to downstream station", y =  "Water level (m)" ) +
  geom_text( data = vel_label_subset, size = 3, aes(label = station, x = station_distance, y =  water_surf_elevation - Thalweg , vjust = -2)) +
  geom_segment( data = vel_label_subset, aes(xend = station_distance,
                                             y = water_surf_elevation - Thalweg + 0.12 , 
                                             yend = water_surf_elevation - Thalweg + 0.3))

#print(p_flow_area)

# OTHER HYDRAULIC PARAMETERS
  
### FROUDE NUMBER
#   
# p_froude = ggplot( data = vel_subset, aes (x = station_distance, y = froude)) +
#   geom_line() +
#   labs(x = "Distance to downstream station", y =  "Froude number") +
#   geom_text( data = vel_label_subset, size = 3, aes(label = station, x = station_distance, y = froude, vjust = 2))# +
  # coord_cartesian(xlim = c(3000, 4000)) 
  
# print(p_froude)

  
### THALWEG

# Use this line if you grabbed data from only one run using grab_output_data and you have in output_data
# thalweg_subset = subset( output_data,
#                          timestep_index == vel_time )


# Use this line if you used append_output_data and therefore you have data from different runs in complete_output_data
# thalweg_subset = subset( complete_output_data, timestep_index = 1,
#                          timestep_index == vel_time & equation == "SE1" & model == "EQ" & return_period == 100 )
# 
# p_thalweg = ggplot( data = thalweg_subset, aes( x = station_distance, y = Thalweg)) +
#   geom_line( )

# print( p_thalweg)


multiplot( p_flow_vel, p_flow_area, p_height, cols = 1) 

 
 