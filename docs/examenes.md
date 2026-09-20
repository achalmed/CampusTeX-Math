---
tipo: doc
titulo: "Exámenes: armar uno desde la plantilla"
estado: activo
---
# Exámenes: armar uno desde la plantilla

Un examen es el único documento de CampusTeX que **no** tiene script: se arma copiando
`templates/exam/examen.tex` y sustituyendo sus marcadores a mano. Este documento describe el
procedimiento tal como es hoy, para que no haya que redescubrirlo leyendo la plantilla.

## Qué es un examen aquí

Un documento independiente, clase `article` —no `book`, como el libro de curso— que carga el
**mismo núcleo**: los colores de `core/colors.tex`, las cajas de `core/boxes.tex` y la lista
`alternativas` son idénticas a las del libro, de modo que la prueba se ve como el material con
el que el alumno estudió. No forma parte del libro: no se declara con `\include` en el
`main.tex` del curso y se compila por separado.

## Procedimiento

```bash
mkdir courses/aritmetica/examen_mensual_01                        # el nombre empieza por «examen»
cp templates/exam/examen.tex courses/aritmetica/examen_mensual_01/
$EDITOR courses/aritmetica/examen_mensual_01/examen.tex           # marcadores, cabecera y preguntas
cd courses/aritmetica/examen_mensual_01 && lualatex examen.tex    # desde la carpeta del examen
```

Qué hay que tocar en el `.tex` copiado:

| dónde | qué | por qué |
|---|---|---|
| `\newcommand{\NombreCurso}` | el marcador `{{CURSO}}` por el nombre real del curso | el preámbulo aborta si `\NombreCurso` no está definido |
| cabecera del documento | `{{CURSO_MAYUS}}` de la línea de identidad, duración | la plantilla no la rellena nadie: no hay `render_template` en este flujo |
| `\CoreDir` y `\ConfigDir` | solo si el examen no está a tres niveles de la raíz | `\input` resuelve rutas contra el directorio de compilación, no contra el archivo |
| bloque de preguntas | un `\ejercicio` + `alternativas` con 5 `\item` por pregunta | la misma convención que en `ejercicios.tex` (`docs/workflow.md`) |

La plantilla ya trae `\CoreDir` y `\ConfigDir` a tres niveles arriba, que es la
profundidad de `courses/<curso>/<examen>/`. Si el examen se guarda en otro sitio hay que
ajustarlos: es el error más frecuente de este flujo.

## Convenciones que sí comprueba el doctor

`scripts/doctor.sh` no valida el contenido del examen, pero sí el **nombre de su carpeta**:
dentro de un curso solo acepta `semana_NN_tema` y carpetas que empiecen por `examen`
(minúsculas, guiones bajos, sin tildes). Un `Examen Mensual 1/` produce una advertencia y rompe
los scripts que recorren el curso.

El PDF resultante se versiona, como todos los PDF finales del repo: es material entregable.

## Pendiente

**Un `new-exam.sh` en `scripts/` (abierto el 2026-09-20; dueño: Edison Achalma).** Haría con un examen
lo que `scripts/new-week.sh` hace con una semana: crear la carpeta con el nombre correcto,
rellenar `{{CURSO}}` y `{{CURSO_MAYUS}}` con `render_template` de `scripts/lib/common.sh` y
ajustar la profundidad de `\CoreDir`. Hasta que exista, este procedimiento manual es el flujo
oficial. La entrada del registro está en `docs/decisiones.md`.
