## Functions
library(GGally)
## Funciones ----------
## Tablas resumen ------
Resumen_Estadistico <- function(indexed_numeric_var){
        if(max(indexed_numeric_var) < 100){
                tabla <- as.data.frame(as.array(summary(indexed_numeric_var)))
                tabla$Freq <- round(tabla$Freq, digits = 2)
                n <- as.character(tabla$Var1)
                n <- paste(n,"|",sep = "")
                tabla <- data.frame(t(tabla[,-1]))
                colnames(tabla) <- n
                
                tabla[2,] <- tabla[1,]
                tabla[2,] <- paste(tabla[2,],"|", sep = "")
                tabla[1,] <- rep("---|", length(colnames(tabla)))
                
                rownames(tabla) <- NULL
                
                print(tabla, row.names = FALSE)
        }else{
                tabla <- as.data.frame(as.array(summary(indexed_numeric_var)))
                tabla$Freq <- round(tabla$Freq)
                n <- as.character(tabla$Var1)
                n <- paste(n,"|",sep = "")
                tabla <- data.frame(t(tabla[,-1]))
                colnames(tabla) <- n
                
                tabla[2,] <- tabla[1,]
                tabla[2,] <- paste(tabla[2,],"|", sep = "")
                tabla[1,] <- rep("---|", length(colnames(tabla)))
                
                rownames(tabla) <- NULL
                
                print(tabla, row.names = FALSE)  
        }
}

TablaResumen_Decreciente <- function(cat_var){
        
        tabla <- data.frame(table(cat_var))
        tabla <- tabla[order(tabla$Freq, decreasing = T),]
        
        n <- as.character(tabla$cat_var)
        n <- paste(n,"|",sep = "")
        
        tabla <- as.data.frame(t(tabla[,-1]))
        
        colnames(tabla) <- n
        
        tabla[2,] <- tabla[1,]
        tabla[2,] <- paste(tabla[2,],"|", sep = "")
        tabla[1,] <- rep("---|", length(colnames(tabla)))
        
        rownames(tabla) <- NULL
        
        print(tabla, row.names = FALSE)
}

TablaResumen_Original <- function(cat_var){
        
        tabla <- data.frame(table(cat_var))
        
        n <- as.character(tabla$cat_var)
        n <- paste(n,"|",sep = "")
        
        tabla <- as.data.frame(t(tabla[,-1]))
        
        colnames(tabla) <- n

        tabla[2,] <- tabla[1,]
        tabla[2,] <- paste(tabla[2,],"|", sep = "")
        tabla[1,] <- rep("---|", length(colnames(tabla)))
        
        rownames(tabla) <- NULL
        
        print(tabla, row.names = FALSE)
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
        k = round(1 + log2(M)) + 1
        
        p <- ggplot(df, aes(x = num_var, y = ..density..)) + 
                geom_histogram(colour = "#99D5B8", 
                               fill = "#99D5B8",
                               alpha = 0.5,
                               bins = k) +
                geom_density() +
                geom_vline(aes(xintercept = mean(num_var), color = "Mean"),
                           # col="#0A1F57", 
                           size = 1,
                           linetype = "dashed") +
                geom_vline(aes(xintercept = median(num_var), color = "Median"),
                           # col="#2681B6", 
                           size = 1,
                           linetype = "dashed") +
                labs(x = NULL, y = NULL) +
                # expand_limits(y=0) +
                scale_color_manual(name = "Statistics", 
                                   values = c(Median = "#2681B6", Mean = "#0A1F57")) +
                theme(plot.title = element_text(hjust = 0.5),
                      legend.position = c(1,1), 
                      legend.justification = c(1.5,1.5))
        return(p)
}

Histograma_Log10 <- function(df, num_var){
        
        # Stutges rule for the number of bins
        M = nrow(df) 
        k = round(1 + log2(M)) + 1
        
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
## Funciones para ggpairs-----
my_density <- function(data, mapping, ...) {
        p <- ggplot(data = data, mapping = mapping) +
                geom_density(aes(fill = NULL, ...))
        return(p)
}

# Custom correlation coefficients 
my_custom_cor <- function(data, mapping, color = I("grey50"), sizeRange = c(1, 5), ...) {
        
        # get the x and y data to use the other code
        x <- eval(mapping$x, data)
        y <- eval(mapping$y, data)
        
        ct <- cor.test(x,y)
        sig <- symnum(
                ct$p.value, corr = FALSE, na = FALSE,
                cutpoints = c(0, 0.001, 0.01, 0.05, 0.1, 1),
                symbols = c("***", "**", "*", ".", " ")
        )
        
        r <- unname(ct$estimate)
        rt <- format(r, digits=2)[1]
        
        # since we can't print it to get the strsize, just use the max size range
        cex <- max(sizeRange)
        
        # helper function to calculate a useable size
        percent_of_range <- function(percent, range) {
                percent * diff(range) + min(range, na.rm = TRUE)
        }
        
        # plot the cor value
        ggally_text(
                label = as.character(rt), 
                mapping = aes(),
                xP = 0.5, yP = 0.5, 
                size = I(percent_of_range(cex * abs(r), sizeRange)),
                color = color,
                ...
        ) + 
                # add the sig stars
                geom_text(
                        aes_string(
                                x = 0.8,
                                y = 0.8
                        ),
                        label = sig, 
                        size = I(cex),
                        color = color,
                        ...
                ) + 
                # remove all the background stuff and wrap it with a dashed line
                theme_classic() + 
                theme(
                        panel.background = element_rect(
                                color = color, 
                                linetype = "longdash"
                        ), 
                        axis.line = element_blank(), 
                        axis.ticks = element_blank(), 
                        axis.text.y = element_blank(), 
                        axis.text.x = element_blank()
                )
}
                
#Extract Legend

g_legend<-function(a.gplot){
        tmp <- ggplot_gtable(ggplot_build(a.gplot))
        leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
        legend <- tmp$grobs[[leg]]
        return(legend)}