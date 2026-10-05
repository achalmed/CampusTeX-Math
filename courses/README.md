---
tipo: readme
estado: activo
---
# courses/ — el contenido académico: un libro por curso, una carpeta por semana

Es dueña de lo que escribe el docente y de nada más: aquí no se define un color, una caja, un
paquete global ni una fuente. Todo eso vive en `core/` y en `config/`. Las carpetas se crean
con `scripts/new-course.sh` y `scripts/new-week.sh`, nunca a mano: los nombres y la estructura
son un contrato que `scripts/doctor.sh` comprueba.

## Estructura

| ruta | qué es | dueño / generador |
|---|---|---|
| `<curso>/main.tex` | el libro: metadatos del curso en la §B, macros propios en la §D y los `\include` de las semanas | `scripts/new-course.sh`; el docente activa semanas |
| `<curso>/portada_libro.tex` · `<curso>/indice.tex` | portada e índice temático del curso | `scripts/new-course.sh` |
| `<curso>/main.pdf` | el libro compilado; **sí se versiona** (material entregable) | `scripts/build-course.sh` |
| `<curso>/estado.yml` | el estado del curso cuando no es `activo`; lo lee `scripts/stats.sh` | a mano |
| `<curso>/semana_NN_tema/` | la unidad de contenido: `teoria.tex`, `ejercicios.tex`, `resueltos.tex` | `scripts/new-week.sh`; el docente escribe |
| `<curso>/examen*/` | un examen suelto, fuera del libro | a mano (`docs/examenes.md`) |

## Reglas

- **Carpeta de semana:** `semana_NN_tema`, dos dígitos, minúsculas, guion bajo, sin tildes. Una
  carpeta que no sea `semana_NN_…` ni empiece por `examen` produce una advertencia del doctor.
- **Los tres módulos no compilan solos:** son fragmentos sin preámbulo y solo existen dentro del
  `main.tex`. «Compilar una semana» es dejar descomentados solo sus `\include`; los `\include`
  comentados son el interruptor, y es el flujo normal.
- **Nunca `\usepackage` ni `\definecolor` dentro de un módulo de semana**, y nunca `$$ … $$`:
  matemática exhibida con `\[ … \]` o `align*`. Lo comprueba `scripts/doctor.sh`.
- La composición de una semana —cuántos ejercicios y de qué niveles— está escrita una sola vez,
  en `docs/escribir-una-semana.md`.
- **Un curso sin semanas no es un curso abandonado:** se declara en su `estado.yml` con el
  vocabulario de `meta/docs/historial/NORMATIVA_ARCHIVOS.md` §2.1 (`en_espera`, `borrador`, `archivado`…), y
  el motivo se anota en `docs/decisiones.md`. Sin `estado.yml`, un curso se considera `activo`.

## Límite honesto

Esta carpeta no guarda nada de los alumnos: ni listas, ni notas, ni asistencia. El remoto es
público. El registro del dictado —quién, cuándo, con qué resultado— es competencia de
`10 Class`, no de CampusTeX.
