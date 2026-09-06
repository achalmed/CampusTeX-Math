# assets/ — Recursos gráficos del framework

Separación estricta: los recursos gráficos viven aquí, nunca dentro de
`courses/` ni `core/`.

| Carpeta        | Contenido                                             | Cómo usarlo                                                                                            |
| -------------- | ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| `images/`      | Figuras e ilustraciones generales                     | `\includegraphics{figura}` — sin ruta: `core/graphics.tex` ya registra esta carpeta en `\graphicspath` |
| `logos/`       | Logotipos de la academia                              | `\includegraphics{logo_academia}` (también en `\graphicspath`)                                         |
| `tikz/`        | Figuras TikZ reutilizables (`.tex` con `tikzpicture`) | `\input{../../assets/tikz/figura}` desde un módulo                                                     |
| `icons/`       | Iconos para cajas o portadas                          | Igual que `images/` (agregar a `\graphicspath` si se usa mucho)                                        |
| `backgrounds/` | Fondos de portada                                     | Referenciar con ruta explícita desde la portada                                                        |
| `watermarks/`  | Marcas de agua (borrador, muestra…)                   | Referenciar con ruta explícita                                                                         |

Los `.gitkeep` existen solo para que las carpetas vacías sobrevivan al
control de versiones; se pueden borrar cuando la carpeta tenga contenido.
