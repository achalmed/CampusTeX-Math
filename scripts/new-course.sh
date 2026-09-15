#!/usr/bin/env bash
# =====================================================================
#  new-course.sh — Crea un curso nuevo desde templates/course/
#
#  Uso:
#    ./scripts/new-course.sh "Geometría"
#    ./scripts/new-course.sh "Razonamiento Matemático"
#
#  Genera courses/<slug>/ con main.tex, portada_libro.tex e indice.tex
#  listos para compilar. Las semanas se agregan con new-week.sh.
# =====================================================================
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/lib/common.sh"

readonly TEMPLATE_DIR="${PROJECT_ROOT}/templates/course"

usage() {
    cat <<EOF
Uso: $(basename "$0") "<Nombre del Curso>"

Crea courses/<slug>/ desde la plantilla, listo para compilar.

Ejemplos:
  $(basename "$0") "Geometría"
  $(basename "$0") "Razonamiento Matemático"
EOF
}

main() {
    [[ $# -eq 1 && -n "$1" ]] || { usage >&2; exit 2; }
    [[ "$1" != "-h" && "$1" != "--help" ]] || { usage; exit 0; }

    local course_name=$1
    local slug course_upper course_dir_path
    slug=$(slugify "$course_name")
    [[ -n "$slug" ]] || die "El nombre '$course_name' no produce un identificador válido."
    course_upper=$(printf '%s' "$course_name" | tr '[:lower:]áéíóúñ' '[:upper:]ÁÉÍÓÚÑ')
    course_dir_path="${COURSES_DIR}/${slug}"

    [[ ! -e "$course_dir_path" ]] || die "Ya existe ${course_dir_path} — no se sobreescribe."
    [[ -d "$TEMPLATE_DIR" ]] || die "No se encontró la plantilla en ${TEMPLATE_DIR}."

    mkdir -p "$course_dir_path"
    local file
    for file in main.tex portada_libro.tex indice.tex; do
        render_template "${TEMPLATE_DIR}/${file}" "${course_dir_path}/${file}" \
            "CURSO=${course_name}" \
            "CURSO_MAYUS=${course_upper}" \
            "SLUG=${slug}"
        log_ok "creado courses/${slug}/${file}"
    done

    log_ok "Curso '${course_name}' creado."
    log_info "Siguientes pasos:"
    log_info "  1. Agrega la primera semana:  ./scripts/new-week.sh ${slug} 01 nombre_del_tema"
    log_info "  2. Compila el libro:          ./scripts/build-course.sh ${slug}"
}

main "$@"
