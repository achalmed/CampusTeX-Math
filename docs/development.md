---
tipo: doc
titulo: "Guía de desarrollo del framework"
estado: activo
---
# Guía de desarrollo del framework

Para quien modifica el _sistema_ (core, scripts, plantillas), no el
contenido académico. Dice cómo se modifica CampusTeX **hoy**; lo que
todavía no existe y por qué está en `docs/decisiones.md`.

## Principios

1. **El núcleo es la única fuente de verdad** de colores, cajas, fuentes y
   macros. Nada de eso se define en cursos ni módulos.
2. **`scripts/lib/common.sh` es la única fuente** de logging, detección de
   raíz, descubrimiento de cursos y compilación. Los scripts son delgados.
3. **El Makefile delega en scripts/** — nunca duplicar lógica en él.
4. **Incremental y verificado**: después de cada cambio al núcleo,
   compilar los 5 cursos (`./scripts/build-all.sh`). Nunca dejar el
   proyecto sin compilar.
5. **Compatibilidad**: el contenido académico existente no se toca salvo
   error de compilación demostrable.

## Dónde agregar cada cosa

| Quiero agregar…                    | Va en…                                                                                                        |
| ---------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| Un color                           | `core/colors.tex` (¿de verdad hace falta un 14.º color?)                                                      |
| Una caja nueva                     | `core/boxes.tex`                                                                                              |
| Un paquete para TODOS los cursos   | El módulo de core temáticamente correcto; respetar el orden de carga documentado en `core/preamble.tex`       |
| Un paquete/macro de UN curso       | `main.tex` del curso, sección §D                                                                              |
| Un valor editable (nombre, ciclo…) | `config/project.tex` (global) o §B del curso                                                                  |
| Un script nuevo                    | `scripts/`, con `source scripts/lib/common.sh`, `set -euo pipefail`, ayuda `-h` y documentación en `docs/commands.md` |
| Una herramienta de un solo uso     | `scripts/migracion/`, fuera del ciclo normal y fuera del Makefile                                             |

## Trampas conocidas de LuaLaTeX + unicode-math

Documentadas en los comentarios de `core/math.tex` y `core/boxes.tex`. La
narración de cada error, con su síntoma y su salida, está una sola vez, en
`docs/faq.md`; aquí queda la lista de lo que no se puede hacer:

- **Nunca** cargar `amssymb` (colisiona con unicode-math).
- **Nunca** recargar `unicode-math` con opciones: produce el *Option
  clash* que rompía 4 de 5 cursos antes de la reestructuración.
- Símbolos renombrados: `\blacklozenge` → `\mdlgblklozenge`; `\square` →
  `\mdlgwhtsquare` (el núcleo provee un alias de compatibilidad).
- Math en títulos de sección: envolver en
  `\texorpdfstring{$...$}{texto}` para los marcadores PDF.
- No usar caracteres Unicode decorativos en opciones de tcolorbox
  (el parser pgfkeys los rompe).

## Verificación

```bash
bash -n scripts/*.sh scripts/lib/*.sh   # sintaxis Bash
./scripts/doctor.sh                     # validación del proyecto
./scripts/build-all.sh                  # compilación completa
```

No hay suite de tests: la correctitud LaTeX se verifica compilando y
revisando el PDF.

## Trabajar con git

El repositorio existe desde el 2026-06-17 y su remoto es público
(`achalmed/CampusTeX-Math` en GitHub). Lo ordinario se confirma en
`main`; un cambio estructural del núcleo o de los scripts va en una rama
descriptiva y se fusiona cuando los cinco cursos compilan. Mensajes en
español, con la forma `<ámbito>: <qué cambia y por qué>`. Los PDF finales
se versionan a propósito; los auxiliares de LaTeX y los `.xopp` de clase,
no. El detalle del flujo está en `docs/contributing.md`.

## Hacia dónde va (y por qué no está aquí)

La hoja de ruta —capa YAML → TeX, exportación multiformato,
`new-course.sh --from-indice`, integración continua, perfiles de
academia— vive en `docs/decisiones.md`, con fecha y dueño por pendiente.
Este documento no la repite: lo caducado no debe contaminar lo normativo.
