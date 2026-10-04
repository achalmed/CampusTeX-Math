---
tipo: doc
titulo: "Escribir una semana"
estado: activo
---
# Escribir una semana

Cómo crea, escribe y entrega el docente una semana de un libro de curso. Este documento es el
dueño de la **regla de composición** de una semana; `templates/week/ejercicios.tex` la
implementa, y si la regla cambia, cambian los dos en el mismo commit.

## Ciclo semanal

```bash
# 1. Crear la semana (carpeta + 3 módulos desde plantilla)
./scripts/new-week.sh aritmetica 31 sucesiones

# 2. Activar la semana: pegar en courses/aritmetica/main.tex el bloque
#    \include que imprime el script, en la unidad correspondiente.

# 3. Escribir el contenido en:
#    courses/aritmetica/semana_31_sucesiones/teoria.tex
#    courses/aritmetica/semana_31_sucesiones/ejercicios.tex
#    courses/aritmetica/semana_31_sucesiones/resueltos.tex

# 4. Compilar mientras escribes (recompila al guardar)
./scripts/watch.sh aritmetica     # o: make watch-aritmetica

# 5. Antes de entregar: diagnóstico + compilación limpia
./scripts/doctor.sh
./scripts/build-course.sh aritmetica --clean
```

`./scripts/new-week.sh --list` muestra los cursos existentes.

## Compilar solo la semana en curso

En el `main.tex`, deja descomentados **solo** los `\include` de la semana
que estás trabajando — el resto comentados. Esto acelera la compilación y
es el flujo normal. Para el libro completo, descomenta todas las semanas
escritas.

## Composición de una semana

- **15 ejercicios: 5 básicos, 5 intermedios y 5 avanzados (tipo admisión).**
- Cada ejercicio: `\ejercicio` + enunciado, `alternativas` con exactamente
  5 `\item`, `\vspace{0.3cm}`, y su respuesta en la clave al pie.
- La clave de respuestas completa cierra `ejercicios.tex`.

## Convenciones de contenido

- Carpeta: `semana_NN_nombre_del_tema` (dos dígitos, minúsculas, guiones
  bajos, sin tildes).
- Módulos sin preámbulo: `teoria.tex`, `ejercicios.tex`, `resueltos.tex`
  no compilan solos; solo vía `main.tex`.
- Matemática exhibida: `\[ ... \]` o `align*` — **nunca** `$$ ... $$`.
- Colores y cajas: SOLO los del núcleo (`core/colors.tex`, `core/boxes.tex`).
  Nunca `\definecolor` ni `\usepackage` en un módulo de contenido.

## Estructura pedagógica de cada módulo

La plantilla de `templates/week/` ya trae el esqueleto:

- **teoria.tex**: portada de clase → motivación → definiciones (cajadef) →
  propiedades (cajaprop) → fórmulas (cajaformula) → casos especiales →
  errores comunes (cajaadvert) → 3 ejemplos (cajaejemplo) → resumen + tip.
- **ejercicios.tex**: instrucciones → 3 niveles × 5 ejercicios en 2
  columnas → clave de respuestas.
- **resueltos.tex**: por ejercicio: enunciado (problema) → tema/método →
  análisis → desarrollo `align*` → respuesta final (cajarespuesta).

## Antes de entregar

Una semana está lista cuando:

- es matemáticamente correcta y está verificada;
- se creó con `./scripts/new-week.sh` (estructura garantizada);
- cumple la composición y las convenciones de arriba, con la clave completa;
- `./scripts/build-course.sh <curso>` compila sin errores;
- `./scripts/doctor.sh` no da errores nuevos.

## Exámenes

El examen no forma parte del libro y se arma a mano desde `templates/exam/`: el procedimiento
está en `docs/examenes.md`.
