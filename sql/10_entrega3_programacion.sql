-- Entrega 3 BASICA - Operaciones equivalentes SIN programacion PL/SQL
-- La rubrica original pedia funciones, paquete y triggers (temas NO vistos:
-- PLSQL/Triggers). Aqui cada operacion se hace con SQL basico
-- (SELECT, UPDATE, INSERT SELECT, CASE, agregados, subconsultas).
-- Requiere 08 y 09 de Entrega 3. Ejecutar con Run Script (F5).

SET DEFINE OFF;

------------------------------------------------------------------------
-- 1. Diferencia de gol de Colombia (101) en 2026 (equivale a FN_E3_DIFERENCIA_GOL).
-- Solo JOIN + SUM. Esperado: favor 8, contra 3, diferencia 5.
------------------------------------------------------------------------

SELECT SUM(CASE WHEN pp.id_seleccion = 101 THEN pp.goles_marcados ELSE 0 END) AS goles_favor,
       SUM(CASE WHEN pp.id_seleccion <> 101 THEN pp.goles_marcados ELSE 0 END) AS goles_contra,
       SUM(CASE WHEN pp.id_seleccion = 101 THEN pp.goles_marcados ELSE 0 END)
       - SUM(CASE WHEN pp.id_seleccion <> 101 THEN pp.goles_marcados ELSE 0 END) AS diferencia_gol
  FROM participacion_partido pp
  JOIN partido p
    ON p.id_partido = pp.id_partido
 WHERE p.estado_partido = 'FINALIZADO'
   AND pp.id_partido IN (SELECT id_partido FROM participacion_partido WHERE id_seleccion = 101);

------------------------------------------------------------------------
-- 2. Resultado esperado segun marcador (equivale a FN_E3_RESULTADO_ESPERADO).
-- Solo CASE (tema SQL basico). Ejemplo: local 2 - visitante 1.
------------------------------------------------------------------------

SELECT 2 AS goles_local, 1 AS goles_visitante,
       CASE WHEN 2 > 1 THEN 'GANO' WHEN 2 < 1 THEN 'PERDIO' ELSE 'EMPATO' END AS resultado_local,
       CASE WHEN 1 > 2 THEN 'GANO' WHEN 1 < 2 THEN 'PERDIO' ELSE 'EMPATO' END AS resultado_visitante
  FROM dual;

------------------------------------------------------------------------
-- 3. Verificar que un partido tiene pareja LOCAL/VISITANTE coherente
-- (equivale a FN_E3_PARTIDO_VALIDO). Ejemplo partido 5001 (debe dar 2,1,1,0).
------------------------------------------------------------------------

SELECT COUNT(*) AS total,
       SUM(CASE WHEN condicion = 'LOCAL' THEN 1 ELSE 0 END) AS locales,
       SUM(CASE WHEN condicion = 'VISITANTE' THEN 1 ELSE 0 END) AS visitantes
  FROM participacion_partido
 WHERE id_partido = 5001;

-- Inconsistencias de resultado vs goles (debe dar cero filas si todo esta bien).
SELECT pp.id_partido, pp.condicion, pp.goles_marcados, pp.resultado
  FROM participacion_partido pp
  JOIN participacion_partido op
    ON op.id_partido = pp.id_partido
   AND op.id_seleccion <> pp.id_seleccion
 WHERE pp.id_partido = 5001
   AND ((pp.condicion = 'LOCAL' AND pp.goles_marcados > op.goles_marcados AND pp.resultado <> 'GANO')
        OR (pp.condicion = 'LOCAL' AND pp.goles_marcados < op.goles_marcados AND pp.resultado <> 'PERDIO')
        OR (pp.goles_marcados = op.goles_marcados AND pp.resultado <> 'EMPATO'))
 ORDER BY pp.condicion;

------------------------------------------------------------------------
-- 4. Goles de un jugador (equivale a FN_E3_GOLES_JUGADOR). Ej: 1002 (3 goles).
------------------------------------------------------------------------

SELECT NVL(SUM(ep.goles), 0) AS goles_jugador_1002
  FROM estadistica_jugador_partido ep
  JOIN partido p
    ON p.id_partido = ep.id_partido
 WHERE ep.id_jugador = 1002
   AND p.estado_partido = 'FINALIZADO';

------------------------------------------------------------------------
-- 5. Ranking de goleadores 2026 (equivale a la funcion pipelined).
-- Solo GROUP BY + ORDER BY + FETCH FIRST (sin PIPELINED).
------------------------------------------------------------------------

SELECT j.id_jugador,
       j.nombres || ' ' || j.apellidos AS jugador,
       s.pais AS seleccion,
       NVL(SUM(ep.goles), 0) AS goles,
       COUNT(DISTINCT ep.id_partido) AS partidos
  FROM convocatoria c
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
 WHERE c.id_edicion = 1
 GROUP BY j.id_jugador, j.nombres || ' ' || j.apellidos, s.pais
 ORDER BY goles DESC, jugador
 FETCH FIRST 10 ROWS ONLY;

------------------------------------------------------------------------
-- 6. Puntos de una seleccion (equivale a FN_E3_PUNTOS_SELECCION). Ej: Colombia = 10.
------------------------------------------------------------------------

SELECT NVL(SUM(CASE pp.resultado WHEN 'GANO' THEN 3 WHEN 'EMPATO' THEN 1 ELSE 0 END), 0) AS puntos_colombia
  FROM participacion_partido pp
  JOIN partido p
    ON p.id_partido = pp.id_partido
 WHERE pp.id_seleccion = 101
   AND p.estado_partido = 'FINALIZADO';

------------------------------------------------------------------------
-- 7. Carga de un resultado (equivale a CARGAR_RESULTADOS_MASIVOS).
-- Ejemplo comentado sobre el partido 5001 (mismo marcador, no cambia nada).
-- Descomentar para practicar el UPDATE doble + cierre.
------------------------------------------------------------------------

-- UPDATE participacion_partido SET goles_marcados = 2, resultado = 'GANO'
--  WHERE id_partido = 5001 AND condicion = 'LOCAL';
-- UPDATE participacion_partido SET goles_marcados = 1, resultado = 'PERDIO'
--  WHERE id_partido = 5001 AND condicion = 'VISITANTE';
-- UPDATE partido SET estado_partido = 'FINALIZADO' WHERE id_partido = 5001;

------------------------------------------------------------------------
-- 8. Actualizar la tabla de posiciones (equivale al procedimiento).
-- Solo DELETE + INSERT SELECT con JOIN + GROUP BY (sin paquete).
------------------------------------------------------------------------

DELETE FROM tabla_posiciones_e3 WHERE id_edicion = 1;
DELETE FROM tabla_posiciones_e3 WHERE id_edicion = 2;

INSERT INTO tabla_posiciones_e3 (id_edicion, id_seleccion, id_grupo, partidos_jugados,
    victorias, empates, derrotas, puntos, goles_favor, goles_contra, diferencia_goles)
SELECT e.id_edicion, s.id_seleccion, MAX(ig.id_grupo),
       COUNT(pp.id_participacion),
       SUM(CASE WHEN pp.resultado = 'GANO' THEN 1 ELSE 0 END),
       SUM(CASE WHEN pp.resultado = 'EMPATO' THEN 1 ELSE 0 END),
       SUM(CASE WHEN pp.resultado = 'PERDIO' THEN 1 ELSE 0 END),
       SUM(CASE WHEN pp.resultado = 'GANO' THEN 3 WHEN pp.resultado = 'EMPATO' THEN 1 ELSE 0 END),
       NVL(SUM(pp.goles_marcados), 0),
       NVL(SUM(op.goles_marcados), 0),
       NVL(SUM(pp.goles_marcados), 0) - NVL(SUM(op.goles_marcados), 0)
  FROM seleccion s
  JOIN edicion_mundial e
    ON e.id_edicion = s.id_edicion
  LEFT JOIN inscripcion_grupo ig
    ON ig.id_seleccion = s.id_seleccion
  LEFT JOIN participacion_partido pp
    ON pp.id_seleccion = s.id_seleccion
  LEFT JOIN partido p
    ON p.id_partido = pp.id_partido
   AND p.estado_partido = 'FINALIZADO'
  LEFT JOIN participacion_partido op
    ON op.id_partido = pp.id_partido
   AND op.id_seleccion <> pp.id_seleccion
 WHERE e.id_edicion IN (1, 2)
 GROUP BY e.id_edicion, s.id_seleccion;

-- Verificacion del llenado (debe dar 10 filas).
SELECT COUNT(*) AS posiciones_cargadas FROM tabla_posiciones_e3;

------------------------------------------------------------------------
-- 9. Cierre de fase (equivale a CERRAR_FASE). Solo INSERT + SELECT.
------------------------------------------------------------------------

-- Verificacion previa: partidos de grupos 2026 finalizados (debe dar 4).
SELECT COUNT(*) AS partidos_grupos_2026
  FROM partido
 WHERE id_edicion = 1
   AND fase = 'FASE DE GRUPOS'
   AND estado_partido = 'FINALIZADO';

INSERT INTO cierre_fase (id_edicion, fase, estado, usuario_cierre)
VALUES (1, 'FASE DE GRUPOS', 'CERRADA', 'PROPIETARIO');

SELECT id_edicion, fase, estado FROM cierre_fase ORDER BY id_edicion, fase;

------------------------------------------------------------------------
-- 10. Auditoria manual (equivale a los triggers de auditoria).
-- Cada cambio se registra con INSERT (tema Modificadores).
------------------------------------------------------------------------

INSERT INTO auditoria_evento (id_auditoria, usuario_bd, tabla_afectada, operacion, clave_registro, detalle)
VALUES (100, 'PROPIETARIO', 'TABLA_POSICIONES_E3', 'INSERT', '1', 'Posiciones recalculadas con INSERT SELECT');

SELECT COUNT(*) AS auditorias FROM auditoria_evento;

COMMIT;
