 readr::read_csv("scripts/raw_bills_data.csv") -> legislative_data

 show_available_bills <- function() {
 
  legislative_data %>% 
    dplyr::mutate(id = as.character(glue::glue("{id}-{camara}")),
                  fecha = lubridate::as_date(fecha), 
                  mes = lubridate::month(fecha), 
                  year = lubridate::year(fecha)) %>% 
    dplyr::select(-c(fecha)) %>% 
    DT::datatable()
  
}


get_bill_result <- function(bill = NULL) {
  
  legislative_data %>% 
    dplyr::mutate(id = as.character(glue::glue("{id}-{camara}"))) %>% 
    dplyr::filter(id == bill) 
    
}


get_votes <- function(bill =NULL){
  
  data <- legislative_data %>% 
    dplyr::mutate(id = as.character(glue::glue("{id}-{camara}")),
                  fecha = lubridate::as_date(fecha), 
                  mes = lubridate::month(fecha), 
                  year = lubridate::year(fecha)) %>% 
    dplyr::select(-c(camara, fecha)) 
  
  
        selection <- if(bill %in% data$id){
          
          data %>% 
            dplyr::filter(id == bill) %>% 
            dplyr::mutate(chamber = dplyr::case_when(
              stringr::str_detect(id, "Dipu") ~ "dip", 
              TRUE ~ "sen"), 
                   id = stringr::str_remove_all(id, "\\D"))
            
          } else {
              
              "Error: bill was not found // No se encontró la votación"
            }
        
        jsonlite::read_json(glue::glue("https://raw.githubusercontent.com/electorArg/PolAr_Data/master/legis/{selection$chamber}/votos/{selection$year}/{selection$id}.json")) %>% 
          tibble::enframe() %>% 
          tidyr::unnest_wider(col = value)
     
        
        
        }

