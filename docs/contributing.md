# Cómo contribuir

## Contribuir contenido académico (lo más valioso)

Un tema completo = `teoria.tex` + `ejercicios.tex` + `resueltos.tex` de una
semana. Requisitos:

- Matemáticamente correcto y verificado.
- Generado con `./scripts/new-week.sh` (estructura garantizada).
- Exactamente 15 ejercicios (5 básicos, 5 intermedios, 5 avanzados) con
  clave de respuestas completa.
- Compila sin errores: `./scripts/build-course.sh <curso>`.
- Pasa `./scripts/doctor.sh` sin errores nuevos.
- Respeta las convenciones de `docs/workflow.md` (nada de `$$`, 5
  alternativas por ejercicio, cajas del núcleo).

## Contribuir al framework

- Leer antes `docs/architecture.md` y `docs/development.md`.
- Un cambio al núcleo debe compilar los 5 cursos existentes sin
  modificar su apariencia (salvo que ese sea el objetivo declarado).
- Scripts nuevos: patrón de los existentes (`lib/common.sh`,
  `set -euo pipefail`, `--help`, mensajes en español).

## Estilo

- Contenido, comentarios y documentación en **español**; identificadores
  de código (funciones Bash, marcadores de plantilla) en el idioma ya
  usado por el archivo.
- Comentarios que expliquen el _por qué_ (las trampas de unicode-math en
  `core/math.tex` son el ejemplo a imitar).

## Flujo con git

El proyecto aún no es repositorio git (decisión del autor: se
inicializará manualmente). Cuando lo sea, el flujo previsto es el
estándar: rama descriptiva → cambios verificados → PR con descripción de
qué y por qué. El `.gitignore` ya está preparado.
