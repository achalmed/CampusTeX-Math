# Sistema de plantillas

Las plantillas viven en `templates/` y usan marcadores `{{NOMBRE}}` que los
scripts sustituyen al generar (función `render_template` de
`scripts/lib/common.sh`).

## templates/course/ — curso nuevo

Usada por `new-course.sh`. Genera `main.tex`, `portada_libro.tex`,
`indice.tex`.

| Marcador          | Ejemplo     | Origen                                     |
| ----------------- | ----------- | ------------------------------------------ |
| `{{CURSO}}`       | `Geometría` | argumento del script, tal como se escribió |
| `{{CURSO_MAYUS}}` | `GEOMETRÍA` | derivado (para la portada)                 |
| `{{SLUG}}`        | `geometria` | derivado (nombre de carpeta)               |

## templates/week/ — semana nueva

Usada por `new-week.sh`. Genera `teoria.tex`, `ejercicios.tex`,
`resueltos.tex` con la estructura pedagógica completa como esqueleto
comentado.

| Marcador          | Ejemplo                        |
| ----------------- | ------------------------------ |
| `{{CARPETA}}`     | `semana_05_productos_notables` |
| `{{NN}}`          | `05`                           |
| `{{TEMA_TITULO}}` | `Productos Notables`           |

## templates/exam/ — examen

Copiar a mano (`cp`) dentro de una subcarpeta del curso y reemplazar
`{{CURSO}}`/`{{CURSO_MAYUS}}`. Usa clase `article` con el núcleo completo;
define `\CoreDir`/`\ConfigDir` a tres niveles porque vive un nivel más
profundo que un `main.tex`.

## Modificar o crear plantillas

1. Editar el `.tex` en `templates/…` — es LaTeX normal más marcadores.
2. Si se agrega un marcador nuevo, añadir el par `CLAVE=valor` en la
   llamada a `render_template` del script correspondiente.
3. Probar generando un curso/semana de prueba y compilando; borrar después.

Regla: las plantillas **no** definen colores, cajas ni paquetes — todo eso
es del núcleo. Una plantilla solo estructura contenido.
