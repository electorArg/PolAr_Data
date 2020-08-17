### Check files Legislative Bills

library(tidyverse)

# Check github repo content
pg_dip <- xml2::read_html(glue::glue('https://github.com/electorArg/PolAr_Data/tree/master/legis/dip'))
pg_sen <- xml2::read_html(glue::glue('https://github.com/electorArg/PolAr_Data/tree/master/legis/sen'))

# parse repo content and create files dir data frame
dir_dip <- rvest::html_nodes(pg_dip, "a") %>%
  rvest::html_attr(name = "href" ) %>%
  stringr::str_match('.*json') %>%
  stats::na.omit() %>% 
  tibble::as_tibble()  %>% 
  dplyr::rename(name = V1) %>% 
  dplyr::mutate(name = stringr::str_remove(name, pattern = "/electorArg/PolAr_Data/blob/master/legis/dip/"),
                name = stringr::str_remove(name, pattern = ".json")) %>%
  dplyr::mutate(dir = glue::glue("https://raw.githubusercontent.com/electorArg/PolAr_Data/master/legis/dip/{name}.json"))


dir_sen <- rvest::html_nodes(pg_sen, "a") %>%
  rvest::html_attr(name = "href" ) %>%
  stringr::str_match('.*json') %>%
  stats::na.omit() %>% 
  tibble::as_tibble()  %>% 
  dplyr::rename(name = V1) %>% 
  dplyr::mutate(name = stringr::str_remove(name, pattern = "/electorArg/PolAr_Data/blob/master/legis/sen/"),
                name = stringr::str_remove(name, pattern = ".json")) %>%
  dplyr::mutate(dir = glue::glue("https://raw.githubusercontent.com/electorArg/PolAr_Data/master/legis/sen/{name}.json"))




### Load every json 
dip_json <- purrr::map(.x = dir_dip$dir, .f = jsonlite::read_json)
sen_json <- purrr::map(.x = dir_sen$dir, .f = jsonlite::read_json)

# DIPUTADOS
desc_dip <- dip_json %>% flatten() %>% map_chr("title")
id_dip<- dip_json %>% flatten() %>% map_chr("id")
fecha_dip<- dip_json %>% flatten() %>% map_chr("date")

diputados <- cbind(id_dip, descripcion_dip, fecha_dip) %>% 
  as_tibble() %>% 
  mutate(camara = "Diputados") %>% 
  rename(id = 1, 
         descripcion = 2, 
         fecha = 3)


# SENADO  

descripcion_sen <- sen_json %>% flatten() %>% map_chr("title")
id_sen<- sen_json %>% flatten() %>% map_chr("id")
fecha_sen<- sen_json %>% flatten() %>% map_chr("date")


senado <- cbind(id_sen, descripcion_sen, fecha_sen) %>% 
  as_tibble() %>% 
  mutate(camara = "Senado")%>% 
  rename(id = 1, 
         descripcion = 2, 
         fecha = 3)



### DOS CAMARAS 

legislative_data <- rbind(diputados, senado) 

write_csv(legislative_data, "scripts/raw_bills_data.csv")

