# Arquitectura

## Visión

CampusTeX es un **framework de publicación educativa** en LuaLaTeX: separa
el _contenido académico_ (courses/) del _sistema editorial_ (core/, config/,
templates/) y de la _automatización_ (scripts/, Makefile).

```
CampusTeX-Preuniversitario/
├── core/               ← Núcleo: preámbulo modular (13 módulos)
│   └── preamble.tex    ← Cargador; documenta el orden de carga
├── config/
│   └── project.tex     ← Identidad global: academia, docente, ciclo
├── courses/            ← SOLO contenido académico
│   └── <curso>/
│       ├── main.tex            ← metadatos §B + \include de semanas
│       ├── portada_libro.tex
│       ├── indice.tex
│       └── semana_NN_tema/     ← teoria / ejercicios / resueltos .tex
├── templates/          ← Plantillas de curso, semana y examen
├── scripts/            ← Automatización (lib/common.sh compartida)
├── assets/             ← Recursos gráficos (registrados en \graphicspath)
├── legacy/             ← Documentos standalone antiguos (intactos)
├── docs/               ← Esta documentación
├── Makefile            ← Fachada sobre scripts/
└── .latexmkrc          ← Config de latexmk (opcional)
```

## El núcleo (core/)

`core/preamble.tex` es un **cargador**: cada módulo tiene una única
responsabilidad y el orden de carga está documentado línea a línea.

| Módulo           | Responsabilidad                                      | Dependencia de orden                                                |
| ---------------- | ---------------------------------------------------- | ------------------------------------------------------------------- |
| `layout.tex`     | geometry, multicol                                   | —                                                                   |
| `math.tex`       | amsmath → mathtools → unicode-math + alias `\square` | unicode-math SIEMPRE al final del bloque math; NUNCA cargar amssymb |
| `fonts.tex`      | Selección de familias (con override por curso)       | después de math (necesita unicode-math)                             |
| `colors.tex`     | Paleta de 13 colores — única fuente de verdad        | antes de todo lo que colorea                                        |
| `boxes.tex`      | 8 cajas tcolorbox pedagógicas                        | necesita colors                                                     |
| `headers.tex`    | fancyhdr                                             | usa `\NombreCurso`                                                  |
| `sections.tex`   | titlesec (guarda `\ifcsname c@chapter`)              | —                                                                   |
| `lists.tex`      | enumitem + lista `alternativas` A–E                  | —                                                                   |
| `tables.tex`     | booktabs, tabularx, multirow                         | —                                                                   |
| `graphics.tex`   | tikz, pgfplots + `\graphicspath` → assets/           | —                                                                   |
| `links.tex`      | hyperref + metadatos PDF automáticos                 | después de unicode-math y titlesec                                  |
| `typography.tex` | microtype, setspace, parskip                         | —                                                                   |
| `macros.tex`     | `\ejercicio`, `\portadaclase`                        | necesita colors y tikz                                              |

### Regla de rutas

`\input` resuelve rutas **relativas al directorio de compilación**
(la carpeta del curso), no al archivo que invoca. Por eso el cargador usa
`\providecommand{\CoreDir}{../../core}`: un documento a otra profundidad
(p. ej. un examen en `courses/<curso>/examen_01/`) redefine `\CoreDir`
antes de cargar el preámbulo.

## Sistema de configuración (precedencia)

1. `\newcommand` en el `main.tex` del curso (§B, antes del preámbulo) — **gana**.
2. `config/project.tex` — defaults globales vía `\providecommand`.
3. Defaults del framework (`core/fonts.tex`).

El preámbulo **falla temprano** con mensaje claro si `\NombreCurso` no está
definido.

### Override de fuentes por curso

```latex
% en el main.tex del curso, ANTES del preámbulo:
\newcommand{\FuenteSerif}        {EB Garamond}
\newcommand{\OpcionesFuenteSerif}{Numbers=OldStyle}
```

(Economía es el ejemplo vivo.)

## Decisiones de diseño

- **Config en TeX, no YAML/TOML**: LaTeX no lee YAML sin herramientas
  externas; `config/project.tex` funciona con una instalación TeX pura.
  Una capa YAML → TeX generada por script queda como evolución futura
  (ver `docs/development.md`).
- **`\include` comentados como interruptores**: compilar solo la semana en
  curso es el flujo normal del docente; los comentarios son el mecanismo
  más simple y visible.
- **`legacy/` intocado**: los documentos standalone antiguos (estilo
  pdflatex) compilan por sí solos; migrarlos al framework es trabajo
  editorial, no técnico, y no se hace automáticamente.

## Escalabilidad

La arquitectura no cambia con el crecimiento: un curso nuevo es una carpeta
en `courses/` (creada por `new-course.sh`); una semana nueva es una carpeta
dentro del curso (`new-week.sh`). 20 cursos × 50 semanas no requieren tocar
`core/` ni `scripts/`. Varias academias = varios `config/project.tex`
alternativos (parámetro futuro de `build-course.sh`).
