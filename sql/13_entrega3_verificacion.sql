-- Entrega 3 BASICA - Verificacion (solo SELECT, sin PL/SQL ni funciones)
-- Esperado: 2 sedes, 4 ciudades, 4 grupos, 14 jugadores, 8 partidos,
-- 12 estadisticas, 8 incidencias. Reglas con cero filas.

SET DEFINE OFF;

------------------------------------------------------------------------
-- Conteos de catalogos y operacion.
------------------------------------------------------------------------

SELECT 'SEDE' AS entidad, COUNT(*) AS cantidad FROM sede
UNION ALL
SELECT 'CIUDAD', COUNT(*) FROM ciudad
UNION ALL
SELECT 'ESTADIO', COUNT(*) FROM estadio
UNION ALL
SELECT 'SELECCION', COUNT(*) FROM seleccion
UNION ALL
SELECT 'GRUPO_TORNEO', COUNT(*) FROM grupo_torneo
UNION ALL
SELECT 'JUGADOR', COUNT(*) FROM jugador
UNION ALL
SELECT 'CUERPO_TECNICO', COUNT(*) FROM cuerpo_tecnico
UNION ALL
SELECT 'PARTIDO', COUNT(*) FROM partido
UNION ALL
SELECT 'ESTADISTICA_JUGADOR_PARTIDO', COUNT(*) FROM estadistica_jugador_partido
UNION ALL
SELECT 'INCIDENCIA', COUNT(*) FROM incidencia
UNION ALL
SELECT 'AUDITORIA_EVENTO', COUNT(*) FROM auditoria_evento
UNION ALL
SELECT 'TABLA_POSICIONES_E3', COUNT(*) FROM tabla_posiciones_e3
ORDER BY entidad;

------------------------------------------------------------------------
-- Debe dar maximo 4 por grupo (grupos de ejemplo: 3,3,2,2).
------------------------------------------------------------------------

SELECT id_grupo, COUNT(*) AS selecciones
  FROM inscripcion_grupo
 GROUP BY id_grupo
HAVING COUNT(*) > 4
 ORDER BY id_grupo;

-- Detalle por grupo (informativo, debe dar 3,3,2,2).
SELECT id_grupo, COUNT(*) AS selecciones
  FROM inscripcion_grupo
 GROUP BY id_grupo
 ORDER BY id_grupo;

------------------------------------------------------------------------
-- Debe dar cero filas: goles de equipo vs suma de estadisticas.
-- (Se compara por partido+seleccion con LEFT JOIN basico.)
------------------------------------------------------------------------

SELECT pp.id_partido, pp.id_seleccion,
       pp.goles_marcados AS goles_marcador,
       NVL(SUM(ep.goles), 0) AS goles_estadistica
  FROM participacion_partido pp
  LEFT JOIN estadistica_jugador_partido ep
    ON ep.id_partido = pp.id_partido
   AND ep.id_seleccion = pp.id_seleccion
 GROUP BY pp.id_partido, pp.id_seleccion, pp.goles_marcados
HAVING pp.goles_marcados <> NVL(SUM(ep.goles), 0)
 ORDER BY pp.id_partido, pp.id_seleccion;

------------------------------------------------------------------------
-- Debe dar cero filas: partidos finalizados incompletos (sin pareja LOCAL/VIS).
------------------------------------------------------------------------

SELECT p.id_partido
  FROM partido p
  LEFT JOIN participacion_partido l
    ON l.id_partido = p.id_partido AND l.condicion = 'LOCAL'
  LEFT JOIN participacion_partido v
    ON v.id_partido = p.id_partido AND v.condicion = 'VISITANTE'
 WHERE p.estado_partido = 'FINALIZADO'
   AND (l.id_participacion IS NULL OR v.id_participacion IS NULL)
 ORDER BY p.id_partido;

------------------------------------------------------------------------
-- Debe dar cero filas: incidencias sin auditoria manual.
------------------------------------------------------------------------

SELECT i.id_incidencia
  FROM incidencia i
  LEFT JOIN auditoria_evento a
    ON a.clave_registro = TO_CHAR(i.id_incidencia)
   AND a.tabla_afectada = 'INCIDENCIA'
   AND a.operacion = 'INSERT'
 WHERE a.id_auditoria IS NULL
   AND i.id_incidencia <= 8
 ORDER BY i.id_incidencia;

------------------------------------------------------------------------
-- Conteos de las vistas E3 (evidencia rapida).
------------------------------------------------------------------------

SELECT 'RESULTADOS' AS vista, COUNT(*) AS cantidad FROM vw_e3_resultados_consolidados
UNION ALL
SELECT 'POSICIONES', COUNT(*) FROM vw_e3_tabla_posiciones_grupo
UNION ALL
SELECT 'GOLEADORES', COUNT(*) FROM vw_e3_goleadores
UNION ALL
SELECT 'INCIDENCIAS', COUNT(*) FROM vw_e3_incidencias_detalle
UNION ALL
SELECT 'RESUMEN_FASE', COUNT(*) FROM vw_e3_resumen_fase
ORDER BY vista;
