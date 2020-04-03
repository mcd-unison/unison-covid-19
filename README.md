# Dashboard Unison COVID-19 Sonora

Este tablero es un recurso elaborado un grupo de profesores del [Departamento de Matemáticas](https://www.mat.uson.mx) de la [Universidad de Sonora](https://www.unison.mx) del área de [Ciencia de Datos](mcd.unison.mx). El tablero se realizó en el lenguje *R* usando el lenguaje de marcado *Rmarkdown* y la plantilla [*flexdashboard for R*](https://rmarkdown.rstudio.com/flexdashboard/index.html). Nos basamos en un ejemplo base desarrollado por [Rami Krispin](https://twitter.com/Rami_Krispin) y el cual se puede consultar [aquí](https://github.com/RamiKrispin/coronavirus_dashboard).

**Datos**

Los datos sobre el proceso del COVID-19 en el Estado de Sonora se reciben diariamente de la [Secretaría de Salud del Estado de Sonora](https://www.sonora.gob.mx/temas-de-interes/salud.html), gracias a la colaboración entre la Universidad de Sonora y el Gobierno del Estado durante este periodo excepcional.
Los datos sobre el proceso del COVID-19 de los estados de México se tomaron del [repositorio de datos manenido por Gabriel Alfonso Carranco-Sapiéns](https://github.com/carranco-sga/Mexico-COVID-19). Esta base se actualiza cada día a partir de la información de la [SSA](https://www.gob.mx/salud). Los datos sobre la población de México se tomaron de [INEGI](https://www.inegi.org.mx/app/tabulados/interactivos/?px=Poblacion_07&bd=Poblacion).
Los datos sobre el proceso del COVID-19 en el estado Arizona (EU) se tomaron del [Centro de recursos sobre Coronavirus](https://coronavirus.jhu.edu) de la Universidad Johns Hopkins University & Medicine. Esta base de datos se actualizan cada día a media noche y se pueden obtener [aquí](https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data). 

**Paquetes utilizados y documentación**

* Tablero: [flexdashboard](https://rmarkdown.rstudio.com/flexdashboard/)
* Gráficas: [plotly](https://plot.ly/r/)
* Mapa: [leaflet](https://rstudio.github.io/leaflet/)
* Manipulación de datos:  [dplyr](https://dplyr.tidyverse.org/) [tidyr](https://tidyr.tidyverse.org/)
* Tablas: [DT](https://rstudio.github.io/DT/)

**Reproducibilidad**

El tablero se genera diariamente como una página web estática. Es posible realizar un *fork* al [proyecto en Github](https://github.com/mcd-unison/coronavirus_dashboard), descargarlo, modificarlo y publicar un tablero similar en las páginas web que desees.

**Contacto**

[O. Gutú](mailto:olivia.gutu@unison.mx) | [J. P.  Soto](mailto:juanpablo.soto@unison.mx) | [J. Waissman](mailto:julio.waissman@unison.mx)

