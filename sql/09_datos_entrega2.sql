-- Entrega 2 BASICA - Datos con solo INSERT (Modificadores)
-- Requiere 08_ddl_entrega2.sql y los datos BASICOS de la Entrega 1
-- (2 ediciones, 5 estadios, 10 selecciones, 8 partidos).
-- Solo usa INSERT INTO ... VALUES. Sin PL/SQL, sin bucles,
-- sin INSERT ALL, sin SELECT FROM dual.
-- Todos los nombres son ficticios.

SET DEFINE OFF;

------------------------------------------------------------------------
-- 1. Paises sede y relacion con cada edicion (5 + 5 filas)
------------------------------------------------------------------------

INSERT INTO pais_sede_e2 (id_pais_sede, nombre, codigo_iso) VALUES (1, 'Mexico', 'MEX');
INSERT INTO pais_sede_e2 (id_pais_sede, nombre, codigo_iso) VALUES (2, 'Colombia', 'COL');
INSERT INTO pais_sede_e2 (id_pais_sede, nombre, codigo_iso) VALUES (3, 'Alemania', 'GER');
INSERT INTO pais_sede_e2 (id_pais_sede, nombre, codigo_iso) VALUES (4, 'Espana', 'ESP');
INSERT INTO pais_sede_e2 (id_pais_sede, nombre, codigo_iso) VALUES (5, 'Portugal', 'PRT');

INSERT INTO edicion_pais_e2 (id_edicion, id_pais_sede, tipo_sede) VALUES (1, 1, 'PRINCIPAL');
INSERT INTO edicion_pais_e2 (id_edicion, id_pais_sede, tipo_sede) VALUES (1, 2, 'COSEDE');
INSERT INTO edicion_pais_e2 (id_edicion, id_pais_sede, tipo_sede) VALUES (1, 3, 'COSEDE');
INSERT INTO edicion_pais_e2 (id_edicion, id_pais_sede, tipo_sede) VALUES (2, 4, 'PRINCIPAL');
INSERT INTO edicion_pais_e2 (id_edicion, id_pais_sede, tipo_sede) VALUES (2, 5, 'COSEDE');

------------------------------------------------------------------------
-- 2. Ciudades y union estadio-ciudad (5 + 5 filas)
------------------------------------------------------------------------

INSERT INTO ciudad_e2 (id_ciudad, id_pais_sede, nombre) VALUES (101, 1, 'Ciudad de Mexico');
INSERT INTO ciudad_e2 (id_ciudad, id_pais_sede, nombre) VALUES (102, 2, 'Bogota');
INSERT INTO ciudad_e2 (id_ciudad, id_pais_sede, nombre) VALUES (103, 3, 'Berlin');
INSERT INTO ciudad_e2 (id_ciudad, id_pais_sede, nombre) VALUES (201, 4, 'Madrid');
INSERT INTO ciudad_e2 (id_ciudad, id_pais_sede, nombre) VALUES (202, 5, 'Lisboa');

INSERT INTO estadio_ciudad_e2 (id_estadio, id_ciudad) VALUES (1001, 101);
INSERT INTO estadio_ciudad_e2 (id_estadio, id_ciudad) VALUES (1002, 102);
INSERT INTO estadio_ciudad_e2 (id_estadio, id_ciudad) VALUES (1003, 103);
INSERT INTO estadio_ciudad_e2 (id_estadio, id_ciudad) VALUES (2001, 201);
INSERT INTO estadio_ciudad_e2 (id_estadio, id_ciudad) VALUES (2002, 202);

------------------------------------------------------------------------
-- 3. Fases y relacion partido-fase (4 + 8 filas)
------------------------------------------------------------------------

INSERT INTO fase_e2 (id_fase, codigo, orden_fase, tipo_fase) VALUES (1, 'FASE DE GRUPOS', 1, 'GRUPOS');
INSERT INTO fase_e2 (id_fase, codigo, orden_fase, tipo_fase) VALUES (2, 'OCTAVOS', 2, 'ELIMINATORIA');
INSERT INTO fase_e2 (id_fase, codigo, orden_fase, tipo_fase) VALUES (3, 'CUARTOS', 3, 'ELIMINATORIA');
INSERT INTO fase_e2 (id_fase, codigo, orden_fase, tipo_fase) VALUES (4, 'FINAL', 4, 'ELIMINATORIA');

INSERT INTO partido_fase_e2 (id_partido, id_edicion, id_fase) VALUES (5001, 1, 1);
INSERT INTO partido_fase_e2 (id_partido, id_edicion, id_fase) VALUES (5002, 1, 1);
INSERT INTO partido_fase_e2 (id_partido, id_edicion, id_fase) VALUES (5003, 1, 1);
INSERT INTO partido_fase_e2 (id_partido, id_edicion, id_fase) VALUES (5004, 1, 2);
INSERT INTO partido_fase_e2 (id_partido, id_edicion, id_fase) VALUES (5005, 1, 3);
INSERT INTO partido_fase_e2 (id_partido, id_edicion, id_fase) VALUES (5006, 1, 4);
INSERT INTO partido_fase_e2 (id_partido, id_edicion, id_fase) VALUES (6001, 2, 1);
INSERT INTO partido_fase_e2 (id_partido, id_edicion, id_fase) VALUES (6002, 2, 4);

------------------------------------------------------------------------
-- 4. Grupos e inscripciones (4 grupos, 10 inscripciones)
-- 2026: A(101,102,103) B(104,105,106) / 2030: A(201,202) B(203,204)
------------------------------------------------------------------------

INSERT INTO grupo_e2 (id_grupo, id_edicion, codigo, nombre) VALUES (11, 1, 'A', 'Grupo A');
INSERT INTO grupo_e2 (id_grupo, id_edicion, codigo, nombre) VALUES (12, 1, 'B', 'Grupo B');
INSERT INTO grupo_e2 (id_grupo, id_edicion, codigo, nombre) VALUES (21, 2, 'A', 'Grupo A');
INSERT INTO grupo_e2 (id_grupo, id_edicion, codigo, nombre) VALUES (22, 2, 'B', 'Grupo B');

INSERT INTO inscripcion_grupo_e2 (id_grupo, id_seleccion, orden_inicial, es_cabeza_serie) VALUES (11, 101, 1, 'S');
INSERT INTO inscripcion_grupo_e2 (id_grupo, id_seleccion, orden_inicial, es_cabeza_serie) VALUES (11, 102, 2, 'N');
INSERT INTO inscripcion_grupo_e2 (id_grupo, id_seleccion, orden_inicial, es_cabeza_serie) VALUES (11, 103, 3, 'N');
INSERT INTO inscripcion_grupo_e2 (id_grupo, id_seleccion, orden_inicial, es_cabeza_serie) VALUES (12, 104, 1, 'S');
INSERT INTO inscripcion_grupo_e2 (id_grupo, id_seleccion, orden_inicial, es_cabeza_serie) VALUES (12, 105, 2, 'N');
INSERT INTO inscripcion_grupo_e2 (id_grupo, id_seleccion, orden_inicial, es_cabeza_serie) VALUES (12, 106, 3, 'N');
INSERT INTO inscripcion_grupo_e2 (id_grupo, id_seleccion, orden_inicial, es_cabeza_serie) VALUES (21, 201, 1, 'S');
INSERT INTO inscripcion_grupo_e2 (id_grupo, id_seleccion, orden_inicial, es_cabeza_serie) VALUES (21, 202, 2, 'N');
INSERT INTO inscripcion_grupo_e2 (id_grupo, id_seleccion, orden_inicial, es_cabeza_serie) VALUES (22, 203, 1, 'S');
INSERT INTO inscripcion_grupo_e2 (id_grupo, id_seleccion, orden_inicial, es_cabeza_serie) VALUES (22, 204, 2, 'N');

------------------------------------------------------------------------
-- 5. Posiciones, convocatorias, jugadores (4 + 10 + 20 + 20 filas)
------------------------------------------------------------------------

INSERT INTO posicion_jugador_e2 (id_posicion, codigo, nombre) VALUES (1, 'POR', 'Portero');
INSERT INTO posicion_jugador_e2 (id_posicion, codigo, nombre) VALUES (2, 'DEF', 'Defensa');
INSERT INTO posicion_jugador_e2 (id_posicion, codigo, nombre) VALUES (3, 'MED', 'Mediocampista');
INSERT INTO posicion_jugador_e2 (id_posicion, codigo, nombre) VALUES (4, 'DEL', 'Delantero');

INSERT INTO convocatoria_e2 (id_convocatoria, id_edicion, id_seleccion, fecha_corte, estado) VALUES (101, 1, 101, DATE '2026-05-01', 'OFICIAL');
INSERT INTO convocatoria_e2 (id_convocatoria, id_edicion, id_seleccion, fecha_corte, estado) VALUES (102, 1, 102, DATE '2026-05-01', 'OFICIAL');
INSERT INTO convocatoria_e2 (id_convocatoria, id_edicion, id_seleccion, fecha_corte, estado) VALUES (103, 1, 103, DATE '2026-05-01', 'OFICIAL');
INSERT INTO convocatoria_e2 (id_convocatoria, id_edicion, id_seleccion, fecha_corte, estado) VALUES (104, 1, 104, DATE '2026-05-01', 'OFICIAL');
INSERT INTO convocatoria_e2 (id_convocatoria, id_edicion, id_seleccion, fecha_corte, estado) VALUES (105, 1, 105, DATE '2026-05-01', 'OFICIAL');
INSERT INTO convocatoria_e2 (id_convocatoria, id_edicion, id_seleccion, fecha_corte, estado) VALUES (106, 1, 106, DATE '2026-05-01', 'OFICIAL');
INSERT INTO convocatoria_e2 (id_convocatoria, id_edicion, id_seleccion, fecha_corte, estado) VALUES (201, 2, 201, DATE '2030-05-01', 'OFICIAL');
INSERT INTO convocatoria_e2 (id_convocatoria, id_edicion, id_seleccion, fecha_corte, estado) VALUES (202, 2, 202, DATE '2030-05-01', 'OFICIAL');
INSERT INTO convocatoria_e2 (id_convocatoria, id_edicion, id_seleccion, fecha_corte, estado) VALUES (203, 2, 203, DATE '2030-05-01', 'OFICIAL');
INSERT INTO convocatoria_e2 (id_convocatoria, id_edicion, id_seleccion, fecha_corte, estado) VALUES (204, 2, 204, DATE '2030-05-01', 'OFICIAL');

-- 2 jugadores por seleccion (nombres ficticios).
INSERT INTO jugador_e2 (id_jugador, nombres, apellidos, fecha_nacimiento, id_posicion, pie_dominante) VALUES (1001, 'James', 'Rios', DATE '1995-03-10', 3, 'D');
INSERT INTO jugador_e2 (id_jugador, nombres, apellidos, fecha_nacimiento, id_posicion, pie_dominante) VALUES (1002, 'Luis', 'Rios', DATE '1998-07-21', 4, 'D');
INSERT INTO jugador_e2 (id_jugador, nombres, apellidos, fecha_nacimiento, id_posicion, pie_dominante) VALUES (1003, 'Kai', 'Muller', DATE '1994-01-15', 4, 'D');
INSERT INTO jugador_e2 (id_jugador, nombres, apellidos, fecha_nacimiento, id_posicion, pie_dominante) VALUES (1004, 'Timo', 'Muller', DATE '2000-11-02', 2, 'I');
INSERT INTO jugador_e2 (id_jugador, nombres, apellidos, fecha_nacimiento, id_posicion, pie_dominante) VALUES (1005, 'Hugo', 'Lara', DATE '1996-05-30', 3, 'D');
INSERT INTO jugador_e2 (id_jugador, nombres, apellidos, fecha_nacimiento, id_posicion, pie_dominante) VALUES (1006, 'Diego', 'Lara', DATE '2001-02-14', 4, 'I');
INSERT INTO jugador_e2 (id_jugador, nombres, apellidos, fecha_nacimiento, id_posicion, pie_dominante) VALUES (1007, 'Sadio', 'Diallo', DATE '1997-09-09', 4, 'D');
INSERT INTO jugador_e2 (id_jugador, nombres, apellidos, fecha_nacimiento, id_posicion, pie_dominante) VALUES (1008, 'Moussa', 'Diallo', DATE '1999-12-01', 2, 'I');
INSERT INTO jugador_e2 (id_jugador, nombres, apellidos, fecha_nacimiento, id_posicion, pie_dominante) VALUES (1009, 'Kenji', 'Sato', DATE '1995-06-18', 4, 'I');
INSERT INTO jugador_e2 (id_jugador, nombres, apellidos, fecha_nacimiento, id_posicion, pie_dominante) VALUES (1010, 'Akira', 'Sato', DATE '2002-04-04', 3, 'D');
INSERT INTO jugador_e2 (id_jugador, nombres, apellidos, fecha_nacimiento, id_posicion, pie_dominante) VALUES (1011, 'Chris', 'Wood', DATE '1993-08-08', 4, 'D');
INSERT INTO jugador_e2 (id_jugador, nombres, apellidos, fecha_nacimiento, id_posicion, pie_dominante) VALUES (1012, 'Ben', 'Wood', DATE '2000-10-10', 1, 'D');
INSERT INTO jugador_e2 (id_jugador, nombres, apellidos, fecha_nacimiento, id_posicion, pie_dominante) VALUES (2001, 'Alvaro', 'Toro', DATE '1996-03-03', 4, 'D');
INSERT INTO jugador_e2 (id_jugador, nombres, apellidos, fecha_nacimiento, id_posicion, pie_dominante) VALUES (2002, 'Pablo', 'Toro', DATE '2001-07-07', 3, 'I');
INSERT INTO jugador_e2 (id_jugador, nombres, apellidos, fecha_nacimiento, id_posicion, pie_dominante) VALUES (2003, 'Lionel', 'Prado', DATE '1994-05-05', 4, 'I');
INSERT INTO jugador_e2 (id_jugador, nombres, apellidos, fecha_nacimiento, id_posicion, pie_dominante) VALUES (2004, 'Julian', 'Prado', DATE '1999-09-09', 3, 'D');
INSERT INTO jugador_e2 (id_jugador, nombres, apellidos, fecha_nacimiento, id_posicion, pie_dominante) VALUES (2005, 'Yassine', 'Aziz', DATE '1997-01-01', 1, 'D');
INSERT INTO jugador_e2 (id_jugador, nombres, apellidos, fecha_nacimiento, id_posicion, pie_dominante) VALUES (2006, 'Omar', 'Aziz', DATE '2000-02-02', 2, 'I');
INSERT INTO jugador_e2 (id_jugador, nombres, apellidos, fecha_nacimiento, id_posicion, pie_dominante) VALUES (2007, 'Bruno', 'Costa', DATE '1995-11-11', 3, 'D');
INSERT INTO jugador_e2 (id_jugador, nombres, apellidos, fecha_nacimiento, id_posicion, pie_dominante) VALUES (2008, 'Rafa', 'Costa', DATE '2002-06-06', 4, 'D');

INSERT INTO convocatoria_jugador_e2 (id_convocatoria, id_jugador, dorsal, es_capitan) VALUES (101, 1001, 10, 'S');
INSERT INTO convocatoria_jugador_e2 (id_convocatoria, id_jugador, dorsal, es_capitan) VALUES (101, 1002, 9, 'N');
INSERT INTO convocatoria_jugador_e2 (id_convocatoria, id_jugador, dorsal, es_capitan) VALUES (102, 1003, 9, 'S');
INSERT INTO convocatoria_jugador_e2 (id_convocatoria, id_jugador, dorsal, es_capitan) VALUES (102, 1004, 4, 'N');
INSERT INTO convocatoria_jugador_e2 (id_convocatoria, id_jugador, dorsal, es_capitan) VALUES (103, 1005, 10, 'S');
INSERT INTO convocatoria_jugador_e2 (id_convocatoria, id_jugador, dorsal, es_capitan) VALUES (103, 1006, 9, 'N');
INSERT INTO convocatoria_jugador_e2 (id_convocatoria, id_jugador, dorsal, es_capitan) VALUES (104, 1007, 9, 'S');
INSERT INTO convocatoria_jugador_e2 (id_convocatoria, id_jugador, dorsal, es_capitan) VALUES (104, 1008, 4, 'N');
INSERT INTO convocatoria_jugador_e2 (id_convocatoria, id_jugador, dorsal, es_capitan) VALUES (105, 1009, 9, 'S');
INSERT INTO convocatoria_jugador_e2 (id_convocatoria, id_jugador, dorsal, es_capitan) VALUES (105, 1010, 8, 'N');
INSERT INTO convocatoria_jugador_e2 (id_convocatoria, id_jugador, dorsal, es_capitan) VALUES (106, 1011, 9, 'S');
INSERT INTO convocatoria_jugador_e2 (id_convocatoria, id_jugador, dorsal, es_capitan) VALUES (106, 1012, 1, 'N');
INSERT INTO convocatoria_jugador_e2 (id_convocatoria, id_jugador, dorsal, es_capitan) VALUES (201, 2001, 9, 'S');
INSERT INTO convocatoria_jugador_e2 (id_convocatoria, id_jugador, dorsal, es_capitan) VALUES (201, 2002, 8, 'N');
INSERT INTO convocatoria_jugador_e2 (id_convocatoria, id_jugador, dorsal, es_capitan) VALUES (202, 2003, 10, 'S');
INSERT INTO convocatoria_jugador_e2 (id_convocatoria, id_jugador, dorsal, es_capitan) VALUES (202, 2004, 8, 'N');
INSERT INTO convocatoria_jugador_e2 (id_convocatoria, id_jugador, dorsal, es_capitan) VALUES (203, 2005, 1, 'S');
INSERT INTO convocatoria_jugador_e2 (id_convocatoria, id_jugador, dorsal, es_capitan) VALUES (203, 2006, 4, 'N');
INSERT INTO convocatoria_jugador_e2 (id_convocatoria, id_jugador, dorsal, es_capitan) VALUES (204, 2007, 8, 'S');
INSERT INTO convocatoria_jugador_e2 (id_convocatoria, id_jugador, dorsal, es_capitan) VALUES (204, 2008, 9, 'N');

------------------------------------------------------------------------
-- 6. Arbitraje y catalogos (4 + 2 + 8 + 3 filas)
------------------------------------------------------------------------

INSERT INTO arbitro_e2 (id_arbitro, nombres, apellidos, confederacion, activo) VALUES (1, 'Nestor', 'Pitana', 'CONMEBOL', 'S');
INSERT INTO arbitro_e2 (id_arbitro, nombres, apellidos, confederacion, activo) VALUES (2, 'Bjorn', 'Kuipers', 'UEFA', 'S');
INSERT INTO arbitro_e2 (id_arbitro, nombres, apellidos, confederacion, activo) VALUES (3, 'Marco', 'Rodriguez', 'CONCACAF', 'S');
INSERT INTO arbitro_e2 (id_arbitro, nombres, apellidos, confederacion, activo) VALUES (4, 'Bakary', 'Gassama', 'CAF', 'S');

INSERT INTO rol_arbitral_e2 (id_rol, codigo, nombre) VALUES (1, 'CENTRAL', 'Arbitro principal');
INSERT INTO rol_arbitral_e2 (id_rol, codigo, nombre) VALUES (2, 'ASISTENTE', 'Arbitro asistente');

INSERT INTO asignacion_arbitral_e2 (id_partido, id_arbitro, id_rol, calificacion) VALUES (5001, 1, 1, 8.5);
INSERT INTO asignacion_arbitral_e2 (id_partido, id_arbitro, id_rol, calificacion) VALUES (5002, 2, 1, 7.0);
INSERT INTO asignacion_arbitral_e2 (id_partido, id_arbitro, id_rol, calificacion) VALUES (5003, 3, 1, 8.0);
INSERT INTO asignacion_arbitral_e2 (id_partido, id_arbitro, id_rol, calificacion) VALUES (5004, 1, 1, 9.0);
INSERT INTO asignacion_arbitral_e2 (id_partido, id_arbitro, id_rol, calificacion) VALUES (5005, 2, 1, 7.5);
INSERT INTO asignacion_arbitral_e2 (id_partido, id_arbitro, id_rol, calificacion) VALUES (5006, 4, 1, 8.2);
INSERT INTO asignacion_arbitral_e2 (id_partido, id_arbitro, id_rol, calificacion) VALUES (6001, 2, 1, 8.8);
INSERT INTO asignacion_arbitral_e2 (id_partido, id_arbitro, id_rol, calificacion) VALUES (6002, 1, 1, 9.2);

INSERT INTO tipo_evento_e2 (id_tipo_evento, codigo, nombre, afecta_marcador) VALUES (1, 'GOL', 'Gol validado', 'S');
INSERT INTO tipo_evento_e2 (id_tipo_evento, codigo, nombre, afecta_marcador) VALUES (2, 'AMARILLA', 'Tarjeta amarilla', 'N');
INSERT INTO tipo_evento_e2 (id_tipo_evento, codigo, nombre, afecta_marcador) VALUES (3, 'ROJA', 'Tarjeta roja', 'N');

------------------------------------------------------------------------
-- 7. Eventos (12 filas: goles de muestra + tarjetas)
------------------------------------------------------------------------

INSERT INTO evento_partido_e2 (id_evento, id_partido, minuto, minuto_adicional, id_tipo_evento, id_seleccion, id_jugador, descripcion) VALUES (1, 5001, 23, 0, 1, 101, 1002, 'Gol de Colombia');
INSERT INTO evento_partido_e2 (id_evento, id_partido, minuto, minuto_adicional, id_tipo_evento, id_seleccion, id_jugador, descripcion) VALUES (2, 5001, 55, 0, 1, 101, 1001, 'Gol de Colombia');
INSERT INTO evento_partido_e2 (id_evento, id_partido, minuto, minuto_adicional, id_tipo_evento, id_seleccion, id_jugador, descripcion) VALUES (3, 5001, 78, 0, 1, 102, 1003, 'Gol de Alemania');
INSERT INTO evento_partido_e2 (id_evento, id_partido, minuto, minuto_adicional, id_tipo_evento, id_seleccion, id_jugador, descripcion) VALUES (4, 5002, 60, 0, 2, 103, 1005, 'Amarilla a Mexico');
INSERT INTO evento_partido_e2 (id_evento, id_partido, minuto, minuto_adicional, id_tipo_evento, id_seleccion, id_jugador, descripcion) VALUES (5, 5003, 15, 0, 1, 105, 1009, 'Gol de Japon');
INSERT INTO evento_partido_e2 (id_evento, id_partido, minuto, minuto_adicional, id_tipo_evento, id_seleccion, id_jugador, descripcion) VALUES (6, 5003, 70, 0, 1, 106, 1011, 'Gol de Nueva Zelanda');
INSERT INTO evento_partido_e2 (id_evento, id_partido, minuto, minuto_adicional, id_tipo_evento, id_seleccion, id_jugador, descripcion) VALUES (7, 5004, 10, 0, 1, 101, 1002, 'Gol de Colombia');
INSERT INTO evento_partido_e2 (id_evento, id_partido, minuto, minuto_adicional, id_tipo_evento, id_seleccion, id_jugador, descripcion) VALUES (8, 5004, 40, 0, 1, 101, 1002, 'Gol de Colombia');
INSERT INTO evento_partido_e2 (id_evento, id_partido, minuto, minuto_adicional, id_tipo_evento, id_seleccion, id_jugador, descripcion) VALUES (9, 5005, 90, 0, 1, 101, 1001, 'Gol de Colombia visitante');
INSERT INTO evento_partido_e2 (id_evento, id_partido, minuto, minuto_adicional, id_tipo_evento, id_seleccion, id_jugador, descripcion) VALUES (10, 5006, 50, 0, 1, 105, 1009, 'Gol de Japon visitante');
INSERT INTO evento_partido_e2 (id_evento, id_partido, minuto, minuto_adicional, id_tipo_evento, id_seleccion, id_jugador, descripcion) VALUES (11, 6001, 30, 0, 1, 201, 2001, 'Gol de Espana');
INSERT INTO evento_partido_e2 (id_evento, id_partido, minuto, minuto_adicional, id_tipo_evento, id_seleccion, id_jugador, descripcion) VALUES (12, 6002, 65, 0, 1, 204, 2008, 'Gol de Portugal');

------------------------------------------------------------------------
-- 8. Estadisticas por jugador (12 filas coherentes con el marcador)
------------------------------------------------------------------------

INSERT INTO estadistica_jugador_e2 (id_partido, id_jugador, id_convocatoria, minutos, goles, asistencias, remates, tarjetas_amarillas, tarjetas_rojas, es_titular) VALUES (5001, 1002, 101, 90, 1, 1, 3, 0, 0, 'S');
INSERT INTO estadistica_jugador_e2 (id_partido, id_jugador, id_convocatoria, minutos, goles, asistencias, remates, tarjetas_amarillas, tarjetas_rojas, es_titular) VALUES (5001, 1003, 102, 90, 1, 0, 2, 1, 0, 'S');
INSERT INTO estadistica_jugador_e2 (id_partido, id_jugador, id_convocatoria, minutos, goles, asistencias, remates, tarjetas_amarillas, tarjetas_rojas, es_titular) VALUES (5002, 1005, 103, 90, 0, 0, 1, 1, 0, 'S');
INSERT INTO estadistica_jugador_e2 (id_partido, id_jugador, id_convocatoria, minutos, goles, asistencias, remates, tarjetas_amarillas, tarjetas_rojas, es_titular) VALUES (5002, 1007, 104, 90, 0, 0, 1, 0, 0, 'S');
INSERT INTO estadistica_jugador_e2 (id_partido, id_jugador, id_convocatoria, minutos, goles, asistencias, remates, tarjetas_amarillas, tarjetas_rojas, es_titular) VALUES (5003, 1009, 105, 90, 2, 1, 4, 0, 0, 'S');
INSERT INTO estadistica_jugador_e2 (id_partido, id_jugador, id_convocatoria, minutos, goles, asistencias, remates, tarjetas_amarillas, tarjetas_rojas, es_titular) VALUES (5003, 1011, 106, 90, 2, 0, 3, 1, 0, 'S');
INSERT INTO estadistica_jugador_e2 (id_partido, id_jugador, id_convocatoria, minutos, goles, asistencias, remates, tarjetas_amarillas, tarjetas_rojas, es_titular) VALUES (5004, 1002, 101, 90, 2, 0, 4, 0, 0, 'S');
INSERT INTO estadistica_jugador_e2 (id_partido, id_jugador, id_convocatoria, minutos, goles, asistencias, remates, tarjetas_amarillas, tarjetas_rojas, es_titular) VALUES (5005, 1001, 101, 90, 1, 1, 2, 0, 0, 'S');
INSERT INTO estadistica_jugador_e2 (id_partido, id_jugador, id_convocatoria, minutos, goles, asistencias, remates, tarjetas_amarillas, tarjetas_rojas, es_titular) VALUES (5006, 1009, 105, 90, 1, 0, 2, 0, 0, 'S');
INSERT INTO estadistica_jugador_e2 (id_partido, id_jugador, id_convocatoria, minutos, goles, asistencias, remates, tarjetas_amarillas, tarjetas_rojas, es_titular) VALUES (5006, 1001, 101, 90, 1, 0, 2, 1, 0, 'S');
INSERT INTO estadistica_jugador_e2 (id_partido, id_jugador, id_convocatoria, minutos, goles, asistencias, remates, tarjetas_amarillas, tarjetas_rojas, es_titular) VALUES (6001, 2001, 201, 90, 1, 1, 3, 0, 0, 'S');
INSERT INTO estadistica_jugador_e2 (id_partido, id_jugador, id_convocatoria, minutos, goles, asistencias, remates, tarjetas_amarillas, tarjetas_rojas, es_titular) VALUES (6002, 2008, 204, 90, 1, 0, 2, 0, 0, 'S');

------------------------------------------------------------------------
-- 9. Incidencias + auditoria MANUAL (4 + 4 filas, sin trigger)
------------------------------------------------------------------------

INSERT INTO tipo_incidencia_e2 (id_tipo_incidencia, codigo, nombre, severidad) VALUES (1, 'LESION', 'Lesion de jugador', 'MEDIA');
INSERT INTO tipo_incidencia_e2 (id_tipo_incidencia, codigo, nombre, severidad) VALUES (2, 'SEGURIDAD', 'Incidente de seguridad', 'ALTA');
INSERT INTO tipo_incidencia_e2 (id_tipo_incidencia, codigo, nombre, severidad) VALUES (3, 'LOGISTICA', 'Incidente logistico', 'BAJA');

INSERT INTO incidencia_e2 (id_incidencia, id_partido, id_tipo_incidencia, minuto, descripcion, resuelta) VALUES (9001, 5001, 3, 70, 'Retraso logistico en accesos', 'S');
INSERT INTO incidencia_e2 (id_incidencia, id_partido, id_tipo_incidencia, minuto, descripcion, resuelta) VALUES (9002, 5003, 1, 55, 'Lesion leve de un jugador', 'S');
INSERT INTO incidencia_e2 (id_incidencia, id_partido, id_tipo_incidencia, minuto, descripcion, resuelta) VALUES (9003, 5004, 2, 80, 'Revision de seguridad en tribuna', 'N');
INSERT INTO incidencia_e2 (id_incidencia, id_partido, id_tipo_incidencia, minuto, descripcion, resuelta) VALUES (9004, 6002, 3, 20, 'Falla electrica menor', 'S');

INSERT INTO auditoria_e2 (id_auditoria, tabla_afectada, operacion, id_registro, usuario_bd, detalle) VALUES (1, 'INCIDENCIA_E2', 'INSERT', 9001, 'PROPIETARIO', 'Incidencia creada');
INSERT INTO auditoria_e2 (id_auditoria, tabla_afectada, operacion, id_registro, usuario_bd, detalle) VALUES (2, 'INCIDENCIA_E2', 'INSERT', 9002, 'PROPIETARIO', 'Incidencia creada');
INSERT INTO auditoria_e2 (id_auditoria, tabla_afectada, operacion, id_registro, usuario_bd, detalle) VALUES (3, 'INCIDENCIA_E2', 'INSERT', 9003, 'PROPIETARIO', 'Incidencia creada');
INSERT INTO auditoria_e2 (id_auditoria, tabla_afectada, operacion, id_registro, usuario_bd, detalle) VALUES (4, 'INCIDENCIA_E2', 'INSERT', 9004, 'PROPIETARIO', 'Incidencia creada');

COMMIT;
