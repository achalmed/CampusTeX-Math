#!/usr/bin/env bash
# =====================================================================
#  lib/common.sh — Funciones compartidas por todos los scripts
#
#  Provee: logging con niveles, detección de la raíz del proyecto,
#  descubrimiento de cursos y utilidades de compilación.
#  Todos los scripts hacen `source` de este archivo; ninguno duplica
#  estas funciones.
# =====================================================================

# --- Raíz del proyecto -----------------------------------------------------
# Se resuelve desde la ubicación física de ESTE archivo, no del CWD,
# para que los scripts funcionen desde cualquier directorio.
COMMON_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${COMMON_LIB_DIR}/../.." && pwd)"
readonly COMMON_LIB_DIR PROJECT_ROOT

# Directorio de cursos: courses/ en la arquitectura actual; se acepta
# la raíz como fallback para compatibilidad con estados intermedios.
if [[ -d "${PROJECT_ROOT}/courses" ]]; then
    readonly COURSES_DIR="${PROJECT_ROOT}/courses"
else
    readonly COURSES_DIR="${PROJECT_ROOT}"
fi

# --- Colores (solo si stdout es una terminal) ------------------------------
if [[ -t 1 ]]; then
    readonly C_RED=$'\033[0;31m' C_YELLOW=$'\033[0;33m' \
             C_GREEN=$'\033[0;32m' C_BLUE=$'\033[0;34m' C_RESET=$'\033[0m'
else
    readonly C_RED="" C_YELLOW="" C_GREEN="" C_BLUE="" C_RESET=""
fi

# --- Logging ---------------------------------------------------------------
# WARN y ERROR van a stderr para no contaminar salidas encadenables.
_log() {
    local level=$1 color=$2
    shift 2
    printf '%s[%s]%s %s\n' "$color" "$level" "$C_RESET" "$*"
}

log_info()  { _log "INFO"  "$C_BLUE"   "$@"; }
log_ok()    { _log "OK"    "$C_GREEN"  "$@"; }
log_warn()  { _log "WARN"  "$C_YELLOW" "$@" >&2; }
log_error() { _log "ERROR" "$C_RED"    "$@" >&2; }

die() {
    log_error "$@"
    exit 1
}

# --- Descubrimiento de cursos ----------------------------------------------
# list_courses()
# Imprime el nombre de cada curso (carpeta con main.tex) uno por línea.
list_courses() {
    local dir
    for dir in "${COURSES_DIR}"/*/; do
        [[ -f "${dir}main.tex" ]] && basename "$dir"
    done
}

# course_dir() — imprime la ruta absoluta de un curso, o falla.
# Arguments: $1 - nombre del curso
course_dir() {
    local name=$1
    local dir="${COURSES_DIR}/${name}"
    [[ -f "${dir}/main.tex" ]] || die "No existe el curso '${name}' (esperaba ${dir}/main.tex). Cursos disponibles: $(list_courses | tr '\n' ' ')"
    printf '%s\n' "$dir"
}

# --- Utilidades de texto ---------------------------------------------------
# slugify()
# Convierte un nombre a identificador de carpeta: minúsculas, sin
# tildes, espacios y guiones → guion bajo. "Razonamiento Matemático"
# → "razonamiento_matematico".
slugify() {
    printf '%s' "$1" \
        | iconv -f UTF-8 -t ASCII//TRANSLIT 2>/dev/null \
        | tr '[:upper:]' '[:lower:]' \
        | tr ' -' '__' \
        | tr -cd 'a-z0-9_'
}

# titlecase()
# Convierte un slug a título legible: "productos_notables" →
# "Productos Notables". No restituye tildes (el docente ajusta el
# título fino en el .tex).
titlecase() {
    printf '%s' "$1" \
        | tr '_' ' ' \
        | sed 's/\b\(.\)/\u\1/g'
}

# render_template()
# Copia una plantilla sustituyendo los marcadores {{...}}.
#
# Arguments:
#   $1 - archivo de plantilla
#   $2 - archivo destino
#   resto - pares MARCADOR=VALOR (sin llaves), p. ej. CURSO=Geometría
render_template() {
    local template=$1 dest=$2
    shift 2
    local content pair key value
    content=$(<"$template")
    for pair in "$@"; do
        key=${pair%%=*}
        value=${pair#*=}
        content=${content//"{{${key}}}"/"$value"}
    done
    printf '%s' "$content" >"$dest"
}

# --- Compilación -----------------------------------------------------------
# compile_course()
# Compila el main.tex de un curso. Usa latexmk si está instalado
# (gestiona las pasadas automáticamente); si no, dos pasadas de
# lualatex, que es lo que necesitan el índice y las referencias.
#
# Arguments:
#   $1 - ruta de la carpeta del curso
# Returns:
#   0 si el PDF se generó; 1 si la compilación falló
compile_course() {
    local dir=$1
    local name
    name=$(basename "$dir")

    if command -v latexmk >/dev/null 2>&1; then
        log_info "Compilando ${name} con latexmk…"
        # -r carga el rc del proyecto: latexmk no busca en directorios padre
        ( cd "$dir" && latexmk -r "${PROJECT_ROOT}/.latexmkrc" main.tex ) \
            >"${dir}/build.log" 2>&1
    else
        log_info "Compilando ${name} con lualatex (2 pasadas — latexmk no instalado)…"
        ( cd "$dir" \
            && lualatex -interaction=nonstopmode -halt-on-error main.tex \
            && lualatex -interaction=nonstopmode -halt-on-error main.tex ) \
            >"${dir}/build.log" 2>&1
    fi

    if [[ $? -eq 0 && -f "${dir}/main.pdf" ]]; then
        rm -f "${dir}/build.log"
        log_ok "${name}: main.pdf generado"
        return 0
    fi
    log_error "${name}: la compilación falló — revisa ${dir}/build.log y ${dir}/main.log"
    return 1
}
