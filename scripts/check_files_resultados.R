#### Bases de datos de elecciones nacionales de Argetina
#### Lectura de archivos desde Google Drive - juanpabloruiznicolini@gmail.com

# Cargo libererias
library(tidyverse)
library(googledrive)  # va a pedir autentica acceso a cuenta de GMAIL vía API de Tidyverse


# RUTA DONDE ESTAN LOS DATOS
ruta <- "https://drive.google.com/open?id=1LzqbqS2rmMthzYpZYhPU3R8umaJZOt_U"


# CARGO EL LISTADO DE DATOS DE LA CARPETA
datos <- googledrive::drive_ls(path = ruta,
                               recursive = T) # Recursive trae los archivos de todas las careptas
  
# Genero una nueva tabla descomponiendo nombre de arhcivos en parametros

archivos <- datos %>% 
  arrange(name) %>% 
  slice(26:464) %>%                     # LIMPIO NOMBRES DE CARPETAS   
  group_by(name) %>% 
  slice(1) %>%  # sjuan_sen_paso2017 esta duplicado. No encuentro bug. En la base una sola vez y tiene = id
  ungroup() %>% 
  filter(!str_detect(name, "2019"),     # EXCLUYO ELECCION 2019 (mal naming y otro formato)
         !str_detect(name, "presi")) %>%  # Excluyo  presi / otro formato
  mutate(name = str_to_lower(name)) %>% 
  separate(name, into = c("provincia", "categoria", "turno"), 
           sep = "[:punct:]", remove = F) 

### CHEQUEO CONSISTENCIA EN CANTIDAD DE ARCHIVOS 
archivos %>% 
  group_by(turno) %>%  # DEBERIAN SER 32 (24 Diputados + 8 Senadores) x turno
  summarise(n = n())

# Chequo de n(elecciones) x provincia y categoria
archivos %>%    
  group_by(provincia, categoria) %>%  # 8 provincias tienen una eleccion mas de senador (turno 2009)
  summarise(n = n()) %>% 
  arrange(n,provincia) %>% 
  print(n = Inf)


