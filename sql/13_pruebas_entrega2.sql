-- Entrega 2 BASICA - Casos de prueba (solo DML + SELECT)
-- Sin PL/SQL, sin SAVEPOINT, sin DBMS_OUTPUT.
-- Forma de uso:
--   1. Ejecutar cada bloque numerado en orden y su SELECT de verificacion.
--   2. Los CASOS FALLIDOS estan comentados: al descomentarlos Oracle debe
--      rechazarlos con ORA-00001 (UNIQUE), ORA-02290 (CHECK) u ORA-02291 (FK).
--   3. Al final se borran los datos temporales para no contaminar el dataset.

SET DEFINE OFF;

------------------------------------------------------------------------
-- OK-01: insertar una incidencia valida + su auditoria MANUAL.
------------------------------------------------------------------------

INSERT INTO incidencia_e2 (id_incidencia, id_partido, id_tipo_incidencia, minuto, descripcion, resuelta)
VALUES (990001, 5001, 1, 44, 'Caso exitoso temporal de Entrega 2', 'S');

INSERT INTO auditoria_e2 (id_auditoria, tabla_afectada, operacion, id_registro, usuario_bd, detalle)
VALUES (990001, 'INCIDENCIA_E2', 'INSERT', 990001, 'PROPIETARIO', 'Incidencia creada (prueba)');

-- Verificacion: la incidencia quedo auditada (debe dar 1 fila).
SELECT COUNT(*) AS auditoria_ok01
  FROM auditoria_e2
 WHERE tabla_afectada = 'INCIDENCIA_E2'
   AND operacion = 'INSERT'
   AND id_registro = 990001;

------------------------------------------------------------------------
-- OK-02: cada edicion tiene sus grupos (debe dar 4 grupos, 10 inscripciones).
------------------------------------------------------------------------

SELECT COUNT(*) AS grupos FROM grupo_e2;
SELECT COUNT(*) AS inscripciones FROM inscripcion_grupo_e2;

------------------------------------------------------------------------
-- FALLO-03: dorsal repetido en la misma convocatoria (debe dar ORA-00001).
------------------------------------------------------------------------

-- INSERT INTO convocatoria_jugador_e2 (id_convocatoria, id_jugador, dorsal, es_capitan)
-- VALUES (101, 1002, 10, 'N');

------------------------------------------------------------------------
-- FALLO-04: minutos negativos en estadistica (debe dar ORA-02290).
------------------------------------------------------------------------

-- UPDATE estadistica_jugador_e2 SET minutos = -1
--  WHERE id_partido = 5001 AND id_jugador = 1002;

------------------------------------------------------------------------
-- FALLO-05: fase con partido inexistente (debe dar ORA-02291).
------------------------------------------------------------------------

-- INSERT INTO partido_fase_e2 (id_partido, id_edicion, id_fase)
-- VALUES (999999, 1, 1);

------------------------------------------------------------------------
-- FALLO-06: evento fuera de rango (debe dar ORA-02290).
------------------------------------------------------------------------

-- INSERT INTO evento_partido_e2 (id_evento, id_partido, minuto, minuto_adicional, id_tipo_evento, id_seleccion, id_jugador, descripcion)
-- VALUES (999999, 5001, 131, 0, 1, 101, 1002, 'Evento fuera de rango');

------------------------------------------------------------------------
-- Limpieza: borrar los datos temporales de la prueba OK-01.
------------------------------------------------------------------------

DELETE FROM auditoria_e2 WHERE id_auditoria = 990001;
DELETE FROM incidencia_e2 WHERE id_incidencia = 990001;

-- Verificacion final: la incidencia temporal ya no existe (debe dar 0).
SELECT COUNT(*) AS limpieza_ok
  FROM incidencia_e2
 WHERE id_incidencia = 990001;

COMMIT;

-- Nota de roles: probar 12_roles_entrega2.sql en sesiones ADMIN/ANALISTA/AUDITOR
-- con usuarios del DBA (ver comentarios al final de ese script).
