# ══════════════════════════════════════════════════════════════════
#  Makefile — CampusTeX-Preuniversitario
#
#  Fachada de conveniencia: cada objetivo delega en scripts/, que es
#  la única fuente de verdad de la lógica de compilación.
#
#  Uso:
#    make              → compila todos los cursos
#    make algebra      → compila un curso (uno por carpeta en courses/)
#    make watch-algebra→ recompila al guardar
#    make clean        → elimina auxiliares LaTeX
#    make doctor       → valida la salud del proyecto
#    make stats        → estadísticas del proyecto
#    make help         → esta ayuda
# ══════════════════════════════════════════════════════════════════

# Cursos = subcarpetas de courses/ que contienen un main.tex
COURSES := $(notdir $(patsubst %/main.tex,%,$(wildcard courses/*/main.tex)))

.PHONY: all clean doctor stats help $(COURSES) $(addprefix watch-,$(COURSES))

all:
	./scripts/build-all.sh

$(COURSES):
	./scripts/build-course.sh $@

$(addprefix watch-,$(COURSES)):
	./scripts/watch.sh $(patsubst watch-%,%,$@)

clean:
	./scripts/clean.sh

doctor:
	./scripts/doctor.sh

stats:
	./scripts/stats.sh

help:
	@echo "Objetivos disponibles:"
	@echo "  make / make all      compila todos los cursos"
	@echo "  make <curso>         compila un curso: $(COURSES)"
	@echo "  make watch-<curso>   recompila al guardar cambios"
	@echo "  make clean           elimina auxiliares LaTeX"
	@echo "  make doctor          valida la salud del proyecto"
	@echo "  make stats           estadísticas del proyecto"
	@echo ""
	@echo "Scripts con argumentos (sin objetivo make):"
	@echo "  ./scripts/new-course.sh \"Geometría\""
	@echo "  ./scripts/new-week.sh algebra 05 productos_notables"
