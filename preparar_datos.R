# =============================================================================
# Preparación de los datos: Breast Cancer Wisconsin (Diagnostic)
#
# Descarga el conjunto de datos del repositorio UCI y genera el archivo
# data/dataBreastCancer.txt que utiliza el análisis principal.
#
# Si la descarga no está disponible, recurre a la copia del mismo conjunto
# incluida en el paquete mclust de CRAN.
#
# Uso:  source("data/preparar_datos.R")
# =============================================================================

destino <- file.path("data", "dataBreastCancer.txt")

# Nombres de las 30 variables: diez medidas morfológicas del núcleo, cada una
# resumida por su media, su error estándar y el peor valor observado.
medidas <- c("radius", "texture", "perimeter", "area", "smoothness",
             "compactness", "concavity", "concave_points", "symmetry",
             "fractal_dimension")

nombres_columnas <- c("id", "diagnosis",
                      paste0(medidas, "_mean"),
                      paste0(medidas, "_se"),
                      paste0(medidas, "_worst"))

urls_uci <- c(
  "https://archive.ics.uci.edu/ml/machine-learning-databases/breast-cancer-wisconsin/wdbc.data",
  "http://archive.ics.uci.edu/ml/machine-learning-databases/breast-cancer-wisconsin/wdbc.data"
)

descargar_de_uci <- function(urls, nombres) {
  for (url in urls) {
    datos <- tryCatch(
      read.csv(url, header = FALSE, col.names = nombres),
      error = function(e) NULL,
      warning = function(w) NULL
    )
    if (!is.null(datos) && nrow(datos) > 0) {
      message("Datos descargados de UCI.")
      return(datos)
    }
  }
  NULL
}

obtener_de_mclust <- function(nombres) {
  if (!requireNamespace("mclust", quietly = TRUE)) {
    stop("No se pudo descargar de UCI y el paquete mclust no está instalado.\n",
         "Instálalo con: install.packages(\"mclust\")")
  }
  message("Descarga no disponible; se usa la copia incluida en mclust.")
  wdbc <- mclust::wdbc
  datos <- as.data.frame(wdbc)
  names(datos) <- nombres[seq_along(names(datos))]
  datos
}

# ---- Ejecución -------------------------------------------------------------

if (!dir.exists("data")) dir.create("data")

datos <- descargar_de_uci(urls_uci, nombres_columnas)
if (is.null(datos)) datos <- obtener_de_mclust(nombres_columnas)

# La columna id no aporta información al análisis
datos$id <- NULL

# El análisis espera el diagnóstico como B (benigno) o M (maligno)
datos$diagnosis <- factor(datos$diagnosis, levels = c("B", "M"))

stopifnot(nrow(datos) == 569, ncol(datos) == 31, !anyNA(datos$diagnosis))

write.table(datos, destino, row.names = FALSE, quote = FALSE, sep = " ")

message("Archivo creado en ", destino, " (", nrow(datos), " casos, ",
        ncol(datos), " variables).")
