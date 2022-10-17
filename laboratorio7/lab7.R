library(readr)
library(dplyr)
library(highcharter)
library(plotly)
library(stringr)
library(lubridate)
library(stringi)
library(tidyverse)
library(readxl)
library(writexl)
library(sf)
library(ggplot2)
library(mapview)

df <- read_delim("c1.csv")

df <- df[,1:22]
df$Fecha <- dmy(df$Fecha)

df <- df %>% 
  mutate(Camion_5 = gsub("Q","",Camion_5),
         Camion_5 = gsub("-","0",Camion_5), 
         Camion_5 = as.numeric(Camion_5), 
         Pickup = gsub("Q","",Pickup),
         Pickup = gsub("-","0",Pickup), 
         Pickup = as.numeric(Pickup),
         Moto = gsub("Q","",Moto),
         Moto = gsub("-","0",Moto), 
         Moto = as.numeric(Moto),
         factura = gsub("Q","",factura),
         factura = gsub("-","0",factura), 
         factura = as.numeric(factura), 
         
         directoCamion_5 = gsub("Q","",directoCamion_5),
         directoCamion_5 = gsub("-","0",directoCamion_5), 
         directoCamion_5 = as.numeric(directoCamion_5), 
         
         directoPickup = gsub("Q","",directoPickup),
         directoPickup = gsub("-","0",directoPickup), 
         directoPickup = as.numeric(directoPickup), 
         
         directoMoto = gsub("Q","",directoMoto),
         directoMoto = gsub("-","0",directoMoto), 
         directoMoto = as.numeric(directoMoto), 
         
         fijoCamion_5 = gsub("Q","",fijoCamion_5),
         fijoCamion_5 = gsub("-","0",fijoCamion_5), 
         fijoCamion_5 = as.numeric(fijoCamion_5), 
         
         fijoPickup = gsub("Q","",fijoPickup),
         fijoPickup = gsub("-","0",fijoPickup), 
         fijoPickup = as.numeric(fijoPickup), 
         
         fijoMoto = gsub("Q","",fijoMoto),
         fijoMoto = gsub("-","0",fijoMoto), 
         fijoMoto = as.numeric(fijoMoto))

df <- df %>% 
  mutate(Vehiculo = case_when(Camion_5 != 0 ~ "Camion", 
                              Pickup != 0~ "Pickup", 
                              Moto != 0 ~ "Moto"))
df <- df %>% 
  mutate(Costo_total = case_when(Camion_5 != 0 ~ Camion_5, 
                                 Pickup != 0~ Pickup, 
                                 Moto != 0 ~ Moto))

df <- df %>% 
  mutate(Costo_directo = case_when(directoCamion_5 != 0 ~ directoCamion_5, 
                                   directoPickup != 0~ directoPickup, 
                                   directoMoto != 0 ~ directoMoto))

df <- df %>% 
  mutate(Costo_fijo = case_when(fijoCamion_5 != 0 ~ fijoCamion_5, 
                                fijoPickup != 0~ fijoPickup, 
                                fijoMoto != 0 ~ fijoMoto))

df <- df %>% 
  mutate(Costo_fijo = case_when(fijoCamion_5 != 0 ~ fijoCamion_5, 
                                fijoPickup != 0~ fijoPickup, 
                                fijoMoto != 0 ~ fijoMoto))

df <- df %>% 
  mutate(Costo_total_2 = Costo_fijo + Costo_directo)

df <- df %>% 
  mutate(Costo_total_dif = Costo_total - Costo_total_2)

df <- df %>% 
  mutate(Ganancia = factura - Costo_total)

df <- df %>% 
  mutate(Ganancia2 = factura - Costo_total_2)

df %>%
  select(Vehiculo, Costo_total_dif) %>%
  group_by(Vehiculo) %>%
  summarise(n())

#--------- vehiculos
df %>%
  select(Vehiculo) %>%
  group_by(Vehiculo) %>%
  summarise(cantidad = n()) %>%
  arrange(desc(cantidad)) %>%
  hchart("column", hcaes(x = Vehiculo, y = cantidad)) %>%
  hc_add_theme(hc_theme_darkunica()) %>%
  hc_title(text = "<b>Distribución por vehículos </b>")

df %>%
  select(Vehiculo, Ganancia) %>%
  group_by(Vehiculo) %>%
  summarise(ganancia = n()) %>%
  arrange(desc(ganancia)) %>%
  hchart("column", hcaes(x = Vehiculo, y = ganancia)) %>%
  hc_add_theme(hc_theme_darkunica()) %>%
  hc_title(text = "<b>Ganancia por vehículo </b>")

#costo tiempo vehiculos
a <- df %>%
  select(Fecha, Vehiculo, Costo_total) %>%
  group_by(month(Fecha), Vehiculo) %>%
  summarise(c_tot = n())

names(a)[1] <- "Fecha"

a %>%
  hchart("line", hcaes(x = Fecha, y = c_tot, group = Vehiculo)) %>% 
  hc_add_theme(hc_theme_darkunica()) %>%
  hc_title(text = "<b>Costo total durante el ciclo 2017 por vehiculos. </b>")



#----------------- codigos
df %>%
  select(Cod) %>%
  group_by(Cod) %>%
  summarise(cantidad = n()) %>%
  arrange(desc(cantidad)) %>%
  hchart("column", hcaes(x = Cod, y = cantidad)) %>%
  hc_add_theme(hc_theme_darkunica()) %>%
  hc_title(text = "<b>Distribución por servicios </b>")

df %>%
  select(Cod, Ganancia) %>%
  group_by(Cod) %>%
  summarise(ganancia = n()) %>%
  arrange(desc(ganancia)) %>%
  hchart("column", hcaes(x = Cod, y = ganancia)) %>%
  hc_add_theme(hc_theme_darkunica()) %>%
  hc_title(text = "<b>Ganancia por servicio </b>")

a <- df %>%
  select(Fecha, Cod, Costo_total) %>%
  group_by(month(Fecha), Cod) %>%
  summarise(c_tot = n())

names(a)[1] <- "Fecha"

a %>%
  hchart("line", hcaes(x = Fecha, y = c_tot, group = Cod)) %>% 
  hc_add_theme(hc_theme_darkunica()) %>%
  hc_title(text = "<b>Costo total durante el ciclo 2017 por servicio. </b>")

#------------------ origen
df %>%
  select(origen) %>%
  group_by(origen) %>%
  summarise(cantidad = n()) %>%
  arrange(desc(cantidad)) %>%
  hchart("column", hcaes(x = origen, y = cantidad)) %>%
  hc_add_theme(hc_theme_darkunica()) %>%
  hc_title(text = "<b>Distribución por el origen </b>")

df %>%
  select(origen, Ganancia) %>%
  group_by(origen) %>%
  summarise(ganancia = n()) %>%
  arrange(desc(ganancia)) %>%
  hchart("column", hcaes(x = origen, y = ganancia)) %>%
  hc_add_theme(hc_theme_darkunica()) %>%
  hc_title(text = "<b>Ganancia por origen </b>")

a <- df %>%
  select(Fecha, origen, Costo_total) %>%
  group_by(month(Fecha), origen) %>%
  summarise(c_tot = n())

names(a)[1] <- "Fecha"

a %>%
  hchart("line", hcaes(x = Fecha, y = c_tot, group = origen)) %>% 
  hc_add_theme(hc_theme_darkunica()) %>%
  hc_title(text = "<b>Costo total durante el ciclo 2017 por origen. </b>")




#------------------
mg17 <- df %>%
  filter(Fecha < dmy("01-10-2017")) %>%
  summarise(mop = sum(Ganancia))

baja <- mg17*0.25

mg18 <- mg17 - baja

a <- df %>%
  select(Fecha, Cod, Ganancia) %>%
  group_by(month(Fecha), Cod) %>%
  summarise(g_tot = n())


b <- df %>%
  select(Fecha, Cod, Ganancia) %>%
  group_by(month(Fecha), Cod) %>%
  summarise(g_tot = n())

names(a)[1] <- "Fecha"
names(b)[1] <- "Fecha"

c <- a$g_tot*0.05
c[21:120] <- a$g_tot[21:120] * 0.10
c[41:120] <- a$g_tot[41:120] * 0.15
c[61:120] <- a$g_tot[61:120] * 0.20
c[81:120] <- a$g_tot[81:120] * 0.25
b$g_tot <- b$g_tot - c
b <- b %>%
  filter(Fecha < 10)

b$Fecha <- b$Fecha + 11
a <- bind_rows(a, b)

a %>%
  hchart("line", hcaes(x = Fecha, y = g_tot, group = Cod)) %>% 
  hc_add_theme(hc_theme_darkunica()) %>%
  hc_title(text = "<b>Movimiento del margen operativo. </b>")

f <- df %>%
  select(ID) %>%
  group_by(ID) %>%
  summarise(n=n())

mean(f$n)
f %>%
  filter(n>4)

16822/74229

df %>%
  select(ID) %>%
  group_by(ID) %>%
  summarise(n=n()) %>%
  arrange(desc(n)) %>%
  hchart("column", hcaes(x = ID, y = n)) %>%
  hc_add_theme(hc_theme_darkunica()) %>%
  hc_title(text = "<b>Distribución de postes </b>")

d <- table(df$`120+`)
m_82 <- d[2]/d[1]



df <- df %>% 
  mutate(mant = case_when(`120+` != "X" ~ "0"))

df <- df %>%
  mutate(mant = gsub("x","1",`120+`))

df$mant <- as.numeric(df$mant)
df$mant[is.na(df$mant)] <- 0
df$mant <- as.numeric(df$mant)

g <- df %>%
  select(ID, mant) %>%
  group_by(ID) %>%
  summarise(n=sum(mant)) %>%
  filter(n != 0)

g %>%
  hchart("column", hcaes(x = ID, y = n)) %>%
  hc_add_theme(hc_theme_darkunica()) %>%
  hc_title(text = "<b>Distribución de mantenimiento 120+ de los postes </b>")

red <- nrow(g) * cost_prom
red
cost_prom <- df %>%
  summarise(prom = mean(Costo_total))

perd <- (mg17-mg18) / nrow(df)
n_cost <- cost_prom + perd
n_cost/cost_prom

tarifario <- df %>%
  select(factura, Cod) %>%
  group_by(Cod) %>%
  summarise(min = min(factura), max = max(factura), prom = mean(factura))
tarifario

mg_cr <- mg18 * 1.10
crecimiento <- mg_cr - mg18
crecimiento

