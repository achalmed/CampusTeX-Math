---
tipo: readme
estado: activo
---
# scripts/ — la automatización de CampusTeX: crear, compilar, vigilar, limpiar, diagnosticar, medir

Es dueña de toda la lógica ejecutable del framework. El `Makefile` de la raíz es una fachada
de conveniencia: **delega, nunca duplica**. Y los scripts son delgados porque
`scripts/lib/common.sh` es la única fuente de logging, detección de la raíz, descubrimiento de
cursos, sustitución de plantillas y compilación. La referencia de uso, con argumentos y
códigos de salida, está en `docs/comandos.md`.

## Estructura

| archivo | qué hace |
|---|---|
| `lib/common.sh` | la librería compartida: logging, `PROJECT_ROOT`, `list_courses`, `render_template`, `compile_course` |
| `new-course.sh` | crea `courses/<slug>/` desde `templates/course/` |
| `new-week.sh` | crea `semana_NN_tema/` con los tres módulos e imprime su bloque `\include` |
| `build-course.sh` | compila un curso (latexmk o dos pasadas de lualatex) |
| `build-all.sh` | compila todos y resume; sale 1 si alguno falla |
| `watch.sh` | recompila al guardar (inotify, o sondeo cada 2 s si no está instalado) |
| `clean.sh` | borra auxiliares de LaTeX; nunca PDF ni fuentes |
| `doctor.sh` | diagnóstico: semanas incompletas, `\include` rotos, convenciones, integridad del núcleo y la normativa de archivos del ecosistema |
| `stats.sh` | estadísticas de contenido; con `--update-readme` reescribe el bloque STATS del `README.md` |
| `migracion/` | herramientas de un solo uso, fuera del ciclo normal |

## Reglas para un script nuevo

- `source lib/common.sh`, `set -euo pipefail`, ayuda con `-h`/`--help`, mensajes en español.
- Ningún logger propio, ninguna detección de raíz propia, ninguna lógica de compilación
  propia: todo eso lo da `lib/common.sh`.
- Se documenta en `docs/comandos.md` y, si tiene equivalente cómodo, en el `Makefile`.
- Códigos de salida: 0 éxito, 1 error de ejecución, 2 error de argumentos.
- Se comprueba con `bash -n scripts/*.sh scripts/lib/*.sh` antes de nada.
- Si es de un solo uso —una migración—, va a `migracion/` y no a esta carpeta.

## Límite honesto

No hay pruebas automáticas de estos scripts: se verifican con `bash -n`, corriéndolos y mirando
el resultado. `doctor.sh` avisa, no arregla. Armar un examen es el único flujo manual del
repositorio (`docs/examenes.md`). Solo `new-course.sh`, `new-week.sh` y `build-course.sh` tienen
ayuda con `-h`; los demás no la analizan (`docs/comandos.md`).
