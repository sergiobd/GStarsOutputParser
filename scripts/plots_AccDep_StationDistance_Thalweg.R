# Plots a vertical profile of the reach colored with accumulated depostions.
# Therefore, this script allows to evaluate how the geometry of the reach is related to deposition.
# 
# - timestep
#   timestep_index where deposition wants to be studied.
# 
# - stations_up / stations_down:
#   Vector of stations that will be used as text labels
# 
# Assumes data has been grabbed using append_data or grab_output_data
# Requires multiplot.R, http://www.cookbook-r.com/Graphs/Multiple_graphs_on_one_page_(ggplot2)/

timestep = max(complete_output_data$timestep_index)

# Use this line if you ran only one simulation and you used grab_output_data
# data_subset = subset( output_data, timestep_index == timestep)

# Use this line if you used append_data and therefore your data is in complete_output_data
data_subset = subset( complete_output_data, timestep_index == timestep & model == "EQ" &
                                equation == "SE1" & return_period == 100)

p_AccDep_stationDistance = ggplot( data_subset, aes( x = station_distance, y = AccDep_tons) )+
  geom_line() + #coord_cartesian(ylim=c(-8000, 8000))+
  labs( x = "Distance to downstream station (m) ", y = "Accumulated deposition (tons)",
        title = "Accumulated deposition and Thalweg", subtitle = "Last timestep (29h), Equilibrium model, EQ1, return period 100")

stations_up = c( 13, 17, 23, 28, 33, 40, 47, 54, 60, 65, 72,86, 78, 95, 99, 104, 112)

label_data_up = subset( data_subset , station %in% stations_up )


stations_down = c(8, 12, 16, 19, 36, 44, 49, 57, 67, 94, 101, 106, 137)
label_data_down = subset( data_subset , station %in% stations_down )
                        

p_AccDep_stationDistance = p_AccDep_stationDistance +
  geom_text(data = label_data_up , size = 3,
            aes(x = station_distance, y = AccDep_tons, label= station, vjust = -3.5) ) +
  geom_text(data = label_data_down , size = 3,
          aes(x = station_distance, y = AccDep_tons, label= station, vjust = 3.5) )

# aes(color = AccDep_tons) )
#p_AccDep_stationDistance = p_AccDep_stationDistance + scale_color_distiller(palette = "Spectral")
#p_AccDep_stationDistance = p_AccDep_stationDistance + theme_bw()


pThalweg = ggplot(  data_subset, aes(x = station_distance, y = Thalweg)) +
  geom_point( aes(color = AccDep_tons))+ 
  scale_color_distiller(palette = "RdBu") +
  labs( x = "Distance to downstream station (m) ", y = "Thalweg (m)", color ="Accumulated deposition (tons)")

pThalweg = pThalweg + theme_bw() + theme(legend.position="bottom", 
                                         legend.text = element_text(size = 8),
                                         legend.key.width = unit(2, "cm")
                                         )

# LABELS

num_stations = max(as.numeric(output_data$station))

thalweg_label_data_up = subset( data_subset, station %in% stations_up )
thalweg_label_data_down = subset( data_subset, station %in% stations_down )


pThalweg = pThalweg + geom_text(data = thalweg_label_data_up ,  size = 3, 
                                aes(x = station_distance, y =Thalweg, label = station, vjust = -5) ) +
  geom_segment(data = thalweg_label_data_up, 
               aes(x = station_distance, y = Thalweg + 0.2, yend = Thalweg + 0.5, xend = station_distance ) ) #+
  #geom_text(data = thalweg_label_data_down ,  size = 3, 
  #           aes(x = station_distance, y =Thalweg, label = station, vjust = +5) ) +
  # geom_segment(data = thalweg_label_data_down, aes(x = station_distance, y = Thalweg - 0.2, yend = Thalweg - 0.5, xend = station_distance ) )
  # 


multiplot( p_AccDep_stationDistance, pThalweg , cols = 1)
