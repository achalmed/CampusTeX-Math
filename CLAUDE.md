# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

**CampusTeX** — a modular LuaLaTeX *framework* for producing Peruvian pre-university teaching material (course books, weekly handouts, exams) for Álgebra, Aritmética, Trigonometría, Física and Economía, taught by Edison Achalma at CEBA Santo Domingo. All content, comments, docs and CLI output are in **Spanish** — keep new content in Spanish.

This directory **is a git repository** (remote `achalmed/CampusTeX-Math`); the 2026-07 restructure was committed in September 2026. Commit only when asked, as everywhere else in the workspace.

[README.md](README.md) is the project cover; the real documentation lives in `docs/` ([architecture](docs/architecture.md), [workflow](docs/workflow.md), [commands](docs/commands.md), [development](docs/development.md), [faq](docs/faq.md)). [docs/auditoria.md](docs/auditoria.md) records the 2026-07 restructuring and the bugs it fixed.

## Commands

```bash
./scripts/build-course.sh <curso>        # compile one course (= make <curso>)
./scripts/build-all.sh                   # compile everything (= make all)
./scripts/new-course.sh "Geometría"      # scaffold a new course
./scripts/new-week.sh <curso> NN tema    # scaffold a week (3 modules); prints the \include block
./scripts/watch.sh <curso>               # recompile on save
./scripts/doctor.sh                      # project health checks (run before delivering)
./scripts/stats.sh [--update-readme]     # content statistics
./scripts/clean.sh [--dry-run]           # delete LaTeX aux files (never PDFs)
```

Compilation is **always LuaLaTeX** (never pdflatex/xelatex), **always from the course folder** (`courses/<curso>/`) because `\input{../../core/preamble}` is CWD-relative. Scripts handle this; manual: `lualatex main.tex` twice. `latexmk` is used if installed (`.latexmkrc` at root, passed via `-r`), otherwise scripts fall back to two lualatex passes. There is no test suite: correctness = compiles clean + `doctor.sh` passes + PDF looks right.

## Architecture

```
core/       preamble.tex = loader of 13 single-responsibility modules (load ORDER is
            documented inline and matters: math → fonts → colors → boxes → … → links)
config/     project.tex — global identity (academia/docente/ciclo) via \providecommand
courses/    content only: <curso>/main.tex (§B metadata + mostly-commented \include
            switches) + semana_NN_tema/{teoria,ejercicios,resueltos}.tex (preamble-less
            fragments, NOT standalone-compilable)
templates/  course/, week/, exam/ — {{MARCADOR}} placeholders filled by render_template
scripts/    thin scripts sourcing lib/common.sh (logging, root detection, compile logic)
assets/     graphics; images/ and logos/ are already on \graphicspath
legacy/     pre-framework standalone pdflatex-style documents — self-contained, do NOT
            use the core; never create new material there, never delete them
```

**Config precedence:** course `\newcommand` in main.tex §B (before the preamble input) → `config/project.tex` defaults → framework defaults in `core/fonts.tex`. Font override example lives in `courses/economia/main.tex` (EB Garamond). The preamble errors out early if `\NombreCurso` is undefined.

## Hard rules (violating these broke the project before — see docs/auditoria.md)

- **Never** load `amssymb`, and **never** re-load `fontspec`/`unicode-math` in a course: the core loads them (unicode-math with options → reloading causes *Option clash*, the bug that once broke 4 of 5 courses).
- unicode-math renames amssymb symbols: `\blacklozenge`→`\mdlgblklozenge`; `\square` has a compat alias in `core/math.tex`. Math in section titles needs `\texorpdfstring`.
- Colors/boxes are defined **only** in `core/colors.tex` / `core/boxes.tex`. Course-specific packages/macros go in main.tex §D; editable values go in `config/` — never hardcoded in `core/`.
- Content conventions: `\[ \]`/`align*` (never `$$`); each exercise = `\ejercicio` + `alternativas` with exactly 5 `\item` + answer key; folders `semana_NN_tema` (lowercase, underscores, no accents). `doctor.sh` enforces most of this.
- Makefile delegates to `scripts/`; `scripts/lib/common.sh` is the single source of Bash logic. Verify script changes with `bash -n`.
- After ANY change to `core/`, run `./scripts/build-all.sh` — all 5 courses must compile.
