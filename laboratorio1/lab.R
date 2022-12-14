library(readxl)
library(readr)
library(tidyverse)
library(tidytext)
library(writexl)
library(ggplot2)


# Problema 1----------------
d01 <- readxl::read_excel("01-2018.xlsx")
d02 <- readxl::read_excel('02-2018.xlsx')
d03 <- readxl::read_excel('03-2018.xlsx')
d04 <- readxl::read_excel('04-2018.xlsx')
d05 <- readxl::read_excel('05-2018.xlsx')
d06 <- readxl::read_excel('06-2018.xlsx')
d07 <- readxl::read_excel('07-2018.xlsx')
d08 <- readxl::read_excel('08-2018.xlsx')
d09 <- readxl::read_excel('09-2018.xlsx')
d10 <- readxl::read_excel('10-2018.xlsx')
d11 <- readxl::read_excel('11-2018.xlsx')

str(d01)
str(d02)
str(d03)
str(d04)
str(d05)
str(d06)
str(d07)
str(d08)
str(d09)
str(d10)
str(d11)
typeof(d01)

d07 <- d07[,-9] #Quitando la o las columnas que no interesan
d08 <- d08[,-9:-10]
d09 <- d09[,-9]
d10 <- d10[,-9]
d11 <- d11[,-9]

data <- rbind(d01, d02, d03, d04, d05, d06, d07, d08, d09, d10, d11)
data
ncol(data)
str(data)

generate_df <- function(x, n){ return(
  data.frame(
    FECHA = sample(x, size = n, replace = TRUE)
  )
)
}

fecha <- generate_df('01-2018', nrow(d01))
fecha <- rbind(fecha, generate_df('02-2018', nrow(d02)))
fecha <- rbind(fecha, generate_df('03-2018', nrow(d03)))
fecha <- rbind(fecha, generate_df('04-2018', nrow(d04)))
fecha <- rbind(fecha, generate_df('05-2018', nrow(d05)))
fecha <- rbind(fecha, generate_df('06-2018', nrow(d06)))
fecha <- rbind(fecha, generate_df('07-2018', nrow(d07)))
fecha <- rbind(fecha, generate_df('08-2018', nrow(d08)))
fecha <- rbind(fecha, generate_df('09-2018', nrow(d09)))
fecha <- rbind(fecha, generate_df('10-2018', nrow(d10)))
fecha <- rbind(fecha, generate_df('11-2018', nrow(d11)))


fecha
data2 <- cbind(data, fecha)
data2
str(data2)
data2[2180,]

write_xlsx(data2, "entregable.xlsx")
entregable <- readxl::read_excel("entregable.xlsx")
entregable

#Problema 2 -----------------------------

generat_df <- function(x, n){ return(
  data.frame(
    a = sample(1:20, size = n, replace = TRUE)
  )
)
}

vlista <- lapply(1:4, generat_df, n = 8)
vlista

moda <- function(x) {
  return(as.numeric(names(which.max(table(x)))))
}

tabla <- vlista[1]
df.tabla <- data.frame(tabla)

m <- moda(df.tabla)
tabla <- unlist(tabla)
tabla

titulo <- "Histograma de los datos"
subtitulo <- paste(" Moda = ",m)
ggplot(data = df.tabla, mapping = aes(x=tabla)) +
  geom_histogram(bins=30) +
  ggtitle(titulo, subtitle = subtitulo) +
  xlab('Valores') + ylab('Frecuencia') +
  geom_vline(aes(xintercept = m,
                 color = "moda"),
             linetype = "dashed",
             size = 1)

tabla <- vlista[2]
df.tabla <- data.frame(tabla)

m <- moda(df.tabla)
tabla <- unlist(tabla)
tabla

titulo <- "Histograma de los datos"
subtitulo <- paste(" Moda = ",m)
ggplot(data = df.tabla, mapping = aes(x=tabla)) +
  geom_histogram(bins=30) +
  ggtitle(titulo, subtitle = subtitulo) +
  xlab('Valores') + ylab('Frecuencia') +
  geom_vline(aes(xintercept = m,
                 color = "moda"),
             linetype = "dashed",
             size = 1)

tabla <- vlista[3]
df.tabla <- data.frame(tabla)

m <- moda(df.tabla)
tabla <- unlist(tabla)
tabla

titulo <- "Histograma de los datos"
subtitulo <- paste(" Moda = ",m)
ggplot(data = df.tabla, mapping = aes(x=tabla)) +
  geom_histogram(bins=30) +
  ggtitle(titulo, subtitle = subtitulo) +
  xlab('Valores') + ylab('Frecuencia') +
  geom_vline(aes(xintercept = m,
                 color = "moda"),
             linetype = "dashed",
             size = 1)

tabla <- vlista[4]
df.tabla <- data.frame(tabla)

m <- moda(df.tabla)
tabla <- unlist(tabla)
tabla

titulo <- "Histograma de los datos"
subtitulo <- paste(" Moda = ",m)
ggplot(data = df.tabla, mapping = aes(x=tabla)) +
  geom_histogram(bins=30) +
  ggtitle(titulo, subtitle = subtitulo) +
  xlab('Valores') + ylab('Frecuencia') +
  geom_vline(aes(xintercept = m,
                 color = "moda"),
             linetype = "dashed",
             size = 1)

# Problema 3 --------------------------------------------------------------------------
sat <- read_delim("Informacion_para_analisis_estadistico_vehiculos_2019_enero/INE_PARQUE_VEHICULAR_080219.txt", delim="|")
head(sat)
