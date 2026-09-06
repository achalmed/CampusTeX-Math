#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════
#  new-week.sh — Crea una semana (tema) nueva dentro de un curso
#
#  Uso:
#    ./scripts/new-week.sh algebra 05 productos_notables
#
#  Genera courses/<curso>/semana_NN_tema/{teoria,ejercicios,resueltos}.tex
#  desde templates/week/ y muestra el bloque \include listo para pegar
#  en el main.tex del curso.
#
#  NOTA: el bloque \include NO se inserta automáticamente en main.tex:
#  el punto de inserción (unidad/capítulo correcto) es una decisión
#  pedagógica del docente que un script no puede adivinar con seguridad.
# ══════════════════════════════════════════════════════════════════
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/lib/common.sh"

readonly TEMPLATE_DIR="${PROJECT_ROOT}/templates/week"

usage() {
    cat <<EOF
Uso: $(basename "$0") <curso> <NN> <nombre_del_tema>

  curso            curso existente (ver: $(basename "$0") --list)
  NN               número de semana, dos dígitos (01–99)
  nombre_del_tema  minúsculas y guiones bajos, sin tildes

Ejemplos:
  $(basename "$0") algebra 05 productos_notables
  $(basename "$0") aritmetica 31 sucesiones
EOF
}

main() {
    [[ "${1:-}" != "-h" && "${1:-}" != "--help" ]] || { usage; exit 0; }
    if [[ "${1:-}" == "--list" ]]; then list_courses; exit 0; fi
    [[ $# -eq 3 ]] || { usage >&2; exit 2; }

    local course=$1 week_number=$2 topic=$3

    # Validar entradas ANTES de crear nada
    local course_path
    course_path=$(course_dir "$course")
    [[ "$week_number" =~ ^[0-9]{2}$ ]] \
        || die "El número de semana debe ser de dos dígitos (ej. 05), recibí: '$week_number'"
    [[ "$topic" =~ ^[a-z0-9_]+$ ]] \
        || die "El tema debe ir en minúsculas con guiones bajos y sin tildes (ej. productos_notables), recibí: '$topic'"

    local folder="semana_${week_number}_${topic}"
    local week_dir="${course_path}/${folder}"
    [[ ! -e "$week_dir" ]] || die "Ya existe ${week_dir} — no se sobreescribe."
    [[ -d "$TEMPLATE_DIR" ]] || die "No se encontró la plantilla en ${TEMPLATE_DIR}."

    local topic_title
    topic_title=$(titlecase "$topic")

    mkdir -p "$week_dir"
    local file
    for file in teoria.tex ejercicios.tex resueltos.tex; do
        render_template "${TEMPLATE_DIR}/${file}" "${week_dir}/${file}" \
            "CARPETA=${folder}" \
            "NN=${week_number}" \
            "TEMA_TITULO=${topic_title}"
        log_ok "creado courses/${course}/${folder}/${file}"
    done

    log_ok "Semana ${week_number} (${topic_title}) creada en '${course}'."
    log_info "Pega este bloque en courses/${course}/main.tex, dentro de la unidad que corresponda:"
    cat <<EOF

% --- Semana ${week_number}: ${topic_title} ---
\\include{${folder}/teoria}
\\include{${folder}/ejercicios}
\\include{${folder}/resueltos}

EOF
}

main "$@"
