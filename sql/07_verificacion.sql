-- Entrega 1 - Consultas de verificación y evidencias
-- Ejecutar después de cargar datos, vistas y pruebas DML.

SET DEFINE OFF;

------------------------------------------------------------------------
-- Conteo de filas por tabla
------------------------------------------------------------------------

SELECT 'EDICION_MUNDIAL' AS tabla, COUNT(*) AS cantidad
  FROM edicion_mundial
UNION ALL
SELECT 'ESTADIO', COUNT(*)
  FROM estadio
UNION ALL
SELECT 'SELECCION', COUNT(*)
  FROM seleccion
UNION ALL
SELECT 'PARTIDO', COUNT(*)
  FROM partido
UNION ALL
SELECT 'PARTICIPACION_PARTIDO', COUNT(*)
  FROM participacion_partido
ORDER BY tabla;

------------------------------------------------------------------------
-- Debe devolver cero filas: todos los partidos tienen exactamente dos
-- participaciones.
------------------------------------------------------------------------

SELECT p.id_partido, p.id_edicion, COUNT(pp.id_participacion) AS cantidad
  FROM partido p
  LEFT JOIN participacion_partido pp
    ON pp.id_partido = p.id_partido
   AND pp.id_edicion = p.id_edicion
 GROUP BY p.id_partido, p.id_edicion
HAVING COUNT(pp.id_participacion) <> 2
 ORDER BY p.id_partido;

------------------------------------------------------------------------
-- Debe devolver cero filas: no hay dos locales, dos visitantes ni
-- selecciones repetidas en un mismo partido.
------------------------------------------------------------------------

SELECT id_partido, condicion, COUNT(*) AS cantidad
  FROM participacion_partido
 GROUP BY id_partido, condicion
HAVING COUNT(*) > 1
 ORDER BY id_partido, condicion;

SELECT id_partido, id_seleccion, COUNT(*) AS cantidad
  FROM participacion_partido
 GROUP BY id_partido, id_seleccion
HAVING COUNT(*) > 1
 ORDER BY id_partido, id_seleccion;

------------------------------------------------------------------------
-- Debe devolver cero filas: partidos dentro del rango de su edición.
------------------------------------------------------------------------

SELECT p.id_partido, e.anio, p.fecha_hora
  FROM partido p
  JOIN edicion_mundial e
    ON e.id_edicion = p.id_edicion
 WHERE p.fecha_hora < CAST(e.fecha_inicio AS TIMESTAMP)
    OR p.fecha_hora >= CAST(e.fecha_fin + 1 AS TIMESTAMP)
 ORDER BY p.id_partido;

------------------------------------------------------------------------
-- Debe devolver cero filas: asistencia no superior a la capacidad.
------------------------------------------------------------------------

SELECT p.id_partido, es.nombre AS estadio,
       p.asistencia_registrada, es.capacidad
  FROM partido p
  JOIN estadio es
    ON es.id_estadio = p.id_estadio
   AND es.id_edicion = p.id_edicion
 WHERE p.asistencia_registrada > es.capacidad
 ORDER BY p.id_partido;

------------------------------------------------------------------------
-- Conteo de registros producidos por las cinco vistas.
------------------------------------------------------------------------

SELECT 'VW_MARCADOR_PARTIDOS' AS vista, COUNT(*) AS cantidad
  FROM vw_marcador_partidos
UNION ALL
SELECT 'VW_TABLA_POSICIONES', COUNT(*)
  FROM vw_tabla_posiciones
UNION ALL
SELECT 'VW_GOLEADORES_SEL', COUNT(*)
  FROM vw_goleadores_sel
UNION ALL
SELECT 'VW_OCUPACION_ESTADIO', COUNT(*)
  FROM vw_ocupacion_estadio
UNION ALL
SELECT 'VW_PARTIDOS_ATIPICOS', COUNT(*)
  FROM vw_partidos_atipicos
ORDER BY vista;

------------------------------------------------------------------------
-- Resumen automático. Si una regla estructural falla, el bloque termina
-- con error para que la ejecución quede visible en SQL Developer.
------------------------------------------------------------------------

SET SERVEROUTPUT ON;

DECLARE
    v_ediciones             NUMBER;
    v_estadios              NUMBER;
    v_selecciones           NUMBER;
    v_partidos              NUMBER;
    v_participaciones       NUMBER;
    v_partidos_incompletos  NUMBER;
    v_duplicados_condicion  NUMBER;
    v_duplicados_seleccion  NUMBER;
    v_fuera_edicion         NUMBER;
    v_aforo_excedido        NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_ediciones FROM edicion_mundial;
    SELECT COUNT(*) INTO v_estadios FROM estadio;
    SELECT COUNT(*) INTO v_selecciones FROM seleccion;
    SELECT COUNT(*) INTO v_partidos FROM partido;
    SELECT COUNT(*) INTO v_participaciones FROM participacion_partido;

    SELECT COUNT(*)
      INTO v_partidos_incompletos
      FROM (
            SELECT p.id_partido
              FROM partido p
              LEFT JOIN participacion_partido pp
                ON pp.id_partido = p.id_partido
               AND pp.id_edicion = p.id_edicion
             GROUP BY p.id_partido
            HAVING COUNT(pp.id_participacion) <> 2
           );

    SELECT COUNT(*)
      INTO v_duplicados_condicion
      FROM (
            SELECT id_partido, condicion
              FROM participacion_partido
             GROUP BY id_partido, condicion
            HAVING COUNT(*) > 1
           );

    SELECT COUNT(*)
      INTO v_duplicados_seleccion
      FROM (
            SELECT id_partido, id_seleccion
              FROM participacion_partido
             GROUP BY id_partido, id_seleccion
            HAVING COUNT(*) > 1
           );

    SELECT COUNT(*)
      INTO v_fuera_edicion
      FROM partido p
      JOIN edicion_mundial e
        ON e.id_edicion = p.id_edicion
     WHERE p.fecha_hora < CAST(e.fecha_inicio AS TIMESTAMP)
        OR p.fecha_hora >= CAST(e.fecha_fin + 1 AS TIMESTAMP);

    SELECT COUNT(*)
      INTO v_aforo_excedido
      FROM partido p
      JOIN estadio es
        ON es.id_estadio = p.id_estadio
       AND es.id_edicion = p.id_edicion
     WHERE p.asistencia_registrada > es.capacidad;

    DBMS_OUTPUT.PUT_LINE('=== RESUMEN DE VERIFICACION ===');
    DBMS_OUTPUT.PUT_LINE('Ediciones: ' || v_ediciones);
    DBMS_OUTPUT.PUT_LINE('Estadios: ' || v_estadios);
    DBMS_OUTPUT.PUT_LINE('Selecciones: ' || v_selecciones);
    DBMS_OUTPUT.PUT_LINE('Partidos: ' || v_partidos);
    DBMS_OUTPUT.PUT_LINE('Participaciones: ' || v_participaciones);
    DBMS_OUTPUT.PUT_LINE(
        'Partidos con cantidad de participaciones distinta de 2: '
        || v_partidos_incompletos
    );
    DBMS_OUTPUT.PUT_LINE(
        'Duplicados por condicion: ' || v_duplicados_condicion
    );
    DBMS_OUTPUT.PUT_LINE(
        'Duplicados por seleccion: ' || v_duplicados_seleccion
    );
    DBMS_OUTPUT.PUT_LINE('Partidos fuera de edicion: ' || v_fuera_edicion);
    DBMS_OUTPUT.PUT_LINE('Partidos sobre el aforo: ' || v_aforo_excedido);

    IF v_ediciones <> 4
       OR v_estadios <> 100
       OR v_selecciones <> 192
       OR v_partidos <> 416
       OR v_participaciones <> 832
       OR v_partidos_incompletos > 0
       OR v_duplicados_condicion > 0
       OR v_duplicados_seleccion > 0
       OR v_fuera_edicion > 0
       OR v_aforo_excedido > 0 THEN
        RAISE_APPLICATION_ERROR(
            -20910,
            'La verificacion estructural encontro inconsistencias.'
        );
    END IF;

    DBMS_OUTPUT.PUT_LINE('VERIFICACION ESTRUCTURAL: OK');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('VERIFICACION ESTRUCTURAL: ERROR - ' || SQLERRM);
        RAISE;
END;
/
