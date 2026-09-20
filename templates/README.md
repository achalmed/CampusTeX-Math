---
tipo: readme
estado: activo
---
# templates/ — las plantillas de curso, semana y examen, con sus marcadores `{{NOMBRE}}`

Es dueña de la **forma inicial** de cada cosa que se crea: qué archivos aparecen, con qué
esqueleto pedagógico y con qué marcadores por rellenar. Los sustituye la función
`render_template` de `scripts/lib/common.sh`, que recibe pares `CLAVE=valor`. El detalle de
cada marcador está en `docs/templates.md`.

## Estructura

| carpeta | la usa | genera |
|---|---|---|
| `course/` | `scripts/new-course.sh` | `main.tex` (§B metadatos, §D macros propios, `\include` de semanas), `portada_libro.tex`, `indice.tex` |
| `week/` | `scripts/new-week.sh` | `teoria.tex`, `ejercicios.tex`, `resueltos.tex` con la estructura pedagógica completa como esqueleto comentado |
| `exam/` | nadie: se copia a mano | `examen.tex`, clase `article` sobre el mismo núcleo (`docs/examenes.md`) |

`templates/week/ejercicios.tex` es, además, la fuente de la regla de composición de una semana:
15 ejercicios en tres niveles y cinco alternativas por ejercicio. Si esa regla cambiara, cambia
aquí primero y después en `docs/workflow.md`.

## Reglas

- **Una plantilla estructura contenido; no define nada.** Ni colores, ni cajas, ni paquetes:
  todo eso es del núcleo. Una plantilla que carga un paquete es un error.
- Marcador nuevo: se añade el par `CLAVE=valor` en la llamada a `render_template` del script
  que la usa, o no se rellenará nunca.
- Se prueba generando un curso o una semana de prueba, compilando, y borrando después.

## Límite honesto

Las plantillas no se versionan por separado ni tienen compatibilidad hacia atrás: un curso
creado hace meses no se actualiza cuando la plantilla cambia. Y `exam/` no tiene script: sus
marcadores se sustituyen a mano hasta que exista un `new-exam.sh` en `scripts/`
(pendiente fechado en `docs/decisiones.md`).
