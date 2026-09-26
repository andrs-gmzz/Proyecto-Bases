-- Entrega 2 BASICA - Vistas de analisis y control
-- Solo usa SELECT, JOINS, GROUP BY, CASE, agregados y subconsultas
-- escalares o en el FROM. Sin WITH, sin ventanas, sin PL/SQL.
-- Requiere 08_ddl_entrega2.sql y 09_datos_entrega2.sql.

SET DEFINE OFF;

------------------------------------------------------------------------
-- 1. Rendimiento de jugadores por edicion (JOIN + GROUP BY, sin ranking).
------------------------------------------------------------------------

CREATE OR REPLACE VIEW vw_e2_rendimiento_jugador AS
SELECT c.id_edicion,
       e.anio,
       j.id_jugador,
       j.nombres || ' ' || j.apellidos AS jugador,
       s.id_seleccion,
       s.pais,
       COUNT(DISTINCT st.id_partido) AS partidos_jugados,
       NVL(SUM(st.minutos), 0) AS minutos,
       NVL(SUM(st.goles), 0) AS goles,
       NVL(SUM(st.asistencias), 0) AS asistencias,
       NVL(SUM(st.remates), 0) AS remates,
       NVL(SUM(st.tarjetas_amarillas), 0) AS tarjetas_amarillas,
       NVL(SUM(st.tarjetas_rojas), 0) AS tarjetas_rojas
  FROM convocatoria_e2 c
  JOIN edicion_mundial e
    ON e.id_edicion = c.id_edicion
  JOIN seleccion s
    ON s.id_seleccion = c.id_seleccion
  JOIN convocatoria_jugador_e2 cj
    ON cj.id_convocatoria = c.id_convocatoria
  JOIN jugador_e2 j
    ON j.id_jugador = cj.id_jugador
  LEFT JOIN estadistica_jugador_e2 st
    ON st.id_convocatoria = c.id_convocatoria
   AND st.id_jugador = cj.id_jugador
 GROUP BY c.id_edicion, e.anio, j.id_jugador,
          j.nombres, j.apellidos, s.id_seleccion, s.pais;

------------------------------------------------------------------------
-- 2. Rendimiento de selecciones dentro de su grupo.
-- Subconsulta en el FROM (agregado de fase de grupos) + LEFT JOIN.
------------------------------------------------------------------------

CREATE OR REPLACE VIEW vw_e2_tabla_grupo AS
SELECT g.id_edicion,
       g.codigo AS grupo,
       g.nombre AS nombre_grupo,
       s.id_seleccion,
       s.pais,
       i.orden_inicial,
       NVL(r.partidos, 0) AS partidos,
       NVL(r.victorias, 0) AS victorias,
       NVL(r.empates, 0) AS empates,
       NVL(r.derrotas, 0) AS derrotas,
       NVL(r.puntos, 0) AS puntos,
       NVL(r.goles_favor, 0) AS goles_favor
  FROM grupo_e2 g
  JOIN inscripcion_grupo_e2 i
    ON i.id_grupo = g.id_grupo
  JOIN seleccion s
    ON s.id_seleccion = i.id_seleccion
  LEFT JOIN (
        SELECT pp.id_seleccion,
               COUNT(DISTINCT pp.id_partido) AS partidos,
               SUM(CASE WHEN pp.resultado = 'GANO' THEN 1 ELSE 0 END) AS victorias,
               SUM(CASE WHEN pp.resultado = 'EMPATO' THEN 1 ELSE 0 END) AS empates,
               SUM(CASE WHEN pp.resultado = 'PERDIO' THEN 1 ELSE 0 END) AS derrotas,
               SUM(CASE WHEN pp.resultado = 'GANO' THEN 3
                        WHEN pp.resultado = 'EMPATO' THEN 1 ELSE 0 END) AS puntos,
               SUM(pp.goles_marcados) AS goles_favor
          FROM participacion_partido pp
          JOIN partido p
            ON p.id_partido = pp.id_partido
         WHERE p.estado_partido = 'FINALIZADO'
           AND p.fase = 'FASE DE GRUPOS'
         GROUP BY pp.id_seleccion
       ) r
    ON r.id_seleccion = s.id_seleccion;

------------------------------------------------------------------------
-- 3. Indicadores por edicion (subconsultas escalares, concepto basico).
------------------------------------------------------------------------

CREATE OR REPLACE VIEW vw_e2_indicadores_edicion AS
SELECT e.id_edicion,
       e.anio,
       (SELECT COUNT(*)
          FROM partido p
         WHERE p.id_edicion = e.id_edicion) AS partidos,
       (SELECT NVL(SUM(p.asistencia_registrada), 0)
          FROM partido p
         WHERE p.id_edicion = e.id_edicion) AS asistencia_total,
       (SELECT COUNT(*)
          FROM grupo_e2 c
         WHERE c.id_edicion = e.id_edicion) AS grupos,
       (SELECT COUNT(*)
          FROM convocatoria_jugador_e2 cj
          JOIN convocatoria_e2 c
            ON c.id_convocatoria = cj.id_convocatoria
         WHERE c.id_edicion = e.id_edicion) AS jugadores_convocados,
       (SELECT COUNT(*)
          FROM incidencia_e2 i
          JOIN partido p
            ON p.id_partido = i.id_partido
         WHERE p.id_edicion = e.id_edicion) AS incidencias,
       (SELECT ROUND(AVG(p.asistencia_registrada), 2)
          FROM partido p
         WHERE p.id_edicion = e.id_edicion) AS asistencia_promedio
  FROM edicion_mundial e;

------------------------------------------------------------------------
-- 4. Carga y calificacion de arbitros (JOIN + GROUP BY + AVG).
------------------------------------------------------------------------

CREATE OR REPLACE VIEW vw_e2_arbitraje AS
SELECT a.id_arbitro,
       a.nombres || ' ' || a.apellidos AS arbitro,
       a.confederacion,
       COUNT(DISTINCT aa.id_partido) AS partidos_asignados,
       ROUND(AVG(aa.calificacion), 2) AS calificacion_promedio,
       COUNT(DISTINCT CASE
           WHEN p.estado_partido = 'FINALIZADO' THEN p.id_partido
       END) AS partidos_finalizados
  FROM arbitro_e2 a
  LEFT JOIN asignacion_arbitral_e2 aa
    ON aa.id_arbitro = a.id_arbitro
  LEFT JOIN partido p
    ON p.id_partido = aa.id_partido
 GROUP BY a.id_arbitro, a.nombres, a.apellidos, a.confederacion;

------------------------------------------------------------------------
-- 5. Incidencias por fase (JOIN directo + GROUP BY, sin WITH).
------------------------------------------------------------------------

CREATE OR REPLACE VIEW vw_e2_fase_operativa AS
SELECT e.id_edicion,
       e.anio,
       f.id_fase,
       f.codigo AS fase,
       COUNT(DISTINCT p.id_partido) AS partidos,
       NVL(SUM(p.asistencia_registrada), 0) AS asistencia,
       COUNT(i.id_incidencia) AS incidencias,
       ROUND(COUNT(i.id_incidencia) / NULLIF(COUNT(DISTINCT p.id_partido), 0), 2) AS incidencias_por_partido
  FROM edicion_mundial e
  JOIN partido p
    ON p.id_edicion = e.id_edicion
  JOIN partido_fase_e2 pf
    ON pf.id_partido = p.id_partido
  JOIN fase_e2 f
    ON f.id_fase = pf.id_fase
  LEFT JOIN incidencia_e2 i
    ON i.id_partido = p.id_partido
 GROUP BY e.id_edicion, e.anio, f.id_fase, f.codigo;

------------------------------------------------------------------------
-- 6. Vista de solo lectura para el rol Auditor (SELECT simple).
------------------------------------------------------------------------

CREATE OR REPLACE VIEW vw_e2_auditoria_consulta AS
SELECT id_auditoria,
       tabla_afectada,
       operacion,
       id_registro,
       usuario_bd,
       fecha_evento,
       detalle
  FROM auditoria_e2;
