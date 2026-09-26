-- Entrega 2 BASICA - Ocho consultas (solo temas vistos)
-- Solo: SELECT, JOINS, WHERE, GROUP BY, HAVING, ORDER BY,
-- agregados y subconsultas. Sin WITH, sin ventanas, sin PL/SQL.
-- Requiere 08, 09 y 10 de la Entrega 2.

SET DEFINE OFF;

------------------------------------------------------------------------
-- Consulta 1. Top 5 goleadores de 2026 (ORDER BY + limite basico).
------------------------------------------------------------------------

SELECT anio, id_jugador, jugador, pais,
       partidos_jugados AS partidos, goles, asistencias
  FROM vw_e2_rendimiento_jugador
 WHERE anio = 2026
 ORDER BY goles DESC, asistencias DESC, jugador
 FETCH FIRST 5 ROWS ONLY;

------------------------------------------------------------------------
-- Consulta 2. Partido(s) con mayor asistencia por fase (MAX correlacionado).
------------------------------------------------------------------------

SELECT e.anio, f.codigo AS fase, p.id_partido,
       es.nombre AS estadio, p.asistencia_registrada
  FROM partido p
  JOIN edicion_mundial e
    ON e.id_edicion = p.id_edicion
  JOIN partido_fase_e2 pf
    ON pf.id_partido = p.id_partido
  JOIN fase_e2 f
    ON f.id_fase = pf.id_fase
  JOIN estadio es
    ON es.id_estadio = p.id_estadio
 WHERE p.asistencia_registrada = (
        SELECT MAX(p2.asistencia_registrada)
          FROM partido p2
          JOIN partido_fase_e2 pf2
            ON pf2.id_partido = p2.id_partido
         WHERE p2.id_edicion = p.id_edicion
           AND pf2.id_fase = pf.id_fase
       )
 ORDER BY e.anio, f.orden_fase, p.id_partido;

------------------------------------------------------------------------
-- Consulta 3. Rendimiento por grupo en 2026 (JOIN + GROUP BY + ORDER BY).
------------------------------------------------------------------------

SELECT id_edicion, grupo, id_seleccion, pais,
       partidos, victorias, empates, derrotas, puntos, goles_favor
  FROM vw_e2_tabla_grupo
 WHERE id_edicion = 1
 ORDER BY grupo, puntos DESC, goles_favor DESC, pais;

------------------------------------------------------------------------
-- Consulta 4. Ediciones con asistencia promedio por encima del promedio
-- general (subconsulta con AVG, sin WITH).
------------------------------------------------------------------------

SELECT e.anio,
       COUNT(p.id_partido) AS partidos,
       ROUND(AVG(p.asistencia_registrada), 2) AS asistencia_promedio,
       MAX(p.asistencia_registrada) AS asistencia_maxima
  FROM edicion_mundial e
  JOIN partido p
    ON p.id_edicion = e.id_edicion
 GROUP BY e.anio
HAVING AVG(p.asistencia_registrada) > (
        SELECT AVG(p2.asistencia_registrada)
          FROM partido p2
       )
 ORDER BY asistencia_promedio DESC;

------------------------------------------------------------------------
-- Consulta 5. Jugadores con tarjetas en 2026 (GROUP BY + HAVING +
-- subconsulta escalar de eventos).
------------------------------------------------------------------------

SELECT j.id_jugador,
       j.nombres || ' ' || j.apellidos AS jugador,
       s.pais,
       SUM(st.tarjetas_amarillas) AS amarillas,
       SUM(st.tarjetas_rojas) AS rojas,
       SUM(st.minutos) AS minutos,
       (SELECT COUNT(*)
          FROM evento_partido_e2 ev
         WHERE ev.id_jugador = j.id_jugador) AS eventos_registrados
  FROM jugador_e2 j
  JOIN convocatoria_jugador_e2 cj
    ON cj.id_jugador = j.id_jugador
  JOIN convocatoria_e2 c
    ON c.id_convocatoria = cj.id_convocatoria
  JOIN seleccion s
    ON s.id_seleccion = c.id_seleccion
  JOIN estadistica_jugador_e2 st
    ON st.id_jugador = j.id_jugador
   AND st.id_convocatoria = c.id_convocatoria
 WHERE c.id_edicion = 1
 GROUP BY j.id_jugador, j.nombres, j.apellidos, s.pais
HAVING SUM(st.tarjetas_amarillas) > 0
 ORDER BY amarillas DESC, rojas DESC, jugador;

------------------------------------------------------------------------
-- Consulta 6. Carga de arbitros centrales (GROUP BY + HAVING basico).
-- Umbral >= 2 (dataset pequeno) en vez de >= 5.
------------------------------------------------------------------------

SELECT a.id_arbitro,
       a.nombres || ' ' || a.apellidos AS arbitro,
       COUNT(DISTINCT aa.id_partido) AS partidos_asignados,
       ROUND(AVG(aa.calificacion), 2) AS calificacion_promedio
  FROM arbitro_e2 a
  JOIN asignacion_arbitral_e2 aa
    ON aa.id_arbitro = a.id_arbitro
 WHERE aa.id_rol = 1
 GROUP BY a.id_arbitro, a.nombres, a.apellidos
HAVING COUNT(DISTINCT aa.id_partido) >= 2
 ORDER BY partidos_asignados DESC, calificacion_promedio DESC;

------------------------------------------------------------------------
-- Consulta 7. Fases con mas incidencias que el promedio por fase.
-- Version basica: compara conteo contra promedio de conteos.
------------------------------------------------------------------------

SELECT f.codigo AS fase,
       COUNT(DISTINCT p.id_partido) AS partidos,
       COUNT(i.id_incidencia) AS incidencias
  FROM fase_e2 f
  JOIN partido_fase_e2 pf
    ON pf.id_fase = f.id_fase
  JOIN partido p
    ON p.id_partido = pf.id_partido
  LEFT JOIN incidencia_e2 i
    ON i.id_partido = p.id_partido
 GROUP BY f.codigo
HAVING COUNT(i.id_incidencia) > (
        SELECT AVG(cantidad)
          FROM (
                SELECT COUNT(i2.id_incidencia) AS cantidad
                  FROM fase_e2 f2
                  JOIN partido_fase_e2 pf2
                    ON pf2.id_fase = f2.id_fase
                  JOIN partido p2
                    ON p2.id_partido = pf2.id_partido
                  LEFT JOIN incidencia_e2 i2
                    ON i2.id_partido = p2.id_partido
                 GROUP BY f2.codigo
               )
       )
 ORDER BY incidencias DESC, fase;

------------------------------------------------------------------------
-- Consulta 8. Jugadores que marcaron en mas de una fase
-- (JOIN + GROUP BY + HAVING COUNT DISTINCT, sin WITH).
------------------------------------------------------------------------

SELECT j.id_jugador,
       j.nombres || ' ' || j.apellidos AS jugador,
       COUNT(DISTINCT f.codigo) AS fases_con_gol,
       SUM(st.goles) AS goles_totales
  FROM estadistica_jugador_e2 st
  JOIN jugador_e2 j
    ON j.id_jugador = st.id_jugador
  JOIN partido_fase_e2 pf
    ON pf.id_partido = st.id_partido
  JOIN fase_e2 f
    ON f.id_fase = pf.id_fase
 WHERE st.goles > 0
 GROUP BY j.id_jugador, j.nombres, j.apellidos
HAVING COUNT(DISTINCT f.codigo) > 1
 ORDER BY goles_totales DESC, jugador;
