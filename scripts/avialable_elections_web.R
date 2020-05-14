##### INTERACTIVE TABLE

library(polAr)
library(tidyverse)

data <- show_available_elections(viewer = F) %>% 
  mutate(category = case_when(
          category == "presi" ~ "Presidente", 
          category == "dip" ~ "Diputades", 
          category == "sen" ~ "Senadores"),
         round = case_when(
          round == "gral" ~ "GENERAL", 
          round == "paso" ~ "PASO")) %>% 
  select(Distrito = NOMBRE,
         Año = year, 
         Turno = round, 
         Categoría = category) 
  
DT::datatable(data, options = list( 
  language = list(url = '//cdn.datatables.net/plug-ins/1.10.11/i18n/Spanish.json'))) %>% 
  DT::formatStyle( 
    'Categoría',
    target = 'cell',
    backgroundColor = DT::styleEqual(c("Senadores","Presidente", "Diputades"), 
                                     c("#91bfdb","#ffffbf","#fc8d59"))) %>% 
  DT::formatStyle( 
    'Turno',
    target = 'cell',
    backgroundColor = DT::styleEqual(c("PASO","GENERAL"), 
                                     c("#f1a340","#998ec3")))

