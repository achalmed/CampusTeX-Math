---
tipo: doc
titulo: "Preguntas frecuentes y solución de problemas"
estado: activo
---
# Preguntas frecuentes y solución de problemas

## Compilación

### «Option clash for package unicode-math»

Un `main.tex` está recargando `fontspec`/`unicode-math`. El núcleo ya los
carga: borra esos `\usepackage` del curso. (Fue el bug histórico que rompía
4 de 5 cursos — `docs/auditoria.md`.)

### «Undefined control sequence \square» (u otro símbolo amssymb)

unicode-math renombra símbolos de amssymb. Alias ya provistos: `\square`.
Para otros: buscar el nombre unicode-math (p. ej. `\blacklozenge` →
`\mdlgblklozenge`) o añadir un alias en `core/math.tex`.

### «CampusTeX: define \NombreCurso en el main.tex…»

Error intencional del framework: falta `\newcommand{\NombreCurso}{…}` antes
de `\input{../../core/preamble}` (§B del main.tex).

### El PDF no refleja mis cambios de índice o referencias

Falta la segunda pasada. `./scripts/build-course.sh <curso>` ya hace las
dos (o usa latexmk, que decide solo).

### «Improper alphabetic constant» en un título de sección

Hay math (`$...$`) en un `\section{}` y hyperref no puede convertirlo a
marcador PDF. Envolver: `\texorpdfstring{$\subset$}{⊂}`.

### Compilo desde la raíz y todo falla

Compila **siempre desde la carpeta del curso** (`courses/<curso>/`): las
rutas `\input{../../core/preamble}` dependen del directorio actual. Los
scripts lo hacen automáticamente.

## Scripts

### «Permission denied» al ejecutar un script

```bash
chmod +x scripts/*.sh
```

### `watch.sh` consume CPU / no detecta cambios

Instala `inotify-tools` (`sudo apt install inotify-tools`); sin él, el
script sondea cada 2 s.

### ¿Cómo cambio academia/docente/ciclo para TODOS los cursos?

`config/project.tex` — un solo archivo. Un curso individual puede
sobreescribir cualquier valor en su §B (`courses/trigonometria/main.tex`
es el ejemplo vivo).

## Contenido

### ¿Puedo compilar una semana suelta sin el libro?

No — los módulos no tienen preámbulo. Comenta todos los `\include` del
main.tex menos los de tu semana: esa es la compilación "de una semana".

### ¿Dónde pongo imágenes?

`assets/images/` (o `assets/logos/`): ya están en `\graphicspath`, así que
`\includegraphics{mi_figura}` funciona sin ruta.

### ¿Qué pasa con los documentos de `legacy/`?

Son los documentos standalone previos al framework (estilo pdflatex).
Compilan por sí solos con su propio preámbulo y NO usan el núcleo. No crear
material nuevo ahí.
