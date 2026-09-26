-- Entrega 1 BASICA - Dataset sintetico con solo INSERT (Modificadores)
-- Requiere haber ejecutado sql/01_ddl.sql.
-- Solo usa INSERT INTO ... VALUES (tema 7-Modificadores).
-- NO usa PL/SQL, ni bucles, ni INSERT ALL, ni SELECT FROM dual.
-- Dataset pequeno pero suficiente para las 15 consultas:
--   2 ediciones, 5 estadios, 10 selecciones, 8 partidos, 16 participaciones.
-- Todos los datos son ficticios.

SET DEFINE OFF;

------------------------------------------------------------------------
-- Ediciones
------------------------------------------------------------------------

INSERT INTO edicion_mundial (id_edicion, anio, pais_sede, lema, fecha_inicio, fecha_fin)
VALUES (1, 2026, 'Mexico, Canada y Estados Unidos', 'Copa 2026', DATE '2026-06-11', DATE '2026-07-19');

INSERT INTO edicion_mundial (id_edicion, anio, pais_sede, lema, fecha_inicio, fecha_fin)
VALUES (2, 2030, 'Espana, Portugal y Marruecos', 'Copa 2030', DATE '2030-06-01', DATE '2030-07-15');

------------------------------------------------------------------------
-- Estadios (capacidad coherente con la asistencia de los partidos)
------------------------------------------------------------------------

INSERT INTO estadio (id_estadio, id_edicion, nombre, ciudad, capacidad)
VALUES (1001, 1, 'Estadio Azteca', 'Ciudad de Mexico', 80000);

INSERT INTO estadio (id_estadio, id_edicion, nombre, ciudad, capacidad)
VALUES (1002, 1, 'Estadio Bogota', 'Bogota', 50000);

INSERT INTO estadio (id_estadio, id_edicion, nombre, ciudad, capacidad)
VALUES (1003, 1, 'Estadio Berlin', 'Berlin', 60000);

INSERT INTO estadio (id_estadio, id_edicion, nombre, ciudad, capacidad)
VALUES (2001, 2, 'Estadio Bernabeu', 'Madrid', 81000);

INSERT INTO estadio (id_estadio, id_edicion, nombre, ciudad, capacidad)
VALUES (2002, 2, 'Estadio Da Luz', 'Lisboa', 65000);

------------------------------------------------------------------------
-- Selecciones 2026 (6): incluye casos para consulta 10 (visitante puro)
------------------------------------------------------------------------

INSERT INTO seleccion (id_seleccion, id_edicion, pais, confederacion)
VALUES (101, 1, 'Colombia', 'CONMEBOL');

INSERT INTO seleccion (id_seleccion, id_edicion, pais, confederacion)
VALUES (102, 1, 'Alemania', 'UEFA');

INSERT INTO seleccion (id_seleccion, id_edicion, pais, confederacion)
VALUES (103, 1, 'Mexico', 'CONCACAF');

INSERT INTO seleccion (id_seleccion, id_edicion, pais, confederacion)
VALUES (104, 1, 'Senegal', 'CAF');

INSERT INTO seleccion (id_seleccion, id_edicion, pais, confederacion)
VALUES (105, 1, 'Japon', 'AFC');

INSERT INTO seleccion (id_seleccion, id_edicion, pais, confederacion)
VALUES (106, 1, 'Nueva Zelanda', 'OFC');

------------------------------------------------------------------------
-- Selecciones 2030 (4)
------------------------------------------------------------------------

INSERT INTO seleccion (id_seleccion, id_edicion, pais, confederacion)
VALUES (201, 2, 'Espana', 'UEFA');

INSERT INTO seleccion (id_seleccion, id_edicion, pais, confederacion)
VALUES (202, 2, 'Argentina', 'CONMEBOL');

INSERT INTO seleccion (id_seleccion, id_edicion, pais, confederacion)
VALUES (203, 2, 'Marruecos', 'CAF');

INSERT INTO seleccion (id_seleccion, id_edicion, pais, confederacion)
VALUES (204, 2, 'Portugal', 'UEFA');

------------------------------------------------------------------------
-- Partidos 2026 (6): fechas dentro de la edicion, sin choques de agenda.
-- 5002 es 0-0 y 5003 suma 8 goles (casos atipicos de la consulta 6).
------------------------------------------------------------------------

INSERT INTO partido (id_partido, id_edicion, id_estadio, fecha_hora, fase, asistencia_registrada, estado_partido)
VALUES (5001, 1, 1001, TO_DATE('2026-06-12 16:00', 'YYYY-MM-DD HH24:MI'), 'FASE DE GRUPOS', 75000, 'FINALIZADO');

INSERT INTO partido (id_partido, id_edicion, id_estadio, fecha_hora, fase, asistencia_registrada, estado_partido)
VALUES (5002, 1, 1002, TO_DATE('2026-06-13 16:00', 'YYYY-MM-DD HH24:MI'), 'FASE DE GRUPOS', 40000, 'FINALIZADO');

INSERT INTO partido (id_partido, id_edicion, id_estadio, fecha_hora, fase, asistencia_registrada, estado_partido)
VALUES (5003, 1, 1003, TO_DATE('2026-06-14 16:00', 'YYYY-MM-DD HH24:MI'), 'FASE DE GRUPOS', 55000, 'FINALIZADO');

INSERT INTO partido (id_partido, id_edicion, id_estadio, fecha_hora, fase, asistencia_registrada, estado_partido)
VALUES (5004, 1, 1001, TO_DATE('2026-06-20 16:00', 'YYYY-MM-DD HH24:MI'), 'OCTAVOS', 78000, 'FINALIZADO');

INSERT INTO partido (id_partido, id_edicion, id_estadio, fecha_hora, fase, asistencia_registrada, estado_partido)
VALUES (5005, 1, 1002, TO_DATE('2026-06-25 16:00', 'YYYY-MM-DD HH24:MI'), 'CUARTOS', 48000, 'FINALIZADO');

INSERT INTO partido (id_partido, id_edicion, id_estadio, fecha_hora, fase, asistencia_registrada, estado_partido)
VALUES (5006, 1, 1001, TO_DATE('2026-07-01 16:00', 'YYYY-MM-DD HH24:MI'), 'FINAL', 79000, 'FINALIZADO');

------------------------------------------------------------------------
-- Partidos 2030 (2)
------------------------------------------------------------------------

INSERT INTO partido (id_partido, id_edicion, id_estadio, fecha_hora, fase, asistencia_registrada, estado_partido)
VALUES (6001, 2, 2001, TO_DATE('2030-06-05 16:00', 'YYYY-MM-DD HH24:MI'), 'FASE DE GRUPOS', 70000, 'FINALIZADO');

INSERT INTO partido (id_partido, id_edicion, id_estadio, fecha_hora, fase, asistencia_registrada, estado_partido)
VALUES (6002, 2, 2002, TO_DATE('2030-06-20 16:00', 'YYYY-MM-DD HH24:MI'), 'FINAL', 60000, 'FINALIZADO');

------------------------------------------------------------------------
-- Participaciones: exactamente 2 por partido (LOCAL + VISITANTE).
-- El resultado es coherente con los goles (se cargo bien desde el inicio).
------------------------------------------------------------------------

-- 5001 Colombia 2-1 Alemania
INSERT INTO participacion_partido (id_participacion, id_partido, id_seleccion, condicion, goles_marcados, resultado)
VALUES (500101, 5001, 101, 'LOCAL', 2, 'GANO');

INSERT INTO participacion_partido (id_participacion, id_partido, id_seleccion, condicion, goles_marcados, resultado)
VALUES (500102, 5001, 102, 'VISITANTE', 1, 'PERDIO');

-- 5002 Mexico 0-0 Senegal
INSERT INTO participacion_partido (id_participacion, id_partido, id_seleccion, condicion, goles_marcados, resultado)
VALUES (500201, 5002, 103, 'LOCAL', 0, 'EMPATO');

INSERT INTO participacion_partido (id_participacion, id_partido, id_seleccion, condicion, goles_marcados, resultado)
VALUES (500202, 5002, 104, 'VISITANTE', 0, 'EMPATO');

-- 5003 Japon 4-4 Nueva Zelanda
INSERT INTO participacion_partido (id_participacion, id_partido, id_seleccion, condicion, goles_marcados, resultado)
VALUES (500301, 5003, 105, 'LOCAL', 4, 'EMPATO');

INSERT INTO participacion_partido (id_participacion, id_partido, id_seleccion, condicion, goles_marcados, resultado)
VALUES (500302, 5003, 106, 'VISITANTE', 4, 'EMPATO');

-- 5004 Colombia 3-0 Mexico
INSERT INTO participacion_partido (id_participacion, id_partido, id_seleccion, condicion, goles_marcados, resultado)
VALUES (500401, 5004, 101, 'LOCAL', 3, 'GANO');

INSERT INTO participacion_partido (id_participacion, id_partido, id_seleccion, condicion, goles_marcados, resultado)
VALUES (500402, 5004, 103, 'VISITANTE', 0, 'PERDIO');

-- 5005 Alemania 1-2 Colombia
INSERT INTO participacion_partido (id_participacion, id_partido, id_seleccion, condicion, goles_marcados, resultado)
VALUES (500501, 5005, 102, 'LOCAL', 1, 'PERDIO');

INSERT INTO participacion_partido (id_participacion, id_partido, id_seleccion, condicion, goles_marcados, resultado)
VALUES (500502, 5005, 101, 'VISITANTE', 2, 'GANO');

-- 5006 Colombia 1-1 Japon
INSERT INTO participacion_partido (id_participacion, id_partido, id_seleccion, condicion, goles_marcados, resultado)
VALUES (500601, 5006, 101, 'LOCAL', 1, 'EMPATO');

INSERT INTO participacion_partido (id_participacion, id_partido, id_seleccion, condicion, goles_marcados, resultado)
VALUES (500602, 5006, 105, 'VISITANTE', 1, 'EMPATO');

-- 6001 Espana 2-0 Argentina
INSERT INTO participacion_partido (id_participacion, id_partido, id_seleccion, condicion, goles_marcados, resultado)
VALUES (600101, 6001, 201, 'LOCAL', 2, 'GANO');

INSERT INTO participacion_partido (id_participacion, id_partido, id_seleccion, condicion, goles_marcados, resultado)
VALUES (600102, 6001, 202, 'VISITANTE', 0, 'PERDIO');

-- 6002 Portugal 1-0 Marruecos
INSERT INTO participacion_partido (id_participacion, id_partido, id_seleccion, condicion, goles_marcados, resultado)
VALUES (600201, 6002, 204, 'LOCAL', 1, 'GANO');

INSERT INTO participacion_partido (id_participacion, id_partido, id_seleccion, condicion, goles_marcados, resultado)
VALUES (600202, 6002, 203, 'VISITANTE', 0, 'PERDIO');

COMMIT;
