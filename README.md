# Análisis estadístico del dataset Breast Cancer Wisconsin (R)

Flujo de análisis estadístico reproducible en R sobre el conjunto de datos
Breast Cancer Wisconsin (Diagnostic), que recoge medidas morfológicas de
núcleos celulares obtenidas por punción aspirativa con aguja fina, etiquetadas
como tumor benigno o maligno.

El análisis no se limita a aplicar pruebas sueltas: las funciones deciden por sí
mismas qué contraste corresponde a cada variable y son reutilizables con
cualquier data frame que tenga una variable de agrupación.

## Qué hace

- Control de calidad: tipos de variable, valores perdidos y detección de
  valores atípicos por el criterio del rango intercuartílico.
- Descriptivos globales y por grupo diagnóstico, con formato numérico adaptado
  a la magnitud de cada valor.
- Test de normalidad de Lilliefors **dentro de cada grupo**, que es la
  condición que realmente asumen los contrastes de comparación de medias.
- Selección automática del contraste: t de Student o U de Mann-Whitney con dos
  grupos, ANOVA o Kruskal-Wallis con más de dos.
- Corrección de Benjamini-Hochberg para controlar la tasa de falsos
  descubrimientos, necesaria al realizar decenas de contrastes simultáneos.
- Correlaciones de Pearson o Spearman según normalidad, recorriendo cada par de
  variables una sola vez, con detección de colinealidad.
- Regresión logística con partición en entrenamiento y prueba, odds ratio con
  intervalos de confianza, matriz de confusión y AUC calculada a partir del
  estadístico de Mann-Whitney.

## Estructura

```
.
├── analisis_estadistico_breast_cancer.Rmd   # análisis completo
├── data/
│   ├── preparar_datos.R                     # descarga y prepara los datos
│   └── dataBreastCancer.txt                 # se genera al ejecutar el script
└── README.md
```

## Cómo reproducirlo

1. Clona el repositorio o descárgalo como ZIP.
2. Instala los paquetes necesarios:

```r
install.packages(c("dplyr", "tidyr", "purrr", "tibble", "ggplot2",
                   "nortest", "rstatix", "rmarkdown", "mclust"))
```

3. No hace falta descargar nada a mano: el análisis ejecuta
   `data/preparar_datos.R` si no encuentra los datos, y ese script los obtiene
   del [repositorio UCI](https://archive.ics.uci.edu/dataset/17/breast+cancer+wisconsin+diagnostic).
   Si la descarga no estuviera disponible, recurre a la copia del mismo
   conjunto incluida en el paquete `mclust`.

4. Abre el `.Rmd` en RStudio y pulsa **Knit**, o ejecuta:

```r
rmarkdown::render("analisis_estadistico_breast_cancer.Rmd")
```

Se genera un informe HTML con todas las tablas y gráficos.

## Notas metodológicas

Los valores atípicos se detectan pero no se eliminan. En variables biológicas
como el radio o el área del núcleo, los valores extremos corresponden a tumores
grandes o irregulares, es decir, a la señal de interés y no a errores de
medida. Descartarlos habría reducido drásticamente el tamaño muestral y sesgado
las comparaciones.

La semilla aleatoria está fijada (`set.seed(123)`), de modo que la partición en
entrenamiento y prueba, y por tanto los resultados del modelo, son
reproducibles.

## Origen

Este análisis parte de un caso práctico del curso **Programación en R** (ISABIAL,
30 h), ampliado posteriormente con la evaluación de normalidad por grupo, la
corrección por comparaciones múltiples y la validación del modelo sobre datos
no usados en el ajuste.

## Autor

Daniel Catalán Piera — Graduado en Biología (Universidad de Alicante).
