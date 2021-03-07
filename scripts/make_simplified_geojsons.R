library(sf)
library(geoAr)
library(tidyverse)
library(leaflet)

# PROVINCIAS
read_sf("geo/departamentos.geojson") %>% 
  st_simplify(dTolerance = .01) %>% 
  write_sf("geo/simplify_provincias.geojson")
  

# CHECK    
read_sf("geo/simplify_provincias.geojson") %>% 
  leaflet() %>% 
  addPolygons() %>% 
  addProviderTiles(providers$OpenStreetMap)
  
    
# DEPARTAMENTOS    
read_sf("geo/departamentos.geojson")  %>% 
 st_simplify(dTolerance = .01) %>% 
 write_sf("geo/simplify_departamentos_provincias.geojson") 
    
    