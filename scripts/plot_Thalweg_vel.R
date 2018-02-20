# A vertical profile of the reach colored by flow_velocity
# 
# - timestep:
#   Timestep where flow_velocity wants to be studied
# 
# Thalweg colored by velocity

require(ggplot2)

timestep = 42

# If you use append_data
thalweg_subset = subset( complete_output_data,
                         timestep_index == vel_time & equation == "SE1" & model == "EQ" & return_period == 100 )

# If you used grab_output_data
# thalweg_subset = subset( output_data,
#                          timestep_index == vel_time )


p_thalweg = ggplot( data = thalweg_subset, aes( x = station_distance, y = Thalweg)) +
  labs( title = "Thalweg and velocity",
        subtitle = "Return period 100, equilibrium model, EQ1, peak time",
                                y = "Thalweg (meters)",
                                x ="Distance from downstream station (m)",
        color = "Flow velocity (m/s)")+
  geom_point( aes(color = flow_velocity)) +
  scale_color_distiller(palette = "RdBu")


# LABELS
label_data = subset( thalweg_subset[ c( "station", "station_distance", "Thalweg")] ,
                     station %in% c( seq(5, num_stations, 10 ) , 99, 49, 28 , 138, 60))

p_thalweg = p_thalweg + 
  geom_text(data = label_data , size = 3, 
            aes(x = station_distance, y = Thalweg, label= station, vjust = -3.5) ) + 
  geom_segment(data = label_data,
               aes(x = station_distance, y = Thalweg + 0.5, yend = Thalweg + 1, xend = station_distance ))

print(p_thalweg)