---
tipo: doc
titulo: "Instalación"
estado: activo
---
# Instalación

Cómo dejar listo el equipo para compilar los libros de CampusTeX y comprobar que funciona.

## Requisitos

| Requisito                                   | Mínimo | Verificación         |
| ------------------------------------------- | ------ | -------------------- |
| TeX Live (con LuaLaTeX)                     | 2023+  | `lualatex --version` |
| Bash                                        | 4.x    | `bash --version`     |
| GNU Make _(opcional, para `make`)_          | —      | `make --version`     |
| latexmk _(opcional, mejora la compilación)_ | —      | `latexmk --version`  |
| inotify-tools _(opcional, para `watch`)_    | —      | `inotifywait --help` |

```bash
# Ubuntu / Debian
sudo apt install texlive-full

# macOS (Homebrew)
brew install --cask mactex

# Windows
# MiKTeX (https://miktex.org/) + Git Bash o WSL para los scripts
```

> Los scripts detectan qué herramientas opcionales existen y se adaptan:
> sin `latexmk` compilan con dos pasadas de `lualatex`; sin `inotifywait`,
> `watch.sh` sondea cambios cada 2 segundos.

## Fuentes tipográficas

Los defectos los fija `core/fonts.tex` y un curso puede cambiarlos en su `main.tex`
(`docs/arquitectura.md`, §Override de fuentes por curso). Están en TeX Live Full; con una
instalación básica: `tlmgr install <paquete>`.

| Fuente | Uso | Paquete |
| --- | --- | --- |
| Libertinus Serif, Libertinus Math | serif y matemática por defecto | `libertinus-fonts` |
| Libertinus Sans | sans-serif por defecto | `libertinus-fonts` |
| InconsolataN | monoespaciada por defecto | `inconsolata` |
| EB Garamond | serif del curso de economía | `ebgaramond` |

## Primer uso

```bash
# desde la raíz del repositorio (la carpeta 11 Book del espacio de trabajo)

# 1. Personaliza la identidad global (academia, docente, ciclo)
$EDITOR config/project.tex

# 2. Compila un curso para verificar la instalación
./scripts/build-course.sh aritmetica
#    o equivalente:  make aritmetica

# 3. Diagnóstico completo
./scripts/doctor.sh
```

El PDF queda en `courses/aritmetica/main.pdf`.
