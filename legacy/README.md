---
tipo: readme
estado: activo
---
# legacy/ — los 22 documentos anteriores al framework: autocontenidos, intocables, nunca se borran

Es dueña de la frontera entre lo que había **antes** de CampusTeX y el framework actual. Son 22
documentos standalone (2,6 MB, un `.tex` y su `.pdf` cada uno) escritos al estilo pdfLaTeX,
con su propio preámbulo: **no usan `core/`** y compilan por sí solos, exactamente como el día
que se escribieron.

## Las tres reglas

1. **Nunca se borran.** Son material didáctico ya impartido; el PDF es su prueba.
2. **Nunca se crea material nuevo aquí.** Todo lo nuevo nace en `courses/` con
   `scripts/new-course.sh` o `scripts/new-week.sh`.
3. **Nunca se les enchufa el núcleo.** Son autocontenidos por definición: cargar `core/` en uno
   de ellos lo rompería y borraría la razón de que esta carpeta exista.

Migrarlos al framework es trabajo editorial, no técnico, y no está planificado ni automatizado
(decisión de 2026-07-05, registrada en `docs/decisiones.md`). `scripts/doctor.sh` y
`scripts/migracion/normalizar-cabeceras.py` la excluyen a propósito.

## Estructura

| carpeta | qué contiene |
|---|---|
| `algebra/` | 5 documentos de CEBA: potenciación, polinomios, productos notables, factorización, fracciones |
| `aritmetica/` | 8 conjuntos de ejercicios y clases (lógica, conjuntos, edades, MCD, racionales, promedios, regla de tres, numeración) |
| `fisica/` | la sesión 01 |
| `plantillas/` | los dos moldes de examen de la época previa: `con_alternativas/` y `sin_alternativas/` |

## Límite honesto

No hay índice, metadatos ni catálogo de estos documentos: el nombre de la carpeta es toda la
descripción que tienen, y así se queda. Si alguno hiciera falta en el material vigente, se
reescribe como una semana en `courses/`; el original no se toca.
