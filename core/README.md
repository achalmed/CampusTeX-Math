---
tipo: readme
estado: activo
---
# core/ — el núcleo de CampusTeX: el preámbulo modular que da forma a todo lo que se compila

Es dueña de **cómo se ve y cómo se comporta** un documento del framework: tipografía, paleta,
cajas pedagógicas, cabeceras, listas, tablas, gráficos, enlaces y macros. Nada de esto se
define en `courses/`, en `templates/` ni en un examen: aquí, y solo aquí.

`preamble.tex` es un **cargador**, no un preámbulo monolítico: carga módulos de una sola
responsabilidad cada uno, y el orden importa. Está documentado línea a línea dentro del propio
archivo; las dependencias que no se pueden romper son: `unicode-math` siempre al final del
bloque de matemática, `fonts` después de `math`, `boxes` después de `colors`, `links` después
de `unicode-math` y `titlesec`. La tabla módulo a módulo está en `docs/arquitectura.md`.

## Estructura

| archivo | de qué es dueño |
|---|---|
| `preamble.tex` | el cargador: valida `\NombreCurso`, fija `\CoreDir`/`\ConfigDir` y carga los módulos en orden |
| `layout.tex` | geometría de página y `multicol` |
| `math.tex` | `amsmath` → `mathtools` → `unicode-math`, y los alias de símbolos renombrados (`\square`) |
| `fonts.tex` | familias tipográficas y los defectos que un curso puede sobreescribir |
| `colors.tex` | la paleta: única fuente de verdad de los colores |
| `boxes.tex` | las cajas `tcolorbox` pedagógicas |
| `headers.tex` | cabeceras y pies (`fancyhdr`), que usan `\NombreCurso` |
| `sections.tex` | títulos de sección (`titlesec`) |
| `lists.tex` | `enumitem` y la lista `alternativas` A–E |
| `tables.tex` | `booktabs`, `tabularx`, `multirow` |
| `graphics.tex` | `tikz`, `pgfplots` y el `\graphicspath` hacia `assets/` |
| `links.tex` | `hyperref` y los metadatos del PDF |
| `typography.tex` | `microtype`, `setspace`, `parskip` |
| `macros.tex` | `\ejercicio` y `\portadaclase` |

## Reglas

- **Ningún valor editable se escribe aquí.** Academia, docente y ciclo van a `config/`; lo
  propio de un curso, a la §D de su `main.tex`.
- **`\input` resuelve rutas contra el directorio de compilación**, no contra el archivo que
  invoca: por eso todo se carga vía `\CoreDir`, y un documento a otra profundidad —un examen—
  redefine `\CoreDir` antes de cargar el preámbulo.
- **Nunca `amssymb`.** Colisiona con `unicode-math`, que el núcleo ya carga con opciones.
- Tras **cualquier** cambio en esta carpeta: `./scripts/build-all.sh`, y todos los cursos deben
  compilar. Es la regla que `docs/desarrollo.md` desarrolla.

## Límite honesto

El núcleo no sabe nada del contenido: no valida cuántos ejercicios tiene una semana ni si la
teoría está completa (eso lo mira `scripts/doctor.sh`). Y no es una capa compartida con el
resto del ecosistema: `10 Class` y `03 writing` tienen la suya, y este núcleo es deliberadamente
autocontenido para que un libro compile con una instalación TeX pura.
