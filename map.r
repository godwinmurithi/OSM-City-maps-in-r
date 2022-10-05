library(remotes)
library(tidyverse)
library(osmdata) # package for working with streets
library(showtext) # for custom fonts
library(ggplot2)
library(ggmap)
library(rvest)
library(ggdark)

#Check available tags
#We can then use getbb() to return the geographic location of a city simply by passing it a string.
available_tags("highway")

available_tags("building")

#We can then use getbb() to return the geographic location of a city simply by passing it a string.
getbb("NAIROBI")
getbb("NAIROBI")

#Now we’re going to grab certain categories of streets from this package. You’ll notice that the key function here, add_osm_feature() 
#takes two arguments, key and value. 
#Since we’re grabbing only street features, and all streets fall under the key “highway”, that’s what we use. I have then arbitrarily divided the values into different 
#categories based on size of the road. You’ll see how this comes into play later when we plot them, but feel free to play with this.#
#Finally, the osmdata_sf() function returns the pulled data in a format that ggmap knows how to work with, making plotting very simple. You can take a look at the
#dataframe it creates to get a sense of the data format

big_streets <- getbb("MOMBASA")%>%
  opq()%>%
  add_osm_feature(key = "highway", 
                  value = c("motorway", "primary", "motorway_link", "primary_link")) %>%
  osmdata_sf()

big_streets


View(big_streets[["osm_lines"]])


#We’ll now do the same and grab two more dataframes of streets: 
#medium streets and small streets. Again, these classifications are arbitrary 
#and can be changed or divided even further depending on your preference. 
#This is the fun part!

med_streets <- getbb("MOMBASA")%>%
  opq()%>%
  add_osm_feature(key = "highway", 
                  value = c("secondary", "tertiary", "secondary_link", "tertiary_link")) %>%
  osmdata_sf()


small_streets <- getbb("MOMBASA")%>%
  opq()%>%
  add_osm_feature(key = "highway", 
                  value = c("residential", "living_street",
                            "unclassified",
                            "service", "footway"
                  )) %>%
  osmdata_sf()

river <- getbb("MOMBASA")%>%
  opq()%>%
  add_osm_feature(key = "waterway", value = c(available_tags("waterway")) %>%
  osmdata_sf()

railway <- getbb("MOMBASA")%>%
  opq()%>%
  add_osm_feature(key = "railway", value="rail") %>%
  osmdata_sf()


buildings <- getbb("MOMBASA")%>%
  opq()%>%
  add_osm_feature(key = "building", 
                  value = c(available_tags("building"))) %>%
  osmdata_sf()

#Now to the fun part: plotting. This is very straightforward because of ggmaps, which gives us the geom_sf() function. 
#All we’re doing here is plotting the “big” streets without any other formatting.
ggplot() +
  geom_sf(data =buildings$osm_polygons,
          inherit.aes = FALSE,
          color = "orange",
          size = .3,
          alpha = .3) +
  geom_sf(data =small_streets$osm_lines,
          inherit.aes = FALSE,
          color = "gray",
          size = .4,
          alpha = .5) +
  geom_sf(data =med_streets$osm_lines,
          inherit.aes = FALSE,
          color = "#666666",
          size = .2,
          alpha = .3) +
  geom_sf(data =river$osm_lines,
          inherit.aes = FALSE,
          color = "blue") +

  theme_void() + # get rid of background color, grid lines, etc.
  theme(plot.title = element_text(size = 20, family = "lato", face="bold", hjust=.5),
        plot.subtitle = element_text(family = "lato", size = 8, hjust=.5, margin=margin(2, 0, 5, 0))) +
  labs(title = "NAIROBI")

                  
                 
                 #save
                  ggsave("ase.png", plot = last_plot(), device = "png")
