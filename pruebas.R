
library(tidyverse)
library(magrittr)

### **¿Estámos aplanando la curva? Evolución a 14 días**


```{r}

df.doblas <- df.son %>% filter(Fecha >= max(Fecha) - 13)
df.doblas$inc <- df.doblas$Sonora - first(df.doblas$Sonora) + 1
df.doblas$dias <- 0:(nrow(df.doblas) - 1) 
df.doblas <- df.doblas %>% 
  mutate(
    dobla.2 = exp(log(2)*dias/2),
    dobla.3 = exp(log(2)*dias/3),
    dobla.5 = exp(log(2)*dias/5)
  )

plotly::plot_ly(data = df.doblas, x = ~Fecha) %>%
  plotly::add_markers(
    y = ~inc, 
    text = ~paste(Sonora, "casos confirmados", sep=" "),
    marker = list(color = "black"),
    line = list(color = decesos_color),
    name = "Casos",
    hoverinfo = 'text'
  ) %>%
  plotly::add_ribbons(
    ymin = ~dobla.3,
    ymax = ~dobla.2,
    opacity = 0.4,
    line = list(color = 'lightred'),
    fillcolor = 'lightred',
    name = "dobla entre 2 y 3 días"
  ) %>%
  plotly::add_ribbons(
    ymin = ~dobla.5,
    ymax = ~dobla.3,
    opacity = 0.4,
    line = list(color = 'yellow'),
    fillcolor = 'yellow',
    name = "dobla entre 3 y 5 días"
  ) %>%
  plotly::add_ribbons(
    ymin = ~(0 * dobla.5),
    ymax = ~dobla.5,
    opacity = 0.4,
    line = list(color = 'lightblue'),
    fillcolor = 'lightblue',
    name = "dobla en más de 5 días"
  ) %>%
  plotly::layout(
    legend = list(x=0.05, y = 0.95),
    yaxis = list(title = "", zeroline = FALSE, showline = FALSE, 
                 type = "log", 
                 showticklabels = FALSE, showgrid = FALSE,
                 fixedrange = TRUE),
    xaxis = list(title = "", zeroline = FALSE, showline = FALSE, 
                 showticklabels = TRUE, showgrid = FALSE,
                 fixedrange = TRUE),
    margin = list( l = 10, r = 10, b = 10, t = 10, pad = 2)
  ) 
```   



### **Relación de Casos Confirmados por Población y por Densidad de Población**

```{r}

df_poblacion <- data.frame(
  "Poblacion" = c(3406465, 2767761, 3155070, 2662480, 112336538, 6828065), 
  "Densidad" = c(14.4, 51.7, 46.4, 15.9, 61, 22.34),
  "Estado" = c("Chihuahua","Sinaloa", "Baja California", 
               "Sonora", "Nacional", "Arizona")
)


df_c %>% dplyr::left_join(df_poblacion) %>%
  dplyr::mutate(
    p.Confirmados = as.numeric(
      format(100000 * Confirmados / Poblacion, digits = 4)
    ),
  ) %>%
  plotly::plot_ly(y = ~ p.Confirmados,
                  x = ~ Densidad,
                  size = ~  log(Confirmados),
                  sizes = c(5, 70),
                  type = 'scatter', mode = 'markers',
                  color = ~Estado,
                  marker = list(sizemode = 'diameter' , opacity = 0.5),
                  hoverinfo = 'text',
                  text = ~paste("</br>", Estado, 
                                "</br> Confirmados: ", Confirmados,
                                "</br> Decesos: ", Decesos,
                                "</br> Incidencia: ", p.Confirmados,
                                "</br> Densidad de pob: ", Densidad
                  )
  ) %>%
  plotly::layout(yaxis = list(title = "Casos por 100 mil hab", fixedrange = TRUE),
                 xaxis = list(title = "Densidad de Población (hab/m2)", fixedrange = TRUE),
                 hovermode = "closest") %>%
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
  


### **Casos nuevos y tiempo de duplicación (en días) al `r  format(as.Date(max(df_s$Fecha)), "%d/%m/%y")`**

```{r}


plot.1 <- plotly::plot_ly(
  data = df.variacion,
  x = ~N.Confirmados,
  y = ~reorder(Estado, N.Confirmados),
  text = ~paste(N.Confirmados, "nuevos", sep=" "),
  hoverinfo = 'text',
  textposition = 'auto',
  name = "C. nuevos",
  type = "bar", 
  marker = list(color = confirmados_color),
  orientation = 'h') %>%
  plotly::layout(
    yaxis = list(title = "", zeroline = FALSE, showline = TRUE, 
                 showticklabels = TRUE, showgrid = FALSE,
                 fixedrange = TRUE),
    xaxis = list(title = "", zeroline = FALSE, showline = FALSE, 
                 showticklabels = FALSE, showgrid = FALSE,
                 fixedrange = TRUE),
    margin = list( l = 10, r = 10, b = 10, t = 10, pad = 2)) 

plot.2 <- plotly::plot_ly(
  data = df.variacion,
  x = ~t.duplicacion,
  y = ~reorder(Estado, N.Confirmados),
  text = ~paste(format(t.duplicacion, digits = 3), "días", sep=" "),
  hoverinfo = 'text',
  textposition = 'auto',
  name = "T. de dup.",
  type = "bar", 
  marker = list(color = decesos_color),
  orientation = 'h') %>%
  plotly::layout(
    yaxis = list(title = "", zeroline = FALSE, showline = TRUE, 
                 showticklabels = FALSE, showgrid = FALSE,
                 fixedrange = TRUE),
    xaxis = list(title = "", zeroline = FALSE, showline = FALSE, 
                 showticklabels = FALSE, showgrid = FALSE,
                 fixedrange = TRUE),
    margin = list( l = 10, r = 10, b = 10, t = 10, pad = 2)) 

plotly::subplot(plot.1, plot.2)  %>%
  plotly::layout(
    showlegend = FALSE
  ) %>%
  plotly::config(
    displaylogo = FALSE,
    modeBarButtonsToRemove = list(
      'sendDataToCloud','zoom2d','pan2d', 'select2d', 'lasso2d',
      'zoomIn2d', 'zoomOut2d',
      #'toImage',
      'autoScale2d', 'resetScale2d', 'hoverClosestCartesian',
      'hoverCompareCartesian', 'toggleSpikelines'))


```
  