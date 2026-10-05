---
tipo: doc
titulo: "Referencia de comandos"
estado: activo
---
# Referencia de comandos

## Scripts (`scripts/`)

Se ejecutan desde cualquier directorio. Solo `new-course.sh`, `new-week.sh` y `build-course.sh`
muestran ayuda con `-h`/`--help`; los demás no analizan esa opción (`clean.sh -h` limpia,
`build-all.sh -h` compila, `watch.sh -h` la toma por un curso), así que su uso es el de esta tabla.

| Script            | Uso                                                   | Qué hace                                                                   |
| ----------------- | ----------------------------------------------------- | -------------------------------------------------------------------------- |
| `new-course.sh`   | `./scripts/new-course.sh "Geometría"`                 | Crea `courses/<slug>/` con main, portada e índice listos                |
| `new-week.sh`     | `./scripts/new-week.sh algebra 05 productos_notables` | Crea la carpeta de semana con los 3 módulos e imprime el bloque `\include`; `--list` lista los cursos |
| `build-course.sh` | `./scripts/build-course.sh algebra [--clean]`         | Compila el libro de un curso (latexmk o 2× lualatex)                       |
| `build-all.sh`    | `./scripts/build-all.sh`                              | Compila todos los cursos y resume; exit 1 si alguno falla                  |
| `watch.sh`        | `./scripts/watch.sh algebra`                          | Recompila al guardar (inotify o sondeo)                                    |
| `clean.sh`        | `./scripts/clean.sh [--dry-run \| -n]`                | Borra auxiliares LaTeX; nunca PDFs ni fuentes                              |
| `doctor.sh`       | `./scripts/doctor.sh`                                 | Diagnóstico: módulos faltantes, includes rotos, convenciones               |
| `stats.sh`        | `./scripts/stats.sh [--update-readme]`                | Estadísticas de contenido; actualiza el README entre marcadores            |

## Herramientas de un solo uso (`scripts/migracion/`)

No forman parte del ciclo normal y no tienen objetivo en el Makefile.

| Script | Qué hizo |
| ------ | -------- |
| `scripts/migracion/normalizar-cabeceras.py` | Normalizó cabeceras de identidad, separadores ASCII y frontmatter de `docs/` según `meta/docs/historial/NORMATIVA_ARCHIVOS.md`. Simula por defecto; `--aplicar` escribe |

## Makefile (equivalentes)

```bash
make               # compila todos los cursos (= make all)
make algebra       # compila un curso
make watch-algebra # recompila al guardar
make clean         # limpia auxiliares
make doctor        # diagnóstico
make stats         # estadísticas
make help          # ayuda
```

## Compilación manual (sin scripts)

```bash
cd courses/algebra
lualatex main.tex && lualatex main.tex        # dos pasadas: TOC + refs
# o con latexmk:
latexmk -r ../../.latexmkrc main.tex
```

Reglas: **siempre LuaLaTeX** (nunca pdflatex/xelatex), **siempre desde la
carpeta del curso** (las rutas `\input{../../core/...}` dependen de ello).

## Comandos LaTeX del framework

| Comando / entorno                                                                                         | Uso                                       |
| --------------------------------------------------------------------------------------------------------- | ----------------------------------------- |
| `\ejercicio`                                                                                              | Numera un ejercicio (contador por unidad) |
| `\begin{alternativas}`                                                                                    | Lista A–E de examen                       |
| `\portadaclase{Tema}{Semana}{N}{Unidad}`                                                                  | Portada TikZ de clase                     |
| `cajadef`, `cajaprop`, `cajaejemplo`, `cajatip`, `cajaadvert`, `cajarespuesta`, `cajaformula`, `problema` | Cajas pedagógicas (`core/boxes.tex`)            |

## Códigos de salida de los scripts

| Código | Significado                                                      |
| ------ | ---------------------------------------------------------------- |
| 0      | Éxito                                                            |
| 1      | Error de ejecución (compilación fallida, validación con errores) |
| 2      | Error de argumentos / uso                                        |
