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
- **Responsable:** Andrés Gómez.
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

## [2026-09-14] — Entrega 3 básica: simplificación a temas vistos

- **Objetivo:** dejar la Entrega 3 solo con conceptos básicos (sin
  funciones, paquete, tipos, secuencias, triggers, ventanas ni PL/SQL).
- **Tareas:** reescribir `08_entrega3_ampliacion.sql` (FK simples, DATE,
  2 índices); `09_entrega3_datos.sql` con solo INSERT/UPDATE (2 sedes,
  4 grupos, 14 jugadores, 12 estadísticas, 8 incidencias + auditoría
  manual); `10_entrega3_programacion.sql` como operaciones equivalentes
  con SELECT/UPDATE/INSERT SELECT (posiciones + cierre incluidos);
  `11_entrega3_reportes.sql` con 6 vistas básicas; `12/13` con solo
  SELECT y casos comentados; actualizar documento, matriz y `app/README`.
- **Responsable:** Andrés Gómez.
- **Dificultades:** la programación PL/SQL se reemplazó por SQL básico;
  la app ya era básica (localStorage) y solo se actualizó su README.

## [2026-09-14] — Entrega 2 básica: simplificación a temas vistos

- **Objetivo:** dejar la Entrega 2 solo con conceptos básicos (sin
  triggers, secuencias, PL/SQL, WITH ni ventanas) y con FK simples
  compatibles con la Entrega 1 básica.
- **Tareas:** reescribir `08_ddl_entrega2.sql` (auditoría manual, DATE/SYSDATE,
  2 índices); `09_datos_entrega2.sql` con solo INSERT (5 países, 4 grupos,
  20 jugadores, 12 estadísticas/eventos, 4 incidencias + 4 auditorías);
  `10_vistas_entrega2.sql` sin WITH; `11_consultas_entrega2.sql` con 8
  consultas básicas; `12_roles_entrega2.sql` con GRANT explícitos;
  `13_pruebas_entrega2.sql` y `14_verificacion_entrega2.sql` con solo
  DML/SELECT; actualizar documento y matriz E2.
- **Responsable:** Andrés Gómez.
- **Dificultades:** la auditoría automática por trigger se reemplazó por
  INSERT manual + verificación con LEFT JOIN.

## [2026-09-14] — Entrega 1 básica: simplificación a temas vistos

- **Objetivo:** dejar la Entrega 1 solo con conceptos básicos
  (Modelo Relacional, SQL, JOINS, Agregados/Subconsultas, Vistas,
  Modificadores, Integridad/Privilegios) y eliminar PL/SQL, triggers,
  transacciones, ventanas y WITH complejo.
- **Tareas:** reescribir `01_ddl.sql` sin paquetes ni triggers (solo PK/FK/
  UNIQUE/CHECK/DEFAULT/DATE + 2 índices); `02_datos_prueba.sql` con solo
  INSERT (2 ediciones, 5 estadios, 10 selecciones, 8 partidos, 16
  participaciones); `03_vistas.sql` sin WITH; `06_consultas.sql` sin WITH
  ni ventanas (Q5/Q9/Q15 con subconsultas + MAX, Q1 con FETCH FIRST);
  `04_dml_pruebas.sql` con solo INSERT/UPDATE/DELETE/SELECT y casos
  inválidos comentados; `05_privilegios.sql` con solo CREATE ROLE/GRANT/
  REVOKE; `07_verificacion.sql` con solo SELECT; actualizar documento,
  álgebra y matriz.
- **Responsable:** Andrés Gómez.
- **Rama:** `main` (simplificación entrega-1-básica).
- **Dificultades:** las validaciones de fecha, aforo, coherencia de marcador
  y cierre con 2 participaciones ya no se impiden con triggers: se cargan
  bien y se verifican con consultas de `07_verificacion.sql`.

## [2026-09-13] — Entrega 2: ampliación del modelo

- **Objetivo:** ampliar el modelo inicial hasta un diseño normalizado para análisis
  deportivo, operación del torneo y control de acceso.
- **Tareas:** agregar grupos, jugadores, convocatorias, estadísticas, arbitraje,
  eventos, incidencias, auditoría, ocho consultas avanzadas, tres roles y casos de
  prueba exitosos y fallidos.
- **Responsable:** Andrés Gómez.
- **Rama:** `feature/entrega-2`.
- **Dificultades:** falta ejecutar los scripts 08–14 en el servidor Oracle del curso y
  capturar la evidencia de los roles en sesiones separadas.
- **Evidencia:** `docs/documento_entrega2.md`, `docs/matriz_entrega2.md` y
  `sql/08_ddl_entrega2.sql` a `sql/14_verificacion_entrega2.sql`.

## [2026-09-13] — Entrega 3: programación, aplicación y reportes

- **Objetivo:** completar los criterios de la Entrega 3 de la rúbrica.
- **Tareas:** ampliar el esquema con sedes, ciudades, grupos, jugadores,
  convocatorias, cuerpo técnico, estadísticas, incidencias y auditoría;
  implementar funciones, procedimientos y triggers de negocio; crear vistas
  de reportes; construir el panel web local con CRUD, partidos, estadísticas
  e incidencias.
- **Responsable:** Andrés Gómez.
- **Rama:** `feature/entrega-2` (rama actual del repositorio).
- **Dificultades:** la ejecución Oracle y las capturas de evidencia dependen de
  las credenciales y permisos del servidor del curso; la aplicación local usa
  `localStorage` para permitir una demostración independiente.
- **Evidencia:** `sql/08_entrega3_ampliacion.sql` a
  `sql/13_entrega3_verificacion.sql`, `app/`, `README.md` y
  `docs/matriz_rubrica.md`.

## [Pendiente] — Semana 3: DDL e integridad

- **Objetivo:** ejecutar el DDL en el esquema del curso y validar restricciones.
- **Tareas:** probar PK, FK, `CHECK`, `UNIQUE`, triggers e índices.
- **Responsable:** Andrés Gómez.
- **Rama:** `feature/ddl-restricciones`.
- **Dificultades:** registrar aquí los errores de ejecución y su solución.

## [Pendiente] — Semana 4: datos y vistas

- **Objetivo:** cargar el dataset sintético y verificar las cinco vistas.
- **Tareas:** contar registros, comprobar coherencia referencial y documentar resultados.
- **Responsable:** Andrés Gómez.
- **Rama:** `feature/datos-vistas`.
- **Dificultades:** registrar aquí inconsistencias o ajustes realizados.

## [Pendiente] — Semana 5: consultas SQL

- **Objetivo:** ejecutar las quince consultas sobre el modelo inicial.
- **Tareas:** validar `JOIN`, outer join, subconsultas, agregaciones y reutilización de vistas.
- **Responsable:** Andrés Gómez.
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
- **Responsable:** Andrés Gómez.
- **Rama:** `main`.
- **Dificultades:** registrar aquí las observaciones finales.
