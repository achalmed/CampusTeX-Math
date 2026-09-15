#!/usr/bin/env bash
# =====================================================================
#  build-all.sh — Compila TODOS los cursos del proyecto
#
#  Uso:
#    ./scripts/build-all.sh
#
#  No se detiene en el primer fallo: compila todo y presenta un
#  resumen final, saliendo con código 1 si algún curso falló.
# =====================================================================
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/lib/common.sh"

main() {
    local -a passed=() failed=()
    local course

    while IFS= read -r course; do
        if compile_course "${COURSES_DIR}/${course}"; then
            passed+=("$course")
        else
            failed+=("$course")
        fi
    done < <(list_courses)

    printf '\n'
    log_info "═══════════ RESUMEN ═══════════"
    log_ok   "Compilados : ${#passed[@]} (${passed[*]:-—})"
    if [[ ${#failed[@]} -gt 0 ]]; then
        log_error "Fallaron   : ${#failed[@]} (${failed[*]})"
        exit 1
    fi
}

main "$@"
