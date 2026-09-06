#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════
#  clean.sh — Elimina los archivos auxiliares de compilación LaTeX
#
#  Uso:
#    ./scripts/clean.sh            → limpia todo el proyecto
#    ./scripts/clean.sh --dry-run  → muestra qué borraría, sin borrar
#
#  Nunca toca PDFs ni archivos fuente (.tex, .sh, .md).
# ══════════════════════════════════════════════════════════════════
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/lib/common.sh"

# Extensiones auxiliares que genera LuaLaTeX/latexmk.
# "* synctex.gz" (con espacio) es una variante corrupta detectada en
# la auditoría del proyecto — se incluye a propósito.
readonly AUX_PATTERNS=(
    "*.aux" "*.log" "*.toc" "*.out" "*.lof" "*.lot"
    "*.fls" "*.fdb_latexmk" "*.synctex.gz" "* synctex.gz"
    "*.bbl" "*.blg" "*.bcf" "*.run.xml" "*.nav" "*.snm" "*.vrb"
    "build.log"
)

DRY_RUN=false
[[ "${1:-}" == "--dry-run" || "${1:-}" == "-n" ]] && DRY_RUN=true

# build_find_args()
# Construye los argumentos -name/-o para find a partir de AUX_PATTERNS.
build_find_args() {
    local pattern first=true
    for pattern in "${AUX_PATTERNS[@]}"; do
        $first || printf -- '-o\n'
        printf -- '-name\n%s\n' "$pattern"
        first=false
    done
}

main() {
    local -a find_args
    mapfile -t find_args < <(build_find_args)

    local -a targets
    mapfile -t targets < <(find "$PROJECT_ROOT" -type f \( "${find_args[@]}" \) -not -path "*/.git/*")

    if [[ ${#targets[@]} -eq 0 ]]; then
        log_ok "El proyecto ya está limpio (0 auxiliares)."
        return 0
    fi

    local file
    for file in "${targets[@]}"; do
        if $DRY_RUN; then
            log_info "[dry-run] borraría: ${file#"$PROJECT_ROOT"/}"
        else
            rm -f "$file"
        fi
    done

    if $DRY_RUN; then
        log_ok "${#targets[@]} archivo(s) se borrarían (ninguno fue tocado)."
    else
        log_ok "${#targets[@]} archivo(s) auxiliares eliminados."
    fi
}

main "$@"
