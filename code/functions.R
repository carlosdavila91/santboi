## Functions

## Funciones ----------
TablaResumen_Decreciente <- function(cat_var){
        tabla <- data.frame(table(cat_var))
        tabla <- tabla[order(tabla$Freq, decreasing = T),]
        n <- as.character(tabla$cat_var)
        tabla <- as.data.frame(t(tabla[,-1]))
        colnames(tabla) <- n
        rownames(tabla) <- ""
        tabla
}

TablaResumen_Original <- function(cat_var){
        tabla <- data.frame(table(cat_var))
        n <- as.character(tabla$cat_var)
        tabla <- as.data.frame(t(tabla[,-1]))
        colnames(tabla) <- n
        rownames(tabla) <- ""
        tabla
}

BarrasPlot_Ordenado <- function(df, indexed_var){
        library(ggplot2)
        if(any(any(nchar(levels(indexed_var))>= 10))==TRUE){
                
                aux <- data.frame(table(indexed_var))
        
                p <- ggplot(aux, aes(x = reorder(indexed_var, -Freq), y = Freq)) + 
                        geom_bar(stat = "identity") + 
                        theme(axis.text.x = element_text(angle = 45, hjust = 1))
        }
        else{
                aux <- data.frame(table(indexed_var))
                
                p <- ggplot(aux, aes(x = reorder(indexed_var, -Freq), y = Freq)) + 
                        geom_bar(stat = "identity")
        }
        return(p)
}

BarrasPlot <- function(df, indexed_var){
        library(ggplot2)
        if(any(any(nchar(levels(indexed_var))>= 10))==TRUE){
                p <- ggplot(df, aes(x = indexed_var)) + 
                        geom_bar() + 
                        theme(axis.text.x = element_text(angle = 45, hjust = 1))
        }
        else{
                p <- ggplot(df, aes(x = indexed_var)) + 
                        geom_bar()
        }
        return(p)
}

Histograma <- function(df, num_var){
        p <- ggplot(df, aes(x = num_var)) + geom_histogram()
        return(p)
}

Histograma_Log10 <- function(df, num_var){
        p <- ggplot(df, aes(x = log(num_var))) + geom_histogram()
        return(p)
}

fancy_scientific <- function(l) {
        # turn in to character string in scientific notation
        l <- format(l, scientific = TRUE)
        # quote the part before the exponent to keep all the digits
        l <- gsub("^(.*)e", "'\\1'e", l)
        # turn the 'e+' into plotmath format
        l <- gsub("e", "%*%10^", l)
        # return this as an expression
        parse(text=l)
}