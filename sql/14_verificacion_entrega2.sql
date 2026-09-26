-- Entrega 2 BASICA - Verificacion estructural (solo SELECT)
-- Sin PL/SQL ni DBMS_OUTPUT. Cada regla "debe dar cero filas".
-- Esperado: 5 paises, 5 ciudades, 5 estadio_ciudad, 4 fases, 8 partido_fase,
-- 4 grupos, 10 inscripciones, 4 posiciones, 10 convocatorias, 20 jugadores,
-- 20 convocatoria_jugador, 12 estadisticas, 8 asignaciones, 12 eventos,
-- 4 incidencias y 4 auditorias.

SET DEFINE OFF;

------------------------------------------------------------------------
-- Conteos por tabla.
------------------------------------------------------------------------

SELECT 'PAIS_SEDE_E2' AS tabla, COUNT(*) AS cantidad FROM pais_sede_e2
UNION ALL
SELECT 'CIUDAD_E2', COUNT(*) FROM ciudad_e2
UNION ALL
SELECT 'ESTADIO_CIUDAD_E2', COUNT(*) FROM estadio_ciudad_e2
UNION ALL
SELECT 'GRUPO_E2', COUNT(*) FROM grupo_e2
UNION ALL
SELECT 'INSCRIPCION_GRUPO_E2', COUNT(*) FROM inscripcion_grupo_e2
UNION ALL
SELECT 'JUGADOR_E2', COUNT(*) FROM jugador_e2
UNION ALL
SELECT 'CONVOCATORIA_E2', COUNT(*) FROM convocatoria_e2
UNION ALL
SELECT 'CONVOCATORIA_JUGADOR_E2', COUNT(*) FROM convocatoria_jugador_e2
UNION ALL
SELECT 'ESTADISTICA_JUGADOR_E2', COUNT(*) FROM estadistica_jugador_e2
UNION ALL
SELECT 'ASIGNACION_ARBITRAL_E2', COUNT(*) FROM asignacion_arbitral_e2
UNION ALL
SELECT 'EVENTO_PARTIDO_E2', COUNT(*) FROM evento_partido_e2
UNION ALL
SELECT 'INCIDENCIA_E2', COUNT(*) FROM incidencia_e2
UNION ALL
SELECT 'AUDITORIA_E2', COUNT(*) FROM auditoria_e2
ORDER BY tabla;

------------------------------------------------------------------------
-- Debe dar cero filas: sin dorsales duplicados por convocatoria.
------------------------------------------------------------------------

SELECT id_convocatoria, dorsal, COUNT(*) AS cantidad
  FROM convocatoria_jugador_e2
 GROUP BY id_convocatoria, dorsal
HAVING COUNT(*) > 1
 ORDER BY id_convocatoria, dorsal;

------------------------------------------------------------------------
-- Debe dar cero filas: estadisticas sin convocatoria valida.
------------------------------------------------------------------------

SELECT st.id_partido, st.id_jugador
  FROM estadistica_jugador_e2 st
  LEFT JOIN convocatoria_jugador_e2 cj
    ON cj.id_convocatoria = st.id_convocatoria
   AND cj.id_jugador = st.id_jugador
 WHERE cj.id_jugador IS NULL
 ORDER BY st.id_partido, st.id_jugador;

------------------------------------------------------------------------
-- Debe dar cero filas: partidos sin fase asignada.
------------------------------------------------------------------------

SELECT p.id_partido
  FROM partido p
  LEFT JOIN partido_fase_e2 pf
    ON pf.id_partido = p.id_partido
 WHERE pf.id_partido IS NULL
   AND p.id_partido IN (5001, 5002, 5003, 5004, 5005, 5006, 6001, 6002)
 ORDER BY p.id_partido;

------------------------------------------------------------------------
-- Debe dar cero filas: incidencias sin su auditoria manual.
------------------------------------------------------------------------

SELECT i.id_incidencia
  FROM incidencia_e2 i
  LEFT JOIN auditoria_e2 a
    ON a.id_registro = i.id_incidencia
   AND a.tabla_afectada = 'INCIDENCIA_E2'
   AND a.operacion = 'INSERT'
 WHERE a.id_auditoria IS NULL
 ORDER BY i.id_incidencia;

------------------------------------------------------------------------
-- Conteos de las vistas E2 (evidencia rapida).
------------------------------------------------------------------------

SELECT 'VW_E2_RENDIMIENTO' AS vista, COUNT(*) AS cantidad FROM vw_e2_rendimiento_jugador
UNION ALL
SELECT 'VW_E2_TABLA_GRUPO', COUNT(*) FROM vw_e2_tabla_grupo
UNION ALL
SELECT 'VW_E2_INDICADORES', COUNT(*) FROM vw_e2_indicadores_edicion
UNION ALL
SELECT 'VW_E2_ARBITRAJE', COUNT(*) FROM vw_e2_arbitraje
UNION ALL
SELECT 'VW_E2_FASE_OP', COUNT(*) FROM vw_e2_fase_operativa
UNION ALL
SELECT 'VW_E2_AUDITORIA', COUNT(*) FROM vw_e2_auditoria_consulta
ORDER BY vista;
