---
tipo: doc
titulo: "Modificar el framework"
estado: activo
---
# Modificar el framework

Para quien cambia el _sistema_ (núcleo, scripts, plantillas), no el contenido académico. Dice
dónde va cada cosa y cómo se comprueba un cambio; cómo funciona el núcleo está en
`docs/arquitectura.md`, y lo que todavía no existe, en `docs/decisiones.md` §Pendientes.

## Principios

1. **El núcleo es la única fuente de verdad** de colores, cajas, fuentes y
   macros. Nada de eso se define en cursos ni módulos.
2. **`scripts/lib/common.sh` es la única fuente** de logging, detección de
   raíz, descubrimiento de cursos y compilación. Los scripts son delgados.
3. **El Makefile delega en scripts/** — nunca duplicar lógica en él.
4. **Incremental y verificado**: después de cada cambio al núcleo,
   compilar todos los cursos (`./scripts/build-all.sh`) sin cambiar su
   apariencia, salvo que ese sea el objetivo declarado.
5. **Compatibilidad**: el contenido académico existente no se toca salvo
   error de compilación demostrable.

## Dónde agregar cada cosa

| Quiero agregar…                    | Va en…                                                                                                        |
| ---------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| Un color                           | `core/colors.tex` (antes, comprobar que ninguno de la paleta sirve)                                           |
| Una caja nueva                     | `core/boxes.tex`                                                                                              |
| Un paquete para TODOS los cursos   | El módulo de core temáticamente correcto; respetar el orden de carga documentado en `core/preamble.tex`       |
| Un paquete/macro de UN curso       | `main.tex` del curso, sección §D                                                                              |
| Un valor editable (nombre, ciclo…) | `config/project.tex` (global) o §B del curso                                                                  |
| Un script nuevo                    | `scripts/`, con las reglas de `scripts/README.md` y su fila en `docs/comandos.md`                             |
| Una herramienta de un solo uso     | `scripts/migracion/`, fuera del ciclo normal y fuera del Makefile                                             |

## Lo que no se puede hacer con LuaLaTeX + unicode-math

La lista de prohibiciones está en `CLAUDE.md` (§Reglas) y en los comentarios de
`core/math.tex` y `core/boxes.tex`; cada error, con su síntoma y su arreglo, en
`docs/problemas-frecuentes.md`. No se repite aquí.

## Estilo

- Contenido, comentarios y documentación en **español**; identificadores
  de código (funciones Bash, marcadores de plantilla) en el idioma ya
  usado por el archivo.
- Comentarios que expliquen el _por qué_ (las trampas de unicode-math en
  `core/math.tex` son el ejemplo a imitar).

## Verificación

```bash
bash -n scripts/*.sh scripts/lib/*.sh   # sintaxis Bash
./scripts/doctor.sh                     # validación del proyecto
./scripts/build-all.sh                  # compilación completa
```

No hay suite de tests: la correctitud LaTeX se verifica compilando y
revisando el PDF.

## Git

El remoto es público: `achalmed/CampusTeX-Math` en GitHub. Lo ordinario —una semana nueva, una
corrección— se confirma en `main`; un cambio estructural —el núcleo, los scripts, la
organización— va en una rama descriptiva y se fusiona cuando todos los cursos compilan.
Mensajes en español, con la forma `<ámbito>: <qué cambia y por qué>`. Antes de cualquier
commit: `./scripts/doctor.sh` y `./scripts/build-all.sh`. Los PDF finales se versionan a
propósito; los auxiliares de LaTeX y los `.xopp` de clase, no (el `.gitignore` lo explica
decisión por decisión).
