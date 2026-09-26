-- Entrega 1 BASICA - Vistas analiticas
-- Solo usa SELECT, JOINS, GROUP BY, CASE, agregados y una vista sobre otra.
-- NO usa WITH, ni funciones de ventana, ni PL/SQL.
-- Requiere sql/01_ddl.sql y sql/02_datos_prueba.sql.

SET DEFINE OFF;

------------------------------------------------------------------------
-- 1. Partido con sede y marcador en una sola fila (JOIN + GROUP BY).
------------------------------------------------------------------------

CREATE OR REPLACE VIEW vw_marcador_partidos AS
SELECT
    p.id_partido,
    e.id_edicion,
    e.anio,
    p.fase,
    p.fecha_hora,
    es.id_estadio,
    es.nombre AS estadio,
    es.ciudad,
    MAX(CASE WHEN pp.condicion = 'LOCAL' THEN s.pais END) AS seleccion_local,
    MAX(CASE WHEN pp.condicion = 'VISITANTE' THEN s.pais END) AS seleccion_visitante,
    NVL(MAX(CASE WHEN pp.condicion = 'LOCAL' THEN pp.goles_marcados END), 0) AS goles_local,
    NVL(MAX(CASE WHEN pp.condicion = 'VISITANTE' THEN pp.goles_marcados END), 0) AS goles_visitante,
    p.asistencia_registrada,
    p.estado_partido
FROM partido p
JOIN edicion_mundial e
  ON e.id_edicion = p.id_edicion
JOIN estadio es
  ON es.id_estadio = p.id_estadio
LEFT JOIN participacion_partido pp
  ON pp.id_partido = p.id_partido
LEFT JOIN seleccion s
  ON s.id_seleccion = pp.id_seleccion
GROUP BY
    p.id_partido, e.id_edicion, e.anio, p.fase, p.fecha_hora,
    es.id_estadio, es.nombre, es.ciudad,
    p.asistencia_registrada, p.estado_partido;

------------------------------------------------------------------------
-- 2. Tabla de posiciones por edicion y seleccion.
-- Solo JOIN + GROUP BY. La tabla rival (op) se une por id_partido.
------------------------------------------------------------------------

CREATE OR REPLACE VIEW vw_tabla_posiciones AS
SELECT
    e.id_edicion,
    e.anio,
    s.id_seleccion,
    s.pais,
    s.confederacion,
    COUNT(pp.id_participacion) AS partidos_jugados,
    SUM(CASE WHEN pp.resultado = 'GANO' THEN 1 ELSE 0 END) AS victorias,
    SUM(CASE WHEN pp.resultado = 'EMPATO' THEN 1 ELSE 0 END) AS empates,
    SUM(CASE WHEN pp.resultado = 'PERDIO' THEN 1 ELSE 0 END) AS derrotas,
    SUM(CASE WHEN pp.resultado = 'GANO' THEN 3
             WHEN pp.resultado = 'EMPATO' THEN 1
             ELSE 0 END) AS puntos,
    NVL(SUM(pp.goles_marcados), 0) AS goles_favor,
    NVL(SUM(op.goles_marcados), 0) AS goles_contra,
    NVL(SUM(pp.goles_marcados), 0) - NVL(SUM(op.goles_marcados), 0) AS diferencia_goles
FROM seleccion s
JOIN edicion_mundial e
  ON e.id_edicion = s.id_edicion
LEFT JOIN participacion_partido pp
  ON pp.id_seleccion = s.id_seleccion
LEFT JOIN partido p
  ON p.id_partido = pp.id_partido
 AND p.estado_partido = 'FINALIZADO'
LEFT JOIN participacion_partido op
  ON op.id_partido = pp.id_partido
 AND op.id_seleccion <> pp.id_seleccion
GROUP BY
    e.id_edicion, e.anio, s.id_seleccion, s.pais, s.confederacion;

------------------------------------------------------------------------
-- 3. Goles acumulados por seleccion (JOIN + GROUP BY + SUM).
------------------------------------------------------------------------

CREATE OR REPLACE VIEW vw_goleadores_sel AS
SELECT
    e.id_edicion,
    e.anio,
    s.id_seleccion,
    s.pais,
    s.confederacion,
    COUNT(pp.id_participacion) AS partidos_jugados,
    NVL(SUM(pp.goles_marcados), 0) AS goles_marcados
FROM seleccion s
JOIN edicion_mundial e
  ON e.id_edicion = s.id_edicion
LEFT JOIN participacion_partido pp
  ON pp.id_seleccion = s.id_seleccion
LEFT JOIN partido p
  ON p.id_partido = pp.id_partido
 AND p.estado_partido = 'FINALIZADO'
GROUP BY
    e.id_edicion, e.anio, s.id_seleccion, s.pais, s.confederacion;

------------------------------------------------------------------------
-- 4. Ocupacion promedio por estadio (JOIN + AVG).
------------------------------------------------------------------------

CREATE OR REPLACE VIEW vw_ocupacion_estadio AS
SELECT
    e.id_edicion,
    e.anio,
    es.id_estadio,
    es.nombre AS estadio,
    es.ciudad,
    es.capacidad,
    COUNT(p.id_partido) AS partidos_albergados,
    NVL(SUM(p.asistencia_registrada), 0) AS asistencia_total,
    ROUND(NVL(AVG(p.asistencia_registrada), 0) / es.capacidad * 100, 2) AS ocupacion_promedio_pct
FROM edicion_mundial e
JOIN estadio es
  ON es.id_edicion = e.id_edicion
LEFT JOIN partido p
  ON p.id_estadio = es.id_estadio
GROUP BY
    e.id_edicion, e.anio, es.id_estadio, es.nombre, es.ciudad, es.capacidad;

------------------------------------------------------------------------
-- 5. Partidos atipicos: 0-0 o 8 o mas goles (vista sobre vista + WHERE).
------------------------------------------------------------------------

CREATE OR REPLACE VIEW vw_partidos_atipicos AS
SELECT
    v.id_partido,
    v.id_edicion,
    v.anio,
    v.fase,
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
    v.estado_partido
FROM vw_marcador_partidos v
WHERE v.estado_partido = 'FINALIZADO'
  AND v.seleccion_local IS NOT NULL
  AND v.seleccion_visitante IS NOT NULL
  AND (v.goles_local + v.goles_visitante >= 8
       OR (v.goles_local = 0 AND v.goles_visitante = 0));
