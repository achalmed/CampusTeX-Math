---
tipo: readme
estado: activo
---
# config/ — la identidad del proyecto: el único archivo que se edita para cambiar todos los cursos

Es dueña de los valores que cambian de una academia a otra o de un ciclo a otro —nombre de la
academia, del docente, ciclo, versión del material— y de nada más. `meta/workspace.yml` declara
`config/project.tex` como la **fuente de verdad** de este repositorio.

## Estructura

| archivo | de qué es dueño |
|---|---|
| `project.tex` | `\NombreAcademia`, `\NombreDocente`, `\CicloActual`, `\VersionMaterial` y el gancho para redefinir el color de acento |

## Cómo funciona la precedencia

Los valores se declaran con `\providecommand`, que **no** pisa una definición previa. De ahí el
orden, de mayor a menor autoridad:

1. `\newcommand` en la §B del `main.tex` del curso, antes de cargar el preámbulo — gana.
2. `config/project.tex` — los defectos globales de este proyecto.
3. `core/fonts.tex` — los defectos del framework.

`courses/trigonometria/main.tex` es el ejemplo vivo de override de identidad y
`courses/economia/main.tex` el de override de fuente (EB Garamond).

`\NombreCurso` **no** va aquí: es inherentemente propio de cada curso y se define en su
`main.tex`. El preámbulo aborta con un mensaje de CampusTeX si falta.

## Límite honesto

Es LaTeX, no YAML: no lo leen las herramientas del ecosistema. Fue una decisión —LaTeX no lee
YAML sin herramientas externas y el proyecto debe funcionar con una instalación TeX pura—, y
una capa `project.yml` junto a `config/project.tex` generada a TeX sigue siendo un pendiente registrado en
`docs/decisiones.md`. Tampoco hay perfiles múltiples: un solo `project.tex` por repositorio.
