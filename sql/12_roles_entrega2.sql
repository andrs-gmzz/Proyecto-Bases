-- Entrega 2 BASICA - Roles y privilegios (solo GRANT/REVOKE)
-- Solo usa CREATE ROLE, GRANT y REVOKE (tema 8). Sin PL/SQL.
-- Ejecutar como propietario. Si los roles ya existen, comentar CREATE ROLE.
-- No contiene contrasenas ni crea usuarios reales.

SET DEFINE OFF;

CREATE ROLE rol_fifa_e2_admin_torneo;
CREATE ROLE rol_fifa_e2_analista_dep;
CREATE ROLE rol_fifa_e2_auditor_consulta;

------------------------------------------------------------------------
-- 1. Administrador del Torneo: gestiona E1 + E2, auditoria solo lectura.
------------------------------------------------------------------------

GRANT SELECT, INSERT, UPDATE, DELETE ON edicion_mundial TO rol_fifa_e2_admin_torneo;
GRANT SELECT, INSERT, UPDATE, DELETE ON estadio TO rol_fifa_e2_admin_torneo;
GRANT SELECT, INSERT, UPDATE, DELETE ON seleccion TO rol_fifa_e2_admin_torneo;
GRANT SELECT, INSERT, UPDATE, DELETE ON partido TO rol_fifa_e2_admin_torneo;
GRANT SELECT, INSERT, UPDATE, DELETE ON participacion_partido TO rol_fifa_e2_admin_torneo;
GRANT SELECT, INSERT, UPDATE, DELETE ON pais_sede_e2 TO rol_fifa_e2_admin_torneo;
GRANT SELECT, INSERT, UPDATE, DELETE ON edicion_pais_e2 TO rol_fifa_e2_admin_torneo;
GRANT SELECT, INSERT, UPDATE, DELETE ON ciudad_e2 TO rol_fifa_e2_admin_torneo;
GRANT SELECT, INSERT, UPDATE, DELETE ON estadio_ciudad_e2 TO rol_fifa_e2_admin_torneo;
GRANT SELECT, INSERT, UPDATE, DELETE ON fase_e2 TO rol_fifa_e2_admin_torneo;
GRANT SELECT, INSERT, UPDATE, DELETE ON partido_fase_e2 TO rol_fifa_e2_admin_torneo;
GRANT SELECT, INSERT, UPDATE, DELETE ON grupo_e2 TO rol_fifa_e2_admin_torneo;
GRANT SELECT, INSERT, UPDATE, DELETE ON inscripcion_grupo_e2 TO rol_fifa_e2_admin_torneo;
GRANT SELECT, INSERT, UPDATE, DELETE ON posicion_jugador_e2 TO rol_fifa_e2_admin_torneo;
GRANT SELECT, INSERT, UPDATE, DELETE ON jugador_e2 TO rol_fifa_e2_admin_torneo;
GRANT SELECT, INSERT, UPDATE, DELETE ON convocatoria_e2 TO rol_fifa_e2_admin_torneo;
GRANT SELECT, INSERT, UPDATE, DELETE ON convocatoria_jugador_e2 TO rol_fifa_e2_admin_torneo;
GRANT SELECT, INSERT, UPDATE, DELETE ON arbitro_e2 TO rol_fifa_e2_admin_torneo;
GRANT SELECT, INSERT, UPDATE, DELETE ON rol_arbitral_e2 TO rol_fifa_e2_admin_torneo;
GRANT SELECT, INSERT, UPDATE, DELETE ON asignacion_arbitral_e2 TO rol_fifa_e2_admin_torneo;
GRANT SELECT, INSERT, UPDATE, DELETE ON tipo_evento_e2 TO rol_fifa_e2_admin_torneo;
GRANT SELECT, INSERT, UPDATE, DELETE ON evento_partido_e2 TO rol_fifa_e2_admin_torneo;
GRANT SELECT, INSERT, UPDATE, DELETE ON estadistica_jugador_e2 TO rol_fifa_e2_admin_torneo;
GRANT SELECT, INSERT, UPDATE, DELETE ON tipo_incidencia_e2 TO rol_fifa_e2_admin_torneo;
GRANT SELECT, INSERT, UPDATE, DELETE ON incidencia_e2 TO rol_fifa_e2_admin_torneo;

GRANT SELECT ON auditoria_e2 TO rol_fifa_e2_admin_torneo;
GRANT SELECT ON vw_e2_rendimiento_jugador TO rol_fifa_e2_admin_torneo;
GRANT SELECT ON vw_e2_tabla_grupo TO rol_fifa_e2_admin_torneo;
GRANT SELECT ON vw_e2_indicadores_edicion TO rol_fifa_e2_admin_torneo;
GRANT SELECT ON vw_e2_arbitraje TO rol_fifa_e2_admin_torneo;
GRANT SELECT ON vw_e2_fase_operativa TO rol_fifa_e2_admin_torneo;

------------------------------------------------------------------------
-- 2. Analista Deportivo: solo consulta vistas (sin DML).
------------------------------------------------------------------------

GRANT SELECT ON vw_e2_rendimiento_jugador TO rol_fifa_e2_analista_dep;
GRANT SELECT ON vw_e2_tabla_grupo TO rol_fifa_e2_analista_dep;
GRANT SELECT ON vw_e2_indicadores_edicion TO rol_fifa_e2_analista_dep;
GRANT SELECT ON vw_e2_arbitraje TO rol_fifa_e2_analista_dep;
GRANT SELECT ON vw_e2_fase_operativa TO rol_fifa_e2_analista_dep;
GRANT SELECT ON vw_marcador_partidos TO rol_fifa_e2_analista_dep;
GRANT SELECT ON vw_tabla_posiciones TO rol_fifa_e2_analista_dep;
GRANT SELECT ON vw_goleadores_sel TO rol_fifa_e2_analista_dep;

------------------------------------------------------------------------
-- 3. Auditor: solo indicadores y auditoria (sin tablas operativas).
------------------------------------------------------------------------

GRANT SELECT ON vw_e2_auditoria_consulta TO rol_fifa_e2_auditor_consulta;
GRANT SELECT ON vw_e2_indicadores_edicion TO rol_fifa_e2_auditor_consulta;
GRANT SELECT ON vw_e2_fase_operativa TO rol_fifa_e2_auditor_consulta;

------------------------------------------------------------------------
-- 4. Evidencia de privilegios del esquema propietario.
------------------------------------------------------------------------

SELECT grantee, table_name, privilege
  FROM user_tab_privs_made
 WHERE grantee IN (
           'ROL_FIFA_E2_ADMIN_TORNEO',
           'ROL_FIFA_E2_ANALISTA_DEP',
           'ROL_FIFA_E2_AUDITOR_CONSULTA'
       )
 ORDER BY grantee, table_name, privilege;

-- Pruebas manuales (las hace el DBA con usuarios reales):
-- GRANT rol_fifa_e2_admin_torneo TO usuario_admin_e2;     -- INSERT/UPDATE/DELETE en INCIDENCIA_E2: OK
-- GRANT rol_fifa_e2_analista_dep TO usuario_analista_e2;  -- SELECT vistas: OK / INSERT PARTIDO: ORA-01031
-- GRANT rol_fifa_e2_auditor_consulta TO usuario_auditor;  -- SELECT auditoria: OK / SELECT JUGADOR_E2: ORA-00942
