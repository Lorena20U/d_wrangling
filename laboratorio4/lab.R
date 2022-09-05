library(readr)
library(dplyr)
library(highcharter)
library(plotly)
library(stringr)
library(stringi)
library(tidyverse)

#str_detect de la libreria stringr <- para el laboratorio 4

tabla <- read_delim("lab4/tabla_completa.csv",
                 ",", escape_double = FALSE, trim_ws = TRUE)
str(tabla)

tabla <- tabla %>%
  mutate_if(is.character, as.factor) %>%
  add_column('faltante' = 0, 'devolucion' = 0, 'despacho' = 0) %>%
  rename_all(., .funs = tolower)

tabla$cliente <- data.frame(tolower(tabla$cliente))
tabla$piloto <- data.frame(tolower(tabla$piloto))
tabla$unidad <- str_replace_all(tabla$unidad, "\xf1o", "nio")
tabla$unidad <- data.frame(tolower(tabla$unidad))
a <- tabla$piloto
names(a)[1] <- 'piloto'
tabla$piloto <- a$piloto
a <- tabla$unidad
names(a)[1] <- 'unidad'
tabla$unidad <- a$unidad
a <- tabla$cliente
names(a)[1] <- 'cliente'
a <- a %>% 
  mutate(despacho = str_extract(a$cliente, "despacho a cliente"),
         faltante = str_extract(a$cliente, "faltante"),
         devolucion = str_extract(a$cliente, "devolucion"))

a$despacho <- a$despacho %>%
  str_replace_all("despacho a cliente", "1")
a$faltante <- a$faltante %>%
  str_replace_all("faltante", "1")
a$devolucion <- a$devolucion %>%
  str_replace_all("devolucion", "1")

a$despacho[is.na(a$despacho)] <- 0
a$faltante[is.na(a$faltante)] <- 0
a$devolucion[is.na(a$devolucion)] <- 0

a$cliente <- a$cliente %>%
  str_replace_all("faltante", "") %>%
  str_replace_all("despacho a cliente", "") %>%
  str_replace_all("devolucion", "") %>%
  str_replace_all( " /", "") %>%
  str_replace_all("/", "") %>%
  str_replace_all("\\|", "")
a
a$cliente <- sub("taqueria el chinito ", "taqueria el chinito", a$cliente)
a$cliente <- sub("ubiquo labs ", "ubiquo labs", a$cliente)
tabla$cliente <- a$cliente
tabla$faltante <- as.numeric(a$faltante)
tabla$despacho <- as.numeric(a$despacho)
tabla$devolucion <- as.numeric(a$devolucion)
tabla$mes <- as.numeric(tabla$mes)

str(tabla)
as.data.frame(table(tabla$devolucion))
as.data.frame(table(tabla$mes))
as.data.frame(table(tabla$anio))

view(tabla)
#tabla <- tabla %>%
 # mutate(pu = q/cantidad)
str(tabla)
#--------------
# Identificando la cantidad de clientes
tabla %>%
  summarise(clientes = n_distinct(tabla$cliente))
tabla$cantidad <- tabla$cantidad/100

tabla %>%
  select(cantidad, cliente) %>%
  group_by(cliente) %>%
  summarise(cantidades = n_distinct(cantidad)) %>%
  hchart("column", hcaes(x = cliente, y = cantidades)) %>%
  hc_title(text = "<b>Demanda de productos </b>") %>%
  hc_subtitle(text = " <i> </i>")

tabla %>%
  select(q, cliente) %>%
  group_by(cliente) %>%
  summarise(q = n()) %>%
  hchart("column", hcaes(x = cliente, y = q)) %>%
  hc_title(text = "<b>Ganancia por cliente</b>") %>%
  hc_subtitle(text = " <i> </i>")

tabla %>%
  select(piloto) %>%
  group_by(piloto) %>%
  summarise(entregas = n())
