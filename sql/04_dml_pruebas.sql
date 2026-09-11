-- Entrega 1 - DML, errores controlados y comportamiento ON DELETE
-- Requiere haber ejecutado el DDL y el dataset.

SET DEFINE OFF;
SET SERVEROUTPUT ON;

DECLARE
    c_partido_prueba CONSTANT NUMBER := 990000;
    v_estado         partido.estado_partido%TYPE;
    v_hijos          NUMBER;
    v_rechazada      BOOLEAN;
    v_codigo_error   NUMBER;
    v_mensaje_error  VARCHAR2(4000);
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== CICLO DE VIDA DE UN PARTIDO ===');

    -- 1. Crear el encuentro en estado transitorio.
    INSERT INTO partido (
        id_partido, id_edicion, id_estadio, fecha_hora, fase,
        asistencia_registrada, estado_partido
    ) VALUES (
        c_partido_prueba,
        1,
        1001,
        TIMESTAMP '2026-07-19 18:00:00',
        'FASE DE GRUPOS',
        30000,
        'PROGRAMADO'
    );

    -- 2. Registrar las dos selecciones en una sola sentencia.
    INSERT ALL
        INTO participacion_partido (
            id_participacion, id_partido, id_edicion, id_seleccion,
            condicion, goles_marcados, resultado
        ) VALUES (
            c_partido_prueba * 10 + 1,
            c_partido_prueba,
            1,
            1001,
            'LOCAL',
            0,
            'EMPATO'
        )
        INTO participacion_partido (
            id_participacion, id_partido, id_edicion, id_seleccion,
            condicion, goles_marcados, resultado
        ) VALUES (
            c_partido_prueba * 10 + 2,
            c_partido_prueba,
            1,
            1002,
            'VISITANTE',
            0,
            'EMPATO'
        )
    SELECT 1 FROM dual;

    -- 3. Actualizar el marcador de ambas participaciones.
    UPDATE participacion_partido
       SET goles_marcados = CASE
                                WHEN condicion = 'LOCAL' THEN 2
                                ELSE 1
                            END,
           resultado = CASE
                          WHEN condicion = 'LOCAL' THEN 'GANO'
                          ELSE 'PERDIO'
                      END
     WHERE id_partido = c_partido_prueba;

    -- 4. Cerrar el partido; el trigger exige exactamente dos participaciones.
    UPDATE partido
       SET estado_partido = 'FINALIZADO'
     WHERE id_partido = c_partido_prueba;

    SELECT estado_partido
      INTO v_estado
      FROM partido
     WHERE id_partido = c_partido_prueba;

    DBMS_OUTPUT.PUT_LINE('Partido ' || c_partido_prueba
                         || ' cerrado con estado: ' || v_estado);

    DBMS_OUTPUT.PUT_LINE('=== OPERACIONES INVALIDAS ===');

    -- Caso inválido 1: CHECK de goles no negativos.
    SAVEPOINT prueba_gol_negativo;
    v_rechazada := FALSE;
    BEGIN
        UPDATE participacion_partido
           SET goles_marcados = -1
         WHERE id_participacion = c_partido_prueba * 10 + 1;
    EXCEPTION
        WHEN OTHERS THEN
            v_rechazada := TRUE;
            v_codigo_error := SQLCODE;
            v_mensaje_error := SQLERRM;
            ROLLBACK TO prueba_gol_negativo;
            IF v_codigo_error <> -2290 THEN
                RAISE;
            END IF;
            DBMS_OUTPUT.PUT_LINE(
                'Caso 1 rechazado correctamente (gol negativo): '
                || v_mensaje_error
            );
    END;
    IF NOT v_rechazada THEN
        ROLLBACK TO prueba_gol_negativo;
        RAISE_APPLICATION_ERROR(
            -20901,
            'La prueba del gol negativo no produjo error.'
        );
    END IF;

    -- Caso inválido 2: un tercer participante repite la condición LOCAL.
    SAVEPOINT prueba_tercer_participante;
    v_rechazada := FALSE;
    BEGIN
        INSERT INTO participacion_partido (
            id_participacion, id_partido, id_edicion, id_seleccion,
            condicion, goles_marcados, resultado
        ) VALUES (
            c_partido_prueba * 10 + 3,
            c_partido_prueba,
            1,
            1003,
            'LOCAL',
            0,
            'EMPATO'
        );
    EXCEPTION
        WHEN OTHERS THEN
            v_rechazada := TRUE;
            v_codigo_error := SQLCODE;
            v_mensaje_error := SQLERRM;
            ROLLBACK TO prueba_tercer_participante;
            IF v_codigo_error <> -1 THEN
                RAISE;
            END IF;
            DBMS_OUTPUT.PUT_LINE(
                'Caso 2 rechazado correctamente (tercer participante): '
                || v_mensaje_error
            );
    END;
    IF NOT v_rechazada THEN
        ROLLBACK TO prueba_tercer_participante;
        RAISE_APPLICATION_ERROR(
            -20902,
            'La prueba de la tercera participación no produjo error.'
        );
    END IF;

    -- Caso inválido 3: el partido se agenda fuera del periodo de la edición.
    SAVEPOINT prueba_fecha_fuera_rango;
    v_rechazada := FALSE;
    BEGIN
        INSERT INTO partido (
            id_partido, id_edicion, id_estadio, fecha_hora, fase,
            asistencia_registrada, estado_partido
        ) VALUES (
            c_partido_prueba + 1,
            1,
            1001,
            TIMESTAMP '2027-01-01 12:00:00',
            'FASE DE GRUPOS',
            1000,
            'PROGRAMADO'
        );
    EXCEPTION
        WHEN OTHERS THEN
            v_rechazada := TRUE;
            v_codigo_error := SQLCODE;
            v_mensaje_error := SQLERRM;
            ROLLBACK TO prueba_fecha_fuera_rango;
            IF v_codigo_error <> -20001 THEN
                RAISE;
            END IF;
            DBMS_OUTPUT.PUT_LINE(
                'Caso 3 rechazado correctamente (fecha fuera de rango): '
                || v_mensaje_error
            );
    END;
    IF NOT v_rechazada THEN
        ROLLBACK TO prueba_fecha_fuera_rango;
        RAISE_APPLICATION_ERROR(
            -20903,
            'La prueba de fecha fuera de rango no produjo error.'
        );
    END IF;

    -- Caso inválido 4: resultado textual contrario al marcador.
    SAVEPOINT prueba_resultado_inconsistente;
    v_rechazada := FALSE;
    BEGIN
        UPDATE participacion_partido
           SET resultado = 'GANO'
         WHERE id_participacion = c_partido_prueba * 10 + 2;
    EXCEPTION
        WHEN OTHERS THEN
            v_rechazada := TRUE;
            v_codigo_error := SQLCODE;
            v_mensaje_error := SQLERRM;
            ROLLBACK TO prueba_resultado_inconsistente;
            IF v_codigo_error <> -20006 THEN
                RAISE;
            END IF;
            DBMS_OUTPUT.PUT_LINE(
                'Caso 4 rechazado correctamente (resultado inconsistente): '
                || v_mensaje_error
            );
    END;
    IF NOT v_rechazada THEN
        ROLLBACK TO prueba_resultado_inconsistente;
        RAISE_APPLICATION_ERROR(
            -20904,
            'La prueba de resultado inconsistente no produjo error.'
        );
    END IF;

    -- Caso inválido 5: intento de borrar una participación de un partido
    -- finalizado; la pareja debe conservarse completa.
    SAVEPOINT prueba_borrado_participacion;
    v_rechazada := FALSE;
    BEGIN
        DELETE FROM participacion_partido
         WHERE id_participacion = c_partido_prueba * 10 + 1;
    EXCEPTION
        WHEN OTHERS THEN
            v_rechazada := TRUE;
            v_codigo_error := SQLCODE;
            v_mensaje_error := SQLERRM;
            ROLLBACK TO prueba_borrado_participacion;
            IF v_codigo_error <> -20013 THEN
                RAISE;
            END IF;
            DBMS_OUTPUT.PUT_LINE(
                'Caso 5 rechazado correctamente (partido finalizado): '
                || v_mensaje_error
            );
    END;
    IF NOT v_rechazada THEN
        ROLLBACK TO prueba_borrado_participacion;
        RAISE_APPLICATION_ERROR(
            -20905,
            'La eliminación de una participación finalizada no fue rechazada.'
        );
    END IF;

    -- Caso inválido 6: un partido no puede nacer directamente como
    -- FINALIZADO sin haber registrado sus dos participaciones.
    SAVEPOINT prueba_cierre_directo;
    v_rechazada := FALSE;
    BEGIN
        INSERT INTO partido (
            id_partido, id_edicion, id_estadio, fecha_hora, fase,
            asistencia_registrada, estado_partido
        ) VALUES (
            c_partido_prueba + 2,
            1,
            1001,
            TIMESTAMP '2026-07-19 21:00:00',
            'FASE DE GRUPOS',
            1000,
            'FINALIZADO'
        );
    EXCEPTION
        WHEN OTHERS THEN
            v_rechazada := TRUE;
            v_codigo_error := SQLCODE;
            v_mensaje_error := SQLERRM;
            ROLLBACK TO prueba_cierre_directo;
            IF v_codigo_error <> -20007 THEN
                RAISE;
            END IF;
            DBMS_OUTPUT.PUT_LINE(
                'Caso 6 rechazado correctamente (cierre directo): '
                || v_mensaje_error
            );
    END;
    IF NOT v_rechazada THEN
        ROLLBACK TO prueba_cierre_directo;
        RAISE_APPLICATION_ERROR(
            -20906,
            'Un partido fue creado como FINALIZADO sin participaciones.'
        );
    END IF;

    DBMS_OUTPUT.PUT_LINE('=== PRUEBAS ON DELETE ===');

    -- Relación CASCADE: borrar el partido borra sus participaciones.
    DELETE FROM partido
     WHERE id_partido = c_partido_prueba;

    SELECT COUNT(*)
      INTO v_hijos
      FROM participacion_partido
     WHERE id_partido = c_partido_prueba;

    IF v_hijos = 0 THEN
        DBMS_OUTPUT.PUT_LINE(
            'CASCADE verificado: las participaciones del partido fueron borradas.'
        );
    ELSE
        DBMS_OUTPUT.PUT_LINE(
            'ERROR: CASCADE no produjo el resultado esperado.'
        );
    END IF;

    -- Relación NO ACTION implícita (equivalente a RESTRICT):
    -- una selección con historial no se puede eliminar.
    SAVEPOINT prueba_restrict_seleccion;
    v_rechazada := FALSE;
    BEGIN
        DELETE FROM seleccion
         WHERE id_seleccion = 1001
           AND id_edicion = 1;
    EXCEPTION
        WHEN OTHERS THEN
            v_rechazada := TRUE;
            v_codigo_error := SQLCODE;
            v_mensaje_error := SQLERRM;
            ROLLBACK TO prueba_restrict_seleccion;
            IF v_codigo_error <> -2292 THEN
                RAISE;
            END IF;
            DBMS_OUTPUT.PUT_LINE(
                'NO ACTION/RESTRICT verificado: selección protegida: '
                || v_mensaje_error
            );
    END;
    IF NOT v_rechazada THEN
        ROLLBACK TO prueba_restrict_seleccion;
        RAISE_APPLICATION_ERROR(
            -20907,
            'La selección con historial fue eliminada.'
        );
    END IF;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Pruebas DML finalizadas y transacción confirmada.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Pruebas DML canceladas: ' || SQLERRM);
        RAISE;
END;
/
