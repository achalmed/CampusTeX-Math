#!/usr/bin/env bash
# =====================================================================
#  build-course.sh — Compila el libro completo de UN curso
#
#  Uso:
#    ./scripts/build-course.sh algebra
#    ./scripts/build-course.sh algebra --clean   (limpia auxiliares después)
#
#  Usa latexmk si está instalado; si no, dos pasadas de lualatex.
# =====================================================================
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/lib/common.sh"

usage() {
    cat <<EOF
Uso: $(basename "$0") <curso> [--clean]

Cursos disponibles:
$(list_courses | sed 's/^/  /')
EOF
}

main() {
    [[ $# -ge 1 ]] || { usage >&2; exit 2; }
    [[ "$1" != "-h" && "$1" != "--help" ]] || { usage; exit 0; }

    local course=$1
    local clean_after=false
    [[ "${2:-}" != "--clean" ]] || clean_after=true

    local course_path
    course_path=$(course_dir "$course")

    compile_course "$course_path" || exit 1

    if $clean_after; then
        "${PROJECT_ROOT}/scripts/clean.sh" >/dev/null
        log_info "Auxiliares eliminados."
    fi
}

main "$@"
