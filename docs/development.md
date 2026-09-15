---
tipo: doc
titulo: "Guía de desarrollo del framework"
estado: activo
---
# Guía de desarrollo del framework

Para quien modifica el _sistema_ (core, scripts, plantillas), no el
contenido académico.

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
| Un script nuevo                    | `scripts/`, con `source lib/common.sh`, `set -euo pipefail`, ayuda `-h` y documentación en `docs/commands.md` |

## Trampas conocidas de LuaLaTeX + unicode-math

Documentadas en los comentarios de `core/math.tex` y `core/boxes.tex`:

- **Nunca** cargar `amssymb` (colisiona con unicode-math).
- **Nunca** recargar `unicode-math` con opciones (Option clash — fue el
  bug que rompía 4 de 5 cursos; ver `docs/auditoria.md`).
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

## Hoja de ruta (evolución futura)

- **Metadatos YAML → TeX**: `config/project.yml` + script generador, para
  integrarse con el ecosistema de `scripts_for_quarto`.
- **Exportación multi-formato**: HTML/EPUB vía tex4ht o pandoc; a largo
  plazo, puente a Quarto.
- **`new-course.sh --from-indice`**: generar las carpetas de semanas desde
  el índice temático del README.
- **CI/CD**: cuando el proyecto sea repositorio git, un workflow que
  ejecute `doctor.sh` + `build-all.sh` y publique los PDFs como artifacts
  (la estructura de scripts ya está pensada para eso: códigos de salida
  correctos y sin estado interactivo).
- **Perfiles de academia**: múltiples `config/<academia>.tex`
  seleccionables por flag en `build-course.sh`.
