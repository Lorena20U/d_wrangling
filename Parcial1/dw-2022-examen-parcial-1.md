dw-2022-parcial-1
================
Tepi
9/19/2022

# Examen parcial

Indicaciones generales:

-   Usted tiene el período de la clase para resolver el examen parcial.

-   La entrega del parcial, al igual que las tareas, es por medio de su
    cuenta de github, pegando el link en el portal de MiU.

-   Pueden hacer uso del material del curso e internet (stackoverflow,
    etc.). Sin embargo, si encontramos algún indicio de copia, se
    anulará el exámen para los estudiantes involucrados. Por lo tanto,
    aconsejamos no compartir las agregaciones que generen.

## Sección I: Preguntas teóricas.

-   Existen 10 preguntas directas en este Rmarkdown, de las cuales usted
    deberá responder 5. Las 5 a responder estarán determinadas por un
    muestreo aleatorio basado en su número de carné.

-   Ingrese su número de carné en `set.seed()` y corra el chunk de R
    para determinar cuáles preguntas debe responder.

``` r
#set.seed("20200396") 
v<- 1:10
preguntas <-sort(sample(v, size = 5, replace = FALSE ))

paste0("Mis preguntas a resolver son: ",paste0(preguntas,collapse = ", "))
```

    ## [1] "Mis preguntas a resolver son: 2, 3, 4, 8, 10"

### Listado de preguntas teóricas

1.  Para las siguientes sentencias de `base R`, liste su contraparte de
    `dplyr`:

    -   `str()`
    -   `df[,c("a","b")]`
    -   `names(df)[4] <- "new_name"` donde la posición 4 corresponde a
        la variable `old_name`
    -   `df[df$variable == "valor",]`

2.  Al momento de filtrar en SQL, ¿cuál keyword cumple las mismas
    funciones que el keyword `OR` para filtrar uno o más elementos una
    misma columna?

3.  ¿Por qué en R utilizamos funciones de la familia apply
    (lapply,vapply) en lugar de utilizar ciclos?

4.  ¿Cuál es la diferencia entre utilizar `==` y `=` en R?

5.  ¿Cuál es la forma correcta de cargar un archivo de texto donde el
    delimitador es `:`?

6.  ¿Qué es un vector y en qué se diferencia en una lista en R?

7.  ¿Qué pasa si quiero agregar una nueva categoría a un factor que no
    se encuentra en los niveles existentes?

8.  Si en un dataframe, a una variable de tipo `factor` le agrego un
    nuevo elemento que *no se encuentra en los niveles existentes*,
    ¿cuál sería el resultado esperado y por qué?

    -   El nuevo elemento
    -   `NA`

9.  En SQL, ¿para qué utilizamos el keyword `HAVING`?

10. Si quiero obtener como resultado las filas de la tabla A que no se
    encuentran en la tabla B, ¿cómo debería de completar la siguiente
    sentencia de SQL?

    -   SELECT \* FROM A \_\_\_\_\_\_\_ B ON A.KEY = B.KEY WHERE
        \_\_\_\_\_\_\_\_\_\_ = \_\_\_\_\_\_\_\_\_\_

Extra: ¿Cuántos posibles exámenes de 5 preguntas se pueden realizar
utilizando como banco las diez acá presentadas? (responder con código de
R.)

## Sección II Preguntas prácticas.

-   Conteste las siguientes preguntas utilizando sus conocimientos de R.
    Adjunte el código que utilizó para llegar a sus conclusiones en un
    chunk del markdown.

A. De los clientes que están en más de un país,¿cuál cree que es el más
rentable y por qué?

B. Estrategia de negocio ha decidido que ya no operará en aquellos
territorios cuyas pérdidas sean “considerables”. Bajo su criterio,
¿cuáles son estos territorios y por qué ya no debemos operar ahí?

### I. Preguntas teóricas

## A

#### Mis preguntas a resolver son: 3, 4, 6, 7, 9

3.  ¿Por qué en R utilizamos funciones de la familia apply
    (lapply,vapply) en lugar de utilizar ciclos?

Esto es para evitar el uso de ciclos por medio de funciones que operan
con cada elementos de la estructura. Entonces, si se tiene un set de
datos con diferentes columnas, por medio de lapply nos permite realizar
operaciones aritmeticas y estadisticas por columna sin la necesidad de
ciclos.

4.  ¿Cuál es la diferencia entre utilizar `==` y `=` en R?

El primero (==) es un operador logico en donde se comparan dos objetos y
si son iguales se retorna TRUE, de lo contrario, ambos elementos son
diferentes. El segundo (=) es un operador de asignacion de izquierda al
igual que \<- pero no se suele utilizar en R como en Python y otros
lenguajes de programacion. Tambien es un asignador de argumentos.

6.  ¿Qué es un vector y en qué se diferencia en una lista en R?

Los vectores son unidimensionales, es decir almacenan diferentes tipos
de carácteres y se pueden ejecutar operaciones matematicas y logicas
segun el tipo de dato. Las listas son similares que los vectores, pero a
diferencia de ellos, pueden almacenar diferentes tipos de datos, es
dimensional como una matriz.

7.  ¿Qué pasa si quiero agregar una nueva categoría a un factor que no
    se encuentra en los niveles existentes?

Al momento de analizar la informacion y ver los niveles existentes no
reconoce la nueva etiqueta por lo que lo coloca como NA, para que esto
no suceda y reconozca el nuevo nivel hay que hacer factor nuevamente a
la cadena de datos.

9.  En SQL, ¿para qué utilizamos el keyword `HAVING`?

Se utiliza para filtrar en base a una caracteristica en especifico en
donde se utilicen funciones de grupo, en otras palabras es el where de
un group by.

``` r
examen
```

    ##   examenes
    ## 1        7
    ## 2        5
    ## 3        9
    ## 4        3
    ## 5        8

## B

A. De los clientes que están en más de un país,¿cuál cree que es el más
rentable y por qué?

``` r
#cuantos paises tenemos
table(pais)
```

    ## pais
    ## 4046ee34 4f03bd9b 
    ##   117004   109232

B. Estrategia de negocio ha decidido que ya no operará en aquellos
territorios cuyas pérdidas sean “considerables”. Bajo su criterio,
¿cuáles son estos territorios y por qué ya no debemos operar ahí?

``` r
###resuelva acá
```
