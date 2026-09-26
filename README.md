# Proyecto FIFA — Entrega 3

Sistema de información para la gestión de una Copa Mundial de la FIFA.

## Información del equipo

- Integrante: Andrés Gómez
- Curso: Bases de Datos
- Entrega: 3 — Programación en base de datos, aplicación funcional y reportes
- Motor: Oracle Database
- Cliente: Oracle SQL Developer
- Esquema: `<SCHEMA_DEL_CURSO>`

## Base heredada de las Entregas 1 y 2

La Entrega 1 se implementó sobre el modelo genérico inicial de cinco entidades:

1. `EDICION_MUNDIAL`
2. `ESTADIO`
3. `SELECCION`
4. `PARTIDO`
5. `PARTICIPACION_PARTIDO`

Se agregan únicamente ajustes menores necesarios para cumplir las consultas y reglas
solicitadas: asistencia registrada, estado del partido, resultado de cada participación y
claves compuestas de consistencia entre edición y sus entidades dependientes. Jugadores,
árbitros, grupos, estadísticas detalladas, boletería, prensa e incidencias se presentan como
evolución propuesta en la evaluación crítica.

## Alcance de la Entrega 2

La segunda entrega conserva las tablas de la primera y agrega un modelo normalizado para:

- países sede, ciudades y fases;
- grupos e inscripción de selecciones;
- posiciones, jugadores y convocatorias;
- estadísticas de jugador por partido;
- árbitros, roles arbitrales y asignaciones;
- eventos, incidencias y auditoría;
- análisis avanzado y tres perfiles de acceso.

La documentación completa se encuentra en `docs/documento_entrega2.md` y la matriz de
trazabilidad en `docs/matriz_entrega2.md`.

## Estructura prevista del repositorio

```text
.
├── README.md
├── CHANGELOG.md
├── app/
│   ├── index.html
│   ├── styles.css
│   ├── app.js
│   └── README.md
├── docs/
│   ├── documento_tecnico.md
│   ├── algebra_relacional.md
│   ├── matriz_rubrica.md
│   ├── documento_entrega2.md
│   └── matriz_entrega2.md
└── sql/
    ├── 01_ddl.sql
    ├── 02_datos_prueba.sql
    ├── 03_vistas.sql
    ├── 04_dml_pruebas.sql
    ├── 05_privilegios.sql
    ├── 06_consultas.sql
    ├── 07_verificacion.sql
    ├── 08_ddl_entrega2.sql
    ├── 09_datos_entrega2.sql
    ├── 10_vistas_entrega2.sql
    ├── 11_consultas_entrega2.sql
    ├── 12_roles_entrega2.sql
    ├── 13_pruebas_entrega2.sql
    ├── 14_verificacion_entrega2.sql
    ├── 08_entrega3_ampliacion.sql
    ├── 09_entrega3_datos.sql
    ├── 10_entrega3_programacion.sql
    ├── 11_entrega3_reportes.sql
    ├── 12_entrega3_pruebas.sql
    └── 13_entrega3_verificacion.sql
```

Los scripts de la Entrega 2 se ejecutan después de los scripts 01–07 y conservan la
compatibilidad con el modelo inicial.

## Orden de ejecución en SQL Developer

Ejecutar cada archivo conectado al esquema asignado por el curso y usando **Run Script
(F5)**, porque los scripts contienen bloques PL/SQL terminados con `/`.

1. `sql/01_ddl.sql` — tablas, restricciones, triggers e índices.
2. `sql/02_datos_prueba.sql` — dataset sintético coherente.
3. `sql/03_vistas.sql` — cinco vistas justificadas.
4. `sql/06_consultas.sql` — las quince consultas solicitadas.
5. `sql/04_dml_pruebas.sql` — ciclo de vida, errores controlados y `ON DELETE`.
6. `sql/05_privilegios.sql` — roles y `GRANT`/`REVOKE`; ejecutar con permisos DBA o
   solicitar su ejecución al administrador del servidor.
7. `sql/07_verificacion.sql` — conteos y comprobaciones para capturar evidencias.
8. `sql/08_ddl_entrega2.sql` — modelo normalizado ampliado.
9. `sql/09_datos_entrega2.sql` — grupos, jugadores, convocatorias y estadísticas.
10. `sql/10_vistas_entrega2.sql` — vistas de análisis y auditoría.
11. `sql/11_consultas_entrega2.sql` — ocho consultas avanzadas.
12. `sql/12_roles_entrega2.sql` — administrador, analista y auditor.
13. `sql/13_pruebas_entrega2.sql` — casos exitosos y fallidos.
14. `sql/14_verificacion_entrega2.sql` — conteos y reglas estructurales.

Los scripts no contienen credenciales reales. Antes de ejecutar, completar los datos de
conexión entregados por el curso:

```text
Host:     <HOST_DEL_CURSO>
Puerto:   <PUERTO_DEL_CURSO>
Servicio: <SERVICE_NAME_O_SID>
Usuario:  <SCHEMA_DEL_CURSO>
```

## Conexión y seguridad

- No se deben guardar contraseñas, wallets, archivos `.p12`, `.key` ni datos personales
  reales en este repositorio.
- `ROL_FIFA_E1_ANDRES_CONSULTA` solo recibe permisos de lectura.
- `ROL_FIFA_E1_ANDRES_OPERATIVO` recibe permisos de lectura e inserción/actualización sobre las
  tablas transaccionales (`PARTIDO` y `PARTICIPACION_PARTIDO`), sin permisos de borrado.
- `ROL_FIFA_E2_ADMIN_TORNEO` administra las tablas operativas de ambas entregas.
- `ROL_FIFA_E2_ANALISTA_DEP` consulta vistas de análisis sin permisos DML.
- `ROL_FIFA_E2_AUDITOR_CONSULTA` consulta indicadores y auditoría sin acceso directo a
  las tablas operativas.
- Oracle no implementa `ON UPDATE CASCADE` en claves foráneas. El documento técnico
  explica esta limitación y la decisión de usar `NO ACTION` implícito para preservar
  referencias.

## Flujo de trabajo Git

Aunque el trabajo sea individual, se conservará trazabilidad mediante ramas y pull
requests:

```text
main
├── feature/modelo-documental
├── feature/entrega-2
├── feature/entrega-3
├── feature/ddl-restricciones
├── feature/datos-vistas
└── feature/consultas-pruebas
```

Cada semana se debe:

1. Crear o actualizar una rama de trabajo.
2. Registrar cambios pequeños y descriptivos con commits frecuentes.
3. Abrir un pull request hacia `main`.
4. Actualizar `CHANGELOG.md` con objetivo, tareas, responsable, rama y dificultades.
5. Integrar el pull request después de revisar que los scripts siguen ejecutando.

Cuando se cree el repositorio remoto en GitHub, enlazarlo sin almacenar credenciales:

```powershell
git remote add origin https://github.com/<USUARIO_GITHUB>/proyecto-fifa-entrega-1.git
git branch -M main
git push -u origin main
```

## Cronograma de avances

| Semana | Hito | Actividad | Responsable | Evidencia |
|---|---|---|---|---|
| 1 | Comprensión del problema | Revisar enunciado, rúbrica y modelo inicial | Andrés Gómez | `CHANGELOG.md`, documentación inicial |
| 2 | Modelo | Elaborar ERD, supuestos y modelo lógico | Andrés Gómez | `docs/documento_tecnico.md` |
| 3 | Integridad | Implementar DDL, claves, restricciones y triggers | Andrés Gómez | `sql/01_ddl.sql` |
| 4 | Datos y vistas | Cargar dataset sintético y crear cinco vistas | Andrés Gómez | `sql/02_datos_prueba.sql`, `sql/03_vistas.sql` |
| 5 | Consultas | Implementar y validar las quince consultas | Andrés Gómez | `sql/06_consultas.sql` |
| 6 | DML y privilegios | Probar ciclo de vida, errores, borrados y roles | Andrés Gómez | `sql/04_dml_pruebas.sql`, `sql/05_privilegios.sql` |
| 7 | Revisión | Ejecutar todo en el servidor, corregir inconsistencias y capturar evidencias | Andrés Gómez | capturas/resultados de SQL Developer |
| 8 | Entrega | Revisar rúbrica, actualizar changelog y preparar sustentación | Andrés Gómez | versión final y pull request |
| 9 | Entrega 3 | Implementar programación Oracle, aplicación funcional y reportes | Andrés Gómez | `sql/08_entrega3_*`, `app/`, pruebas y matriz |

Las semanas y actividades se deben ajustar a las fechas oficiales publicadas por el curso.

## Entrega 2 — ejecución y evidencias

La ampliación se trabaja en `feature/entrega-2`. Antes de solicitar el pull request se
deben ejecutar los scripts 08–14, capturar las ocho consultas avanzadas, probar los tres
roles con usuarios autorizados por el DBA y actualizar `CHANGELOG.md`.

## Entrega 3 — implementación básica (sin programación PL/SQL)

La Entrega 3 amplía con SQL básico y la aplicación local:

- catálogos de sedes, ciudades, estadios, selecciones, grupos, jugadores y cuerpo técnico;
- estadísticas individuales, incidencias, tabla de posiciones y auditoría MANUAL;
- operaciones equivalentes con SELECT/CASE/agregados: diferencia de gol, puntos,
  ranking top 10, recálculo de posiciones con INSERT SELECT y cierre de fase;
- 6 vistas de reportes (sin ventanas) + auditoría con INSERT manual;
- panel web local en `app/index.html` con CRUD, registro de partidos y filtros de reportes.

### Ejecución Oracle

Si la base de la Entrega 1 ya está instalada, ejecutar en SQL Developer con **Run Script
(F5)**:

> La base debe incluir `sql/03_vistas.sql`, porque el paquete de posiciones y
> los reportes reutilizan `VW_TABLA_POSICIONES` y `VW_MARCADOR_PARTIDOS`.

1. `sql/08_entrega3_ampliacion.sql`
2. `sql/09_entrega3_datos.sql`
3. `sql/10_entrega3_programacion.sql`
4. `sql/11_entrega3_reportes.sql`
5. `sql/12_entrega3_pruebas.sql`
6. `sql/13_entrega3_verificacion.sql`

Los scripts 08 y 09 son estructura y carga inicial de una sola ejecución. No incluyen
credenciales. Las salidas de los scripts 12 y 13 sirven como evidencia de
operaciones básicas, reportes y coherencia de datos (sin funciones ni triggers).

### Aplicación

Abrir `app/index.html` en un navegador moderno. La demostración funciona sin instalar
dependencias y conserva los cambios en `localStorage`; `app/README.md` documenta la
correspondencia con las vistas Oracle y las operaciones del script 10.
