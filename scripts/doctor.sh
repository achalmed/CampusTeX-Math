#!/usr/bin/env bash
# =====================================================================
#  doctor.sh — Diagnóstico de salud del proyecto
#
#  Uso:
#    ./scripts/doctor.sh
#
#  Revisa, por curso y a nivel de proyecto:
#    • semanas incompletas (falta teoria/ejercicios/resueltos.tex)
#    • \include e \input activos que apuntan a archivos inexistentes
#    • carpetas que violan la convención semana_NN_tema
#    • \definecolor fuera de core/colors.tex (colores duplicados)
#    • \usepackage dentro de módulos de contenido (preámbulos furtivos)
#    • uso de $$ ... $$ (prohibido por convención)
#    • carga de amssymb o unicode-math en cursos (rompe el núcleo)
#    • dependencias del sistema (lualatex, herramientas opcionales)
#
#  Sale con código 1 si hay ERRORES; las advertencias no bloquean.
# =====================================================================
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/lib/common.sh"

ERRORS=0
WARNINGS=0

error() { log_error "$@"; ERRORS=$((ERRORS + 1)); }
warn()  { log_warn  "$@"; WARNINGS=$((WARNINGS + 1)); }

# check_system_dependencies()
# lualatex es obligatorio; el resto solo mejora la experiencia.
check_system_dependencies() {
    log_info "── Dependencias del sistema ──"
    if command -v lualatex >/dev/null 2>&1; then
        log_ok "lualatex disponible"
    else
        error "lualatex NO está instalado — el proyecto no puede compilar"
    fi
    local tool
    for tool in latexmk make inotifywait; do
        command -v "$tool" >/dev/null 2>&1 \
            || warn "$tool no está instalado (opcional; ver docs/installation.md)"
    done
}

# check_week_completeness()
# Cada semana_* debe tener los tres módulos.
# Arguments: $1 - ruta del curso
check_week_completeness() {
    local course_path=$1 course week_dir module
    course=$(basename "$course_path")
    for week_dir in "$course_path"/semana_*/; do
        [[ -d "$week_dir" ]] || continue
        for module in teoria ejercicios resueltos; do
            [[ -f "${week_dir}${module}.tex" ]] \
                || warn "${course}/$(basename "$week_dir"): falta ${module}.tex"
        done
    done
}

# check_naming_convention()
# Dentro de un curso solo se esperan semana_NN_tema/ y (opcional)
# carpetas de examen. Espacios o mayúsculas rompen los scripts.
# Arguments: $1 - ruta del curso
check_naming_convention() {
    local course_path=$1 course dir name
    course=$(basename "$course_path")
    for dir in "$course_path"/*/; do
        [[ -d "$dir" ]] || continue
        name=$(basename "$dir")
        [[ "$name" =~ ^(semana_[0-9]{2}[a-z0-9_]*|examen[a-z0-9_]*)$ ]] \
            || warn "${course}/${name}: no sigue la convención semana_NN_tema (minúsculas, sin espacios ni tildes)"
    done
}

# check_broken_includes()
# Todo \include/\input ACTIVO del main.tex debe apuntar a un .tex real.
# Arguments: $1 - ruta del curso
check_broken_includes() {
    local course_path=$1 course ref
    course=$(basename "$course_path")
    while IFS= read -r ref; do
        [[ -f "${course_path}/${ref}.tex" || -f "${course_path}/${ref}" ]] \
            || error "${course}/main.tex referencia inexistente: ${ref}"
    done < <(grep -oP '^\s*\\(include|input)\{\K[^}]+' "${course_path}/main.tex" \
                | grep -v '^\.\./\.\./core' | grep -v '^\\')
}

# check_content_hygiene()
# Los módulos de contenido no definen colores/paquetes ni usan $$.
# Arguments: $1 - ruta del curso
check_content_hygiene() {
    local course_path=$1 course hits
    course=$(basename "$course_path")

    hits=$(grep -rln --include='*.tex' '\\definecolor' "$course_path" || true)
    [[ -z "$hits" ]] || warn "${course}: \\definecolor fuera de core/colors.tex en: $(echo "$hits" | tr '\n' ' ')"

    hits=$(grep -rln --include='*.tex' '\\usepackage' "$course_path"/semana_*/ 2>/dev/null || true)
    [[ -z "$hits" ]] || error "${course}: módulos de semana con \\usepackage (deben ser fragmentos sin preámbulo): $(echo "$hits" | tr '\n' ' ')"

    hits=$(grep -rln --include='*.tex' '\\usepackage{\(amssymb\|unicode-math\|fontspec\)}' "${course_path}/main.tex" || true)
    [[ -z "$hits" ]] || error "${course}/main.tex recarga paquetes del núcleo (produce Option clash o colisiones)"

    hits=$(grep -rlnE --include='*.tex' '\${2}[^$]' "$course_path"/semana_*/ 2>/dev/null || true)
    [[ -z "$hits" ]] || warn "${course}: uso de \$\$…\$\$ (usar \\[ \\] o align*): $(echo "$hits" | tr '\n' ' ')"
}

# check_core_integrity()
# El cargador debe referenciar módulos existentes, y a la inversa no
# debe haber módulos huérfanos en core/.
check_core_integrity() {
    log_info "── Núcleo (core/) ──"
    local module referenced
    while IFS= read -r module; do
        [[ -f "${PROJECT_ROOT}/core/${module}.tex" ]] \
            || error "core/preamble.tex carga un módulo inexistente: core/${module}.tex"
    done < <(grep -oP '\\input\{\\CoreDir/\K[^}]+' "${PROJECT_ROOT}/core/preamble.tex")

    for module in "${PROJECT_ROOT}"/core/*.tex; do
        module=$(basename "$module" .tex)
        [[ "$module" == "preamble" ]] && continue
        referenced=$(grep -c "CoreDir/${module}}" "${PROJECT_ROOT}/core/preamble.tex" || true)
        [[ "$referenced" -gt 0 ]] \
            || warn "core/${module}.tex existe pero preamble.tex no lo carga (¿código muerto?)"
    done

    [[ -f "${PROJECT_ROOT}/config/project.tex" ]] \
        || error "Falta config/project.tex"
}

# --- Normativa de archivos (meta/NORMATIVA_ARCHIVOS.md §11): un módulo, tres doctores: fase M9 de §12
# Raíz del workspace por core/env.sh (nunca una ruta escrita a mano); el semáforo
# de core/archivos.py (0 sano · 1 avisos · 2 fallos) se vuelca en los contadores.
check_normativa_archivos() {
    local core_env="${PROJECT_ROOT}/../core/env.sh" salida
    log_info "── Normativa de archivos (core/archivos.py) ──"
    if [[ ! -f "$core_env" ]]; then
        log_warn "core/env.sh no encontrado: no se valida la normativa de archivos"
        WARNINGS=$((WARNINGS + 1)); return
    fi
    # shellcheck source=/dev/null
    source "$core_env"
    salida=0
    python3 "${DOCS_ROOT}/core/archivos.py" validar "${DOCS_ROOT}/11 Book" --max 5 || salida=$?   # set -e: capturar sin abortar
    case $salida in
        0) log_ok "Normativa de archivos: sano" ;;
        1) log_warn "Normativa de archivos: avisos (ver arriba)"; WARNINGS=$((WARNINGS + 1)) ;;
        *) log_error "Normativa de archivos: fallos (ver arriba)"; ERRORS=$((ERRORS + 1)) ;;
    esac
}

main() {
    log_info "Diagnóstico CampusTeX — $(date '+%Y-%m-%d %H:%M')"
    printf '\n'
    check_system_dependencies
    printf '\n'
    check_core_integrity
    printf '\n'
    log_info "── Cursos ──"
    local course
    while IFS= read -r course; do
        check_week_completeness   "${COURSES_DIR}/${course}"
        check_naming_convention   "${COURSES_DIR}/${course}"
        check_broken_includes     "${COURSES_DIR}/${course}"
        check_content_hygiene     "${COURSES_DIR}/${course}"
    done < <(list_courses)

    printf '\n'
    check_normativa_archivos

    printf '\n'
    if [[ $ERRORS -eq 0 && $WARNINGS -eq 0 ]]; then
        log_ok "Proyecto sano: 0 errores, 0 advertencias."
    elif [[ $ERRORS -eq 0 ]]; then
        log_ok "Sin errores. ${WARNINGS} advertencia(s) — revisar arriba."
    else
        log_error "${ERRORS} error(es), ${WARNINGS} advertencia(s)."
        exit 1
    fi
}

main "$@"
