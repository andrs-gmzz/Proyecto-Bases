-- Entrega 1 BASICA - Las quince consultas solicitadas
-- Solo usa: SELECT, JOINS (JOIN y LEFT JOIN), WHERE, GROUP BY, HAVING,
-- ORDER BY, agregados (COUNT, SUM, AVG, MAX, MIN) y subconsultas
-- (IN, EXISTS, NOT EXISTS, = y > con SELECT). Reutiliza las 5 vistas.
-- NO usa WITH, ni funciones de ventana (DENSE_RANK/OVER), ni PL/SQL.
-- Dataset de referencia: edicion con anio = 2026.

SET DEFINE OFF;

------------------------------------------------------------------------
-- 1. Top 5 selecciones con mas goles en 2026 (ORDER BY + limite basico).
------------------------------------------------------------------------

SELECT anio, id_seleccion, pais, confederacion, goles_marcados
  FROM vw_goleadores_sel
 WHERE anio = 2026
 ORDER BY goles_marcados DESC, pais
 FETCH FIRST 5 ROWS ONLY;

------------------------------------------------------------------------
-- 2. Porcentaje de ocupacion por estadio (reutiliza la vista).
------------------------------------------------------------------------

SELECT anio, id_estadio, estadio, ciudad, capacidad,
       partidos_albergados, asistencia_total, ocupacion_promedio_pct
  FROM vw_ocupacion_estadio
 WHERE anio = 2026
 ORDER BY ocupacion_promedio_pct DESC, estadio;

------------------------------------------------------------------------
-- 3. Selecciones con mayor diferencia de gol (subconsulta no correlacionada con MAX).
------------------------------------------------------------------------

SELECT t.anio, t.id_seleccion, t.pais, t.goles_favor,
       t.goles_contra, t.diferencia_goles
  FROM vw_tabla_posiciones t
 WHERE t.anio = 2026
   AND t.diferencia_goles = (
        SELECT MAX(t2.diferencia_goles)
          FROM vw_tabla_posiciones t2
         WHERE t2.anio = 2026
       )
 ORDER BY t.pais;

------------------------------------------------------------------------
-- 4. Cantidad de partidos por fase (JOIN + GROUP BY).
------------------------------------------------------------------------

SELECT e.anio, p.fase, COUNT(*) AS cantidad_partidos
  FROM partido p
  JOIN edicion_mundial e
    ON e.id_edicion = p.id_edicion
 WHERE e.anio = 2026
 GROUP BY e.anio, p.fase
 ORDER BY
       CASE p.fase
           WHEN 'FASE DE GRUPOS' THEN 1
           WHEN 'DIECISEISAVOS' THEN 2
           WHEN 'OCTAVOS' THEN 3
           WHEN 'CUARTOS' THEN 4
           WHEN 'SEMIFINALES' THEN 5
           WHEN 'TERCER PUESTO' THEN 6
           WHEN 'FINAL' THEN 7
       END;

------------------------------------------------------------------------
-- 5. Por cada edicion, estadio(s) con mayor cantidad de partidos.
-- Version basica: subconsulta en el FROM + MAX correlacionado (sin WITH ni ventana).
------------------------------------------------------------------------

SELECT c.anio, c.id_estadio, c.estadio, c.partidos_albergados
  FROM (
        SELECT e.anio, es.id_estadio, es.nombre AS estadio,
               COUNT(p.id_partido) AS partidos_albergados
          FROM edicion_mundial e
          JOIN estadio es
            ON es.id_edicion = e.id_edicion
          LEFT JOIN partido p
            ON p.id_estadio = es.id_estadio
         GROUP BY e.anio, es.id_estadio, es.nombre
       ) c
 WHERE c.partidos_albergados = (
        SELECT MAX(c2.partidos_albergados)
          FROM (
                SELECT e2.anio, es2.id_estadio,
                       COUNT(p2.id_partido) AS partidos_albergados
                  FROM edicion_mundial e2
                  JOIN estadio es2
                    ON es2.id_edicion = e2.id_edicion
                  LEFT JOIN partido p2
                    ON p2.id_estadio = es2.id_estadio
                 GROUP BY e2.anio, es2.id_estadio
               ) c2
         WHERE c2.anio = c.anio
       )
 ORDER BY c.anio, c.estadio;

------------------------------------------------------------------------
-- 6. Patrones atipicos: 0-0 o al menos ocho goles (reutiliza la vista).
------------------------------------------------------------------------

SELECT id_partido, anio, fase, estadio, seleccion_local,
       seleccion_visitante, goles_local, goles_visitante,
       goles_totales, asistencia_registrada
  FROM vw_partidos_atipicos
 WHERE anio = 2026
 ORDER BY goles_totales DESC, id_partido;

------------------------------------------------------------------------
-- 7. Selecciones invictas (EXISTS + NOT EXISTS, subconsultas correlacionadas).
------------------------------------------------------------------------

SELECT e.anio, s.id_seleccion, s.pais, s.confederacion
  FROM seleccion s
  JOIN edicion_mundial e
    ON e.id_edicion = s.id_edicion
 WHERE e.anio = 2026
   AND EXISTS (
        SELECT 1
          FROM participacion_partido pp
          JOIN partido p
            ON p.id_partido = pp.id_partido
         WHERE pp.id_seleccion = s.id_seleccion
           AND p.estado_partido = 'FINALIZADO'
       )
   AND NOT EXISTS (
        SELECT 1
          FROM participacion_partido pp
          JOIN partido p
            ON p.id_partido = pp.id_partido
         WHERE pp.id_seleccion = s.id_seleccion
           AND p.estado_partido = 'FINALIZADO'
           AND pp.resultado = 'PERDIO'
       )
 ORDER BY s.pais;

------------------------------------------------------------------------
-- 8. Estadios por encima del promedio de ocupacion (subconsulta con AVG).
------------------------------------------------------------------------

SELECT v.anio, v.id_estadio, v.estadio, v.ciudad,
       v.ocupacion_promedio_pct
  FROM vw_ocupacion_estadio v
 WHERE v.anio = 2026
   AND v.ocupacion_promedio_pct > (
        SELECT AVG(v2.ocupacion_promedio_pct)
          FROM vw_ocupacion_estadio v2
         WHERE v2.anio = v.anio
       )
 ORDER BY v.ocupacion_promedio_pct DESC, v.estadio;

------------------------------------------------------------------------
-- 9. Partido(s) con mayor marcador combinado por estadio.
-- Version basica: subconsulta correlacionada con MAX (sin ventana).
------------------------------------------------------------------------

SELECT v.id_estadio, v.estadio, v.anio, v.id_partido, v.fase,
       v.seleccion_local, v.seleccion_visitante,
       v.goles_local, v.goles_visitante,
       v.goles_local + v.goles_visitante AS goles_totales
  FROM vw_marcador_partidos v
 WHERE v.anio = 2026
   AND v.estado_partido = 'FINALIZADO'
   AND (v.goles_local + v.goles_visitante) = (
        SELECT MAX(v2.goles_local + v2.goles_visitante)
          FROM vw_marcador_partidos v2
         WHERE v2.anio = 2026
           AND v2.estado_partido = 'FINALIZADO'
           AND v2.id_estadio = v.id_estadio
       )
 ORDER BY v.estadio, v.id_partido;

------------------------------------------------------------------------
-- 10. Selecciones que jugaron todos sus partidos como LOCAL, o ninguno
-- (GROUP BY + HAVING con SUM y CASE, agregacion basica).
------------------------------------------------------------------------

SELECT e.anio, s.id_seleccion, s.pais,
       COUNT(*) AS partidos_jugados,
       SUM(CASE WHEN pp.condicion = 'LOCAL' THEN 1 ELSE 0 END) AS partidos_como_local
  FROM seleccion s
  JOIN edicion_mundial e
    ON e.id_edicion = s.id_edicion
  JOIN participacion_partido pp
    ON pp.id_seleccion = s.id_seleccion
  JOIN partido p
    ON p.id_partido = pp.id_partido
   AND p.estado_partido = 'FINALIZADO'
 WHERE e.anio = 2026
 GROUP BY e.anio, s.id_seleccion, s.pais
HAVING SUM(CASE WHEN pp.condicion = 'LOCAL' THEN 1 ELSE 0 END) = COUNT(*)
    OR SUM(CASE WHEN pp.condicion = 'LOCAL' THEN 1 ELSE 0 END) = 0
 ORDER BY s.pais;

------------------------------------------------------------------------
-- 11. Selecciones por encima del promedio de diferencia de gol.
------------------------------------------------------------------------

SELECT t.anio, t.id_seleccion, t.pais, t.diferencia_goles
  FROM vw_tabla_posiciones t
 WHERE t.anio = 2026
   AND t.diferencia_goles > (
        SELECT AVG(t2.diferencia_goles)
          FROM vw_tabla_posiciones t2
         WHERE t2.anio = 2026
       )
 ORDER BY t.diferencia_goles DESC, t.pais;

------------------------------------------------------------------------
-- 12. Goles en fase de grupos frente a fase eliminatoria (SUM con CASE).
------------------------------------------------------------------------

SELECT e.anio, s.id_seleccion, s.pais,
       SUM(CASE WHEN p.fase = 'FASE DE GRUPOS' THEN pp.goles_marcados ELSE 0 END) AS goles_fase_grupos,
       SUM(CASE WHEN p.fase <> 'FASE DE GRUPOS' THEN pp.goles_marcados ELSE 0 END) AS goles_fase_eliminatoria
  FROM seleccion s
  JOIN edicion_mundial e
    ON e.id_edicion = s.id_edicion
  JOIN participacion_partido pp
    ON pp.id_seleccion = s.id_seleccion
  JOIN partido p
    ON p.id_partido = pp.id_partido
 WHERE e.anio = 2026
   AND p.estado_partido = 'FINALIZADO'
 GROUP BY e.anio, s.id_seleccion, s.pais
 ORDER BY s.pais;

------------------------------------------------------------------------
-- 13. Estadios con partidos en mas de una fase (HAVING con COUNT DISTINCT).
------------------------------------------------------------------------

SELECT e.anio, es.id_estadio, es.nombre AS estadio,
       COUNT(DISTINCT p.fase) AS fases_distintas
  FROM edicion_mundial e
  JOIN estadio es
    ON es.id_edicion = e.id_edicion
  JOIN partido p
    ON p.id_estadio = es.id_estadio
 WHERE e.anio = 2026
 GROUP BY e.anio, es.id_estadio, es.nombre
HAVING COUNT(DISTINCT p.fase) > 1
 ORDER BY fases_distintas DESC, estadio;

------------------------------------------------------------------------
-- 14. Verificacion de participaciones duplicadas (debe dar cero filas
-- por el UNIQUE(id_partido,id_seleccion)).
------------------------------------------------------------------------

SELECT id_partido, id_seleccion, COUNT(*) AS cantidad
  FROM participacion_partido
 GROUP BY id_partido, id_seleccion
HAVING COUNT(*) > 1
 ORDER BY id_partido, id_seleccion;

------------------------------------------------------------------------
-- 15. Seleccion lider de cada edicion por puntos (version basica).
-- Simplificacion declarada: sin funciones de ventana, el lider es quien
-- iguala el MAX de puntos de su edicion. El desempate por diferencia y
-- goles se muestra en el ORDER BY para lectura, no como filtro.
-- Reutiliza VW_TABLA_POSICIONES.
------------------------------------------------------------------------

SELECT v.anio, v.id_seleccion, v.pais, v.puntos, v.victorias, v.empates,
       v.derrotas, v.goles_favor, v.goles_contra, v.diferencia_goles
  FROM vw_tabla_posiciones v
 WHERE v.puntos = (
        SELECT MAX(v2.puntos)
          FROM vw_tabla_posiciones v2
         WHERE v2.anio = v.anio
       )
 ORDER BY v.anio, v.diferencia_goles DESC, v.goles_favor DESC, v.pais;
