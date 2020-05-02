


##### RESULTADOS ELECCIONES  2019

##### Consultas desde liberías de R con restulados



##### LIBRERIAS #### 

library(tidyverse)




#### PASO ####
#library(paso2019)
paso2019::categorias %>% 
  as_tibble() %>% 
  filter(str_detect(nombre_categoria, "Diputados Nacionales|Senadores Nacionales|Presidente")) %>% 
  pull(nombre_categoria)



datos_seccion <- paso2019::votos %>% as_tibble() %>% 
  ungroup() %>% 
  left_join(mesas, by = "id_mesa") %>% 
  # left_join(establecimientos, by = "id_establecimiento") %>% 
  left_join(distritos, by ="id_distrito") %>% 
  left_join(secciones, by = "id_seccion") %>% 
  select(13:15)  %>% 
  distinct() %>% 
  transmute(codprov = str_sub(codigo_seccion, start = 1, end = 2), 
            coddepto = str_sub(codigo_seccion, start = 3, end = 5), 
            prov = nombre_distrito, 
            depto = nombre_seccion) %>% 
  print()


datos_seccion %>% 
  group_by(prov) %>% 
  summarise(deptos = n()) %>% 
  arrange(desc(deptos)) %>% 
  print(n = 24)


datos_paso <- paso2019::votos %>% as_tibble() %>% 
  left_join(mesas, by = "id_mesa") %>% 
  # left_join(establecimientos, by = "id_establecimiento") %>% 
  left_join(distritos, by ="id_distrito") %>% 
  left_join(secciones, by = "id_seccion") %>% 
  left_join(listas, by = "id_lista") %>% 
  left_join(agrupaciones, by = "id_agrupacion") %>% print(n = 50) %>% 
  left_join(categorias, by = "id_categoria") %>% 
  left_join(meta_agrupaciones, by = "id_meta_agrupacion") %>% 
  filter(str_detect(nombre_categoria, "Diputados Nacionales|Senadores Nacionales|Presidente")) %>% 
  #  group_by(nombre_meta_agrupacion, codigo_seccion, votos_totales, nombre_categoria) %>% 
  #  summarise(votos = sum(votos)) %>% 
  #  mutate(porcentaje = votos / votos_totales*100) %>% 
  #  ungroup() %>% 
  select(nombre_meta_agrupacion, votos, codigo_seccion, nombre_categoria, id_circuito, id_mesa) %>% 
  arrange(-votos) %>% 
  mutate(codprov = str_sub(codigo_seccion, 1 , 2), 
         coddepto = str_sub(codigo_seccion, 3 , 5)) %>% 
  print()




datos_finales_paso <-  datos_paso %>% 
  left_join(datos_seccion, by = c("codprov", "coddepto")) %>% 
  select(codprov, prov, coddepto, depto, circuito = id_circuito, mesa = id_mesa, 
         lista = nombre_meta_agrupacion, votos, categoria = nombre_categoria) 


paso2019 <- datos_finales_paso %>% 
  mutate(cat= case_when(
    str_detect(categoria, "Dip") ~ "DIPUTADO NACIONAL", 
    str_detect(categoria, "Sen") ~ "SENADOR NACIONAL", 
    str_detect(categoria, "Pres") ~ "PRESIDENTE" 
  )) %>% 
  group_by(cat, prov) 



files_paso2019 <- paso2019 %>%
  mutate(provincia = prov) %>% 
  group_by(cat, prov) %>% 
  nest()  %>% 
  pwalk(function(cat, prov, data) write_csv(data, 
                                      file.path("data/2019/", 
                                                paste0("paso2019_", prov, 
                                                       str_squish(str_to_title(cat)), 
                                                       ".csv"))))











### GENERAL ####


library(elecciones.ar.2019)


categorias %>% 
  as_tibble() %>% 
  filter(str_detect(nombre_categoria, "Diputados Nacionales|Senadores Nacionales|Presidente")) %>% 
  pull(nombre_categoria)



datos_seccion <- votos %>% as_tibble() %>% 
  ungroup() %>% 
  left_join(mesas, by = "id_mesa") %>% 
  # left_join(establecimientos, by = "id_establecimiento") %>% 
  left_join(distritos, by ="id_distrito") %>% 
  left_join(secciones, by = "id_seccion") %>% 
  select(14:16)  %>% 
  distinct() %>% 
  transmute(codprov = str_sub(codigo_seccion, start = 1, end = 2), 
            coddepto = str_sub(codigo_seccion, start = 3, end = 5), 
            prov = nombre_distrito, 
            depto = nombre_seccion) %>% 
  print()


datos_seccion %>% 
  group_by(prov) %>% 
  summarise(deptos = n()) %>% 
  arrange(desc(deptos)) %>% 
  print(n = 24)


datos <- votos %>% as_tibble() %>% 
  left_join(mesas, by = "id_mesa") %>% 
  # left_join(establecimientos, by = "id_establecimiento") %>% 
  left_join(distritos, by ="id_distrito") %>% 
  left_join(secciones, by = "id_seccion") %>% 
  left_join(listas, by = "id_lista") %>% 
  left_join(agrupaciones, by = "id_agrupacion") %>% print(n = 50) %>% 
  left_join(categorias, by = "id_categoria") %>% 
  left_join(meta_agrupaciones, by = "id_meta_agrupacion") %>% 
  filter(str_detect(nombre_categoria, "Diputados Nacionales|Senadores Nacionales|Presidente")) %>% 
  #  group_by(nombre_meta_agrupacion, codigo_seccion, votos_totales, nombre_categoria) %>% 
  #  summarise(votos = sum(votos)) %>% 
  #  mutate(porcentaje = votos / votos_totales*100) %>% 
  #  ungroup() %>% 
  select(nombre_meta_agrupacion, votos, codigo_seccion, nombre_categoria, id_circuito, id_mesa) %>% 
  arrange(-votos) %>% 
  mutate(codprov = str_sub(codigo_seccion, 1 , 2), 
         coddepto = str_sub(codigo_seccion, 3 , 5)) %>% 
  print()





datos_finales <-  datos %>% 
  left_join(datos_seccion, by = c("codprov", "coddepto")) %>% 
  select(codprov, prov, coddepto, depto, circuito = id_circuito, mesa = id_mesa, 
         lista = nombre_meta_agrupacion, votos, categoria = nombre_categoria) 


generales2019 <- datos_finales %>% 
  mutate(cat= case_when(
    str_detect(categoria, "Dip") ~ "DIPUTADO NACIONAL", 
    str_detect(categoria, "Sen") ~ "SENADOR NACIONAL", 
    str_detect(categoria, "Pres") ~ "PRESIDENTE" 
  )) %>% 
  group_by(cat) 

files <- generales2019 %>%
  mutate(provincia = prov) %>% 
  group_by(cat, prov) %>% 
  nest()  %>% 
  pwalk(function(cat, prov, data) write_csv(data, 
                                      file.path("data/2019/", 
                                                paste0("generales2019_", prov, 
                                                       str_squish(str_to_title(cat)), 
                                                       ".csv"))))









