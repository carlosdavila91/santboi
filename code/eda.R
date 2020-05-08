## Setup ------
library(readxl)
library(tidyverse)
library(plyr)
library(scales)
library(gridExtra)
library(grid)
library(GGally)
library(reshape2)

source("code/functions.R")

# Set the default theme for the sesion ------
theme_set(theme_light())

## Censo de viviendas en españa --------------------------------------------------
censo <- read.csv("data/clean_censo_2011.csv")
colnames(censo) <- gsub("\\.", "\\ ", colnames(censo))

censo$Decade <- factor(
        censo$Decade, levels = c("Before 1900", "1900-1920","1921-1940",
                                 "1941-1950", "1951-1960", "1961-1970",
                                 "1971-1980", "1981-1990", "1991-2001",
                                 "2002-2011")
)
        
colourCount = length(unique(censo$Decade))
getPalette = colorRampPalette(RColorBrewer::brewer.pal(9, "YlGnBu"))

p <- ggplot(censo, aes(x = Decade, y = Registered)) + 
        geom_col(colour = "grey39", fill = getPalette(colourCount)) +
        labs(title = "Spanish Housing Census grouped by decade") +
        guides(fill = FALSE) +
        scale_y_continuous(labels = fancy_scientific)

p <- p + theme(
        axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1),
        plot.title = element_text(hjust = 0.5)
)

p <- grid.arrange(p + labs(caption="Source: INE, 2019"))

ggsave("images/census.png", p)

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
BarrasPlot(df, df$orientacion_ppal)
        + labs(title = "Main orientation of the building")
        + ggsave("images/orientacion.png")
# Tabla resumen
TablaResumen_Decreciente(df$orientacion_ppal)

## Número de viviendas --------
df$num_viviendas_class <- factor(df$num_viviendas_class, levels = c("Detached",
                                                                    "From 2 to 4 dwellings",
                                                                    "From 5 to 9 dwellings",
                                                                    "From 10 to 19 dwellings",
                                                                    "From 20 to 39 dwellings",
                                                                    "More than 40 dwellings"))
BarrasPlot(df, df$num_viviendas_class)
        + labs(title = "Number of Dwellings")
        + ggsave("images/viviendas.png")
# Tabla resumen
TablaResumen_Original(df$num_viviendas_class)

## Num. de plantas ------
BarrasPlot(df, as.factor(df$num_plantas))
        + labs(title = "Number of floors")
        + ggsave("images/plantas.png")

# Tabla resumen
TablaResumen_Original(as.factor(df$num_plantas))

Resumen_Estadistico(df$num_plantas)

## Uso planta baja ---------
BarrasPlot_Ordenado(df, df$uso_pb)
        + labs(title = "Use of the ground floor")
        + ggsave("images/pbaja.png")
# Tabla resumen
TablaResumen_Decreciente(df$uso_pb)

## Tipo de fachada --------
BarrasPlot(df, df$tipo_fachada)
        + labs(title = "Type of facade")
        + ggsave("images/fachadas.png")
# Tabla resumen
TablaResumen_Original(df$tipo_fachada)

## Tipo de cubierta ------
BarrasPlot(df, df$tipo_cubierta)
        + labs(title = "Type of roof")
        + ggsave("images/cubiertas.png")
# Tabla resumen
TablaResumen_Original(df$tipo_cubierta)

## Tipo de hueco -------
BarrasPlot(df, df$tipo_hueco)
        + labs(title = "Facade openings")
        + ggsave("images/huecos.png")
# Tabla resumen
TablaResumen_Original(df$tipo_hueco)

## Tipo med exp -------
BarrasPlot(df, df$tipo_med_exp)
        + labs(title = "Types of party walls")
        + ggsave("images/medianeras.png")
# Tabla resumen
TablaResumen_Original(df$tipo_med_exp)

## Variables numericas deseables para el plot
nums <- unlist(purrr::map(df, is.numeric))  
nums[c("anyo", "num_plantas", "sup_med_lnc", "sup_envol",
       "sup_median_exp", "sup_patio", "num_viviendas")] <- FALSE

nums[nums == TRUE]

# Multiplot
ggp <- ggpairs(df[,nums], 
        
        # Columns to include into the matrix
        columnLabels = c("Roof Surface", "Facade Surface", 
                         "Openings \nSurface", "Surf. Touching \nthe Ground"),
        
        # What to include in the upper triangle
        upper = list(my_custom_cor),
        
        # What to include in the diagonal
        diag = list(continuous = my_density, 
                    mapping = aes(color = as.factor(df$num_plantas))),
        
        # What to include in the lower triangle
        lower = list(continuous = "points", 
                     mapping = aes(color = df$barrio, alpha = 0.5))
        
        ) +
        
        theme(panel.grid.minor = element_line(colour = "white"), 
              panel.grid.major = element_line(colour = "white"))

# Extract the necesary legends
diag_legend <- g_legend(ggplot(df, 
                               aes(x = sup_fachadas, 
                                   y = ..density..,
                                   color = as.factor(df$num_plantas))) +
                                geom_density() +
                                guides (color = guide_legend(title = "Number \nof Floors")) +
                                theme(legend.title = element_text(face = "bold"),
                                      plot.margin=unit(c(1,-0.5,1,1), "cm")))

low_legend <- g_legend(ggplot(df,
                              aes(x = sup_fachadas, 
                                  y = sup_cubierta,
                                  color = barrio)) +
                                      geom_point() +
                               guides (color = guide_legend(title = "District")) +
                               theme(legend.position = "top",
                                     legend.title = element_text(face = "bold")))
        

g <- grid.grabExpr(print(ggp))

pf <- grid.arrange(g, diag_legend, low_legend, nrow = 2, heights = c(9,1),
                   widths = c(0.9,0.1))

ggsave("images/continuas.png", pf)

## Plot as example
p <- ggplot(df, 
       aes(x = sup_cubierta, 
           y = ..density..,
           color = as.factor(df$num_plantas))) +
        geom_density(show.legend = F) +
        labs(title = "Density Plot of Facade Surface" ,
             x = "Roof Surface", y = "Density") +
        guides (color = guide_legend(title = "Number \nof Floors")) +
        theme(plot.title = element_text(hjust = 0.5))


ggsave("images/densidad.png", p)
