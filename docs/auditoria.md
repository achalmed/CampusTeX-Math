---
tipo: doc
titulo: "🔍 Auditoría del proyecto CampusTeX-Preuniversitario"
estado: activo
---
# 🔍 Auditoría del proyecto CampusTeX-Preuniversitario

> **Fecha**: 2026-07-05 · **Fase**: 1 (auditoría automática, previa a la reestructuración)
> **Estado del proyecto al momento de la auditoría**: 267 archivos, 6.1 MB, sin control de versiones.

---

## 1. Resultado crítico: ningún curso compila

Compilación baseline con `lualatex -interaction=nonstopmode` (TeX Live 2025):

| Curso         | Resultado | Error                                                                                              |
| ------------- | --------- | -------------------------------------------------------------------------------------------------- |
| algebra       | ❌        | `Option clash for package unicode-math`                                                            |
| aritmetica    | ❌        | `Undefined control sequence \square` (`semana_01_01_leyes_logica_propocicional/resueltos.tex:371`) |
| trigonometria | ❌        | `Option clash for package unicode-math`                                                            |
| fisica        | ❌        | `Option clash for package unicode-math`                                                            |
| economia      | ❌        | `Option clash for package unicode-math`                                                            |

### Causa raíz del _option clash_ (4 cursos)

Cada `main.tex` carga en su sección §A:

```latex
\usepackage{fontspec}
\usepackage{unicode-math}          % ← sin opciones
...
\input{../preambulo_comun}         % ← lo recarga con [math-style=ISO, bold-style=ISO]
```

LaTeX prohíbe recargar un paquete con opciones distintas. Los PDF existentes
(`algebra/main.pdf`, `trigonometria/main.pdf`) se generaron con una versión
anterior del preámbulo; el estado actual del repositorio **no reproduce esos PDF**.

### Causa del error en aritmética

`\square` es un símbolo de `amssymb`; con `unicode-math` el nombre correcto es
`\mdlgwhtsquare`. El preámbulo prohíbe `amssymb` (documentado en §3) pero no
ofrece alias de compatibilidad.

Aritmética no sufre el _option clash_ porque es el único curso **sin** sección
de tipografía — lo que a su vez significa que compila con Latin Modern en vez
de TeX Gyre Pagella (inconsistencia tipográfica).

---

## 2. Código duplicado

| Duplicación                                                             | Ubicaciones                                                                                                                                                                                                       | Impacto                                                       |
| ----------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------- |
| Bloque de tipografía (`\setmainfont`…, 4–6 líneas)                      | `algebra`, `trigonometria`, `fisica`, `economia` (falta en `aritmetica`)                                                                                                                                          | Causa directa del _option clash_; 4 copias que mantener       |
| Carga de `fontspec` + `unicode-math`                                    | Cada `main.tex` §A **y** `preambulo_comun.tex` §1/§3                                                                                                                                                              | Redundante; fuente del clash                                  |
| Metadatos (`\NombreAcademia`, `\NombreDocente`, `\CicloActual`)         | 5 `main.tex` con valores divergentes: aritmética dice "CEBA SANTO DOMINGO / Anual 2026", álgebra dice "Academia Preuniversitaria / [Nombre del Docente] / Anual 2025"                                             | Editar la academia exige tocar 5 archivos                     |
| Bloque `\hypersetup{pdftitle…}`                                         | 5 `main.tex`, idéntico salvo el nombre del curso                                                                                                                                                                  | Plantilla repetida                                            |
| Preámbulo completo (~200 líneas)                                        | `aritmetica/semana_01_logica/main.tex` — libro autónomo pre-refactor que además usa `amssymb` (prohibido) y fuentes distintas (TeX Gyre Heros, DejaVu Sans Mono)                                                  | Segunda fuente de verdad del preámbulo; divergente            |
| Preámbulo standalone estilo pdflatex (`inputenc`, `babel`, `fancyhdr`…) | 14+ documentos: `plantilla con/sin alternativas/`, `algebra/ceba */document.tex` (×5), `aritmetica/ejercicios */document.tex` (×6), `fisica/sesion 1/`, `aritmetica/primara clase…/`, `aritmetica/5 Numeracion…/` | Sistema paralelo antiguo, cada uno con su copia del preámbulo |

## 3. Inconsistencias de nomenclatura y estructura

| Problema                                         | Detalle                                                                                                                                                                          |
| ------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Índice con nombre distinto                       | `trigonometria/indice_trigonometria.tex` (los demás: `indice.tex`)                                                                                                               |
| Carpetas fuera de la convención `semana_NN_tema` | `algebra/ceba *` (espacios), `aritmetica/ejercicios *`, `aritmetica/5 Numeracion-I-…`, `aritmetica/primara clase de virtual …` (espacios, mayúsculas, tildes), `fisica/sesion 1` |
| Doble numeración                                 | `semana_01_logica` **y** `semana_01_01_leyes_logica_propocicional` (además con typo: "propocicional" → proposicional)                                                            |
| `\NombreCurso` inconsistente                     | trigonometría: "Trigonometría y algebra" (minúscula, sin tilde)                                                                                                                  |
| Semanas incompletas                              | `trigonometria/semana_04_arcos` sin `teoria.tex`; `aritmetica/semana_01_logica` con `main.tex` espurio                                                                           |
| Archivos misceláneos                             | `.directory` (KDE) en la raíz; `*.xopp` (Xournal++) dentro de semanas — anotaciones, no código                                                                                   |

## 4. Archivos temporales versionables por error

**97 archivos auxiliares** de compilación regados por todo el árbol:
`*.aux` (30), `*.log` (23), `*.synctex.gz` (26, incluidas variantes corruptas
`document synctex.gz` **con espacio**), `*.fls` (4), `*.fdb_latexmk` (4),
`*.toc` (3), `*.out` (3). No existe `.gitignore` (el proyecto aún no es repo git).

Los PDF finales (26) **se conservan** por decisión del proyecto.

## 5. Lo que está bien (y se preserva)

- `preambulo_comun.tex` está impecablemente organizado en §1–§15 con
  comentarios que documentan _por qué_ (orden de unicode-math, nombres de
  símbolos, trampas de pgfkeys). Es la base natural de los módulos `core/`.
- La convención `semana_NN_tema/{teoria,ejercicios,resueltos}.tex` con módulos
  sin preámbulo es una arquitectura correcta de contenido.
- `aritmetica/crear_estructura.sh` demuestra la necesidad de un generador
  (`new-week.sh`) — se reemplaza por scripts generalizados.
- El README (581 líneas) es completo pero mezcla portada, manual y referencia
  → se divide en `docs/` (Fase 10).

## 6. Decisiones tomadas a partir de esta auditoría

1. **Tipografía al núcleo**: la selección de fuentes sale de los `main.tex` y
   entra a `core/fonts.tex` con mecanismo de _override_ por curso (economía
   conserva EB Garamond). Elimina el clash y la copia quíntuple.
2. **Alias de compatibilidad** `\square → \mdlgwhtsquare` en `core/math.tex`
   para que el contenido existente compile sin tocar los `.tex` académicos.
3. **Material antiguo a `legacy/`**: los documentos standalone estilo pdflatex
   se mueven intactos (compilan por sí solos, no referencian nada externo).
   No se elimina ningún contenido académico.
4. **Metadatos a `config/`**: un solo lugar para academia/docente/ciclo
   (global) + curso/fuentes (por curso).
5. `latexmk` **no está instalado** en este sistema: el Makefile y los scripts
   usan `latexmk` si existe y caen a doble pasada de `lualatex` si no.

---

_Informe generado automáticamente en la Fase 1 de la reestructuración._
