-- Entrega 1 - Las quince consultas solicitadas
-- Dataset de referencia: edición con anio = 2026.
-- Ejecutar después de sql/02_datos_prueba.sql y sql/03_vistas.sql.

SET DEFINE OFF;

------------------------------------------------------------------------
-- 1. Top 5 selecciones con más goles marcados en 2026.
------------------------------------------------------------------------

SELECT anio, id_seleccion, pais, confederacion, goles_marcados
  FROM (
        SELECT anio, id_seleccion, pais, confederacion, goles_marcados
          FROM vw_goleadores_sel
         WHERE anio = 2026
         ORDER BY goles_marcados DESC, pais
       )
 WHERE ROWNUM <= 5;

------------------------------------------------------------------------
-- 2. Porcentaje de ocupación estimado por estadio.
-- Reutiliza VW_OCUPACION_ESTADIO.
------------------------------------------------------------------------

SELECT anio, id_estadio, estadio, ciudad, capacidad,
       partidos_albergados, asistencia_total, ocupacion_promedio_pct
  FROM vw_ocupacion_estadio
 WHERE anio = 2026
 ORDER BY ocupacion_promedio_pct DESC, estadio;

------------------------------------------------------------------------
-- 3. Selecciones con mayor diferencia de gol.
-- Subconsulta no correlacionada para obtener el máximo.
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
-- 4. Cantidad de partidos por fase.
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
-- 5. Para cada edición, estadio(s) con mayor cantidad de partidos.
-- LEFT JOIN conserva estadios sin partidos.
------------------------------------------------------------------------

WITH conteos AS (
    SELECT e.anio, e.id_edicion, es.id_estadio, es.nombre AS estadio,
           COUNT(p.id_partido) AS partidos_albergados
      FROM edicion_mundial e
      JOIN estadio es
        ON es.id_edicion = e.id_edicion
      LEFT JOIN partido p
        ON p.id_estadio = es.id_estadio
       AND p.id_edicion = es.id_edicion
     GROUP BY e.anio, e.id_edicion, es.id_estadio, es.nombre
),
ranking AS (
    SELECT c.*,
           DENSE_RANK() OVER (
               PARTITION BY c.id_edicion
               ORDER BY c.partidos_albergados DESC
           ) AS posicion
      FROM conteos c
)
SELECT anio, id_edicion, id_estadio, estadio, partidos_albergados
  FROM ranking
 WHERE posicion = 1
 ORDER BY anio, estadio;

------------------------------------------------------------------------
-- 6. Patrones atípicos: 0-0 o al menos ocho goles combinados.
------------------------------------------------------------------------

SELECT id_partido, anio, fase, estadio, seleccion_local,
       seleccion_visitante, goles_local, goles_visitante,
       goles_totales, asistencia_registrada
  FROM vw_partidos_atipicos
 WHERE anio = 2026
 ORDER BY goles_totales DESC, id_partido;

------------------------------------------------------------------------
-- 7. Selecciones invictas.
-- Incluye NOT EXISTS y EXISTS para no considerar selecciones sin partidos.
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
           AND p.id_edicion = pp.id_edicion
         WHERE pp.id_seleccion = s.id_seleccion
           AND pp.id_edicion = s.id_edicion
           AND p.estado_partido = 'FINALIZADO'
       )
   AND NOT EXISTS (
        SELECT 1
          FROM participacion_partido pp
          JOIN partido p
            ON p.id_partido = pp.id_partido
           AND p.id_edicion = pp.id_edicion
         WHERE pp.id_seleccion = s.id_seleccion
           AND pp.id_edicion = s.id_edicion
           AND p.estado_partido = 'FINALIZADO'
           AND pp.resultado = 'PERDIO'
       )
 ORDER BY s.pais;

------------------------------------------------------------------------
-- 8. Estadios por encima del promedio general de ocupación.
-- La subconsulta referencia el año de la fila exterior.
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
------------------------------------------------------------------------

WITH marcadores AS (
    SELECT v.id_estadio, v.estadio, v.anio, v.id_partido, v.fase,
           v.seleccion_local, v.seleccion_visitante,
           v.goles_local, v.goles_visitante,
           v.goles_local + v.goles_visitante AS goles_totales
      FROM vw_marcador_partidos v
     WHERE v.anio = 2026
       AND v.estado_partido = 'FINALIZADO'
),
ranking AS (
    SELECT m.*,
           DENSE_RANK() OVER (
               PARTITION BY m.id_estadio
               ORDER BY m.goles_totales DESC
           ) AS posicion
      FROM marcadores m
)
SELECT id_estadio, estadio, anio, id_partido, fase,
       seleccion_local, seleccion_visitante,
       goles_local, goles_visitante, goles_totales
  FROM ranking
 WHERE posicion = 1
 ORDER BY estadio, id_partido;

------------------------------------------------------------------------
-- 10. Selecciones que jugaron todos sus partidos como LOCAL, o ninguno.
------------------------------------------------------------------------

SELECT e.anio, s.id_seleccion, s.pais,
       COUNT(*) AS partidos_jugados,
       SUM(CASE WHEN pp.condicion = 'LOCAL' THEN 1 ELSE 0 END)
           AS partidos_como_local
  FROM seleccion s
  JOIN edicion_mundial e
    ON e.id_edicion = s.id_edicion
  JOIN participacion_partido pp
    ON pp.id_seleccion = s.id_seleccion
   AND pp.id_edicion = s.id_edicion
  JOIN partido p
    ON p.id_partido = pp.id_partido
   AND p.id_edicion = pp.id_edicion
   AND p.estado_partido = 'FINALIZADO'
 WHERE e.anio = 2026
 GROUP BY e.anio, s.id_seleccion, s.pais
HAVING SUM(CASE WHEN pp.condicion = 'LOCAL' THEN 1 ELSE 0 END) = COUNT(*)
    OR SUM(CASE WHEN pp.condicion = 'LOCAL' THEN 1 ELSE 0 END) = 0
 ORDER BY s.pais;

------------------------------------------------------------------------
-- 11. Selecciones por encima del promedio general de diferencia de gol.
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
-- 12. Comparación de goles en fase de grupos frente a fase eliminatoria.
------------------------------------------------------------------------

SELECT e.anio, s.id_seleccion, s.pais,
       SUM(CASE
               WHEN p.fase = 'FASE DE GRUPOS'
               THEN pp.goles_marcados
               ELSE 0
           END) AS goles_fase_grupos,
       SUM(CASE
               WHEN p.fase <> 'FASE DE GRUPOS'
               THEN pp.goles_marcados
               ELSE 0
           END) AS goles_fase_eliminatoria
  FROM seleccion s
  JOIN edicion_mundial e
    ON e.id_edicion = s.id_edicion
  JOIN participacion_partido pp
    ON pp.id_seleccion = s.id_seleccion
   AND pp.id_edicion = s.id_edicion
  JOIN partido p
    ON p.id_partido = pp.id_partido
   AND p.id_edicion = pp.id_edicion
 WHERE e.anio = 2026
   AND p.estado_partido = 'FINALIZADO'
 GROUP BY e.anio, s.id_seleccion, s.pais
 ORDER BY s.pais;

------------------------------------------------------------------------
-- 13. Estadios con partidos en más de una fase.
------------------------------------------------------------------------

SELECT e.anio, es.id_estadio, es.nombre AS estadio,
       COUNT(DISTINCT p.fase) AS fases_distintas
  FROM edicion_mundial e
  JOIN estadio es
    ON es.id_edicion = e.id_edicion
  JOIN partido p
    ON p.id_estadio = es.id_estadio
   AND p.id_edicion = es.id_edicion
 WHERE e.anio = 2026
 GROUP BY e.anio, es.id_estadio, es.nombre
HAVING COUNT(DISTINCT p.fase) > 1
 ORDER BY fases_distintas DESC, estadio;

------------------------------------------------------------------------
-- 14. Verificación de participaciones duplicadas.
-- Debe devolver cero filas porque existe UNIQUE(id_partido,id_seleccion).
------------------------------------------------------------------------

SELECT id_partido, id_seleccion, COUNT(*) AS cantidad
  FROM participacion_partido
 GROUP BY id_partido, id_seleccion
HAVING COUNT(*) > 1
 ORDER BY id_partido, id_seleccion;

------------------------------------------------------------------------
-- 15. Selección líder de cada edición según puntos y desempates.
-- En el modelo inicial no existe GRUPO; por eso se informa el líder por edición.
-- Reutiliza VW_TABLA_POSICIONES.
------------------------------------------------------------------------

WITH ranking AS (
    SELECT v.*,
           DENSE_RANK() OVER (
               PARTITION BY v.anio
               ORDER BY v.puntos DESC,
                        v.diferencia_goles DESC,
                        v.goles_favor DESC
           ) AS posicion
      FROM vw_tabla_posiciones v
)
SELECT anio, id_seleccion, pais, puntos, victorias, empates,
       derrotas, goles_favor, goles_contra, diferencia_goles
  FROM ranking
 WHERE posicion = 1
 ORDER BY anio, pais;
