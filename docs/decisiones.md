---
tipo: decision
titulo: "Decisiones y pendientes de CampusTeX"
estado: activo
---
# Decisiones y pendientes de CampusTeX

Registro acumulativo por tema (`meta/NORMATIVA_ARCHIVOS.md` §15.6): una entrada por decisión,
con su fecha y su porqué. Recoge la «Hoja de ruta» que hasta DOC4 vivía dentro de
`docs/development.md`, mezclada con instrucciones vigentes. Lo que aquí está como **pendiente**
lleva fecha y dueño; lo que está **decidido** no se vuelve a discutir sin anotar por qué.

## Configuración del proyecto

**Decidido (2026-07-05): la configuración se escribe en TeX, no en YAML ni TOML.**
LaTeX no lee YAML sin herramientas externas, y `config/project.tex` funciona con una instalación
TeX pura. La precedencia —`main.tex` §B del curso → `config/project.tex` → `core/fonts.tex`—
se resuelve con `\providecommand`, que es el mecanismo nativo.

**Pendiente (abierto desde 2026-07-05; dueño: Edison Achalma).** Una capa `project.yml` junto
a `config/project.tex`, generada a TeX por un script, para que la identidad del proyecto sea legible por las
herramientas del ecosistema como lo es `curso.yml` en `10 Class`. Hoy `meta/workspace.yml`
declara `config/project.tex` como la verdad de este repo; mientras no haya generador, sigue
siéndolo. El nombre del tooling del ecosistema es `scripts_quarto_studio` (se llamó
`scripts_for_quarto` hasta 2026; el remoto conserva el nombre antiguo).

## Salidas y formatos

**Decidido (2026-07-05): una sola salida, PDF por LuaLaTeX.**
Nunca pdfLaTeX ni XeLaTeX: el núcleo carga `unicode-math` y fuentes OpenType.

**Pendiente (abierto desde 2026-07-05; dueño: Edison Achalma).** Exportación multiformato
(HTML/EPUB vía tex4ht o pandoc) y, a largo plazo, un puente a Quarto. No hay fecha ni diseño:
mientras tanto el `README.md` lo declara como límite honesto, no como próxima característica.

## Contenido y estructura

**Decidido (2026-07-05): los `\include` comentados son el interruptor de semana.**
Compilar solo la semana en curso es el flujo normal del docente, y comentar líneas es el
mecanismo más simple y más visible que existe. No se añade un sistema de perfiles para esto.

**Decidido (2026-07-05): `legacy/` queda intacto.**
Migrar los 22 documentos standalone al framework es trabajo editorial, no técnico, y no se
automatiza. La regla —autocontenidos, no usan el núcleo, no se amplían, no se borran— vive
desde DOC4 dentro de la propia carpeta, en `legacy/README.md`.

**Decidido (2026-09-20, D11 del diagnóstico documental): `algebra`, `economia` y `fisica` están
`en_espera`, no abandonados.**
Tienen portada, índice y `main.tex` que compila, pero ninguna semana escrita. Cada uno lo
declara en `courses/<curso>/estado.yml` y `scripts/stats.sh` lo marca en el bloque STATS, para
que tres ceros en la portada no se lean como material perdido. Revisar al abrir el siguiente
ciclo de la academia; si para entonces no hay contenido, decidir entre escribirlos o retirar
la carpeta. Dueño: Edison Achalma.

**Pendiente (abierto desde 2026-07-05; dueño: Edison Achalma).**
`./scripts/new-course.sh --from-indice`: generar las carpetas de semanas desde el índice
temático del curso, en vez de una por una con `new-week.sh`.

## Automatización

**Decidido (2026-07-05): el Makefile delega, nunca duplica.**
`scripts/lib/common.sh` es la única fuente de lógica Bash; los scripts son delgados y el
Makefile es solo una fachada de conveniencia.

**Decidido (2026-09-20): las herramientas de un solo uso viven en `scripts/migracion/`.**
`scripts/migracion/normalizar-cabeceras.py`, de la fase M7, no es un comando operativo y no
aparece entre los ocho scripts del ciclo normal (`docs/commands.md`).

**Pendiente (abierto desde 2026-09-20; dueño: Edison Achalma).**
Un `new-exam.sh` en `scripts/`: hoy armar un examen es el único flujo manual del repo —copiar
`templates/exam/examen.tex` y sustituir los marcadores a mano— y queda fuera de `doctor.sh`.
El procedimiento está descrito en `docs/examenes.md`; el script haría con él lo que
`new-week.sh` hace con una semana.

**Pendiente (abierto desde 2026-07-05, reformulado el 2026-09-20; dueño: Edison Achalma).**
Integración continua. El proyecto **ya** es repositorio git con remoto público
(`achalmed/CampusTeX-Math` en GitHub, commits desde 2026-06-17), así que la condición
que bloqueaba este punto desapareció: falta decidir si un workflow que corra `doctor.sh` +
`build-all.sh` y publique los PDF como artifacts compensa, dado que los PDF finales ya se
versionan. Los scripts están preparados: códigos de salida correctos y nada interactivo.

**Pendiente (abierto desde 2026-07-05; dueño: Edison Achalma).**
Perfiles de academia: varios `config/<academia>.tex` seleccionables por opción de
`build-course.sh`, para reusar el mismo contenido con otra identidad institucional.

## Frontera con los otros sistemas del ecosistema

**Decidido (2026-09-11): el libro de curso se registra, no se reespecifica.**
`prompts/00 metodo/ARQUITECTURA_DOCUMENTAL.md` §5.6 es la taxonomía; el esquema —semana =
teoría · ejercicios · resueltos— es de este framework y lo exige `scripts/doctor.sh`. El libro
general, no didáctico, es `\documentclass{libro}` de `03 writing`.

**Decidido (2026-09-20): CampusTeX y `10 Class` siguen siendo dos sistemas.**
`10 Class` es el estándar de **dictado** (curso, sesión, sílabo, evaluación, registro de
alumnos) y consume la capa `sistema-editorial`; CampusTeX produce el **libro impreso** de una
academia preuniversitaria con núcleo propio y autocontenido. Comparten motor (LuaLaTeX) y
parecido en las cajas, pero no comparten núcleo: unificarlos obligaría a que el libro dependa
de la capa editorial y del manifiesto de curso, que es exactamente lo que este framework evita.
No se migran cajas ni estilos de uno a otro sin anotar aquí la razón.
