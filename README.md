---
tipo: readme
estado: activo
---
# 11 Book/ — CampusTeX, libros de curso preuniversitario (remoto CampusTeX-Math)

## Qué es

CampusTeX es un framework LuaLaTeX para producir el material impreso de una academia
preuniversitaria peruana: libros de curso, separatas semanales y exámenes, al nivel editorial
de Aduni, Pamer, Trilce, CEPRE UNI o Lumbreras. Resuelve el problema de que el docente no
debería pelear con el diseño: la tipografía, la paleta, las cajas pedagógicas, la portada de
clase y la compilación ya están decididas en `core/`; en `courses/` solo se escribe contenido.

Un libro de curso es una serie de **semanas**, y cada semana son tres módulos: teoría,
ejercicios propuestos y ejercicios resueltos. Esa es la anatomía que `scripts/doctor.sh`
exige y la que distingue a este sistema de los otros del ecosistema.

**No es** un sistema de dictado ni de gestión académica: no hay sílabo, sesión, asistencia ni
alumnos (eso vive en `10 Class`), ni bibliografía, citas o aparato crítico (eso vive en
`03 writing`). Necesita una instalación TeX Live; del espacio de trabajo solo usa `core`
(entorno y validador de archivos, que llama `scripts/doctor.sh`), cuyo contrato con sus
consumidores mantiene el propio `core` en su documento de consumidores. La identidad del
proyecto (academia, docente, ciclo) es un archivo LaTeX, `config/project.tex`, declarado como
fuente de verdad en `meta/workspace.yml` (id `academic_book_framework`).

## Uso

```bash
$EDITOR config/project.tex                                 # academia, docente y ciclo: un solo archivo
make aritmetica                                            # compila un curso (= ./scripts/build-course.sh aritmetica)
make                                                       # compila todos los cursos
./scripts/new-course.sh "Geometría"                        # crea courses/geometria/ listo para escribir
./scripts/new-week.sh geometria 01 triangulos_notables     # crea la semana e imprime su bloque \include
make watch-aritmetica                                      # recompila al guardar
./scripts/doctor.sh                                        # diagnóstico antes de entregar
./scripts/stats.sh --update-readme                         # regenera el bloque STATS de abajo
```

Cada semana lleva una composición fija de ejercicios con cinco alternativas y su clave. La
regla la especifica `docs/escribir-una-semana.md` y la implementa
`templates/week/ejercicios.tex`; si cambia, cambian los dos en el mismo commit.

## Estado del contenido

<!-- STATS:START — generado por scripts/stats.sh, no editar a mano -->
| Curso | Semanas | Módulos escritos | Ejercicios | PDF |
| ----- | :-----: | :--------------: | :--------: | :-: |
| algebra _(en espera)_ | 0 | 0 | 0 | ✓ |
| aritmetica | 31 | 9 | 45 | ✓ |
| economia _(en espera)_ | 0 | 0 | 0 | ✓ |
| fisica _(en espera)_ | 0 | 0 | 0 | ✓ |
| trigonometria | 1 | 2 | 20 | ✓ |

**Totales:** 5 cursos · 32 semanas · 65 ejercicios · 5 PDF (131 páginas)

*Actualizado: 2026-09-20 por `scripts/stats.sh`*
<!-- STATS:END -->

Tres cursos están **en espera**, no abandonados: `algebra`, `economia` y `fisica` tienen su
portada, su índice y su `main.tex` compilando, pero ninguna semana escrita. Cada uno lo declara
en su `courses/<curso>/estado.yml`, que `scripts/stats.sh` lee para marcarlos en la tabla; el
motivo y la fecha de revisión están en `docs/decisiones.md`.

## Estructura

| carpeta | qué es | dueño / generador |
|---|---|---|
| `core/` | el núcleo: `preamble.tex` carga sus módulos en un orden que importa | a mano; nada de `courses/` lo redefine |
| `config/` | `project.tex`, identidad global por `\providecommand` | a mano; es la `verdad` del proyecto en `meta/workspace.yml` |
| `courses/` | contenido académico: un libro por curso, una carpeta por semana | `scripts/new-course.sh` y `scripts/new-week.sh`; el docente escribe dentro |
| `templates/` | plantillas de curso, semana y examen con marcadores `{{NOMBRE}}` | a mano; las rellena `render_template` de `scripts/lib/common.sh` |
| `scripts/` | automatización: crear, compilar, vigilar, limpiar, diagnosticar, medir | a mano; `scripts/migracion/` guarda lo de un solo uso |
| `assets/` | recursos gráficos; `images/` y `logos/` ya están en `\graphicspath` | a mano |
| `legacy/` | documentos standalone anteriores al framework; intactos | nadie: no se toca, no se amplía, no se borra |
| `docs/` | la documentación permanente | a mano; `docs/README.md` lo genera `core/docs.py indice` |

## Documentación

El índice completo, con tipo y estado de cada documento, está en `docs/README.md` (generado).
| para | documento |
|---|---|
| instalar y compilar por primera vez | `docs/instalacion.md` |
| escribir una semana | `docs/escribir-una-semana.md` |
| armar un examen | `docs/examenes.md` |
| consultar scripts, Makefile y macros | `docs/comandos.md` |
| consultar plantillas y marcadores | `docs/plantillas.md` |
| resolver un error | `docs/problemas-frecuentes.md` |
| entender el núcleo | `docs/arquitectura.md` |
| modificar el framework | `docs/desarrollo.md` |
| saber por qué algo es así y qué está pendiente | `docs/decisiones.md` |

Lo cumplido y fechado vive en `docs/historial/`.

## Límite honesto

- **Una sola salida: PDF por LuaLaTeX.** No exporta HTML ni EPUB, y no soporta pdfLaTeX ni
  XeLaTeX: el núcleo carga `unicode-math` y fuentes OpenType. Un puente a otros formatos sigue
  siendo una idea, no un compromiso (`docs/decisiones.md`).
- **No hay suite de pruebas.** La corrección se comprueba compilando: `./scripts/doctor.sh` sin
  errores, `./scripts/build-all.sh` completo y el PDF revisado a ojo.
- **No hay manifiesto legible por máquina** (`libro.yml` o equivalente): la identidad del
  proyecto está en LaTeX, `config/project.tex`. Fue una decisión, no un olvido: LaTeX no lee
  YAML sin herramientas externas y el proyecto debe funcionar con una instalación TeX pura.
- **No gestiona alumnos, notas ni asistencia**, ni produce contenido: escribir la teoría y los
  ejercicios sigue siendo trabajo del docente.
- **Los módulos de una semana no compilan solos:** son fragmentos sin preámbulo, solo existen
  dentro del `main.tex` de su curso.
- **`legacy/` no se migra automáticamente.** Convertir esos documentos al framework es
  trabajo editorial, no técnico, y no está planificado.
- **Licencia:** `LICENSE` es la licencia MIT, con copyright del autor, y no distingue entre el
  código y el contenido de `courses/` y `legacy/`. Si el contenido debe llevar otra licencia es
  una pregunta abierta en `docs/decisiones.md` §Pendientes.
- **No acepta contribuciones de terceros:** es un proyecto de un solo autor.
