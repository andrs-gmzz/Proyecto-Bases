# CHANGELOG

Registro semanal del avance verificable del proyecto. Cada entrada debe acompañarse de
commits, ramas o pull requests visibles en GitHub.

## [2026-08-30] — Semana 1: planificación e inicio

- **Objetivo:** comprender la rúbrica, delimitar la Entrega 1 al modelo inicial y
  publicar la base del repositorio.
- **Tareas realizadas:**
  - Revisión del enunciado y de los criterios de evaluación.
  - Definición del motor Oracle Database y del cliente SQL Developer.
  - Preparación local del primer borrador técnico y de los scripts, que se publicarán en
    avances posteriores.
  - Registro del cronograma y del flujo de trabajo Git en `README.md`.
- **Responsable:** Andrés Gómez, Andrea chaparro
- **Rama:** `main` (preparación inicial).
- **Dificultades:** todavía falta ejecutar la entrega en el servidor y completar los
  datos de conexión entregados por el curso.
- **Evidencia inicial:** `.gitignore`, `README.md` y `CHANGELOG.md`.

## [2026-09-06] — Semana 2: modelo y documentación

- **Objetivo:** documentar el modelo inicial y su evolución futura.
- **Tareas:** cerrar el ERD, los supuestos, la transformación al modelo lógico, el
  diccionario de datos, la evaluación crítica y la matriz de trazabilidad.
- **Responsable:** Andrés Gómez.
- **Rama:** `feature/modelo-documental`.
- **Dificultades:** aún falta ejecutar y validar los scripts en el servidor Oracle del
  curso.
- **Evidencia:** `docs/documento_tecnico.md`, `docs/algebra_relacional.md` y
  `docs/matriz_rubrica.md`.

## [Pendiente] — Semana 3: DDL e integridad

- **Objetivo:** ejecutar el DDL en el esquema del curso y validar restricciones.
- **Tareas:** probar PK, FK, `CHECK`, `UNIQUE`, triggers e índices.
- **Responsable:** Andrés Gómez, Andrea chaparro
- **Rama:** `feature/ddl-restricciones`.
- **Dificultades:** registrar aquí los errores de ejecución y su solución.

## [Pendiente] — Semana 4: datos y vistas

- **Objetivo:** cargar el dataset sintético y verificar las cinco vistas.
- **Tareas:** contar registros, comprobar coherencia referencial y documentar resultados.
- **Responsable:** Andrés Gómez, Andrea chaparro
- **Rama:** `feature/datos-vistas`.
- **Dificultades:** registrar aquí inconsistencias o ajustes realizados.

## [Pendiente] — Semana 5: consultas SQL

- **Objetivo:** ejecutar las quince consultas sobre el modelo inicial.
- **Tareas:** validar `JOIN`, outer join, subconsultas, agregaciones y reutilización de vistas.
- **Responsable:** Andrés Gómez, Andrea chaparro
- **Rama:** `feature/consultas-pruebas`.
- **Dificultades:** registrar aquí cualquier consulta corregida.

## [Pendiente] — Semana 6: DML y privilegios

- **Objetivo:** probar el ciclo de vida de un partido, operaciones inválidas y roles.
- **Tareas:** documentar mensajes de error, `ON DELETE`, `GRANT` y `REVOKE`.
- **Responsable:** Andrés Gómez.
- **Rama:** `feature/consultas-pruebas`.
- **Dificultades:** registrar aquí las limitaciones del servidor o permisos DBA.

## [Pendiente] — Semana 7: revisión y evidencias

- **Objetivo:** ejecutar el flujo completo en SQL Developer y preparar capturas de resultados.
- **Tareas:** verificar conteos, resultados y trazabilidad de GitHub.
- **Responsable:** Andrés Gómez.
- **Rama:** `feature/revision-entrega-1`.
- **Dificultades:** registrar aquí los problemas finales y su resolución.

## [Pendiente] — Semana 8: cierre

- **Objetivo:** revisar la rúbrica y preparar la sustentación.
- **Tareas:** integrar ramas, revisar el README y entregar la versión final.
- **Responsable:** Andrés Gómez, Andrea chaparro
- **Rama:** `main`.
- **Dificultades:** registrar aquí las observaciones finales.
