# ══════════════════════════════════════════════════════════════════
#  .latexmkrc — Configuración de latexmk para CampusTeX
#
#  El framework compila SIEMPRE con LuaLaTeX. latexmk gestiona solo
#  el número de pasadas (índice, referencias cruzadas).
#
#  latexmk solo lee el rc del directorio actual, no de los padres;
#  los scripts lo pasan explícitamente:  latexmk -r <raíz>/.latexmkrc
#  Para uso manual desde la carpeta de un curso:
#      latexmk -r ../../.latexmkrc main.tex
# ══════════════════════════════════════════════════════════════════

# Motor: 4 = lualatex
$pdf_mode = 4;

# Opciones idénticas a las que usan los scripts del proyecto
$lualatex = 'lualatex -interaction=nonstopmode -halt-on-error -synctex=1 %O %S';

# Limpieza ampliada: latexmk -c también borra estos residuos
$clean_ext = 'synctex.gz run.xml bcf';
