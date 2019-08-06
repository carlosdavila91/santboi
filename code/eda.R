## Setup ------
rm(list = ls(all = T))
library(readxl)
library(tidyverse)
library(plyr)
library(scales)
library(gridExtra)
library(grid)
library(reshape2)

source("code/functions.R")

# Set the default theme for the sesion ------
theme_set(theme_light())
## Censo de viviendas en españa --------------------------------------------------
censo <- read.csv("data/clean_censo_2011.csv")
colnames(censo) <- gsub("\\.", "\\ ", colnames(censo))

censo$Decade <- factor(censo$Decade, levels = c("Before 1900", "1900-1920","1921-1940",
                                            "1941-1950", "1951-1960", "1961-1970",
                                            "1971-1980", "1981-1990", "1991-2001",
                                            "2002-2011"))

colourCount = length(unique(censo$Decade))
getPalette = colorRampPalette(RColorBrewer::brewer.pal(9, "YlGnBu"))

p <- ggplot(censo, aes(x = Decade, y = Registered)) + 
        geom_col(colour = "grey39", fill = getPalette(colourCount)) +
        labs(title = "Spanish Housing Census grouped by decade") +
        guides(fill = FALSE) +
        scale_y_continuous(labels = fancy_scientific)

p <- p + theme (axis.text.x = element_text(angle = 45, vjust = 0.5),
           plot.title = element_text(hjust = 0.5))

g <- grid.arrange(p + labs(caption="Source: INE, 2019"))

ggsave("images/census.png", g)

## Sant Boi ----------------------------------------------------------------------
df <- read.csv("data/1906SB_collection_clean.csv", fileEncoding = "latin1")

## Barrio -----
BarrasPlot_Ordenado(df, df$barrio) +
        labs(title = "Buildings by district", x = NULL, y = NULL) 
ggsave("images/barrio.png")

# Tabla resumen
TablaResumen_Decreciente(df$barrio)

## Decada -----
p2 <- BarrasPlot(df, df$decada)
p2 + labs(title = "Decade in which the building was built")
ggsave("images/decada.png")

# Tabla resumen
TablaResumen_Original(df$decada)

## Orientacion -------
BarrasPlot_Ordenado(df, df$orientacion_ppal) +
        labs(title = "Main orientation of the building")
ggsave("images/orientacion.png")
# Tabla resumen
TablaResumen_Decreciente(df$orientacion_ppal)

## Número de viviendas --------
df$num_viviendas_class <- factor(df$num_viviendas_class, levels = c("Detached",
                                                                    "From 2 to 4 dwellings",
                                                                    "From 5 to 9 dwellings",
                                                                    "From 10 to 19 dwellings",
                                                                    "From 20 to 39 dwellings",
                                                                    "More than 40 dwellings"))
BarrasPlot(df, df$num_viviendas_class) +
        labs(title = "Number of Dwellings")
ggsave("images/viviendas.png")
# Tabla resumen
TablaResumen_Original(df$num_viviendas_class)

## Num. de plantas ------
BarrasPlot(df, as.factor(df$num_plantas)) +
        labs(title = "Number of floors")
ggsave("images/plantas.png")

# Tabla resumen
TablaResumen_Original(as.factor(df$num_plantas))

Resumen_Estadistico(df$num_plantas)

## Uso planta baja ---------
p <- BarrasPlot_Ordenado(df, df$uso_pb)
p + labs(title = "Use of the ground floor")
ggsave("images/pbaja.png")
# Tabla resumen
TablaResumen_Decreciente(df$uso_pb)

## Tipo de fachada --------
p <- BarrasPlot(df, df$tipo_fachada)
p + labs(title = "Type of facade")
ggsave("images/fachadas.png")
# Tabla resumen
TablaResumen_Original(df$tipo_fachada)

## Superficie de fachadas -------
Histograma(df, df$sup_fachadas) +
        labs(title = "Histogram of facades surface")
ggsave("images/sup_fachadas.png")

Resumen_Estadistico(df$sup_fachadas)

# Histograma_Log10(df, df$sup_fachadas) +
#         labs(title = "Histogram in log10 base of facades surface")
# ggsave("images/supl10_fachadas.png")

## Tipo de cubierta ------
BarrasPlot(df, df$tipo_cubierta) + 
        labs(title = "Type of roof")
ggsave("images/cubiertas.png")
# Tabla resumen
TablaResumen_Original(df$tipo_cubierta)

## Superficie de cubierta -----
Histograma(df, df$sup_cubierta) +
        labs(title = "Histogram of Roof Surfaces")
ggsave("images/sup_cubierta.png")

Resumen_Estadistico(df$sup_cubierta)

# Histograma_Log10(df, df$sup_cubierta) +
#         labs(title = "Histogram in log10 base of Roof Surfaces")
# ggsave("images/supl10_cubiertas.png")

## Tipo de hueco -------
BarrasPlot(df, df$tipo_hueco) + 
        labs(title = "Facade openings")
ggsave("images/huecos.png")
# Tabla resumen
TablaResumen_Original(df$tipo_hueco)

## Sup huecos -------
Histograma(df, df$sup_huecos) +
        labs(title = "Histogram of Facade Openings surface")
ggsave("images/sup_huecos.png")

# Histograma_Log10(df, df$sup_huecos)

Resumen_Estadistico(df$sup_huecos)

## Tipo med exp -------
BarrasPlot(df, df$tipo_med_exp) +
        labs(title = "Types of party walls")
ggsave("images/medianeras.png")
# Tabla resumen
TablaResumen_Original(df$tipo_med_exp)

## Sup med. exp. -------
Histograma(df, df$sup_median_exp) + 
        labs(title = "Histogram of party walls surface")
ggsave("images/sup_medianeras.png")

Resumen_Estadistico(df$sup_median_exp)

## Sup med no calefactado -------
# Todos los datos
# Histograma(df, df$sup_med_lnc)
# # Eliminando sup_med_lnc = 0
# aux <- data.frame(df$sup_med_lnc[df$sup_med_lnc != 0])
# colnames(aux) <- "sup_med_lnc_clean"
# Histograma(aux, aux$sup_med_lnc_clean)
# 
# length(df$sup_med_lnc) - length(df$sup_med_lnc[df$sup_med_lnc == 0])

## Superficie en contacto con el terreno -------
Histograma(df, df$sup_contacto_terreno) +
        labs(title = "Histogram of surface in contact with the ground")
ggsave("images/sup_terreno.png")

Resumen_Estadistico(df$sup_contacto_terreno)

# Histograma_Log10( df, df$sup_contacto_terreno )
## Superficie de patio -------
Histograma(df, df$sup_patio) +
        labs(title = "Histogram of surface of courtyard")
ggsave("images/sup_patios.png")

Resumen_Estadistico(df$sup_patio)

# Histograma_Log10(df, df$sup_patio)
## Superficie envolvente ------
# En duda, al ser una variable obtenida a partir de las anteriores
Histograma(df, df$sup_envolv)

