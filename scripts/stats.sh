#!/usr/bin/env bash
# =====================================================================
#  stats.sh — Estadísticas del contenido del proyecto
#
#  Uso:
#    ./scripts/stats.sh                  → muestra las estadísticas
#    ./scripts/stats.sh --update-readme  → además actualiza el README
#                                          entre los marcadores STATS
#
#  Métricas: cursos, semanas (temas), módulos escritos, ejercicios,
#  PDFs generados y páginas totales (si pdfinfo está disponible).
# =====================================================================
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/lib/common.sh"

# count_pdf_pages()
# Suma las páginas de todos los PDF de courses/. Requiere pdfinfo
# (poppler-utils); sin él imprime "—".
count_pdf_pages() {
    command -v pdfinfo >/dev/null 2>&1 || { printf '—'; return; }
    local total=0 pages pdf
    while IFS= read -r pdf; do
        pages=$(pdfinfo "$pdf" 2>/dev/null | awk '/^Pages:/{print $2}')
        total=$((total + ${pages:-0}))
    done < <(find "$COURSES_DIR" -name 'main.pdf')
    printf '%d' "$total"
}

# build_stats_table()
# Imprime la tabla Markdown de estadísticas (una fila por curso).
build_stats_table() {
    local course course_path weeks written exercises pdf_state
    printf '| Curso | Semanas | Módulos escritos | Ejercicios | PDF |\n'
    printf '| ----- | :-----: | :--------------: | :--------: | :-: |\n'
    while IFS= read -r course; do
        course_path="${COURSES_DIR}/${course}"
        weeks=$(find "$course_path" -maxdepth 1 -type d -name 'semana_*' | wc -l)
        # Módulo "escrito" = .tex de semana con contenido real (>1 KB;
        # los esqueletos de plantilla pesan menos)
        written=$(find "$course_path"/semana_*/ -name '*.tex' -size +1k 2>/dev/null | wc -l)
        exercises=$(cat "$course_path"/semana_*/ejercicios.tex 2>/dev/null \
                        | grep -c '\\ejercicio' || true)
        [[ -f "${course_path}/main.pdf" ]] && pdf_state="✓" || pdf_state="—"
        printf '| %s | %s | %s | %s | %s |\n' \
            "$course" "$weeks" "$written" "$exercises" "$pdf_state"
    done < <(list_courses)
}

# update_readme()
# Reemplaza el bloque entre los marcadores STATS del README.
# Arguments: $1 - contenido nuevo (tabla + resumen)
update_readme() {
    local content=$1
    local readme="${PROJECT_ROOT}/README.md"
    grep -q 'STATS:START' "$readme" \
        || die "El README no tiene los marcadores <!-- STATS:START/END -->"

    # awk reconstruye el archivo: conserva todo salvo el interior del bloque
    awk -v new_block="$content" '
        /STATS:START/ { print; print new_block; skipping = 1; next }
        /STATS:END/   { skipping = 0 }
        !skipping     { print }
    ' "$readme" >"${readme}.tmp"
    mv "${readme}.tmp" "$readme"
    log_ok "README.md actualizado (bloque STATS)."
}

main() {
    local courses_total weeks_total exercises_total pdfs_total pages_total table
    courses_total=$(list_courses | wc -l)
    weeks_total=$(find "$COURSES_DIR" -maxdepth 2 -type d -name 'semana_*' | wc -l)
    exercises_total=$(cat "$COURSES_DIR"/*/semana_*/ejercicios.tex 2>/dev/null \
                          | grep -c '\\ejercicio' || true)
    pdfs_total=$(find "$COURSES_DIR" -name 'main.pdf' | wc -l)
    pages_total=$(count_pdf_pages)
    table=$(build_stats_table)

    local summary
    summary=$(printf '%s\n\n**Totales:** %s cursos · %s semanas · %s ejercicios · %s PDF (%s páginas)\n\n*Actualizado: %s por `scripts/stats.sh`*' \
        "$table" "$courses_total" "$weeks_total" "$exercises_total" \
        "$pdfs_total" "$pages_total" "$(date '+%Y-%m-%d')")

    printf '%s\n' "$summary"

    if [[ "${1:-}" == "--update-readme" ]]; then
        update_readme "$summary"
    fi
}

main "$@"
