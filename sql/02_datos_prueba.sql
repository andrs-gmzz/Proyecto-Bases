-- Entrega 1 - Dataset sintético reproducible para Oracle
-- Requiere haber ejecutado previamente sql/01_ddl.sql.
-- Si se ejecuta de nuevo, eliminar primero los datos de las cinco tablas.

SET DEFINE OFF;
SET SERVEROUTPUT ON;

DECLARE
    v_id_edicion        NUMBER(4);
    v_anio              NUMBER(4);
    v_pais_sede         VARCHAR2(120);
    v_lema              VARCHAR2(200);
    v_fecha_inicio      DATE;
    v_fecha_fin         DATE;

    v_id_estadio         NUMBER(10);
    v_nombre_estadio     VARCHAR2(120);
    v_ciudad             VARCHAR2(80);
    v_capacidad          NUMBER(6);

    v_id_seleccion       NUMBER(10);
    v_pais               VARCHAR2(100);
    v_confederacion      VARCHAR2(20);

    v_id_partido         NUMBER(10);
    v_id_participacion   NUMBER(12);
    v_estadio_no         NUMBER;
    v_local_no           NUMBER;
    v_visitante_no       NUMBER;
    v_fecha_hora         TIMESTAMP;
    v_fase               VARCHAR2(30);
    v_asistencia         NUMBER(6);
    v_goles_local        NUMBER(3);
    v_goles_visitante    NUMBER(3);
    v_resultado_local    VARCHAR2(7);
    v_resultado_visitante VARCHAR2(7);
BEGIN
    FOR v_id_edicion IN 1 .. 4 LOOP
        v_anio := CASE v_id_edicion
            WHEN 1 THEN 2026
            WHEN 2 THEN 2030
            WHEN 3 THEN 2034
            ELSE 2038
        END;

        v_pais_sede := CASE v_id_edicion
            WHEN 1 THEN 'Canada, Estados Unidos y Mexico'
            WHEN 2 THEN 'Espana, Portugal y Marruecos'
            WHEN 3 THEN 'Arabia Saudita'
            ELSE 'Sede sintetica 2038'
        END;

        v_lema := 'Copa Mundial sintetica ' || TO_CHAR(v_anio);

        v_fecha_inicio := CASE v_id_edicion
            WHEN 1 THEN DATE '2026-06-11'
            WHEN 2 THEN DATE '2030-06-01'
            WHEN 3 THEN DATE '2034-06-01'
            ELSE DATE '2038-06-01'
        END;

        v_fecha_fin := CASE v_id_edicion
            WHEN 1 THEN DATE '2026-07-19'
            WHEN 2 THEN DATE '2030-07-15'
            WHEN 3 THEN DATE '2034-07-20'
            ELSE DATE '2038-07-20'
        END;

        INSERT INTO edicion_mundial (
            id_edicion, anio, pais_sede, lema, fecha_inicio, fecha_fin
        ) VALUES (
            v_id_edicion, v_anio, v_pais_sede, v_lema,
            v_fecha_inicio, v_fecha_fin
        );

        -- 25 estadios por edición: 100 registros en total.
        FOR v_estadio_no IN 1 .. 25 LOOP
            v_id_estadio := v_id_edicion * 1000 + v_estadio_no;
            v_nombre_estadio := 'Estadio Sintetico '
                                || LPAD(TO_CHAR(v_estadio_no), 2, '0');
            v_ciudad := 'Ciudad Sede '
                        || LPAD(TO_CHAR(v_estadio_no), 2, '0');
            v_capacidad := 40000 + MOD(v_estadio_no, 13) * 5000;

            INSERT INTO estadio (
                id_estadio, id_edicion, nombre, ciudad, capacidad
            ) VALUES (
                v_id_estadio, v_id_edicion, v_nombre_estadio,
                v_ciudad, v_capacidad
            );
        END LOOP;

        -- 48 selecciones por edición: 192 registros en total.
        FOR v_local_no IN 1 .. 48 LOOP
            v_id_seleccion := v_id_edicion * 1000 + v_local_no;
            v_pais := 'Nacion Sintetica '
                      || LPAD(TO_CHAR(v_local_no), 2, '0');
            v_confederacion := CASE MOD(v_local_no - 1, 6)
                WHEN 0 THEN 'CONMEBOL'
                WHEN 1 THEN 'UEFA'
                WHEN 2 THEN 'CONCACAF'
                WHEN 3 THEN 'CAF'
                WHEN 4 THEN 'AFC'
                ELSE 'OFC'
            END;

            INSERT INTO seleccion (
                id_seleccion, id_edicion, pais, confederacion
            ) VALUES (
                v_id_seleccion, v_id_edicion, v_pais, v_confederacion
            );
        END LOOP;

        -- 104 partidos por edición: 416 registros y 832 participaciones.
        FOR v_estadio_no IN 1 .. 104 LOOP
            v_id_partido := v_id_edicion * 10000 + v_estadio_no;
            v_id_estadio := v_id_edicion * 1000
                            + MOD(v_estadio_no - 1, 25) + 1;
            -- Las selecciones 1 y 2 aparecen como visitantes para
            -- conservar casos útiles para la consulta 10.
            v_local_no := MOD(v_estadio_no - 1, 46) + 3;
            v_visitante_no := MOD(v_estadio_no * 7, 48) + 1;
            IF v_local_no = v_visitante_no THEN
                v_visitante_no := MOD(v_visitante_no, 48) + 1;
            END IF;

            v_fecha_hora := CAST(v_fecha_inicio AS TIMESTAMP)
                + NUMTODSINTERVAL(
                    CASE
                        WHEN v_estadio_no <= 72
                            THEN FLOOR((v_estadio_no - 1) / 4)
                        WHEN v_estadio_no <= 88
                            THEN 18 + FLOOR((v_estadio_no - 73) / 4)
                        WHEN v_estadio_no <= 96
                            THEN 22 + FLOOR((v_estadio_no - 89) / 4)
                        WHEN v_estadio_no <= 100
                            THEN 24 + FLOOR((v_estadio_no - 97) / 2)
                        WHEN v_estadio_no <= 102
                            THEN 26 + (v_estadio_no - 101)
                        WHEN v_estadio_no = 103
                            THEN 28
                        ELSE 29
                    END,
                    'DAY'
                )
                + NUMTODSINTERVAL(MOD(v_estadio_no, 4) * 3, 'HOUR');

            v_fase := CASE
                WHEN v_estadio_no <= 72 THEN 'FASE DE GRUPOS'
                WHEN v_estadio_no <= 88 THEN 'DIECISEISAVOS'
                WHEN v_estadio_no <= 96 THEN 'OCTAVOS'
                WHEN v_estadio_no <= 100 THEN 'CUARTOS'
                WHEN v_estadio_no <= 102 THEN 'SEMIFINALES'
                WHEN v_estadio_no = 103 THEN 'TERCER PUESTO'
                ELSE 'FINAL'
            END;

            SELECT capacidad
              INTO v_capacidad
              FROM estadio
             WHERE id_estadio = v_id_estadio
               AND id_edicion = v_id_edicion;

            v_asistencia := 20000
                + MOD(v_estadio_no * 113 + v_id_edicion * 17,
                      v_capacidad - 20000);

            v_goles_local := MOD(v_estadio_no * 3 + v_id_edicion, 8);
            v_goles_visitante := MOD(
                v_estadio_no * 5 + v_id_edicion * 2, 8
            );

            IF v_goles_local > v_goles_visitante THEN
                v_resultado_local := 'GANO';
                v_resultado_visitante := 'PERDIO';
            ELSIF v_goles_local < v_goles_visitante THEN
                v_resultado_local := 'PERDIO';
                v_resultado_visitante := 'GANO';
            ELSE
                v_resultado_local := 'EMPATO';
                v_resultado_visitante := 'EMPATO';
            END IF;

            INSERT INTO partido (
                id_partido, id_edicion, id_estadio, fecha_hora, fase,
                asistencia_registrada, estado_partido
            ) VALUES (
                v_id_partido, v_id_edicion, v_id_estadio, v_fecha_hora,
                v_fase, v_asistencia, 'PROGRAMADO'
            );

            -- Se cargan ambas participaciones en una sola sentencia para
            -- que la regla de cierre pueda validar la pareja completa.
            INSERT ALL
                INTO participacion_partido (
                    id_participacion, id_partido, id_edicion,
                    id_seleccion, condicion, goles_marcados, resultado
                ) VALUES (
                    v_id_partido * 10 + 1, v_id_partido, v_id_edicion,
                    v_id_edicion * 1000 + v_local_no, 'LOCAL',
                    v_goles_local, v_resultado_local
                )
                INTO participacion_partido (
                    id_participacion, id_partido, id_edicion,
                    id_seleccion, condicion, goles_marcados, resultado
                ) VALUES (
                    v_id_partido * 10 + 2, v_id_partido, v_id_edicion,
                    v_id_edicion * 1000 + v_visitante_no, 'VISITANTE',
                    v_goles_visitante, v_resultado_visitante
                )
            SELECT 1 FROM dual;

            -- El estado se cierra después de insertar la pareja.
            UPDATE partido
               SET estado_partido = 'FINALIZADO'
             WHERE id_partido = v_id_partido;
        END LOOP;
    END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Dataset cargado correctamente.');
    DBMS_OUTPUT.PUT_LINE('Ediciones: 4');
    DBMS_OUTPUT.PUT_LINE('Estadios: 100');
    DBMS_OUTPUT.PUT_LINE('Selecciones: 192');
    DBMS_OUTPUT.PUT_LINE('Partidos: 416');
    DBMS_OUTPUT.PUT_LINE('Participaciones: 832');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Carga cancelada: ' || SQLERRM);
        RAISE;
END;
/
