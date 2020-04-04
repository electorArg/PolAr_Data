#### Bases de datos de elecciones nacionales de Argetina
#### Lectura de archivos desde Google Drive

# Cargo libererias
library(tidyverse)
library(googledrive)  # va a pedir autentica acceso a cuenta de GMAIL vía API de Tidyverse


# RUTA DONDE ESTAN LOS DATOS
datos <- "https://drive.google.com/open?id=1LzqbqS2rmMthzYpZYhPU3R8umaJZOt_U"


# CARGO EL LISTADO DE DATOS DE LA CARPETA
datos <- googledrive::drive_ls(path = datos,
                               recursive = T) # Recursive trae los archivos de todas las careptas
  
# Genero una nueva tabla descomponiendo nombre de arhcivos en parametros

archivos <- datos[1] %>%
  arrange(name) %>% 
  slice(26:458) %>%                     # LIMPIO NOMBRES DE CARPETAS   
  filter(!str_detect(name, "2019"),     # EXCLUYO ELECCION 2019 (mal naming y otro formato)
         !str_detect(name, "presi")) %>%  # Excluyo  presi / otro formato
  mutate(name = str_to_lower(name)) %>% 
  separate(name, into = c("provincia", "categoria", "turno"), 
           sep = "\\_", remove = F) %>% 
  separate(turno,"turno", sep = "\\.")

### CHEQUEO CONSISTENCIA EN CANTIDAD DE ARCHIVOS 
archivos %>% 
  group_by(turno) %>%  # DEBERIAN SER 32 (24 Diputados + 8 Senadores) x turno
  summarise(n = n())


archivos %>%    # Chequo de n(elecciones) x provincia para corregir archivos de origen 
  group_by(provincia) %>% 
  summarise(n = n()) %>% 
  arrange(n,provincia) %>% 
  print(n = Inf)










