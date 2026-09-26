-- Entrega 1 BASICA - DML, modificadores y comportamientos ON DELETE
-- Solo usa INSERT, UPDATE, DELETE y SELECT (tema 7-Modificadores).
-- NO usa PL/SQL, ni SAVEPOINT, ni DBMS_OUTPUT, ni manejo de excepciones.
-- Forma de uso en clase:
--   1. Ejecutar los PASOS 1 a 4 en orden (ciclo de vida de un partido).
--   2. Ejecutar cada SELECT de verificacion para ver el resultado.
--   3. Los CASOS INVALIDOS estan comentados: al descomentar cada uno,
--      Oracle debe rechazarlo con error de CHECK, UNIQUE o FK.
--      Asi se demuestra la integridad sin usar triggers ni PL/SQL.

SET DEFINE OFF;

------------------------------------------------------------------------
-- PASO 1: crear un partido de prueba en estado PROGRAMADO.
------------------------------------------------------------------------

INSERT INTO partido (id_partido, id_edicion, id_estadio, fecha_hora, fase, asistencia_registrada, estado_partido)
VALUES (990000, 1, 1001, TO_DATE('2026-07-10 18:00', 'YYYY-MM-DD HH24:MI'), 'FASE DE GRUPOS', 30000, 'PROGRAMADO');

-- Verificacion: el partido existe y esta programado.
SELECT id_partido, fase, asistencia_registrada, estado_partido
  FROM partido
 WHERE id_partido = 990000;

------------------------------------------------------------------------
-- PASO 2: registrar sus dos participaciones (dos INSERT simples).
------------------------------------------------------------------------

INSERT INTO participacion_partido (id_participacion, id_partido, id_seleccion, condicion, goles_marcados, resultado)
VALUES (9900001, 990000, 101, 'LOCAL', 0, 'EMPATO');

INSERT INTO participacion_partido (id_participacion, id_partido, id_seleccion, condicion, goles_marcados, resultado)
VALUES (9900002, 990000, 102, 'VISITANTE', 0, 'EMPATO');

-- Verificacion: el partido tiene exactamente 2 participaciones.
SELECT id_partido, COUNT(*) AS participaciones
  FROM participacion_partido
 WHERE id_partido = 990000
 GROUP BY id_partido;

------------------------------------------------------------------------
-- PASO 3: actualizar el marcador (UPDATE basico).
------------------------------------------------------------------------

UPDATE participacion_partido SET goles_marcados = 2, resultado = 'GANO'
 WHERE id_participacion = 9900001;

UPDATE participacion_partido SET goles_marcados = 1, resultado = 'PERDIO'
 WHERE id_participacion = 9900002;

-- Verificacion del marcador.
SELECT id_seleccion, condicion, goles_marcados, resultado
  FROM participacion_partido
 WHERE id_partido = 990000
 ORDER BY condicion;

------------------------------------------------------------------------
-- PASO 4: cerrar el partido (UPDATE de estado).
------------------------------------------------------------------------

UPDATE partido SET estado_partido = 'FINALIZADO'
 WHERE id_partido = 990000;

SELECT id_partido, estado_partido
  FROM partido
 WHERE id_partido = 990000;

------------------------------------------------------------------------
-- CASOS INVALIDOS (descomentar uno por uno para ver el error de Oracle).
-- Cada uno demuestra una restriccion CHECK, UNIQUE o FK del DDL basico.
------------------------------------------------------------------------

-- CASO 1: gol negativo (debe fallar por CK_PP_GOLES).
-- UPDATE participacion_partido SET goles_marcados = -1 WHERE id_participacion = 9900001;

-- CASO 2: tercera participacion con condicion repetida (debe fallar por UQ_PP_PARTIDO_CONDICION).
-- INSERT INTO participacion_partido (id_participacion, id_partido, id_seleccion, condicion, goles_marcados, resultado)
-- VALUES (9900003, 990000, 103, 'LOCAL', 0, 'EMPATO');

-- CASO 3: misma seleccion dos veces en el partido (debe fallar por UQ_PP_PARTIDO_SELECCION).
-- INSERT INTO participacion_partido (id_participacion, id_partido, id_seleccion, condicion, goles_marcados, resultado)
-- VALUES (9900004, 990000, 101, 'VISITANTE', 0, 'EMPATO');

-- CASO 4: asistencia negativa (debe fallar por CK_PARTIDO_ASISTENCIA).
-- UPDATE partido SET asistencia_registrada = -5 WHERE id_partido = 990000;

-- CASO 5: fase no permitida (debe fallar por CK_PARTIDO_FASE).
-- UPDATE partido SET fase = 'FASE INVENTADA' WHERE id_partido = 990000;

-- CASO 6: seleccion inexistente (debe fallar por FK_PP_SELECCION).
-- INSERT INTO participacion_partido (id_participacion, id_partido, id_seleccion, condicion, goles_marcados, resultado)
-- VALUES (9900005, 990000, 999999, 'VISITANTE', 0, 'EMPATO');

------------------------------------------------------------------------
-- PRUEBA ON DELETE CASCADE: al borrar el partido se borran sus hijas.
------------------------------------------------------------------------

DELETE FROM partido WHERE id_partido = 990000;

-- Verificacion: debe dar cero filas (las 2 participaciones se borraron en cascada).
SELECT COUNT(*) AS participaciones_restantes
  FROM participacion_partido
 WHERE id_partido = 990000;

------------------------------------------------------------------------
-- PRUEBA NO ACTION (comportamiento por defecto): una seleccion con
-- historial no se puede borrar. La siguiente sentencia debe fallar
-- con ORA-02292 (hija existente). Se deja comentada para no detener el script.
------------------------------------------------------------------------

-- DELETE FROM seleccion WHERE id_seleccion = 101;

-- Verificacion: la seleccion 101 sigue existiendo.
SELECT id_seleccion, pais FROM seleccion WHERE id_seleccion = 101;

COMMIT;
