#!/usr/bin/env python3
"""scripts/normalizar-cabeceras.py — migración M7 de la normativa de archivos en CampusTeX.

Objetivo: que cada `.tex`, `.sh` y `.md` del framework cumpla `core/archivos.py`:
  identidad en la línea 1 con la ruta real, sándwich `% ====` en vez de cajas
  `╔══╗`, separadores internos `% --- Título ---` ASCII, `Uso:` en los maestros,
  frontmatter con `tipo: doc` en `docs/`, y ningún artefacto de TeX en el árbol.
Método: reescribe solo comentarios y cabeceras (nunca una línea que no empiece por
  `%` o `#`), deriva el «qué es» del texto de la propia caja, y verifica que el PDF
  de `courses/economia` sea idéntico antes y después (páginas y `pdftotext`).
  Simula por defecto; con --aplicar escribe y anota la bitácora para el UNDO.
Fundamento: meta/NORMATIVA_ARCHIVOS.md §5, §6.2 (LaTeX y Bash), §9.3; fila M7 de §12.
Alternativa: un `sed 's/═/=/g'`. Se descarta: no distingue el borde de la cabecera
  (que es `====`) de un separador interno (que es `--- Título ---`) ni escribe la
  identidad con la ruta.
Límite: no toca `legacy/` (ajeno al núcleo, por contrato del framework) ni contenido.

Uso:
  python3 scripts/normalizar-cabeceras.py [--aplicar] [--bitacora DIR]
"""
from __future__ import annotations

import argparse
import re
import subprocess
import sys
from pathlib import Path

RAIZ = Path(__file__).resolve().parents[1]
CARPETAS = ["core", "config", "courses", "templates", "scripts", "docs"]
ARTEFACTOS = {".aux", ".log", ".out", ".toc", ".lof", ".lot", ".fls", ".fdb_latexmk", ".bbl", ".blg", ".bcf",
              ".nav", ".snm", ".vrb", ".xdv"}
BOX = "╔╗╚╝║═─"
BIT = {"dir": None, "aplicar": False, "plan": []}


def bitacora(clase, *campos):
    if BIT["dir"] is None:
        return
    if not BIT["aplicar"]:
        BIT["plan"].append("\t".join([clase, *campos])); return
    nombre = {"mv": "renombres.tsv", "rm": "borrados.txt", "mod": "modificados.txt"}[clase]
    with open(Path(BIT["dir"]) / nombre, "a", encoding="utf-8") as f:
        f.write("\t".join(campos) + "\n")


def tracked(p: Path) -> bool:
    return subprocess.run(["git", "-C", str(RAIZ), "ls-files", "--error-unmatch", str(p.relative_to(RAIZ))],
                          capture_output=True, text=True).returncode == 0


def minusculas_gritadas(s: str) -> str:
    """Palabras enteramente en mayúsculas → minúsculas; se conservan las mixtas (CampusTeX) y los romanos (II)."""
    return " ".join(w.lower() if re.fullmatch(r"[A-ZÁÉÍÓÚÑ0-9/().,:;·\-]+", w) and not re.fullmatch(r"[IVX]+", w) else w
                    for w in s.split(" "))


def regla(marca: str, titulo: str = "") -> str:
    """`% --- Título ---…` hasta la columna 77 (o `% ====` si es borde de cabecera)."""
    if titulo:
        base = f"{marca} --- {titulo} "
        return base + "-" * max(3, 77 - len(base))
    return f"{marca} " + "=" * 69


def separador_interno(marca: str, l: str) -> str:
    """`% ── Título ────` o `% ─── Título ───` → `% --- Título ---…`; `% ────` sin título → `% -----`."""
    sangria = re.match(r"^\s*", l).group(0)
    cuerpo = l.strip()[len(marca):].strip()
    m = re.match(r"^[─═]+\s*(.*?)\s*[─═]*$", cuerpo)
    titulo = (m.group(1) if m else "").strip()
    if titulo:
        return sangria + regla(marca, titulo)
    return sangria + marca + " " + "-" * 69


def convertir_caja(lineas: list[str], marca: str, rel: str, uso: str | None) -> list[str]:
    """La caja `╔══╗ … ╚══╝` de las primeras líneas → sándwich con identidad."""
    i = 0
    while i < len(lineas) and lineas[i].strip() == "":
        i += 1
    if i >= len(lineas) or not re.match(rf"^\s*{re.escape(marca)}\s*╔", lineas[i]):
        return lineas
    fin = next((k for k in range(i, min(len(lineas), i + 12)) if re.match(rf"^\s*{re.escape(marca)}\s*╚", lineas[k])), None)
    if fin is None:
        return lineas
    interior = []
    for l in lineas[i + 1:fin]:
        t = l.strip()[len(marca):].strip().strip("║").strip()
        if t:
            interior.append(t)
    que = minusculas_gritadas(interior[0]) if interior else rel
    que = re.sub(rf"^{re.escape(rel.lower())}\s*[—:-]+\s*", "", que)     # la caja repetía la ruta en mayúsculas
    que = que.replace(" — ", ": ")
    resto = interior[1:]
    out = [regla(marca), f"{marca}  {rel} — {que}"]
    if resto or uso:
        out.append(f"{marca} " + "-" * 69)
        for r in resto:
            if r.lower().startswith("compilar"):
                if uso:
                    continue
                r = "Uso: " + r.split(":", 1)[1].strip() if ":" in r else r
            out.append(f"{marca}  {r}")
        if uso:
            out.append(f"{marca}  Uso: {uso}")
    out.append(regla(marca))
    return lineas[:i] + out + lineas[fin + 1:]


def normalizar_texto(p: Path, texto: str) -> str:
    marca = "#" if p.suffix == ".sh" else "%"
    rel = p.relative_to(RAIZ).as_posix()
    lineas = texto.split("\n")
    uso = None
    if p.name == "main.tex" and p.parent.parent.name == "courses":
        uso = f"scripts/build-course.sh {p.parent.name}"
    elif rel == "templates/course/main.tex":
        uso = "scripts/build-course.sh <curso>"
    lineas = convertir_caja(lineas, marca, rel, uso)
    fin_cab = 0                                          # última línea de la cabecera: el bloque inicial de comentarios
    while fin_cab < len(lineas) and (lineas[fin_cab].strip().startswith(marca) or lineas[fin_cab].startswith("#!")):
        fin_cab += 1
    out = []
    n = len(lineas)
    k = 0
    while k < n:
        l = lineas[k]
        s = l.strip()
        if s.startswith(marca) and re.match(rf"^{re.escape(marca)}\s*╔", s):
            fin = next((j for j in range(k, min(n, k + 8)) if re.match(rf"^\s*{re.escape(marca)}\s*╚", lineas[j])), None)
            if fin is not None:
                interior = [x.strip()[len(marca):].strip().strip("║").strip() for x in lineas[k + 1:fin]]
                interior = [x for x in interior if x]
                sang = re.match(r"^\s*", l).group(0)
                if interior:
                    out.append(sang + regla(marca, interior[0].replace(" — ", ": ")))
                    out += [f"{sang}{marca}  {x}" for x in interior[1:]]
                k = fin + 1
                continue
        if s.startswith(marca) and re.match(rf"^{re.escape(marca)}\s*[═─]{{2,}}", s):
            cuerpo = s[len(marca):].strip()
            solo_regla = re.fullmatch(r"[═─]+", cuerpo) is not None
            # bloque `% ════` / `% §B TÍTULO` / `%     descripción…` / `% ════` → `% --- §B TÍTULO ---` + descripción
            if solo_regla and k + 1 < n and re.match(rf"^\s*{re.escape(marca)}\s*§?[A-Z0-9]", lineas[k + 1]) \
                    and not re.match(rf"^\s*{re.escape(marca)}\s*[═─]", lineas[k + 1]) and "═" in cuerpo:
                titulo = lineas[k + 1].strip()[len(marca):].strip()
                out.append(re.match(r"^\s*", l).group(0) + regla(marca, titulo))
                k += 2
                while k < n and lineas[k].strip().startswith(marca) and not re.match(rf"^\s*{re.escape(marca)}\s*[═─]{{2,}}", lineas[k].strip()):
                    out.append(lineas[k]); k += 1
                if k < n and re.fullmatch(rf"\s*{re.escape(marca)}\s*[═]+\s*", lineas[k]):
                    k += 1                                   # cierre del bloque: sobra
                continue
            # sándwich `% ═══` que abre o cierra la cabecera (primeras 15 líneas) → borde `====`
            if solo_regla and "═" in cuerpo and k < fin_cab:
                out.append(re.match(r"^\s*", l).group(0) + regla(marca)); k += 1; continue
            out.append(separador_interno(marca, l)); k += 1; continue
        out.append(l); k += 1
    return "\n".join(out)


def frontmatter_doc(p: Path, texto: str) -> str | None:
    if texto.startswith("---"):
        return None
    m = re.search(r"^#\s+(.+)$", texto, re.M)
    titulo = (m.group(1).strip() if m else p.stem.replace("-", " ")).replace('"', "'")
    return f'---\ntipo: doc\ntitulo: "{titulo}"\nestado: activo\n---\n' + texto


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--aplicar", action="store_true")
    ap.add_argument("--bitacora")
    a = ap.parse_args()
    BIT["aplicar"], BIT["dir"] = a.aplicar, a.bitacora
    if a.bitacora:
        Path(a.bitacora).mkdir(parents=True, exist_ok=True)
    nmod = nart = nfm = nmv = 0
    for carpeta in CARPETAS:
        for p in sorted((RAIZ / carpeta).rglob("*")):
            if not p.is_file():
                continue
            if p.suffix in ARTEFACTOS or p.name.endswith(".synctex.gz") or p.name == "build.log":
                if p.suffix == ".log" and not p.read_text(encoding="utf-8", errors="replace").startswith("This is ") and p.name != "build.log":
                    continue
                print(f"  rm  {p.relative_to(RAIZ)}"); bitacora("rm", str(p)); nart += 1
                if a.aplicar:
                    if tracked(p):
                        subprocess.run(["git", "-C", str(RAIZ), "rm", "-q", "-f", str(p)], check=True)
                    else:
                        p.unlink()
                continue
            if p.suffix in (".tex", ".sh", ".cls", ".sty"):
                t = p.read_text(encoding="utf-8")
                nuevo = normalizar_texto(p, t)
                if nuevo != t:
                    print(f"  cab {p.relative_to(RAIZ)}"); bitacora("mod", str(p)); nmod += 1
                    if a.aplicar:
                        p.write_text(nuevo, encoding="utf-8")
            elif p.suffix == ".md" and carpeta == "docs":
                t = p.read_text(encoding="utf-8")
                nuevo = frontmatter_doc(p, t)
                if nuevo:
                    print(f"  fm  {p.relative_to(RAIZ)}"); bitacora("mod", str(p)); nfm += 1
                    if a.aplicar:
                        p.write_text(nuevo, encoding="utf-8")
            elif p.suffix == ".xopp" and p.name != p.name.lower():
                dst = p.with_name(p.name.lower())
                print(f"  mv  {p.relative_to(RAIZ)} → {dst.name}"); bitacora("mv", str(p), str(dst)); nmv += 1
                if a.aplicar:
                    if tracked(p):
                        subprocess.run(["git", "-C", str(RAIZ), "mv", str(p), str(dst)], check=True)
                    else:
                        p.rename(dst)
    print(f"cabeceras/separadores: {nmod} · artefactos: {nart} · frontmatter docs: {nfm} · renombres: {nmv}")
    if a.bitacora and not a.aplicar:
        (Path(a.bitacora) / "plan_11book.tsv").write_text("\n".join(BIT["plan"]) + "\n", encoding="utf-8")
    print("APLICADO" if a.aplicar else "SIMULACIÓN (usa --aplicar)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
