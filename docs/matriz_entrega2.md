# Matriz de trazabilidad — Entrega 2 BASICA (solo temas vistos)

| Criterio | Peso | Implementación básica | Evidencia requerida |
|---|---:|---|---|
| Consultas | 25% | `sql/11_consultas_entrega2.sql`: ocho consultas con JOIN, subconsultas, agregados y vistas (sin WITH ni ventanas) | Resultados ejecutados en Oracle |
| Modelo | 25% | `sql/08_ddl_entrega2.sql` y `docs/documento_entrega2.md`: grupos, jugadores, convocatorias, árbitros, eventos, incidencias y auditoría MANUAL con FK simples | DDL sin errores, ERD y explicación básica |
| Roles y privilegios | 20% | `sql/12_roles_entrega2.sql`: administrador, analista y auditor con solo GRANT/REVOKE | Consultas permitidas y denegadas en sesiones separadas |
| Pruebas | 10% | `sql/13_pruebas_entrega2.sql`: DML + SELECT y 4 casos fallidos comentados (UNIQUE/CHECK/FK) | SELECT de verificación y errores ORA al descomentar |
| Git y organización | 20% | `README.md`, `CHANGELOG.md`, commits y pull request | Historial semanal visible en GitHub |

## Criterio de completitud

La Entrega 2 no debe marcarse como finalizada hasta que:

- Se ejecuten los scripts 08–14 sobre la Entrega 1 BASICA.
- Todas las consultas de `sql/14_verificacion_entrega2.sql` den los conteos
  esperados (5/5/5/4/8/4/10/20/10/20/12/8/12/4/4) y cero filas en las reglas.
- Se guarden los resultados de las ocho consultas básicas.
- Se prueben los tres roles con usuarios autorizados por el DBA.
- Se documenten los casos exitosos y fallidos con resultado esperado y obtenido.
- Se actualicen el `CHANGELOG.md`, la rama y el pull request correspondiente.

> Sin triggers, secuencias, PL/SQL, WITH ni ventanas (temas no vistos).
> La auditoría es manual: cada incidencia lleva su INSERT en `AUDITORIA_E2`.
