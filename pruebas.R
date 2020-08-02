
library(tidyverse)
library(magrittr)

hoy <- Sys.Date()
archivo <- paste("../data/", format(hoy, "%y%m%d"), "COVID19MEXICO.csv", sep='')
if (!file.exists(archivo)) {
  covid.mex.url <- "http://187.191.75.115/gobmx/salud/datos_abiertos/datos_abiertos_covid19.zip"
  covid.mex.file <- download.file(url = covid.mex.url, destfile = "../data/datos_abiertos_covid19.zip")
  unzip("../data/datos_abiertos_covid19.zip", exdir = "../data")
}
df.mexico.ts <- read.csv(archivo, stringsAsFactors = FALSE) %>%
  mutate(FECHA_INGRESO = as.Date(FECHA_INGRESO, "%Y-%m-%d")) %>%
  group_by(FECHA_INGRESO) %>%
  summarise(
    C.nuevos = sum(RESULTADO == 1),
    D.nuevos = sum(RESULTADO == 1 & FECHA_DEF != "9999-99-99"),
    Sinaloa.C.nuevos = sum(RESULTADO == 1 & ENTIDAD_RES == 25),
    Sinaloa.D.nuevos = sum(RESULTADO == 1 & FECHA_DEF != "9999-99-99" & ENTIDAD_RES == 25),
    Chihuahua.C.nuevos = sum(RESULTADO == 1 & ENTIDAD_RES == 08),
    Chihuahua.D.nuevos = sum(RESULTADO == 1 & FECHA_DEF != "9999-99-99" & ENTIDAD_RES == 08),
    BCN.C.nuevos = sum(RESULTADO == 1 & ENTIDAD_RES == 02),
    BCN.D.nuevos = sum(RESULTADO == 1 & FECHA_DEF != "9999-99-99" & ENTIDAD_RES == 02),
  ) %>%
  mutate(
    Confirmados = cumsum(C.nuevos),
    Decesos = cumsum(D.nuevos),
    Sinaloa = cumsum(Sinaloa.C.nuevos),
    `Baja California` = cumsum(BCN.C.nuevos),
    Chihuahua = cumsum(Chihuahua.C.nuevos)
  )




### **Nuevos casos suavizados (Hillo y SLRC) con promedio móvil de 7 días en escala log-log**

```{r}

df.son %>%
  filter(Fecha >= fecha[1]) %>%
  mutate(
    hillo = Hillo.confirmados,
    slrc = SLRC.confirmados,
    caj = Cajeme.confirmados,
    nog = Nogales.confirmados
  ) %>%
  mutate(
    v.son = ma(Sonora - lag(Sonora), 7),
    v.hillo = ma(hillo - lag(hillo), 7),
    v.slrc = ma(slrc - lag(slrc), 7),
    v.caj = ma(caj - lag(caj), 7),
    v.nog = ma(nog - lag(nog), 7),
  ) %>%
  filter(Fecha >= fecha[7]) %>%
  plotly::plot_ly() %>%
  plotly::add_trace(
    y = ~v.son, 
    type = 'scatter', 
    mode = 'lines+markers', 
    name = 'Sonora',
    line = list(color = confirmados_color)
  )%>%
  plotly::add_trace(
    y = ~v.hillo, 
    type = 'scatter', 
    mode = 'lines+markers', 
    name = 'Hermosillo',
    line = list(color = activos_color)
  )%>%
  plotly::add_trace(
    y = ~v.slrc, 
    type = 'scatter', 
    mode = 'lines+markers', 
    name = 'SLRC',
    line = list(color = decesos_color)
  )%>%
  plotly::layout(
    legend = list(x=0.01, y = 0.99, opacity=0.1),
    yaxis = list(title = "Confirmados (log)", type = "log", zeroline = FALSE, 
                 showline = FALSE, showticklabels = FALSE, 
                 showgrid = FALSE, fixedrange = TRUE), 
    xaxis = list(title = paste("días desde el ", format(fecha[7], "%d-%m-%Y"), " (log)", sep=''), 
                 type = "log", zeroline = FALSE, 
                 showline = TRUE, showticklabels = TRUE, 
                 showgrid = FALSE, fixedrange = TRUE),
    hovermode = "compare",
    margin =  list(
      # l = 60,
      # r = 40,
      b = 10,
      t = 10,
      pad = 2
    )) %>%
  plotly::config(displaylogo = FALSE,
                 modeBarButtonsToRemove = list(
                   'sendDataToCloud',
                   'zoom2d',
                   'pan2d',
                   'select2d',
                   'lasso2d',
                   'zoomIn2d', 
                   'zoomOut2d',
                   #'toImage',
                   'autoScale2d',
                   'resetScale2d',
                   'hoverClosestCartesian',
                   'hoverCompareCartesian',
                   'toggleSpikelines'
                 ))




```

