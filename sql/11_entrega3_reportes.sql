-- Entrega 3 BASICA - Vistas de reportes (solo conceptos basicos)
-- Solo SELECT, JOINS, GROUP BY y subconsultas. Sin ventanas, sin PL/SQL.
-- Requiere 08, 09 y 10 de Entrega 3 (la tabla de posiciones ya viene llena).

SET DEFINE OFF;

------------------------------------------------------------------------
-- 1. Resultados consolidados por partido (JOIN + GROUP BY + COUNT).
------------------------------------------------------------------------

CREATE OR REPLACE VIEW vw_e3_resultados_consolidados AS
SELECT v.id_partido,
       p.id_edicion,
       e.anio,
       v.fase,
       p.id_grupo,
       g.codigo AS grupo,
       v.fecha_hora,
       v.id_estadio,
       v.estadio,
       v.ciudad,
       v.seleccion_local,
       v.seleccion_visitante,
       v.goles_local,
       v.goles_visitante,
       v.goles_local + v.goles_visitante AS goles_totales,
       v.asistencia_registrada,
       v.estado_partido,
       COUNT(i.id_incidencia) AS cantidad_incidencias
FROM vw_marcador_partidos v
JOIN partido p
  ON p.id_partido = v.id_partido
JOIN edicion_mundial e
  ON e.id_edicion = p.id_edicion
LEFT JOIN grupo_torneo g
  ON g.id_grupo = p.id_grupo
LEFT JOIN incidencia i
  ON i.id_partido = p.id_partido
GROUP BY v.id_partido, p.id_edicion, e.anio, v.fase, p.id_grupo, g.codigo,
       v.fecha_hora, v.id_estadio, v.estadio, v.ciudad,
       v.seleccion_local, v.seleccion_visitante,
       v.goles_local, v.goles_visitante,
       v.asistencia_registrada, v.estado_partido;

------------------------------------------------------------------------
-- 2. Tabla de posiciones con grupo (sin DENSE_RANK; el orden lo pone la consulta).
------------------------------------------------------------------------

CREATE OR REPLACE VIEW vw_e3_tabla_posiciones_grupo AS
SELECT t.id_edicion,
       e.anio,
       t.id_grupo,
       g.codigo AS grupo,
       t.id_seleccion,
       s.pais AS seleccion,
       t.partidos_jugados,
       t.victorias,
       t.empates,
       t.derrotas,
       t.puntos,
       t.goles_favor,
       t.goles_contra,
       t.diferencia_goles
FROM tabla_posiciones_e3 t
JOIN edicion_mundial e
  ON e.id_edicion = t.id_edicion
JOIN seleccion s
  ON s.id_seleccion = t.id_seleccion
LEFT JOIN grupo_torneo g
  ON g.id_grupo = t.id_grupo;

------------------------------------------------------------------------
-- 3. Goleadores por jugador (JOIN + GROUP BY + SUM).
------------------------------------------------------------------------

CREATE OR REPLACE VIEW vw_e3_goleadores AS
SELECT c.id_edicion,
       e.anio,
       j.id_jugador,
       j.nombres || ' ' || j.apellidos AS jugador,
       c.id_seleccion,
       s.pais AS seleccion,
       SUM(CASE WHEN p.id_partido IS NOT NULL THEN NVL(ep.goles, 0) ELSE 0 END) AS goles,
       COUNT(DISTINCT p.id_partido) AS partidos,
       SUM(CASE WHEN p.id_partido IS NOT NULL THEN NVL(ep.asistencias, 0) ELSE 0 END) AS asistencias,
       SUM(CASE WHEN p.id_partido IS NOT NULL THEN NVL(ep.tarjetas_amarillas, 0) ELSE 0 END) AS tarjetas_amarillas,
       SUM(CASE WHEN p.id_partido IS NOT NULL THEN NVL(ep.tarjetas_rojas, 0) ELSE 0 END) AS tarjetas_rojas
FROM convocatoria c
JOIN edicion_mundial e
  ON e.id_edicion = c.id_edicion
JOIN convocatoria_jugador cj
  ON cj.id_convocatoria = c.id_convocatoria
JOIN jugador j
  ON j.id_jugador = cj.id_jugador
JOIN seleccion s
  ON s.id_seleccion = c.id_seleccion
LEFT JOIN estadistica_jugador_partido ep
  ON ep.id_jugador = j.id_jugador
LEFT JOIN partido p
  ON p.id_partido = ep.id_partido
 AND p.estado_partido = 'FINALIZADO'
WHERE c.estado <> 'ANULADA'
GROUP BY c.id_edicion, e.anio, j.id_jugador,
       j.nombres || ' ' || j.apellidos, c.id_seleccion, s.pais;

------------------------------------------------------------------------
-- 4. Incidencias con contexto (JOINS basicos).
------------------------------------------------------------------------

CREATE OR REPLACE VIEW vw_e3_incidencias_detalle AS
SELECT i.id_incidencia,
       p.id_edicion,
       e.anio,
       i.id_partido,
       p.fase,
       i.minuto,
       ti.nombre AS tipo_incidencia,
       ti.categoria,
       s.pais AS seleccion,
       j.nombres || ' ' || j.apellidos AS jugador,
       i.descripcion,
       i.revisada
FROM incidencia i
JOIN partido p
  ON p.id_partido = i.id_partido
JOIN edicion_mundial e
  ON e.id_edicion = p.id_edicion
JOIN tipo_incidencia ti
  ON ti.id_tipo_incidencia = i.id_tipo_incidencia
LEFT JOIN seleccion s
  ON s.id_seleccion = i.id_seleccion
LEFT JOIN jugador j
  ON j.id_jugador = i.id_jugador;

------------------------------------------------------------------------
-- 5. Resumen por fase (GROUP BY basico).
------------------------------------------------------------------------

CREATE OR REPLACE VIEW vw_e3_resumen_fase AS
SELECT p.id_edicion,
       e.anio,
       p.fase,
       p.id_grupo,
       g.codigo AS grupo,
       COUNT(DISTINCT p.id_partido) AS partidos,
       SUM(NVL(pp.goles_marcados, 0)) AS goles,
       SUM(NVL(p.asistencia_registrada, 0)) AS asistencia
FROM partido p
JOIN edicion_mundial e
  ON e.id_edicion = p.id_edicion
LEFT JOIN grupo_torneo g
  ON g.id_grupo = p.id_grupo
LEFT JOIN participacion_partido pp
  ON pp.id_partido = p.id_partido
WHERE p.estado_partido = 'FINALIZADO'
GROUP BY p.id_edicion, e.anio, p.fase, p.id_grupo, g.codigo;

------------------------------------------------------------------------
-- 6. Resumen de auditoria (GROUP BY sobre DATE, sin TRUNC complejo).
------------------------------------------------------------------------

CREATE OR REPLACE VIEW vw_e3_resumen_auditoria AS
SELECT fecha_evento AS fecha,
       tabla_afectada,
       operacion,
       COUNT(*) AS operaciones
FROM auditoria_evento
GROUP BY fecha_evento, tabla_afectada, operacion;
