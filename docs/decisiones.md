---
tipo: decision
titulo: "Decisiones y pendientes de CampusTeX"
estado: activo
---
# Decisiones y pendientes de CampusTeX

Registro acumulativo por tema (`meta/docs/historial/NORMATIVA_ARCHIVOS.md` §15.6): una entrada por decisión,
con su fecha y su porqué. Lo **decidido** no se vuelve a discutir sin anotar aquí por qué; lo
abierto está en [§Pendientes](#pendientes), con fecha y dueño.

## Configuración del proyecto

**Decidido (2026-07-05): la configuración se escribe en TeX, no en YAML ni TOML.**
LaTeX no lee YAML sin herramientas externas, y `config/project.tex` funciona con una instalación
TeX pura. La precedencia —`main.tex` §B del curso → `config/project.tex` → `core/fonts.tex`—
se resuelve con `\providecommand`, que es el mecanismo nativo. `meta/workspace.yml` declara
`config/project.tex` como la verdad de este repo; una capa `project.yml` generada a TeX es un
pendiente.

## Salidas y formatos

**Decidido (2026-07-05): una sola salida, PDF por LuaLaTeX.**
Nunca pdfLaTeX ni XeLaTeX: el núcleo carga `unicode-math` y fuentes OpenType. La exportación a
otros formatos es un pendiente sin diseño; el `README.md` la declara como límite honesto, no
como próxima característica.

## Contenido y estructura

**Decidido (2026-07-05): los `\include` comentados son el interruptor de semana.**
Compilar solo la semana en curso es el flujo normal del docente, y comentar líneas es el
mecanismo más simple y más visible que existe. No se añade un sistema de perfiles para esto.

**Decidido (2026-07-05): `legacy/` queda intacto.**
Migrar los documentos standalone al framework es trabajo editorial, no técnico, y no se
automatiza. La regla —autocontenidos, no usan el núcleo, no se amplían, no se borran— vive
dentro de la propia carpeta, en `legacy/README.md`.

**Decidido (2026-09-20, D11 del diagnóstico documental): `algebra`, `economia` y `fisica` están
`en_espera`, no abandonados.**
Tienen portada, índice y `main.tex` que compila, pero ninguna semana escrita. Cada uno lo
declara en `courses/<curso>/estado.yml` y `scripts/stats.sh` lo marca en el bloque STATS, para
que tres ceros en la portada no se lean como material perdido. Su revisión está en §Pendientes.

## Automatización

**Decidido (2026-07-05): el Makefile delega, nunca duplica.**
`scripts/lib/common.sh` es la única fuente de lógica Bash; los scripts son delgados y el
Makefile es solo una fachada de conveniencia.

**Decidido (2026-09-20): las herramientas de un solo uso viven en `scripts/migracion/`.**
`scripts/migracion/normalizar-cabeceras.py` no es un comando operativo y no aparece entre los
scripts del ciclo normal (`docs/comandos.md`).

## Documentación

**Decidido (2026-10-04): `docs/` se nombra en español y cada documento tiene una función.**
Los documentos de `docs/` pasaron a nombres semánticos en español (`instalacion`,
`escribir-una-semana`, `comandos`, `plantillas`, `problemas-frecuentes`, `arquitectura`,
`desarrollo`), como en los demás frameworks del ecosistema (`meta/docs/historial/NORMATIVA_ARCHIVOS.md` §4 y
§15.11). La guía de contribución de `docs/` se retiró: el repo no acepta contribuciones de terceros y su
contenido vigente pasó a `docs/escribir-una-semana.md` y `docs/desarrollo.md`. `CHANGELOG.md`
se retiró: el framework no declara versión ni publica etiquetas, y lo que registraba está en el
historial de git y en `docs/historial/`. La regla de composición de una semana tiene un solo
dueño, `docs/escribir-una-semana.md`, y la implementa `templates/week/ejercicios.tex`.

## Frontera con los otros sistemas del ecosistema

**Decidido (2026-09-11): el libro de curso se registra, no se reespecifica.**
`prompts/00 metodo/ARQUITECTURA_DOCUMENTAL.md` lo registra en §4.2 (tipos rechazados: el libro
de curso no se duplica) y en §8.2 (qué hace cada sistema); el esquema —semana = teoría ·
ejercicios · resueltos— es de este framework y lo exige `scripts/doctor.sh`. El libro general,
no didáctico, es `\documentclass{libro}` de `03 writing`.

**Decidido (2026-09-20): CampusTeX y `10 Class` siguen siendo dos sistemas.**
`10 Class` es el estándar de **dictado** (curso, sesión, sílabo, evaluación, registro de
alumnos) y consume la capa `sistema-editorial`; CampusTeX produce el **libro impreso** de una
academia preuniversitaria con núcleo propio y autocontenido. Comparten motor (LuaLaTeX) y
parecido en las cajas, pero no comparten núcleo: unificarlos obligaría a que el libro dependa
de la capa editorial y del manifiesto de curso, que es exactamente lo que este framework evita.
No se migran cajas ni estilos de uno a otro sin anotar aquí la razón.

**Decidido (2026-09-15): del workspace solo se usa `core`.** `scripts/doctor.sh` carga
`core/env.sh` y llama a `core/archivos.py`; si no los encuentra, avisa y sigue. El contrato lo
mantiene el proveedor, en `core/docs/consumidores.md` del workspace.

## Pendientes

| abierto | pendiente | dueño |
|---|---|---|
| 2026-07-05 | Una capa `project.yml` junto a `config/project.tex`, generada a TeX por un script, para que la identidad sea legible por las herramientas del ecosistema como `curso.yml` en `10 Class`. | Edison Achalma |
| 2026-07-05 | Exportación multiformato (HTML/EPUB vía tex4ht o pandoc) y, a largo plazo, un puente a Quarto. Sin fecha ni diseño. | Edison Achalma |
| 2026-07-05 | `./scripts/new-course.sh --from-indice`: generar las carpetas de semanas desde el índice temático del curso. | Edison Achalma |
| 2026-07-05 | Perfiles de academia: varios `config/<academia>.tex` seleccionables por opción de `build-course.sh`. | Edison Achalma |
| 2026-07-05 | Integración continua: decidir si un workflow que corra `doctor.sh` + `build-all.sh` y publique los PDF como artifacts compensa, dado que los PDF finales ya se versionan. Los scripts ya tienen códigos de salida correctos y nada interactivo. | Edison Achalma |
| 2026-09-20 | Un `new-exam.sh` en `scripts/`: haría con un examen lo que `new-week.sh` hace con una semana (carpeta, marcadores con `render_template`, profundidad de `\CoreDir`). Hoy el procedimiento manual de `docs/examenes.md` es el oficial. | Edison Achalma |
| 2026-09-20 | Revisar `algebra`, `economia` y `fisica` al abrir el siguiente ciclo de la academia: escribirlos o retirar la carpeta. | Edison Achalma |
| 2026-10-04 | Alcance de la licencia: `LICENSE` (MIT) no distingue código y contenido. ¿Cubre `courses/`, `legacy/` y los PDF, o el contenido necesita otra licencia? | el autor |
| 2026-10-04 | `CLAUDE.md` prohíbe datos de una institución concreta en el repo público, y las portadas de dos cursos (`courses/aritmetica/main.tex`, `courses/trigonometria/main.tex`) nombran academias. ¿Se retiran esos nombres o se precisa la regla? | el autor |
| 2026-10-04 | ¿El framework va a publicar versiones (etiquetas o releases)? Si sí, vuelve `CHANGELOG.md` con SemVer. `\VersionMaterial` (`config/project.tex`) se define y ninguna plantilla la imprime: usarla o retirarla. | el autor |
| 2026-10-04 | El rótulo «repo Academic_Book_Framework» de la documentación anterior: ¿era el nombre antiguo en GitHub o solo un rótulo local? La documentación usa el remoto (`CampusTeX-Math`) y el id del ecosistema (`academic_book_framework`). | el autor |
| 2026-10-04 | El comentario de cabecera del `Makefile` dice «CampusTeX-Preuniversitario», nombre que ya no tiene el proyecto. | el autor |
| 2026-10-04 | `.directory` (icono de KDE) está versionado aunque el `.gitignore` lo excluye. | el autor |
| 2026-10-04 | Dos PDF anotados de Xournal++ con nombre fechado están versionados en `courses/aritmetica/` (aviso A07), cuando el `.gitignore` declara las anotaciones de clase como no versionadas. ¿Deben estar en git? | el autor |
| 2026-10-04 | `templates/week/ejercicios.tex` define en línea el estilo de la caja «Clave de Respuestas», contra la regla de que una plantilla no define cajas; `doctor.sh` solo vigila `\definecolor`. | el autor |
| 2026-10-04 | `build-all.sh`, `clean.sh`, `doctor.sh`, `stats.sh` y `watch.sh` no analizan `-h`/`--help`; `clean.sh -h` ejecuta la limpieza. | el autor |
| 2026-10-04 | `courses/economia/main.tex` pone un emoji en la opción `title` de una `tcolorbox`, lo que `CLAUDE.md` desaconseja (el PDF compila). | el autor |
