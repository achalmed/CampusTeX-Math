---
tipo: guia_ia
estado: activo
---
# CLAUDE.md — 11 Book (repo `Academic_Book_Framework`, remoto `CampusTeX-Math`)

Guía para el asistente. En español, como todo el ecosistema. `AGENTS.md` es un enlace a este archivo.
Léase antes: `README.md` (qué es y cómo se usa), `docs/README.md` (índice), `config/project.tex`
(el manifiesto de este repo según `meta/workspace.yml`).

CampusTeX produce el **libro de curso** preuniversitario: la variante didáctica del tipo `libro`
de `prompts/00 metodo/ARQUITECTURA_DOCUMENTAL.md` §5.6, con esquema propio —semana = `teoria` ·
`ejercicios` · `resueltos`, exigido por `scripts/doctor.sh`—. Allí está registrado y no se
reespecifica. El libro general, no didáctico, es `\documentclass{libro}` de `03 writing`
(`03 writing/esquemas/libro.tex`). Todo —contenido, comentarios, docs y salida de los
scripts— va en español.

## Reglas que no se negocian

- **Nunca cargar `amssymb`, nunca recargar `fontspec` ni `unicode-math` en un curso.** El núcleo
  los carga, `unicode-math` con opciones; recargarlo produce *Option clash*, el bug que rompió 4
  de los 5 cursos antes de la reestructuración (`docs/faq.md`). `doctor.sh` lo comprueba.
- **Símbolos renombrados por `unicode-math`:** `\blacklozenge` → `\mdlgblklozenge`;
  `\square` tiene alias de compatibilidad en `core/math.tex`, y ahí van los que falten. La
  matemática dentro de un título de sección necesita `\texorpdfstring{$…$}{texto}`.
- **Matemática exhibida con `\[ … \]` o `align*`, nunca `$$ … $$`.** Cada ejercicio es
  `\ejercicio` + enunciado + `alternativas` con exactamente 5 `\item` + su clave; carpetas
  `semana_NN_tema` en minúsculas, con guion bajo y sin tildes. La regla completa de cuántos
  ejercicios lleva una semana está escrita una sola vez, en `docs/workflow.md`.
- **Precedencia de configuración, en este orden:** `\newcommand` del curso en `main.tex` §B
  (antes del preámbulo) → `config/project.tex` → defectos del framework en `core/fonts.tex`.
  Lo editable va a `config/`, nunca escrito a mano dentro de `core/`.
- **Colores y cajas se definen solo en `core/colors.tex` y `core/boxes.tex`.** Un paquete o macro
  de un curso concreto va en la §D de su `main.tex`; un paquete para todos, en el módulo de
  `core/` que le corresponda, respetando el orden de carga.
- **`legacy/` es intocable.** Son 22 documentos standalone previos al framework, autocontenidos,
  que **no** usan el núcleo: no se crea material nuevo ahí, no se migran y no se borran.
- **El Makefile delega, nunca duplica:** `scripts/lib/common.sh` es la única fuente de lógica
  Bash (logging, raíz, descubrimiento de cursos, compilación) y los scripts son delgados.
- **Los PDF finales sí se versionan** (`courses/*/main.pdf`, `legacy/*/document.pdf`): son
  material entregable a docentes. Los auxiliares de LaTeX y los `.xopp` de clase, no; el
  `.gitignore` explica cada decisión, incluida la variante corrupta `* synctex.gz`.
- **Compilar siempre con LuaLaTeX y siempre desde la carpeta del curso.** Nunca pdfLaTeX ni
  XeLaTeX.
- **Commits solo cuando se piden**, como en todo el workspace. El remoto es público: nada de
  datos personales de alumnos ni de una institución concreta entra aquí.

## Cómo se verifica un cambio

```bash
bash -n scripts/*.sh scripts/lib/*.sh          # sintaxis Bash antes de nada
./scripts/doctor.sh                            # salud del proyecto + normativa de archivos
./scripts/build-course.sh aritmetica --clean   # el curso con contenido, compilación limpia
./scripts/build-all.sh                         # obligatorio tras CUALQUIER cambio en core/
python3 ../core/archivos.py validar .          # NORMATIVA §11 y §15; lo llama doctor.sh
```

No hay suite de pruebas: correcto = compila limpio + `doctor.sh` pasa + el PDF se ve bien.

## Detalles que cuesta redescubrir

- **`\input` resuelve rutas contra el directorio de compilación, no contra el archivo que
  invoca.** Por eso se compila desde `courses/<curso>/` y el cargador usa
  `\providecommand{\CoreDir}{../../core}`: un documento a otra profundidad —un examen en
  `courses/<curso>/examen_01/`— redefine `\CoreDir` antes de cargar el preámbulo.
- **El preámbulo falla a propósito** con un mensaje de CampusTeX si el `main.tex` no definió
  `\NombreCurso` antes de `\input{../../core/preamble}`.
- **Los módulos de semana no compilan solos:** son fragmentos sin preámbulo. «Compilar una
  semana» es dejar descomentados solo sus `\include` en el `main.tex`; los `\include`
  comentados son el interruptor, y es el flujo normal del docente.
- **El orden de carga de `core/preamble.tex` importa** y está documentado línea a línea:
  `unicode-math` siempre al final del bloque de matemática; `fonts` después de `math`; `boxes`
  necesita `colors`; `links` después de `unicode-math` y `titlesec`.
- **Override de fuente por curso:** `courses/economia/main.tex` es el ejemplo vivo (EB Garamond
  con `Numbers=OldStyle`), y `courses/trigonometria/main.tex` el de override de identidad.
- **No usar caracteres Unicode decorativos en las opciones de `tcolorbox`:** el parser de
  pgfkeys los rompe.
- **`latexmk` se usa si está instalado, con `-r .latexmkrc`** porque no busca en directorios
  padre; si no está, los scripts caen a dos pasadas de `lualatex` (índice y referencias).
- **El bloque STATS del `README.md` es derivado:** se regenera con
  `./scripts/stats.sh --update-readme`, nunca a mano. Marca los cursos en espera leyendo
  `courses/<curso>/estado.yml`.
- **El flujo de exámenes es manual** (`templates/exam/examen.tex` copiado a mano): es el único
  sin script; está documentado en `docs/examenes.md`, y un `new-exam.sh` sigue pendiente.
- **`scripts/migracion/` guarda las herramientas de un solo uso** (la de M7, que normalizó las
  cabeceras): no son comandos operativos y no se ejecutan en el ciclo normal.

## Dónde está cada cosa

| busco | está en |
|---|---|
| qué es el proyecto y cómo se usa | `README.md` |
| índice de la documentación | `docs/README.md` (generado por `core/docs.py indice`) |
| instalar, fuentes tipográficas, primer uso | `docs/installation.md` |
| escribir una semana, convenciones de contenido | `docs/workflow.md` |
| scripts, objetivos del Makefile, comandos LaTeX | `docs/commands.md` |
| el núcleo, los 13 módulos, la precedencia | `docs/architecture.md` |
| plantillas y marcadores `{{NOMBRE}}` | `docs/templates.md` |
| modificar el framework, trampas de LuaLaTeX | `docs/development.md` |
| aportar contenido o código | `docs/contributing.md` |
| errores comunes con su causa | `docs/faq.md` |
| armar un examen | `docs/examenes.md` |
| por qué algo es así; pendientes fechados | `docs/decisiones.md` |
| qué cambió y cuándo | `CHANGELOG.md` |
| lo cumplido: la auditoría que originó todo | `docs/historial/` |
| qué es dueña cada carpeta | el `README.md` de esa carpeta |
