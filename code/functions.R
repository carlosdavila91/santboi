## Functions

## Funciones ----------
## Tablas resumen ------
TablaResumen_Decreciente <- function(cat_var){
        tabla <- data.frame(table(cat_var))
        tabla <- tabla[order(tabla$Freq, decreasing = T),]
        n <- as.character(tabla$cat_var)
        tabla <- as.data.frame(t(tabla[,-1]))
        colnames(tabla) <- n
        rownames(tabla) <- ""
        colnames(tabla) <- paste(colnames(t),"|",sep = "")
        tabla[2,] <- tabla[1,]
        tabla[2,] <- paste(tabla[2,],"|", sep = "")
        tabla[1,] <- rep("---|", length(colnames(tabla)))
        tabla
}

TablaResumen_Original <- function(cat_var){
        tabla <- data.frame(table(cat_var))
        n <- as.character(tabla$cat_var)
        tabla <- as.data.frame(t(tabla[,-1]))
        colnames(tabla) <- n
        rownames(tabla) <- ""
        colnames(tabla) <- paste(colnames(t),"|",sep = "")
        tabla[2,] <- tabla[1,]
        tabla[2,] <- paste(tabla[2,],"|", sep = "")
        tabla[1,] <- rep("---|", length(colnames(tabla)))
        tabla
}

## Barplots -----
BarrasPlot_Ordenado <- function(df, indexed_var){
        library(ggplot2)
        if(any(any(nchar(levels(indexed_var))>= 10))==TRUE){
                
                aux <- data.frame(table(indexed_var))
        
                p <- ggplot(aux, aes(x = reorder(indexed_var, -Freq), 
                                     y = Freq, 
                                     fill = indexed_var)) + 
                        geom_bar(stat = "identity", colour = "grey39") +
                        scale_fill_brewer(palette = "YlGnBu") + 
                        guides(fill = FALSE) +
                        labs(x = NULL, y = NULL) +
                        theme(axis.text.x = element_text(angle = 45, hjust = 1),
                              plot.title = element_text(hjust = 0.5))
        }
        else{
                aux <- data.frame(table(indexed_var))
                
                p <- ggplot(aux, aes(x = reorder(indexed_var, -Freq), 
                                     y = Freq, 
                                     fill = indexed_var)) + 
                        geom_bar(stat = "identity", colour = "grey39") +
                        scale_fill_brewer(palette = "YlGnBu") + 
                        guides(fill = FALSE) +
                        labs(x = NULL, y = NULL) + 
                        theme(plot.title = element_text(hjust = 0.5))
        }
        return(p)
}

BarrasPlot <- function(df, indexed_var){
        library(ggplot2)
        if(any(any(nchar(levels(indexed_var))>= 10))==TRUE){
                p <- ggplot(df, aes(x = indexed_var, 
                                    fill = indexed_var)) + 
                        geom_bar(colour = "grey39") +
                        scale_fill_brewer(palette = "YlGnBu") + 
                        guides(fill = FALSE) +
                        labs(x = NULL, y = NULL) +
                        theme(axis.text.x = element_text(angle = 45, hjust = 1),
                              plot.title = element_text(hjust = 0.5))
        }
        else{
                p <- ggplot(df, aes(x = indexed_var,
                                    fill = indexed_var)) + 
                        geom_bar(colour = "grey39") +
                        scale_fill_brewer(palette = "YlGnBu") +
                        guides(fill = FALSE) +
                        labs(x = NULL, y = NULL) +
                        theme(plot.title = element_text(hjust = 0.5))
        }
        return(p)
}

## Histogramas -----
Histograma <- function(df, num_var){
        
        # Stutges rule for the number of bins
        M = nrow(df) 
        k = round(1 + log2(M))
        
        p <- ggplot(df, aes(x = num_var)) + 
                geom_histogram(colour = "grey39", fill = "#2644A1", bins = k) +
                labs(x = NULL, y = NULL) +
                theme(plot.title = element_text(hjust = 0.5))
        return(p)
}

Histograma_Log10 <- function(df, num_var){
        
        # Stutges rule for the number of bins
        M = nrow(df) 
        k = round(1 + log2(M))
        
        p <- ggplot(df, aes(x = num_var)) + 
                geom_histogram(colour = "grey39", fill = "#61C0C0", bins = k) +
                labs(x = NULL, y = NULL) +
                scale_x_log10(breaks = pretty_breaks(n = 8)) +
                # scale_x_log10(breaks = seq(from = 10,
                #                            to = round(max(num_var)),
                #                            length.out = 5)) +
                theme(plot.title = element_text(hjust = 0.5),
                      axis.text.x = element_text(angle = 45, hjust = 1))
        return(p)
}

## Notation -------
fancy_scientific <- function(l) {
        # turn in to character string in scientific notation
        l <- format(l, scientific = TRUE)
        # delete the 0*10^0
        l <- gsub("0e\\+00","0",l)
        # quote the part before the exponent to keep all the digits
        l <- gsub("^(.*)e", "'\\1'e", l)
        # turn the 'e+' into plotmath format
        l <- gsub("e", "%*%10^", l)
        # return this as an expression
        parse(text=l)
}

format()