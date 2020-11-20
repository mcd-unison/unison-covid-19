# Script para extraer la información de los reportes hospitalarios anteriores

library(magrittr)
library(tidyverse)
library(readxl)

#fecha.final <- as.Date(paste(16, 10, '2020', sep='-'), format = "%d-%m-%Y")
fecha.final <- Sys.Date()

abre.archivo <- function (dia, mes){
  mes.nombres = c('Ene', 'Feb', 'Mar', 'Abril', 'Mayo', 'Jun', 
                  'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic')
  nombre.archivo = paste(
    "../Datos-Covid19/REPORTE-HOSPITALARIO/REPORTE HOSPITALARIO---",
    mes.nombres[mes],".", sprintf("%02d", dia), ".2020.xlsx", sep = ""
  )
  if(file.exists(nombre.archivo)){
    df.hoy <- read_excel(
      nombre.archivo, sheet=1, range = "A3:S14"
    )  %>% rename(
      Municipio = ...1,
      SSP.disponibles = `CAMAS DISPONIBLES...2`,
      IMSS.disponibles = `CAMAS DISPONIBLES...5`,
      ISSSTESON.disponibles = `CAMAS DISPONIBLES...8`,
      ISSSTE.disponibles = `CAMAS DISPONIBLES...11`,
      Privada.disponibles = `CAMAS DISPONIBLES...14`,
      Total.disponibles = `TOTAL CAMAS DISPONIBLES`,
      SSP.ocupadas = `CAMAS OCUPADAS...3`,
      IMSS.ocupadas = `CAMAS OCUPADAS...6`,
      ISSSTESON.ocupadas = `CAMAS OCUPADAS...9`,
      ISSSTE.ocupadas = `CAMAS OCUPADAS...12`,
      Privada.ocupadas = `CAMAS OCUPADAS...15`,
      Total.ocupadas = `TOTAL CAMAS OCUPADAS`
      # SSP.ocupacion = `% OCUPACION...4`,
      # IMSS.ocupacion = `% OCUPACION...4`,
      # ISSSTESON.ocupacion = `% OCUPACION...4`,
      # ISSSTE.ocupacion = `% OCUPACION...4`,
      # Privada.ocupacion = `% OCUPACION...4`,
      # Total.ocupacion = `% TOTAL ACUMULADO`
    )
  }else{
    data.frame(
      Municipio = c("Caborca", "Hermosillo", "Nogales", "Guaymas", "Navojoa",               
                    "San Luis Río Colorado", "Cajeme", "Agua Prieta",          
                    "Puerto Peñasco", "Huatabampo","TOTAL"),
      SSP.disponibles = rep(NA, 11),
      IMSS.disponibles = rep(NA, 11),
      ISSSTESON.disponibles = rep(NA, 11),
      ISSSTE.disponibles = rep(NA, 11),
      Privada.disponibles = rep(NA, 11),
      Total.disponibles = rep(NA, 11),
      SSP.ocupadas = rep(NA, 11),
      IMSS.ocupadas = rep(NA, 11),
      ISSSTESON.ocupadas = rep(NA, 11),
      ISSSTE.ocupadas = rep(NA, 11),
      Privada.ocupadas = rep(NA, 11),
      Total.ocupadas = rep(NA, 11),
      SSP.ocupacion = rep(NA, 11),
      IMSS.ocupacion = rep(NA, 11),
      ISSSTESON.ocupacion = rep(NA, 11),
      ISSSTE.ocupacion = rep(NA, 11),
      Privada.ocupacion = rep(NA, 11),
      Total.ocupacion = rep(NA, 11)
    )
  }
}


fecha <- c()
Sonora_disponibles <- c()
Sonora_ocupados <- c()
Hillo_disponibles <- c()
Hillo_ocupados <- c()
SLRC_disponibles <- c()
SLRC_ocupados <- c()
Cajeme_disponibles <- c()
Cajeme_ocupados <- c()
Nogales_disponibles <- c()
Nogales_ocupados <- c()
Navojoa_disponibles <- c()
Navojoa_ocupados <- c()
Caborca_disponibles <- c()
Caborca_ocupados <- c()
Guaymas_disponibles <- c()
Guaymas_ocupados <- c()
AP_disponibles <- c()
AP_ocupados <- c()
Huatabampo_disponibles <- c()
Huatabampo_ocupados <- c()
PP_disponibles <- c()
PP_ocupados <- c()

agrega.otra <- gtools::defmacro(mun, vari, val,
  expr={vari <- append(vari, tmp$val[tmp$Municipio == mun])}
)

# Extrae de los archivos indoviduales
for (mes in c(6,7, 8, 9, 10, 11)) {
  for (dia in 1:31) {
    dia.fecha <- as.Date(paste(dia, mes, '2020', sep='-'), format = "%d-%m-%Y")
    if(!is.na(dia.fecha) & dia.fecha <= fecha.final){ 
      tmp <- abre.archivo(dia, mes)
      fecha <-append(fecha, dia.fecha)
      agrega.otra("TOTAL", Sonora_disponibles, Total.disponibles)
      agrega.otra("TOTAL", Sonora_ocupados, Total.ocupadas)
      agrega.otra("Hermosillo", Hillo_disponibles, Total.disponibles)
      agrega.otra("Hermosillo", Hillo_ocupados, Total.ocupadas)
      agrega.otra("San Luis Río Colorado", SLRC_disponibles, Total.disponibles)
      agrega.otra("San Luis Río Colorado", SLRC_ocupados, Total.ocupadas)
      agrega.otra("Cajeme", Cajeme_disponibles, Total.disponibles)
      agrega.otra("Cajeme", Cajeme_ocupados, Total.ocupadas)
      agrega.otra("Nogales", Nogales_disponibles, Total.disponibles)
      agrega.otra("Nogales", Nogales_ocupados, Total.ocupadas)
      agrega.otra("Navojoa", Navojoa_disponibles, Total.disponibles)
      agrega.otra("Navojoa", Navojoa_ocupados, Total.ocupadas)
      agrega.otra("Caborca", Caborca_disponibles, Total.disponibles)
      agrega.otra("Caborca", Caborca_ocupados, Total.ocupadas)
      agrega.otra("Guaymas", Guaymas_disponibles, Total.disponibles)
      agrega.otra("Guaymas", Guaymas_ocupados, Total.ocupadas)
      agrega.otra("Agua Prieta", AP_disponibles, Total.disponibles)
      agrega.otra("Agua Prieta", AP_ocupados, Total.ocupadas)
      agrega.otra("Huatabampo", Huatabampo_disponibles, Total.disponibles)
      agrega.otra("Huatabampo", Huatabampo_ocupados, Total.ocupadas)
      agrega.otra("Puerto Peñasco", PP_disponibles, Total.disponibles)
      agrega.otra("Puerto Peñasco", PP_ocupados, Total.ocupadas)
      if (length(Sonora_disponibles) < length(Hillo_disponibles)){
        print(paste("dia =", dia, ", mes =", mes))
      }
    }
  }
}

# Genera el data frame
df.hospitalizados <- data.frame( 
  fecha  = fecha,
  Sonora_disponibles  = Sonora_disponibles,
  Sonora_ocupados  = Sonora_ocupados,
  Hillo_disponibles  = Hillo_disponibles,
  Hillo_ocupados  = Hillo_ocupados,
  SLRC_disponibles  = SLRC_disponibles,
  SLRC_ocupados  = SLRC_ocupados,
  Cajeme_disponibles  = Cajeme_disponibles,
  Cajeme_ocupados  = Cajeme_ocupados,
  Nogales_disponibles  = Nogales_disponibles,
  Nogales_ocupados  = Nogales_ocupados,
  Navojoa_disponibles  = Navojoa_disponibles,
  Navojoa_ocupados  = Navojoa_ocupados,
  Caborca_disponibles  = Caborca_disponibles,
  Caborca_ocupados  = Caborca_ocupados,
  Guaymas_disponibles  = Guaymas_disponibles,
  Guaymas_ocupados  = Guaymas_ocupados,
  AP_disponibles  = AP_disponibles,
  AP_ocupados  = AP_ocupados,
  Huatabampo_disponibles  = Huatabampo_disponibles,
  Huatabampo_ocupados  = Huatabampo_ocupados,
  PP_disponibles  = PP_disponibles,
  PP_ocupados  = PP_ocupados
)


write.csv(df.hospitalizados, file = "../Datos-Covid19/REPORTE-HOSPITALARIO/acumulados.csv")


# Agrega de los archivos que mando el doctor despues





