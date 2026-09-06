# 📚 CampusTeX-Preuniversitario

> Framework profesional en **LuaLaTeX** para generar libros, separatas y
> exámenes de academias preuniversitarias peruanas — al nivel editorial de
> Aduni, Pamer, Trilce, CEPRE UNI y Lumbreras. El docente **solo escribe el
> contenido**: diseño, tipografía, cajas pedagógicas y automatización ya
> están resueltos.

![Motor](https://img.shields.io/badge/motor-LuaLaTeX-orange?style=flat-square)
![Arquitectura](https://img.shields.io/badge/arquitectura-modular-blue?style=flat-square)
![Idioma](https://img.shields.io/badge/idioma-español-red?style=flat-square)
![Licencia](https://img.shields.io/badge/licencia-MIT-lightgrey?style=flat-square)

## 🚀 Inicio rápido

```bash
# Personaliza academia, docente y ciclo (UN solo archivo para todo)
$EDITOR config/project.tex

# Compila un curso
make aritmetica              # o: ./scripts/build-course.sh aritmetica

# Crea un curso nuevo, listo para escribir
./scripts/new-course.sh "Geometría"

# Crea una semana nueva dentro de un curso
./scripts/new-week.sh geometria 01 triangulos_notables

# Recompila automáticamente mientras escribes
make watch-geometria
```

## 📊 Estado del contenido

<!-- STATS:START — generado por scripts/stats.sh, no editar a mano -->

| Curso         | Semanas | Módulos escritos | Ejercicios | PDF |
| ------------- | :-----: | :--------------: | :--------: | :-: |
| algebra       |    0    |        0         |     0      |  ✓  |
| aritmetica    |   31    |        9         |     45     |  ✓  |
| economia      |    0    |        0         |     0      |  ✓  |
| fisica        |    0    |        0         |     0      |  ✓  |
| trigonometria |    1    |        2         |     20     |  ✓  |

**Totales:** 5 cursos · 32 semanas · 65 ejercicios · 5 PDF (131 páginas)

_Actualizado: 2026-07-05 por `scripts/stats.sh`_

<!-- STATS:END -->

## 🗂️ Estructura

```
core/       Núcleo del framework: preámbulo modular (13 módulos)
config/     Identidad global: academia, docente, ciclo
courses/    Contenido académico: un libro por curso, semanas modulares
templates/  Plantillas de curso, semana y examen
scripts/    Automatización (crear, compilar, validar, medir)
assets/     Recursos gráficos
legacy/     Documentos standalone previos al framework (intactos)
docs/       Documentación completa
```

## 📖 Documentación

| Documento                                    | Contenido                                             |
| -------------------------------------------- | ----------------------------------------------------- |
| [docs/installation.md](docs/installation.md) | Requisitos, fuentes, primer uso                       |
| [docs/workflow.md](docs/workflow.md)         | Flujo semanal del docente y convenciones de contenido |
| [docs/commands.md](docs/commands.md)         | Referencia de todos los scripts y comandos            |
| [docs/architecture.md](docs/architecture.md) | Diseño del framework y decisiones técnicas            |
| [docs/templates.md](docs/templates.md)       | Sistema de plantillas y marcadores                    |
| [docs/development.md](docs/development.md)   | Guía para modificar el framework + hoja de ruta       |
| [docs/contributing.md](docs/contributing.md) | Cómo contribuir contenido o código                    |
| [docs/faq.md](docs/faq.md)                   | Errores comunes y su solución                         |
| [docs/auditoria.md](docs/auditoria.md)       | Auditoría que originó la reestructuración             |

## ✏️ Chuleta del docente

Cajas pedagógicas (definidas en `core/boxes.tex`, colores en `core/colors.tex`):
`cajadef` · `cajaprop` · `cajaejemplo` · `cajatip` · `cajaadvert` ·
`cajarespuesta` · `cajaformula` · `problema`

Cada ejercicio: `\ejercicio` + enunciado, `\begin{alternativas}` con 5
`\item`, respuesta en la clave. Math exhibida con `\[ \]` o `align*`
(nunca `$$`). Detalle completo: [docs/workflow.md](docs/workflow.md).

## 📜 Licencia

MIT — libre de usar, modificar y distribuir manteniendo el aviso de
copyright.

---

<div align="center">

**Hecho con ❤️ para la educación preuniversitaria del Perú**

`LuaLaTeX` · `TikZ` · `tcolorbox` · `pgfplots`

</div>
