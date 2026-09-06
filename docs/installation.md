# Instalación

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

Incluidas en TeX Live Full; con instalación básica: `tlmgr install <paquete>`.

| Fuente                    | Uso                            | Paquete                     |
| ------------------------- | ------------------------------ | --------------------------- |
| TeX Gyre Pagella (+ Math) | Serif y matemática por defecto | `tex-gyre`, `tex-gyre-math` |
| EB Garamond               | Economía                       | `ebgaramond`                |
| Source Sans Pro           | Sans-serif                     | `sourcesanspro`             |
| JetBrains Mono            | Monoespaciada                  | `jetbrainsmono`             |

## Primer uso

```bash
cd CampusTeX-Preuniversitario

# 1. Personaliza la identidad global (academia, docente, ciclo)
$EDITOR config/project.tex

# 2. Compila un curso para verificar la instalación
./scripts/build-course.sh aritmetica
#    o equivalente:  make aritmetica

# 3. Diagnóstico completo
./scripts/doctor.sh
```

El PDF queda en `courses/aritmetica/main.pdf`.
