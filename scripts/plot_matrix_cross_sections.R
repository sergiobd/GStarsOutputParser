# Plots input and output (after simulation) cross sections in a distance range.
# It will plot the profile of cross sections between min_distance and max_distance
# 
# - min_distance:
# Inferior limit of distance range
# 
# - max_distance:
# Superior limit of distance range
# 
# - input_xs_filename:
# Name of the text file containing input cross section data (before simulation)
# 
# Assumes cross-section data has been appended to complete_xs_output_data. Please see comments in code.

# Note:
# Gstars .XPL file contains station index and station distance data. However, GStars input geometry file does not contain the station number of each cross sections. 
# The only way to use "common indexing" for input and output data is to use station distance. Unfortunately, after a run, the station distance might change slightly.
# This is why, in a first stage, station_distance is rounded to a integer. This does not work all the time so you may want to "manually" modify station_distance 
# for ggplots faceting to work correctly.

require(ggplot2)

input_xs_filename = "PuntosCoordenadasxyz1_MIENTRAS.txt" 


# # 28
# min_distance = 2884
# max_distance = 3099

# # 99
# min_distance = 903 
# max_distance = 1059

# # 4
# min_distance = 3689
# max_distance = 3881

# # 49
# min_distance = 2261
# max_distance = 2417

# # 94
# min_distance = 1043
# max_distance = 1158


# # 54
min_distance = 2043
max_distance = 2283

xs_input_data= grab_xs_input_data( input_xs_filename)

# You should put subsetting (filtering) data, here
xs_input_subset = subset(xs_input_data, station_distance < max_distance & station_distance > min_distance & return_period == 100)

# and here
xs_output_subset = subset(complete_xs_output_data, model == "EQ" & equation == "SE1" & 
                                station_distance < max_distance &
                                station_distance > min_distance &
                                return_period == 100 )


xs_input_subset = transform( xs_input_subset, station_distance = round(station_distance) )
xs_output_subset = transform( xs_output_subset, station_distance = round(station_distance) )

# This is what I call "change manually" station distance
# xs_input_subset[xs_input_subset == 2283] = 2284

stations = sort(unique(xs_output_subset$station_distance))


p_xs_comp = ggplot( xs_output_subset, aes(x = x, y = y)) +
  labs(title = "Cross section study", subtitle = "Station 54 (2158m)" , x = "meters", y = "meters" ) +
  scale_x_continuous(breaks = scales::pretty_breaks(n = 3)) +
  geom_line( aes( group = station_distance, color = "after") ) +
  geom_line( data = xs_input_subset, aes(x = x, y = y, color = "before")) +
  facet_grid( . ~ station_distance, switch = "y")

print(p_xs_comp)

# 
# geom_line( aes( y = energy_gradeline_elevation, color = "Energy gradeline elevation")) +
#   geom_line( aes( y = water_surf_elevation, color = "Water surface elevation")) +
#   geom_line( aes(y = Thalweg, color = "Thalweg") ) +
#   scale_color_manual("", breaks = c("Energy gradeline elevation", "Water surface elevation","Thalweg" ),
#                      values = c("#1b9e77", "#d95f02", "#7570b3")
