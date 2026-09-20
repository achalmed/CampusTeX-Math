---
tipo: doc
titulo: "Cómo contribuir"
estado: activo
---
# Cómo contribuir

## Contribuir contenido académico (lo más valioso)

Un tema completo = `teoria.tex` + `ejercicios.tex` + `resueltos.tex` de una
semana. Requisitos:

- Matemáticamente correcto y verificado.
- Generado con `./scripts/new-week.sh` (estructura garantizada).
- La composición de la semana tal y como la especifica `docs/workflow.md`
  (el único documento que la formula), con la clave completa al pie.
- Compila sin errores: `./scripts/build-course.sh <curso>`.
- Pasa `./scripts/doctor.sh` sin errores nuevos.
- Respeta las convenciones de `docs/workflow.md` (nada de `$$`, 5
  alternativas por ejercicio, cajas del núcleo).

## Contribuir al framework

- Leer antes `docs/architecture.md` y `docs/development.md`.
- Un cambio al núcleo debe compilar los 5 cursos existentes sin
  modificar su apariencia (salvo que ese sea el objetivo declarado).
- Scripts nuevos: patrón de los existentes (`scripts/lib/common.sh`,
  `set -euo pipefail`, `--help`, mensajes en español).

## Estilo

- Contenido, comentarios y documentación en **español**; identificadores
  de código (funciones Bash, marcadores de plantilla) en el idioma ya
  usado por el archivo.
- Comentarios que expliquen el _por qué_ (las trampas de unicode-math en
  `core/math.tex` son el ejemplo a imitar).

## Flujo con git

Este repositorio existe desde el 2026-06-17 y su remoto es público:
`achalmed/CampusTeX-Math` en GitHub. Lo ordinario —una semana nueva, una
corrección— se confirma en `main`, con mensajes en español que tienen
la forma `<ámbito>: <qué cambia y por qué>`; un cambio estructural —el
núcleo, los scripts, la organización— va en una rama descriptiva y se
fusiona cuando los cinco cursos compilan. Antes de cualquier commit:
`./scripts/doctor.sh` y `./scripts/build-all.sh`. Los PDF finales se
versionan a propósito; los auxiliares de LaTeX y los `.xopp` de clase, no
(el `.gitignore` lo explica decisión por decisión).
