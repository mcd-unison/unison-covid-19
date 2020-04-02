`%>%` <- magrittr::`%>%`  

### Los datos de la Secretaría de Salud

dt_sas <- readxl::read_excel("data/BASE COVID-19 - IDCL.xlsx", skip=4) %>%
  dplyr::select(
    Id = "ID", Edad = "EDAD", Sexo = "SEXO", 
    Municipio = "MUNICIPIO DE RESIDENCIA",
    Colonia = "COLONIA", Servicio = "SERVICIO MÉDICO", 
    Contagio = "CONTACTO CON SOSPECHOSOS", 
    Atencion = "TIPO DE ATENCIÓN", 
    Tipo = "CLASIFICACIÓN FINAL", 
    Fecha = "FECHA DE INICIO DE SÍNTOMAS"
  ) %>%
  tidyr::drop_na(Sexo)

### Los datos de Juan Pablo

dt_jp <- readxl::read_excel("data/BASE COVID-19 - IDCL.xlsx", skip=4) %>%


### Los datos de los estados  

# Del repositorio de [Gabriel Alfonso Carranco-Sapiéns](https://github.com/carranco-sga/Mexico-COVID-19)
dir <- "https://raw.githubusercontent.com/carranco-sga/Mexico-COVID-19/master/Mexico_COVID19.csv"

dt_nac <- read.csv(dir) %>% 
  dplyr::rename_all(~sub('_D', '_Decesos', .x)) %>%
  dplyr::rename_all(~sub('_I', '_Importados', .x)) %>%
  dplyr::rename_all(~sub('_L', '_Locales', .x)) %>%
  dplyr::rename_all(~sub('_R', '_Recuperados', .x)) %>%
  dplyr::rename_all(~sub('_S', '_Sospechosos', .x)) %>%
  dplyr::rename_at(
    dplyr::vars(dplyr::matches("^[A-Z][A-Z][A-Z]$")),
    dplyr::funs(paste(., "Confirmados", sep='_'))
  ) %>%
  dplyr::select(-Pos_rep, -Susp_rep, -Neg_rep, -IRAG_Test, -Tested_tot) %>%
  dplyr::rename(Nacional_Confirmados = Pos_Confirmados,
                Nacional_Recuperados = Recovered,
                Nacional_Decesos = Deceased,
                Nacional_Sospechosos = Susp,
                Nacional_Importados = Pos_Importados,
                Nacional_Locales = Pos_Locales) %>%
  tidyr::pivot_longer(
    cols = -Fecha,
    names_to = c("Estado", "Tipo"),
    names_pattern = "(.*)_(.*)",
    values_to = "casos"
  ) %>%
  dplyr::mutate(Fecha = as.Date(Fecha))
