# Matriz de trazabilidad de la rúbrica

Esta matriz relaciona cada criterio con el archivo que lo demuestra y con la evidencia
que todavía debe capturarse al ejecutar los scripts en el servidor del curso.

| Criterio | Peso | Entregable preparado | Evidencia por completar |
|---|---:|---|---|
| Documento técnico | 10% | `docs/documento_tecnico.md`: problema, alcance, supuestos, ERD, modelo lógico y diccionario | Revisión final del PDF o exportación del documento |
| DDL y restricciones de negocio | 15% | `sql/01_ddl.sql`: PK, FK simples, `CHECK`, `UNIQUE`, `DEFAULT`, 2 índices (sin triggers ni PL/SQL) | Ejecución sin errores |
| Datos de prueba | 5% | `sql/02_datos_prueba.sql`: solo INSERT (2 ediciones, 5 estadios, 10 selecciones, 8 partidos, 16 participaciones) | Conteos de `sql/07_verificacion.sql` |
| Vistas | 5% | `sql/03_vistas.sql`: cinco vistas con JOIN/GROUP BY (sin WITH ni ventanas) | Resultados y definición de cada vista |
| Modificadores DML | 10% | `sql/04_dml_pruebas.sql`: ciclo de vida con INSERT/UPDATE/DELETE/SELECT y casos inválidos comentados | SELECT antes/después y errores ORA al descomentar |
| Privilegios básicos | 5% | `sql/05_privilegios.sql`: roles de consulta y operación, `GRANT` y `REVOKE` | Prueba con usuarios de base de datos autorizados |
| Álgebra relacional | 5% | `docs/algebra_relacional.md`: cuatro traducciones | Revisión de correspondencia con las consultas SQL |
| Evaluación crítica | 10% | Sección 12 de `docs/documento_tecnico.md`: problemas, ajustes y boceto ampliado | Retroalimentación de la sustentación |
| Consultas SQL | 15% | `sql/06_consultas.sql`: quince consultas básicas con joins, subconsultas, agregaciones y vistas (sin WITH ni ventanas) | Resultados ejecutados y capturas seleccionadas |
| Git y organización | 20% | `README.md`, `CHANGELOG.md`, ramas y cronograma | Repositorio GitHub, commits semanales y pull requests |

## Criterio de cierre

La entrega no debe marcarse como terminada hasta que:

- `sql/01_ddl.sql`, `sql/02_datos_prueba.sql`, `sql/03_vistas.sql`,
  `sql/04_dml_pruebas.sql`, `sql/06_consultas.sql` y `sql/07_verificacion.sql` se
  ejecuten en el esquema del curso.
- Se guarden las salidas o capturas en la ubicación indicada por el profesor.
- Se sustituyan los campos de conexión de `README.md` por instrucciones reales, sin
  incluir contraseñas.
- Se actualice el `CHANGELOG.md` cada semana con el avance real.
- Se cree y enlace el repositorio remoto de GitHub.

## Trazabilidad de la Entrega 3

| Criterio de la rúbrica | Peso | Implementación | Evidencia |
|---|---:|---|---|
| Programación en base de datos | 30% | `sql/10_entrega3_programacion.sql`: operaciones equivalentes con SELECT/UPDATE/INSERT SELECT (sin funciones, paquete ni triggers) | `sql/12_entrega3_pruebas.sql` y `sql/13_entrega3_verificacion.sql` (solo SELECT) |
| Aplicación funcional | 30% | `app/index.html`, `app/app.js` y `app/styles.css`: CRUD de catálogos, partidos, estadísticas e incidencias | Demostración local y exportación JSON |
| Reportes | 20% | `sql/11_entrega3_reportes.sql` y las vistas del panel: resultados, posiciones, goleadores, fases e incidencias | Filtros por edición, selección, grupo y fase |
| Git y organización | 20% | `README.md`, `CHANGELOG.md` y documentación de ejecución | Commits, ramas y capturas del servidor del curso |

### Orden de ejecución de la Entrega 3

1. `08_entrega3_ampliacion.sql` — tablas nuevas con FK simples e índices básicos.
2. `09_entrega3_datos.sql` — catálogos, grupos, jugadores, estadísticas e incidencias (solo INSERT/UPDATE).
3. `10_entrega3_programacion.sql` — operaciones equivalentes con SQL básico (sin funciones ni triggers).
4. `11_entrega3_reportes.sql` — 6 vistas básicas (la tabla de posiciones ya viene llena del paso 10).
5. `12_entrega3_pruebas.sql` — SELECT de verificación y casos inválidos comentados.
6. `13_entrega3_verificacion.sql` — conteos y reglas con cero filas (solo SELECT).
