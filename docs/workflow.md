---
tipo: doc
titulo: "Flujo de trabajo del docente"
estado: activo
---
# Flujo de trabajo del docente

## Ciclo semanal típico

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

## Compilar solo la semana en curso

En el `main.tex`, deja descomentados **solo** los `\include` de la semana
que estás trabajando — el resto comentados. Esto acelera la compilación y
es el flujo normal. Para el libro completo, descomenta todas las semanas
escritas.

## Convenciones de contenido

- Carpeta: `semana_NN_nombre_del_tema` (dos dígitos, minúsculas, guiones
  bajos, sin tildes).
- Módulos sin preámbulo: `teoria.tex`, `ejercicios.tex`, `resueltos.tex`
  no compilan solos; solo via `main.tex`.
- Matemática exhibida: `\[ ... \]` o `align*` — **nunca** `$$ ... $$`.
- Cada ejercicio: `\ejercicio` + enunciado, `alternativas` con exactamente
  5 `\item`, `\vspace{0.3cm}`, y su respuesta en la clave al pie.
- 15 ejercicios por semana: 5 básicos, 5 intermedios, 5 avanzados.
- Colores y cajas: SOLO los del núcleo (`core/colors.tex`, `core/boxes.tex`).
  Nunca `\definecolor` en un módulo de contenido.

## Estructura pedagógica de cada módulo

La plantilla de `templates/week/` ya trae el esqueleto:

- **teoria.tex**: portada de clase → motivación → definiciones (cajadef) →
  propiedades (cajaprop) → fórmulas (cajaformula) → casos especiales →
  errores comunes (cajaadvert) → 3 ejemplos (cajaejemplo) → resumen + tip.
- **ejercicios.tex**: instrucciones → 3 niveles × 5 ejercicios en 2
  columnas → clave de respuestas.
- **resueltos.tex**: por ejercicio: enunciado (problema) → tema/método →
  análisis → desarrollo `align*` → respuesta final (cajarespuesta).

## Exámenes

```bash
mkdir courses/aritmetica/examen_mensual_01
cp templates/exam/examen.tex courses/aritmetica/examen_mensual_01/
$EDITOR courses/aritmetica/examen_mensual_01/examen.tex   # reemplaza {{CURSO}}
cd courses/aritmetica/examen_mensual_01 && lualatex examen.tex
```

El examen usa clase `article` con el mismo núcleo (colores, cajas,
alternativas idénticas al libro).
