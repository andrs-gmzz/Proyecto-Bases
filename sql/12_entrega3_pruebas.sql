-- Entrega 3 BASICA - Pruebas con SELECT y DML (sin PL/SQL)
-- Cada bloque trae su SELECT de verificacion.
-- Los casos invalidos estan comentados con el ORA esperado.
-- Requiere 08, 09, 10 y 11.

SET DEFINE OFF;

------------------------------------------------------------------------
-- 1. Diferencia y puntos de Colombia (funciones reemplazadas por SELECT).
------------------------------------------------------------------------

SELECT SUM(CASE WHEN pp.id_seleccion = 101 THEN pp.goles_marcados ELSE 0 END)
       - SUM(CASE WHEN pp.id_seleccion <> 101 THEN pp.goles_marcados ELSE 0 END) AS diferencia_gol_101
  FROM participacion_partido pp
  JOIN partido p
    ON p.id_partido = pp.id_partido
 WHERE p.estado_partido = 'FINALIZADO'
   AND pp.id_partido IN (SELECT id_partido FROM participacion_partido WHERE id_seleccion = 101);

SELECT NVL(SUM(CASE pp.resultado WHEN 'GANO' THEN 3 WHEN 'EMPATO' THEN 1 ELSE 0 END), 0) AS puntos_101
  FROM participacion_partido pp
  JOIN partido p
    ON p.id_partido = pp.id_partido
 WHERE pp.id_seleccion = 101
   AND p.estado_partido = 'FINALIZADO';

-- Ranking top 5 E3 (debe mostrar a Luis Rios con 3 goles arriba).
SELECT jugador, seleccion, goles, partidos
  FROM vw_e3_goleadores
 WHERE anio = 2026
 ORDER BY goles DESC, jugador
 FETCH FIRST 5 ROWS ONLY;

------------------------------------------------------------------------
-- 2. Carga, posiciones y cierre (procedimientos reemplazados por DML).
------------------------------------------------------------------------

-- Recalcular una fila de posiciones con UPDATE simple (ejemplo sobre Colombia).
UPDATE tabla_posiciones_e3 SET puntos = 10 WHERE id_edicion = 1 AND id_seleccion = 101;

SELECT id_edicion, id_seleccion, puntos, goles_favor, diferencia_goles
  FROM tabla_posiciones_e3
 WHERE id_edicion = 1 AND id_seleccion = 101;

-- Cierre ya creado en el script 10: verificarlo.
SELECT id_edicion, fase, estado FROM cierre_fase ORDER BY id_edicion, fase;

------------------------------------------------------------------------
-- 3. Casos invalidos (descomentar para ver el error; no detienen el script).
------------------------------------------------------------------------

-- Rango de jugador: fecha futura (debe fallar CK_E3_JUGADOR_FECHA... o logica).
-- INSERT INTO jugador (id_jugador, nombres, apellidos, fecha_nacimiento, nacionalidad, posicion, activo)
-- VALUES (9999, 'Test', 'Futuro', DATE '2035-01-01', 'Colombia', 'DELANTERO', 'S');

-- Rango de estadistica: minutos negativos (debe fallar CK_E3_ESTADISTICA_MINUTOS).
-- UPDATE estadistica_jugador_partido SET minutos_jugados = -1 WHERE id_estadistica = 1;

-- Rango de incidencia: minuto 131 (debe fallar CK_E3_INCIDENCIA_MINUTO).
-- UPDATE incidencia SET minuto = 131 WHERE id_incidencia = 1;

-- Marcador inconsistente: poner GANO al visitante que perdio (verificacion manual).
-- UPDATE participacion_partido SET resultado = 'GANO' WHERE id_partido = 5001 AND condicion = 'VISITANTE';

-- Duplicado de estadistica (debe fallar UQ_E3_ESTADISTICA_PARTIDO_JUGADOR).
-- INSERT INTO estadistica_jugador_partido (id_estadistica, id_partido, id_seleccion, id_jugador, minutos_jugados, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, titular)
-- VALUES (999, 5001, 101, 1002, 90, 0, 0, 0, 0, 'S');

------------------------------------------------------------------------
-- 4. Reportes y auditoria (conteos de evidencia).
------------------------------------------------------------------------

SELECT 'RESULTADOS' AS reporte, COUNT(*) AS registros FROM vw_e3_resultados_consolidados
UNION ALL
SELECT 'POSICIONES', COUNT(*) FROM vw_e3_tabla_posiciones_grupo
UNION ALL
SELECT 'GOLEADORES', COUNT(*) FROM vw_e3_goleadores
UNION ALL
SELECT 'INCIDENCIAS', COUNT(*) FROM vw_e3_incidencias_detalle
UNION ALL
SELECT 'RESUMEN_FASE', COUNT(*) FROM vw_e3_resumen_fase
UNION ALL
SELECT 'AUDITORIA', COUNT(*) FROM auditoria_evento
ORDER BY reporte;

COMMIT;
