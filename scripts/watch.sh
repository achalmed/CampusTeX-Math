#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════
#  watch.sh — Recompila un curso automáticamente al guardar cambios
#
#  Uso:
#    ./scripts/watch.sh algebra        (Ctrl+C para salir)
#
#  Usa inotifywait si está instalado (paquete inotify-tools); si no,
#  cae a un sondeo por mtime cada 2 segundos, que funciona en
#  cualquier sistema POSIX.
# ══════════════════════════════════════════════════════════════════
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/lib/common.sh"

readonly POLL_SECONDS=2

# newest_mtime()
# Imprime el mtime más reciente entre los .tex del curso y del núcleo.
# Arguments: $1 - carpeta del curso
newest_mtime() {
    find "$1" "${PROJECT_ROOT}/core" "${PROJECT_ROOT}/config" \
        -name '*.tex' -printf '%T@\n' 2>/dev/null | sort -rn | head -1
}

watch_with_inotify() {
    local dir=$1
    log_info "Vigilando cambios con inotifywait (Ctrl+C para salir)…"
    while inotifywait -q -r -e close_write,move,create \
            --include '.*\.tex$' \
            "$dir" "${PROJECT_ROOT}/core" "${PROJECT_ROOT}/config" >/dev/null; do
        compile_course "$dir" || true
    done
}

watch_with_polling() {
    local dir=$1
    local last_seen now
    last_seen=$(newest_mtime "$dir")
    log_info "inotifywait no está instalado — sondeando cada ${POLL_SECONDS}s (Ctrl+C para salir)…"
    while sleep "$POLL_SECONDS"; do
        now=$(newest_mtime "$dir")
        if [[ "$now" != "$last_seen" ]]; then
            last_seen=$now
            compile_course "$dir" || true
        fi
    done
}

main() {
    [[ $# -eq 1 ]] || { printf 'Uso: %s <curso>\n' "$(basename "$0")" >&2; exit 2; }
    local course_path
    course_path=$(course_dir "$1")

    compile_course "$course_path" || true
    if command -v inotifywait >/dev/null 2>&1; then
        watch_with_inotify "$course_path"
    else
        watch_with_polling "$course_path"
    fi
}

main "$@"
