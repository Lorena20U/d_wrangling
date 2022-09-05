library(readr)
library(dplyr)
library(highcharter)
library(plotly)
library(stringr)
library(stringi)
library(tidyverse)

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

a$cliente <- sub("taqueria el chinito ", "taqueria el chinito", a$cliente)
a$cliente <- sub("ubiquo labs ", "ubiquo labs", a$cliente)
tabla$cliente <- a$cliente
tabla$faltante <- as.numeric(a$faltante)
tabla$despacho <- as.numeric(a$despacho)
tabla$devolucion <- as.numeric(a$devolucion)
tabla$mes <- as.numeric(tabla$mes)

b <- tabla$faltante == 0 & tabla$devolucion == 0 & (tabla$despacho == 0 | tabla$despacho == 1)
b <- b %>%
  str_replace_all('TRUE', '1') %>%
  str_replace_all('FALSE', '0')

tabla$despacho <- as.numeric(b)

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

tabla %>%
  select(cliente) %>%
  group_by(cliente) %>%
  summarise(pedidos = n()) %>%
  arrange(desc(pedidos)) %>%
  hchart("column", hcaes(x = cliente, y = pedidos)) %>%
  hc_title(text = "<b>Demanda de solicitudes </b>") %>%
  hc_subtitle(text = " <i>El pinche obelisco lidera la lista con un total de 256 solicitudes. </i>")

tabla %>%
  select(faltante) %>%
  group_by(faltante) %>%
  summarise(n = n()) %>%
  hchart("column", hcaes(x = faltante, y = n)) %>%
  hc_title(text = "<b>Pedidos en faltante </b>") %>%
  hc_subtitle(text = " <i>1/3 de los pedidos se encuentran en faltante.</i>")


tabla %>%
  select(unidad) %>%
  group_by(unidad) %>%
  summarise(n = n()) %>%
  hchart("column", hcaes(x = unidad, y = n)) %>%
  hc_title(text = "<b>Frecuencia de las unidades </b>") %>%
  hc_subtitle(text = " <i>Los camiones grandes son las unidades que más se utilizan.</i>")

tabla %>%
  select(unidad, faltante) %>%
  group_by(unidad) %>%
  summarise(n = sum(faltante == 1) ) %>%
  hchart("column", hcaes(x = unidad, y = n)) %>%
  hc_title(text = "<b>Distribucion en faltantes </b>") %>%
  hc_subtitle(text = " <i>1/3 de las unidades de camión grande y panel se encuentran en faltante.</i>")


tabla %>%
  select(mes) %>%
  group_by(mes) %>%
  summarise(cantidad_s = n()) %>%
  hchart("line", hcaes(x = mes, y = cantidad_s)) %>% 
  hc_add_theme(hc_theme_google()) %>%
  hc_title(text = "<b>Solicitud de pedidos al mes </b>") %>%
  hc_subtitle(text = " <i>Mayo fue uno de los meses más activos.</i>")

tabla %>%
  select(mes, faltante) %>%
  group_by(mes) %>%
  summarise(cantidad_s = sum(faltante == 1)) %>%
  hchart("line", hcaes(x = mes, y = cantidad_s)) %>% 
  hc_add_theme(hc_theme_google()) %>%
  hc_title(text = "<b>Solicitud de pedidos al mes con estado faltante </b>") %>%
  hc_subtitle(text = " <i>Junio reporta mayor cantidad de viajes en faltante.</i>")

tabla %>%
  select(piloto, faltante) %>%
  group_by(piloto) %>%
  summarise(entregas = sum(faltante == 1)) %>%
  arrange(desc(entregas)) %>%
  hchart("line", hcaes(x = piloto, y = entregas)) %>% 
  hc_add_theme(hc_theme_google()) %>%
  hc_title(text = "<b>Entregas por piloto en faltante </b>") %>%
  hc_subtitle(text = " <i>Fernando Berrio es quien realiza la mayor cantidad de viajes en faltante, con un total de 89 entregas.</i>")

tabla %>%
  select(piloto, despacho) %>%
  group_by(piloto) %>%
  summarise(entregas = sum(despacho == 1)) %>%
  arrange(desc(entregas)) %>%
  hchart("line", hcaes(x = piloto, y = entregas)) %>% 
  hc_add_theme(hc_theme_google()) %>%
  hc_title(text = "<b>Entregas por piloto en tiempo </b>") %>%
  hc_subtitle(text = " <i>Fernando Berrio es quien realiza la mayor cantidad de viajes en tiempo, con un total de 167 entregas.</i>")

tabla %>%
  select(cliente, devolucion) %>%
  group_by(cliente) %>%
  summarise(entregas = sum(devolucion == 1)) %>%
  arrange(desc(entregas)) %>%
  hchart("line", hcaes(x = cliente, y = entregas)) %>% 
  hc_add_theme(hc_theme_google()) %>%
  hc_title(text = "<b>Frecuencia de devoluciones </b>") %>%
  hc_subtitle(text = " <i>Solo se ha registrado una devolucion</i>")

tabla %>%
  select(piloto) %>%
  group_by(piloto) %>%
  summarise(n = n())

tabla %>%
  select(cliente, q) %>%
  group_by(cliente) %>%
  summarise(total = sum(q)) %>%
  arrange(desc(total)) %>%
  hchart("line", hcaes(x = cliente, y = total)) %>% 
  hc_add_theme(hc_theme_google()) %>%
  hc_title(text = "<b>Ganancias obtenidas segun entregas por cliente</b>") %>%
  hc_subtitle(text = " <i>La ganancia total es de 599 mil quetzales durante el año, cerca del 80% se concentra en el Pinche Obelisco, la Taqueria El Chinito, El Gallo Negro, Pollo Pinulo y Ubiquo Labs.</i>")
