library(readr)
library(lubridate)
library(tidyverse)
library(readxl)
library(dplyr)
library(openxlsx)
library(highcharter)
library(nycflights13)

#En tiempo de Norte América, el eclipse total inició el 21 de agosto del 2017 a las 18:26:40.
#Este mismo evento, sucederá un Saros después.
#Un Saros equivale a 223 Synodic Months
#Un Synodic Month equivale a 29 días con 12 horas, con 44 minutos y 3 segundos.

#### parte 1 ####

e_total <- "21 agosto 2017 18:26:40"
e_total <- dmy_hms(e_total, tz="EST")
e_total
synodic_m <- days(29)
synodic_m <- synodic_m + hours(12)
synodic_m <- synodic_m + minutes(44)
synodic_m <- synodic_m + seconds(03)
synodic_m

saroc <- 223 * synodic_m
saroc

s_eclipe <- e_total + saroc
s_eclipe

#### parte 2 ####

tabla <- read_excel("data.xlsx")

tabla <- tabla %>%
  #mutate_if(is.character, as.factor) %>%
  rename_all(., .funs = tolower)

names(tabla) <- str_replace_all(names(tabla), " ", "_")
tabla
#---------------------------------------------------------- meses con mayor cantidad de llamadas por codigo

#strftime()
# modificacion tabla$fecha_creación
b <- tabla
b$fecha_creación <- format(as.Date(as.Date("1899-12-30") + as.numeric(tabla$fecha_creación), "%d-%m-%Y"), "%d-%m-%Y")
b$fecha_creación <- dmy(b$fecha_creación)
a <- tabla
a$fecha_creación <- dmy(tabla$fecha_creación)

a <- a[!is.na(a$fecha_creación),]
b <- b[!is.na(b$fecha_creación),]

tabla <- bind_rows(b, a)

# modificacion tabla$fecha_final
b <- tabla
b$fecha_final <- format(as.Date(as.Date("1899-12-30") + as.numeric(tabla$fecha_final), "%d-%m-%Y"), "%d-%m-%Y")
b$fecha_final <- dmy(b$fecha_final)

a <- tabla
a$fecha_final <- dmy(tabla$fecha_final)
a <- a[!is.na(a$fecha_final),]
b <- b[!is.na(b$fecha_final),]

tabla <- bind_rows(b, a)
tabla

# 1. en que meses existe una mayor cantidad de llamadas por codigo?

c <- tabla %>%
  select(fecha_creación, cod) %>%
  group_by(month(fecha_creación),cod) %>%
  summarise(cant = n())
  
names(c)[1] <- "fecha_creación"

c %>%
  hchart("column", hcaes(x = fecha_creación, y = cant, group = cod)) %>%
  hc_add_theme(hc_theme_hcrt()) %>%
  hc_title(text = "<b>Ocupacion de meses por codigo</b>") %>%
  hc_subtitle(text = " <i>Enero es para cobros y otros, marzo para cancelaciones, mayo para actualizaciones, julio para sin categoria y octubre para consultas y empresarial.</i>")

d <- c %>%
  filter(cod==0 & cant > 1460)
d <- bind_rows(d, (c %>%
  filter(cod=="Actualización de Información" & cant > 1690)))
d <- bind_rows(d,(c %>%
  filter(cod=="Cancelaciones" & cant > 4090)))
d <- bind_rows(d, (c %>%
  filter(cod=="Cobros" & cant > 685)))
d <- bind_rows(d, (c %>%
  filter(cod=="Consultas" & cant > 10750)))
d <- bind_rows(d, (c %>%
  filter(cod=="Empresarial" & cant > 3130)))
d <- bind_rows(d, (c %>%
  filter(cod=="Otros/Varios" & cant > 1120)))

d %>%
  hchart("column", hcaes(x = fecha_creación, y = cant, group = cod)) %>%
  hc_add_theme(hc_theme_smpl()) %>%
  hc_title(text = "<b>Meses mas ocupados por codigo</b>") %>%
  hc_subtitle(text = " <i>Enero es para cobros y otros, marzo para cancelaciones, mayo para actualizaciones, julio para sin categoria y octubre para consultas y empresarial.</i>")



# 2. que dia de la semana es el mas ocupado?
c <- tabla %>%
  select(fecha_creación) %>%
  group_by(weekdays(fecha_creación)) %>%
  summarise(cant = n())
c
names(c)[1] <- "fecha_creación"
c %>%
  hchart("line", hcaes(x = fecha_creación, y = cant)) %>%
  hc_add_theme(hc_theme_smpl()) %>%
  hc_title(text = "<b>Ocupacion de dias</b>") %>%
  hc_subtitle(text = " <i>Domingo es el día más ocupado del año.</i>")


# 3. que mes es el mas ocupado
c <- tabla %>%
  select(fecha_creación, cod) %>%
  group_by(month(fecha_creación)) %>%
  summarise(cant = n())

c
names(c)[1] <- "fecha_creación"
c %>% 
  filter(cant > 22700)

c %>%
  hchart("line", hcaes(x = fecha_creación, y = cant)) %>%
  hc_add_theme(hc_theme_smpl()) %>%
  hc_title(text = "<b>Ocupacion de meses</b>") %>%
  hc_subtitle(text = " <i>Marzo es el mes mas ocupado del año.</i>")

# 4. existe concentracion o estacionalidad en la cantidad de llamadas?

c <- tabla %>%
  select(fecha_creación, cod) %>%
  group_by(month(fecha_creación), cod) %>%
  summarise(cant = n())

c
names(c)[1] <- "fecha_creación"

c %>%
  hchart("line", hcaes(x = fecha_creación, y = cant, group = cod)) %>% 
  hc_title(text = "<b>Llamadas por meses</b>") %>%
  hc_subtitle(text = " <i>Marzo es el mes mas ocupado del año.</i>")

c <- tabla %>%
  select(fecha_creación, cod) %>%
  group_by(day(fecha_creación), cod) %>%
  summarise(cant = n())

c
names(c)[1] <- "fecha_creación"
c %>%
  hchart("line", hcaes(x = fecha_creación, y = cant, group = cod)) %>% 
  hc_title(text = "<b>Llamadas por dias</b>") %>%
  hc_subtitle(text = " <i>Los dias 10 y 7 son los mas ocupados de los meses..</i>")

# 5. cuantos minutos dura la llamada promedio?
difftime(tabla$hora_final, tabla$hora_creacion, units = "min")
min(difftime(tabla$hora_final, tabla$hora_creacion, units = "min"))
max(difftime(tabla$hora_final, tabla$hora_creacion, units = "min"))
mean(difftime(tabla$hora_final, tabla$hora_creacion, units = "min"))

# 6. realice una tabla de frecuencia con el tiempo de llamada
freq <- table(difftime(tabla$hora_final, tabla$hora_creacion, units = "min"))
freq <- as.data.frame(freq)
names(freq) <- c("Tiempo de llamada en minutos", "Cantidad de llamadas")
freq


#### Parte 3 - Signo Zodiacal ####
zodiacal <- c("aries", "tauro", "geminis", "cancer", "leo", "virgo", "libra", "escorpio", "sagitario", "capricornio", "acuario", "piscis")
zodiacal <- cbind(zodiacal, c(21,21,21,22,22,24,24,24,23,22,21,20))
zodiacal <- cbind(zodiacal, c(3,4,5,6,7,8,9,10,11,12,1,2))
zodiacal <- cbind(zodiacal, c(20,20,20,21,21,23,23,23,22,21,20,19))
zodiacal <- cbind(zodiacal, c(4,5,6,7,8,9,10,11,12,1,2,3))
zodiacal <- as.data.frame(zodiacal)
names(zodiacal) <- c("signo", "d_inicio", "m_inicio", "d_final", "m_final")
zodiacal
fecha_nac <- dmy(readline())
fecha_nac
signo <- zodiacal[zodiacal$m_inicio == month(fecha_nac),]
signof <- zodiacal[zodiacal$m_final == month(fecha_nac),]
signo
signof
signor <- ifelse(day(fecha_nac) >= zodiacal$d_inicio, signo$signo, signof$signo)
signor <- signor[1]
signor

#### Parte 4 - Flights ####
flights %>%
  select(dep_time, arr_time, sched_dep_time, sched_arr_time)

fecha <- paste(flights$year, flights$month, flights$day, sep = "-")

f_dep_time <- flights$dep_time
f_dep_time <- sprintf("%04d", f_dep_time)
f_dep_time <- as.POSIXct(paste0(fecha, " ", f_dep_time), format = "%Y-%m-%d %H%M", origin = "1970-01-01", tz = "UTC")
flights <- cbind(flights, f_dep_time)

f_arr_time <- flights$arr_time
f_arr_time <- sprintf("%04d", f_arr_time)
f_arr_time <- as.POSIXct(paste0(fecha, " ", f_arr_time), format = "%Y-%m-%d %H%M", origin = "1970-01-01", tz = "UTC")
flights <- cbind(flights, f_arr_time)

f_sched_time <- flights$sched_dep_time
f_sched_time <- sprintf("%04d", f_sched_time)
f_sched_time <- as.POSIXct(paste0(fecha, " ", f_sched_time), format = "%Y-%m-%d %H%M", origin = "1970-01-01", tz = "UTC")
flights <- cbind(flights, f_sched_time)

f_sched_arr_time <- flights$sched_arr_time
f_sched_arr_time <- sprintf("%04d", f_sched_arr_time)
f_sched_arr_time <- as.POSIXct(paste0(fecha, " ", f_sched_arr_time), format = "%Y-%m-%d %H%M", origin = "1970-01-01", tz = "UTC")
flights <- cbind(flights, f_sched_arr_time)
flights

delay_arr_time <- difftime(f_arr_time, f_sched_arr_time, units = "min")
delay_dep_time <- difftime(f_dep_time, f_sched_time, units = "min")
delay_tot <- delay_arr_time + delay_dep_time
flights <- cbind(flights, delay_tot)
delay_tot2 <- flights$dep_delay + flights$arr_delay
flights <- cbind(flights, delay_tot2)
