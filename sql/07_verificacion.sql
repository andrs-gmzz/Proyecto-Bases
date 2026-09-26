-- Entrega 1 BASICA - Consultas de verificacion y evidencias
-- Solo usa SELECT, COUNT, GROUP BY y HAVING (temas 3, 4 y 5).
-- NO usa PL/SQL ni DBMS_OUTPUT.
-- Cada consulta con comentario "Debe dar cero filas" es una regla de
-- integridad verificada por consulta (en lugar de triggers, tema no visto).

SET DEFINE OFF;

------------------------------------------------------------------------
-- Conteo de filas por tabla.
-- Esperado: 2 ediciones, 5 estadios, 10 selecciones, 8 partidos,
-- 16 participaciones.
------------------------------------------------------------------------

SELECT 'EDICION_MUNDIAL' AS tabla, COUNT(*) AS cantidad
  FROM edicion_mundial
UNION ALL
SELECT 'ESTADIO', COUNT(*)
  FROM estadio
UNION ALL
SELECT 'SELECCION', COUNT(*)
  FROM seleccion
UNION ALL
SELECT 'PARTIDO', COUNT(*)
  FROM partido
UNION ALL
SELECT 'PARTICIPACION_PARTIDO', COUNT(*)
  FROM participacion_partido
ORDER BY tabla;

------------------------------------------------------------------------
-- Debe dar cero filas: todos los partidos tienen 2 participaciones.
------------------------------------------------------------------------

SELECT p.id_partido, COUNT(pp.id_participacion) AS cantidad
  FROM partido p
  LEFT JOIN participacion_partido pp
    ON pp.id_partido = p.id_partido
 GROUP BY p.id_partido
HAVING COUNT(pp.id_participacion) <> 2
 ORDER BY p.id_partido;

------------------------------------------------------------------------
-- Debe dar cero filas: sin condicion duplicada en un partido.
------------------------------------------------------------------------

SELECT id_partido, condicion, COUNT(*) AS cantidad
  FROM participacion_partido
 GROUP BY id_partido, condicion
HAVING COUNT(*) > 1
 ORDER BY id_partido, condicion;

------------------------------------------------------------------------
-- Debe dar cero filas: sin seleccion repetida en un partido.
------------------------------------------------------------------------

SELECT id_partido, id_seleccion, COUNT(*) AS cantidad
  FROM participacion_partido
 GROUP BY id_partido, id_seleccion
HAVING COUNT(*) > 1
 ORDER BY id_partido, id_seleccion;

------------------------------------------------------------------------
-- Debe dar cero filas: partidos dentro del rango de su edicion.
-- (Sin trigger, se verifica por consulta con JOIN basico.)
------------------------------------------------------------------------

SELECT p.id_partido, e.anio, p.fecha_hora
  FROM partido p
  JOIN edicion_mundial e
    ON e.id_edicion = p.id_edicion
 WHERE p.fecha_hora < e.fecha_inicio
    OR p.fecha_hora > e.fecha_fin
 ORDER BY p.id_partido;

------------------------------------------------------------------------
-- Debe dar cero filas: asistencia sin superar la capacidad.
------------------------------------------------------------------------

SELECT p.id_partido, es.nombre AS estadio,
       p.asistencia_registrada, es.capacidad
  FROM partido p
  JOIN estadio es
    ON es.id_estadio = p.id_estadio
 WHERE p.asistencia_registrada > es.capacidad
 ORDER BY p.id_partido;

------------------------------------------------------------------------
-- Debe dar cero filas: sin goles negativos (regla CHECK).
------------------------------------------------------------------------

SELECT id_participacion, id_partido, goles_marcados
  FROM participacion_partido
 WHERE goles_marcados < 0
 ORDER BY id_participacion;

------------------------------------------------------------------------
-- Conteo de registros de las cinco vistas.
------------------------------------------------------------------------

SELECT 'VW_MARCADOR_PARTIDOS' AS vista, COUNT(*) AS cantidad
  FROM vw_marcador_partidos
UNION ALL
SELECT 'VW_TABLA_POSICIONES', COUNT(*)
  FROM vw_tabla_posiciones
UNION ALL
SELECT 'VW_GOLEADORES_SEL', COUNT(*)
  FROM vw_goleadores_sel
UNION ALL
SELECT 'VW_OCUPACION_ESTADIO', COUNT(*)
  FROM vw_ocupacion_estadio
UNION ALL
SELECT 'VW_PARTIDOS_ATIPICOS', COUNT(*)
  FROM vw_partidos_atipicos
ORDER BY vista;
