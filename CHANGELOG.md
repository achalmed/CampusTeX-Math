---
tipo: changelog
estado: activo
---
# CHANGELOG — CampusTeX (`11 Book`, repo `Academic_Book_Framework`)

Cambios del **framework**, no del contenido académico de `courses/` (ese lo miden el bloque
STATS del `README.md` y el `git log`). Fechas ISO, lo más reciente arriba. Las razones de cada
decisión están en `docs/decisiones.md`; lo cumplido y fechado, en `docs/historial/`.

La versión del material —la que aparece en portadas y pies— es `\VersionMaterial` en
`config/project.tex`, hoy `2.0`, y se mueve con el contenido, no con el framework.

## 2026-09-20 — DOC4: documentación bajo la normativa

- `README.md` y `CLAUDE.md` reescritos según `meta/NORMATIVA_ARCHIVOS.md` §15: `README.md` con
  `Qué es · Uso · Estructura · Documentación · Límite honesto`, `CLAUDE.md` en español y sin
  duplicar `docs/architecture.md` ni `docs/commands.md`.
- Añadidos `LICENSE` (MIT, que el README prometía desde el principio), este `CHANGELOG.md`,
  `docs/decisiones.md`, `docs/examenes.md`, `docs/README.md` (generado) y un `README.md` por
  carpeta con dueño: `core/`, `config/`, `courses/`, `legacy/`, `scripts/`, `templates/`.
- `docs/auditoria.md` → `docs/historial/auditoria-2026-07-05.md`, con `estado: hecho`.
- `scripts/normalizar-cabeceras.py` → `scripts/migracion/`: es la herramienta de un solo uso de
  M7, no un comando operativo.
- Corregidos los desfases de `docs/`: el proyecto sí es repositorio git con remoto, la ruta real
  es `11 Book` (no `CampusTeX-Preuniversitario`) y el tooling del ecosistema se llama
  `scripts_quarto_studio`.
- `algebra`, `economia` y `fisica` declarados `en_espera` en `courses/<curso>/estado.yml`;
  `scripts/stats.sh` los marca en el bloque STATS (decisión D11 del diagnóstico documental).

## 2026-09-20 — DOC2: higiene documental

- Temporales y derivados fuera de git; `AGENTS.md` pasa a ser un enlace simbólico a `CLAUDE.md`
  (`meta/NORMATIVA_ARCHIVOS.md` §15.8).
- `courses/economia/main.pdf` recompilado.

## 2026-09-15 — M7: normativa de archivos

- Cabeceras de identidad, separadores de sección y frontmatter de `docs/` alineados con
  `meta/NORMATIVA_ARCHIVOS.md`; artefactos de compilación declarados en el `.gitignore`.
- `scripts/doctor.sh` incorpora la validación de la normativa llamando a `core/archivos.py` a
  través de `core/env.sh`, con el semáforo del doctor (0 sano · 1 avisos · 2 fallos).

## 2026-09-11 — Lugar en la arquitectura documental

- `CLAUDE.md` declara que el libro de curso es la variante didáctica del tipo `libro` de
  `prompts/00 metodo/ARQUITECTURA_DOCUMENTAL.md` §5.6, con esquema propio: semana = teoría ·
  ejercicios · resueltos.

## 2026-09-06 — Reestructuración CampusTeX (trabajo de 2026-07)

- Nace la arquitectura actual: `core/` (preámbulo modular de 13 módulos con orden de carga
  documentado), `config/project.tex` como identidad global, `courses/` solo con contenido,
  `templates/`, `scripts/` sobre `scripts/lib/common.sh`, `assets/`, `legacy/` y `docs/`.
- Se corrigen los bugs que impedían compilar: *Option clash* de `unicode-math` en cuatro cursos
  y `\square` sin alias en aritmética. Los cinco cursos compilan.
- `Makefile` y `.latexmkrc` como fachada: el Makefile delega en `scripts/`, nunca duplica.
- Origen y evidencia: `docs/historial/auditoria-2026-07-05.md`.

## 2026-06-17 — Primer commit

- Fuente LaTeX inicial y logo institucional del proyecto CampusTeX-Math, antes del framework.
