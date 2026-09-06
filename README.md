# Proyecto FIFA — Entrega 1

Sistema de información para la gestión de una Copa Mundial de la FIFA.

## Información del equipo

- Integrante: Andrés Gómez
- Curso: Bases de Datos
- Entrega: 1 — Modelo relacional, SQL e integridad sobre el modelo inicial
- Motor: Oracle Database
- Cliente: Oracle SQL Developer
- Esquema: `<SCHEMA_DEL_CURSO>`

## Alcance de esta entrega

La Entrega 1 se implementa sobre el modelo genérico inicial de cinco entidades:

1. `EDICION_MUNDIAL`
2. `ESTADIO`
3. `SELECCION`
4. `PARTIDO`
5. `PARTICIPACION_PARTIDO`

Se agregan únicamente ajustes menores necesarios para cumplir las consultas y reglas
solicitadas: asistencia registrada, estado del partido, resultado de cada participación y
claves compuestas de consistencia entre edición y sus entidades dependientes. Jugadores,
árbitros, grupos, estadísticas detalladas, boletería, prensa e incidencias se presentan como
evolución propuesta en la evaluación crítica, pero se implementarán en entregas posteriores.

## Estructura prevista del repositorio

```text
.
├── README.md
├── CHANGELOG.md
├── docs/
│   ├── documento_tecnico.md
│   ├── algebra_relacional.md
│   └── matriz_rubrica.md
└── sql/
    ├── 01_ddl.sql
    ├── 02_datos_prueba.sql
    ├── 03_vistas.sql
    ├── 04_dml_pruebas.sql
    ├── 05_privilegios.sql
    ├── 06_consultas.sql
    └── 07_verificacion.sql
```

En este primer avance solo se publican `README.md`, `CHANGELOG.md` y `.gitignore`.
Los documentos técnicos y scripts SQL se incorporarán mediante commits posteriores para
que el progreso quede visible paso a paso.

La matriz de trazabilidad de la rúbrica se incorporará junto con el primer avance técnico
de documentación.

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
- Oracle no implementa `ON UPDATE CASCADE` en claves foráneas. El documento técnico
  explica esta limitación y la decisión de usar `NO ACTION` implícito para preservar
  referencias.

## Flujo de trabajo Git

Aunque el trabajo sea individual, se conservará trazabilidad mediante ramas y pull
requests:

```text
main
├── feature/modelo-documental
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

Las semanas y actividades se deben ajustar a las fechas oficiales publicadas por el curso.
