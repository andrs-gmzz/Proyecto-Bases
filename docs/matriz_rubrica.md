# Matriz de trazabilidad de la rúbrica

Esta matriz relaciona cada criterio con el archivo que lo demuestra y con la evidencia
que todavía debe capturarse al ejecutar los scripts en el servidor del curso.

| Criterio | Peso | Entregable preparado | Evidencia por completar |
|---|---:|---|---|
| Documento técnico | 10% | `docs/documento_tecnico.md`: problema, alcance, supuestos, ERD, modelo lógico y diccionario | Revisión final del PDF o exportación del documento |
| DDL y restricciones de negocio | 15% | `sql/01_ddl.sql`: PK, FK, `CHECK`, `UNIQUE`, triggers e índices | Ejecución sin errores y consulta de `USER_ERRORS` |
| Datos de prueba | 5% | `sql/02_datos_prueba.sql`: 100 estadios, 192 selecciones, 416 partidos y 832 participaciones | Conteos de `sql/07_verificacion.sql` |
| Vistas | 5% | `sql/03_vistas.sql`: cinco vistas justificadas | Resultados y definición de cada vista |
| Modificadores DML | 10% | `sql/04_dml_pruebas.sql`: ciclo de vida, seis errores controlados y dos comportamientos de borrado | Salida de `DBMS_OUTPUT` y conteos antes/después |
| Privilegios básicos | 5% | `sql/05_privilegios.sql`: roles de consulta y operación, `GRANT` y `REVOKE` | Prueba con usuarios de base de datos autorizados |
| Álgebra relacional | 5% | `docs/algebra_relacional.md`: cuatro traducciones | Revisión de correspondencia con las consultas SQL |
| Evaluación crítica | 10% | Sección 12 de `docs/documento_tecnico.md`: problemas, ajustes y boceto ampliado | Retroalimentación de la sustentación |
| Consultas SQL | 15% | `sql/06_consultas.sql`: quince consultas con joins, subconsultas, agregaciones y vistas | Resultados ejecutados y capturas seleccionadas |
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
