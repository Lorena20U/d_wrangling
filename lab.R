library(readxl)
library(readr)
library(tidyverse)
library(tidytext)

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
str(data)

generate_df <- function(fec, n){ return(
  data.frame(
    FECHA = sample(fec, size = n, replace = TRUE)
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
