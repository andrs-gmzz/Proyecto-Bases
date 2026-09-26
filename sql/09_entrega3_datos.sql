-- Entrega 3 BASICA - Datos con solo INSERT/UPDATE (Modificadores)
-- Requiere 08_entrega3_ampliacion.sql y datos BASICOS de E1.
-- Sin PL/SQL, sin bucles, sin secuencias (IDs manuales),
-- sin EXECUTE IMMEDIATE. Datos ficticios y pequenos.

SET DEFINE OFF;

------------------------------------------------------------------------
-- Tipos de incidencia (6 filas, reutilizados por la app)
------------------------------------------------------------------------

INSERT INTO tipo_incidencia (id_tipo_incidencia, nombre, categoria) VALUES (1, 'GOL', 'DEPORTIVA');
INSERT INTO tipo_incidencia (id_tipo_incidencia, nombre, categoria) VALUES (2, 'TARJETA AMARILLA', 'DISCIPLINARIA');
INSERT INTO tipo_incidencia (id_tipo_incidencia, nombre, categoria) VALUES (3, 'TARJETA ROJA', 'DISCIPLINARIA');
INSERT INTO tipo_incidencia (id_tipo_incidencia, nombre, categoria) VALUES (4, 'CAMBIO', 'DEPORTIVA');
INSERT INTO tipo_incidencia (id_tipo_incidencia, nombre, categoria) VALUES (5, 'REVISION VAR', 'TECNOLOGICA');
INSERT INTO tipo_incidencia (id_tipo_incidencia, nombre, categoria) VALUES (6, 'LESION', 'OPERATIVA');

------------------------------------------------------------------------
-- Sedes, edicion_sede y ciudades (2 + 2 + 4 filas)
------------------------------------------------------------------------

INSERT INTO sede (id_sede, nombre, pais, activa) VALUES (1, 'Sede Norteamerica', 'Mexico', 'S');
INSERT INTO sede (id_sede, nombre, pais, activa) VALUES (2, 'Sede Iberia', 'Espana', 'S');

INSERT INTO edicion_sede (id_edicion, id_sede, es_principal) VALUES (1, 1, 'S');
INSERT INTO edicion_sede (id_edicion, id_sede, es_principal) VALUES (2, 2, 'S');

INSERT INTO ciudad (id_ciudad, id_sede, nombre, pais) VALUES (101, 1, 'Ciudad de Mexico', 'Mexico');
INSERT INTO ciudad (id_ciudad, id_sede, nombre, pais) VALUES (102, 1, 'Bogota', 'Colombia');
INSERT INTO ciudad (id_ciudad, id_sede, nombre, pais) VALUES (103, 1, 'Berlin', 'Alemania');
INSERT INTO ciudad (id_ciudad, id_sede, nombre, pais) VALUES (201, 2, 'Madrid', 'Espana');

UPDATE estadio SET id_ciudad = 101 WHERE id_estadio = 1001;
UPDATE estadio SET id_ciudad = 102 WHERE id_estadio = 1002;
UPDATE estadio SET id_ciudad = 103 WHERE id_estadio = 1003;
UPDATE estadio SET id_ciudad = 201 WHERE id_estadio = 2001;
UPDATE estadio SET id_ciudad = 201 WHERE id_estadio = 2002;

------------------------------------------------------------------------
-- Grupos e inscripciones (4 grupos, 10 inscripciones)
------------------------------------------------------------------------

INSERT INTO grupo_torneo (id_grupo, id_edicion, codigo, nombre, fase) VALUES (101, 1, 'A', 'Grupo A', 'FASE DE GRUPOS');
INSERT INTO grupo_torneo (id_grupo, id_edicion, codigo, nombre, fase) VALUES (102, 1, 'B', 'Grupo B', 'FASE DE GRUPOS');
INSERT INTO grupo_torneo (id_grupo, id_edicion, codigo, nombre, fase) VALUES (201, 2, 'A', 'Grupo A', 'FASE DE GRUPOS');
INSERT INTO grupo_torneo (id_grupo, id_edicion, codigo, nombre, fase) VALUES (202, 2, 'B', 'Grupo B', 'FASE DE GRUPOS');

INSERT INTO inscripcion_grupo (id_inscripcion, id_grupo, id_seleccion, posicion) VALUES (1001, 101, 101, 1);
INSERT INTO inscripcion_grupo (id_inscripcion, id_grupo, id_seleccion, posicion) VALUES (1002, 101, 102, 2);
INSERT INTO inscripcion_grupo (id_inscripcion, id_grupo, id_seleccion, posicion) VALUES (1003, 101, 103, 3);
INSERT INTO inscripcion_grupo (id_inscripcion, id_grupo, id_seleccion, posicion) VALUES (1004, 102, 104, 1);
INSERT INTO inscripcion_grupo (id_inscripcion, id_grupo, id_seleccion, posicion) VALUES (1005, 102, 105, 2);
INSERT INTO inscripcion_grupo (id_inscripcion, id_grupo, id_seleccion, posicion) VALUES (1006, 102, 106, 3);
INSERT INTO inscripcion_grupo (id_inscripcion, id_grupo, id_seleccion, posicion) VALUES (2001, 201, 201, 1);
INSERT INTO inscripcion_grupo (id_inscripcion, id_grupo, id_seleccion, posicion) VALUES (2002, 201, 202, 2);
INSERT INTO inscripcion_grupo (id_inscripcion, id_grupo, id_seleccion, posicion) VALUES (2003, 202, 203, 1);
INSERT INTO inscripcion_grupo (id_inscripcion, id_grupo, id_seleccion, posicion) VALUES (2004, 202, 204, 2);

-- Solo los partidos de grupos llevan grupo (los de eliminatoria quedan NULL).
UPDATE partido SET id_grupo = 101 WHERE id_partido = 5001;
UPDATE partido SET id_grupo = 101 WHERE id_partido = 5002;
UPDATE partido SET id_grupo = 102 WHERE id_partido = 5003;
UPDATE partido SET id_grupo = 201 WHERE id_partido = 6001;

------------------------------------------------------------------------
-- Convocatorias (10), jugadores (14), convocatoria_jugador (14)
------------------------------------------------------------------------

INSERT INTO convocatoria (id_convocatoria, id_edicion, id_seleccion, fecha_registro, estado) VALUES (101, 1, 101, DATE '2026-05-01', 'ACTIVA');
INSERT INTO convocatoria (id_convocatoria, id_edicion, id_seleccion, fecha_registro, estado) VALUES (102, 1, 102, DATE '2026-05-01', 'ACTIVA');
INSERT INTO convocatoria (id_convocatoria, id_edicion, id_seleccion, fecha_registro, estado) VALUES (103, 1, 103, DATE '2026-05-01', 'ACTIVA');
INSERT INTO convocatoria (id_convocatoria, id_edicion, id_seleccion, fecha_registro, estado) VALUES (104, 1, 104, DATE '2026-05-01', 'ACTIVA');
INSERT INTO convocatoria (id_convocatoria, id_edicion, id_seleccion, fecha_registro, estado) VALUES (105, 1, 105, DATE '2026-05-01', 'ACTIVA');
INSERT INTO convocatoria (id_convocatoria, id_edicion, id_seleccion, fecha_registro, estado) VALUES (106, 1, 106, DATE '2026-05-01', 'ACTIVA');
INSERT INTO convocatoria (id_convocatoria, id_edicion, id_seleccion, fecha_registro, estado) VALUES (201, 2, 201, DATE '2030-05-01', 'ACTIVA');
INSERT INTO convocatoria (id_convocatoria, id_edicion, id_seleccion, fecha_registro, estado) VALUES (202, 2, 202, DATE '2030-05-01', 'ACTIVA');
INSERT INTO convocatoria (id_convocatoria, id_edicion, id_seleccion, fecha_registro, estado) VALUES (203, 2, 203, DATE '2030-05-01', 'ACTIVA');
INSERT INTO convocatoria (id_convocatoria, id_edicion, id_seleccion, fecha_registro, estado) VALUES (204, 2, 204, DATE '2030-05-01', 'ACTIVA');

INSERT INTO jugador (id_jugador, nombres, apellidos, fecha_nacimiento, nacionalidad, posicion, activo) VALUES (1001, 'James', 'Rios', DATE '1995-03-10', 'Colombia', 'MEDIOCAMPISTA', 'S');
INSERT INTO jugador (id_jugador, nombres, apellidos, fecha_nacimiento, nacionalidad, posicion, activo) VALUES (1002, 'Luis', 'Rios', DATE '1998-07-21', 'Colombia', 'DELANTERO', 'S');
INSERT INTO jugador (id_jugador, nombres, apellidos, fecha_nacimiento, nacionalidad, posicion, activo) VALUES (1003, 'Kai', 'Muller', DATE '1994-01-15', 'Alemania', 'DELANTERO', 'S');
INSERT INTO jugador (id_jugador, nombres, apellidos, fecha_nacimiento, nacionalidad, posicion, activo) VALUES (1005, 'Hugo', 'Lara', DATE '1996-05-30', 'Mexico', 'MEDIOCAMPISTA', 'S');
INSERT INTO jugador (id_jugador, nombres, apellidos, fecha_nacimiento, nacionalidad, posicion, activo) VALUES (1007, 'Sadio', 'Diallo', DATE '1997-09-09', 'Senegal', 'DELANTERO', 'S');
INSERT INTO jugador (id_jugador, nombres, apellidos, fecha_nacimiento, nacionalidad, posicion, activo) VALUES (1009, 'Kenji', 'Sato', DATE '1995-06-18', 'Japon', 'DELANTERO', 'S');
INSERT INTO jugador (id_jugador, nombres, apellidos, fecha_nacimiento, nacionalidad, posicion, activo) VALUES (1010, 'Akira', 'Sato', DATE '2002-04-04', 'Japon', 'MEDIOCAMPISTA', 'S');
INSERT INTO jugador (id_jugador, nombres, apellidos, fecha_nacimiento, nacionalidad, posicion, activo) VALUES (1011, 'Chris', 'Wood', DATE '1993-08-08', 'Nueva Zelanda', 'DELANTERO', 'S');
INSERT INTO jugador (id_jugador, nombres, apellidos, fecha_nacimiento, nacionalidad, posicion, activo) VALUES (2001, 'Alvaro', 'Toro', DATE '1996-03-03', 'Espana', 'DELANTERO', 'S');
INSERT INTO jugador (id_jugador, nombres, apellidos, fecha_nacimiento, nacionalidad, posicion, activo) VALUES (2002, 'Pablo', 'Toro', DATE '2001-07-07', 'Espana', 'MEDIOCAMPISTA', 'S');
INSERT INTO jugador (id_jugador, nombres, apellidos, fecha_nacimiento, nacionalidad, posicion, activo) VALUES (2003, 'Lionel', 'Prado', DATE '1994-05-05', 'Argentina', 'DELANTERO', 'S');
INSERT INTO jugador (id_jugador, nombres, apellidos, fecha_nacimiento, nacionalidad, posicion, activo) VALUES (2005, 'Yassine', 'Aziz', DATE '1997-01-01', 'Marruecos', 'ARQUERO', 'S');
INSERT INTO jugador (id_jugador, nombres, apellidos, fecha_nacimiento, nacionalidad, posicion, activo) VALUES (2007, 'Bruno', 'Costa', DATE '1995-11-11', 'Portugal', 'MEDIOCAMPISTA', 'S');
INSERT INTO jugador (id_jugador, nombres, apellidos, fecha_nacimiento, nacionalidad, posicion, activo) VALUES (2008, 'Rafa', 'Costa', DATE '2002-06-06', 'Portugal', 'DELANTERO', 'S');

INSERT INTO convocatoria_jugador (id_convocatoria, id_jugador, dorsal, capitan) VALUES (101, 1001, 10, 'S');
INSERT INTO convocatoria_jugador (id_convocatoria, id_jugador, dorsal, capitan) VALUES (101, 1002, 9, 'N');
INSERT INTO convocatoria_jugador (id_convocatoria, id_jugador, dorsal, capitan) VALUES (102, 1003, 9, 'S');
INSERT INTO convocatoria_jugador (id_convocatoria, id_jugador, dorsal, capitan) VALUES (103, 1005, 10, 'S');
INSERT INTO convocatoria_jugador (id_convocatoria, id_jugador, dorsal, capitan) VALUES (104, 1007, 9, 'S');
INSERT INTO convocatoria_jugador (id_convocatoria, id_jugador, dorsal, capitan) VALUES (105, 1009, 9, 'S');
INSERT INTO convocatoria_jugador (id_convocatoria, id_jugador, dorsal, capitan) VALUES (105, 1010, 8, 'N');
INSERT INTO convocatoria_jugador (id_convocatoria, id_jugador, dorsal, capitan) VALUES (106, 1011, 9, 'S');
INSERT INTO convocatoria_jugador (id_convocatoria, id_jugador, dorsal, capitan) VALUES (201, 2001, 9, 'S');
INSERT INTO convocatoria_jugador (id_convocatoria, id_jugador, dorsal, capitan) VALUES (201, 2002, 8, 'N');
INSERT INTO convocatoria_jugador (id_convocatoria, id_jugador, dorsal, capitan) VALUES (202, 2003, 10, 'S');
INSERT INTO convocatoria_jugador (id_convocatoria, id_jugador, dorsal, capitan) VALUES (203, 2005, 1, 'S');
INSERT INTO convocatoria_jugador (id_convocatoria, id_jugador, dorsal, capitan) VALUES (204, 2007, 8, 'S');
INSERT INTO convocatoria_jugador (id_convocatoria, id_jugador, dorsal, capitan) VALUES (204, 2008, 9, 'N');

------------------------------------------------------------------------
-- Cuerpo tecnico (4 + 4 filas)
------------------------------------------------------------------------

INSERT INTO cuerpo_tecnico (id_cuerpo_tecnico, nombres, apellidos, cargo, nacionalidad, activo) VALUES (1, 'Carlos', 'Mendez', 'DIRECTOR TECNICO', 'Colombia', 'S');
INSERT INTO cuerpo_tecnico (id_cuerpo_tecnico, nombres, apellidos, cargo, nacionalidad, activo) VALUES (2, 'Lucia', 'Herrera', 'ASISTENTE', 'Mexico', 'S');
INSERT INTO cuerpo_tecnico (id_cuerpo_tecnico, nombres, apellidos, cargo, nacionalidad, activo) VALUES (3, 'Pablo', 'Duarte', 'PREPARADOR FISICO', 'Espana', 'S');
INSERT INTO cuerpo_tecnico (id_cuerpo_tecnico, nombres, apellidos, cargo, nacionalidad, activo) VALUES (4, 'Marta', 'Leon', 'MEDICO', 'Portugal', 'S');

INSERT INTO asignacion_cuerpo_tecnico (id_seleccion, id_cuerpo_tecnico, fecha_inicio, fecha_fin, es_principal) VALUES (101, 1, DATE '2026-01-01', DATE '2026-08-01', 'S');
INSERT INTO asignacion_cuerpo_tecnico (id_seleccion, id_cuerpo_tecnico, fecha_inicio, fecha_fin, es_principal) VALUES (103, 2, DATE '2026-01-01', DATE '2026-08-01', 'S');
INSERT INTO asignacion_cuerpo_tecnico (id_seleccion, id_cuerpo_tecnico, fecha_inicio, fecha_fin, es_principal) VALUES (201, 3, DATE '2030-01-01', DATE '2030-08-01', 'S');
INSERT INTO asignacion_cuerpo_tecnico (id_seleccion, id_cuerpo_tecnico, fecha_inicio, fecha_fin, es_principal) VALUES (204, 4, DATE '2030-01-01', DATE '2030-08-01', 'S');

------------------------------------------------------------------------
-- Estadisticas (12 filas coherentes con el marcador de E1)
------------------------------------------------------------------------

INSERT INTO estadistica_jugador_partido (id_estadistica, id_partido, id_seleccion, id_jugador, minutos_jugados, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, titular) VALUES (1, 5001, 101, 1002, 90, 1, 1, 0, 0, 'S');
INSERT INTO estadistica_jugador_partido (id_estadistica, id_partido, id_seleccion, id_jugador, minutos_jugados, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, titular) VALUES (2, 5001, 102, 1003, 90, 1, 0, 1, 0, 'S');
INSERT INTO estadistica_jugador_partido (id_estadistica, id_partido, id_seleccion, id_jugador, minutos_jugados, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, titular) VALUES (3, 5002, 103, 1005, 90, 0, 0, 1, 0, 'S');
INSERT INTO estadistica_jugador_partido (id_estadistica, id_partido, id_seleccion, id_jugador, minutos_jugados, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, titular) VALUES (4, 5003, 105, 1009, 90, 2, 1, 0, 0, 'S');
INSERT INTO estadistica_jugador_partido (id_estadistica, id_partido, id_seleccion, id_jugador, minutos_jugados, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, titular) VALUES (5, 5003, 106, 1011, 90, 2, 0, 1, 0, 'S');
INSERT INTO estadistica_jugador_partido (id_estadistica, id_partido, id_seleccion, id_jugador, minutos_jugados, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, titular) VALUES (6, 5004, 101, 1002, 90, 2, 0, 0, 0, 'S');
INSERT INTO estadistica_jugador_partido (id_estadistica, id_partido, id_seleccion, id_jugador, minutos_jugados, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, titular) VALUES (7, 5005, 101, 1001, 90, 1, 1, 0, 0, 'S');
INSERT INTO estadistica_jugador_partido (id_estadistica, id_partido, id_seleccion, id_jugador, minutos_jugados, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, titular) VALUES (8, 5006, 105, 1009, 90, 1, 0, 0, 0, 'S');
INSERT INTO estadistica_jugador_partido (id_estadistica, id_partido, id_seleccion, id_jugador, minutos_jugados, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, titular) VALUES (9, 5006, 101, 1001, 90, 1, 0, 1, 0, 'S');
INSERT INTO estadistica_jugador_partido (id_estadistica, id_partido, id_seleccion, id_jugador, minutos_jugados, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, titular) VALUES (10, 6001, 201, 2001, 90, 1, 1, 0, 0, 'S');
INSERT INTO estadistica_jugador_partido (id_estadistica, id_partido, id_seleccion, id_jugador, minutos_jugados, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, titular) VALUES (11, 6001, 202, 2003, 90, 0, 0, 1, 0, 'S');
INSERT INTO estadistica_jugador_partido (id_estadistica, id_partido, id_seleccion, id_jugador, minutos_jugados, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, titular) VALUES (12, 6002, 204, 2008, 90, 1, 0, 0, 0, 'S');

------------------------------------------------------------------------
-- Incidencias (8 filas: 1 VAR por partido de muestra + goles) + auditoria manual
------------------------------------------------------------------------

INSERT INTO incidencia (id_incidencia, id_partido, id_tipo_incidencia, minuto, id_seleccion, id_jugador, descripcion, revisada) VALUES (1, 5001, 5, 44, NULL, NULL, 'Revision VAR de posible fuera de juego.', 'S');
INSERT INTO incidencia (id_incidencia, id_partido, id_tipo_incidencia, minuto, id_seleccion, id_jugador, descripcion, revisada) VALUES (2, 5001, 1, 23, 101, 1002, 'Gol de Colombia.', 'S');
INSERT INTO incidencia (id_incidencia, id_partido, id_tipo_incidencia, minuto, id_seleccion, id_jugador, descripcion, revisada) VALUES (3, 5002, 2, 60, 103, 1005, 'Amarilla a Mexico.', 'S');
INSERT INTO incidencia (id_incidencia, id_partido, id_tipo_incidencia, minuto, id_seleccion, id_jugador, descripcion, revisada) VALUES (4, 5003, 1, 15, 105, 1009, 'Gol de Japon.', 'S');
INSERT INTO incidencia (id_incidencia, id_partido, id_tipo_incidencia, minuto, id_seleccion, id_jugador, descripcion, revisada) VALUES (5, 5004, 1, 10, 101, 1002, 'Gol de Colombia.', 'S');
INSERT INTO incidencia (id_incidencia, id_partido, id_tipo_incidencia, minuto, id_seleccion, id_jugador, descripcion, revisada) VALUES (6, 5005, 6, 80, 102, NULL, 'Lesion leve.', 'N');
INSERT INTO incidencia (id_incidencia, id_partido, id_tipo_incidencia, minuto, id_seleccion, id_jugador, descripcion, revisada) VALUES (7, 6001, 1, 30, 201, 2001, 'Gol de Espana.', 'S');
INSERT INTO incidencia (id_incidencia, id_partido, id_tipo_incidencia, minuto, id_seleccion, id_jugador, descripcion, revisada) VALUES (8, 6002, 4, 64, 204, NULL, 'Cambio tactico de Portugal.', 'N');

INSERT INTO auditoria_evento (id_auditoria, usuario_bd, tabla_afectada, operacion, clave_registro, detalle) VALUES (1, 'PROPIETARIO', 'INCIDENCIA', 'INSERT', '1', 'Revision VAR creada');
INSERT INTO auditoria_evento (id_auditoria, usuario_bd, tabla_afectada, operacion, clave_registro, detalle) VALUES (2, 'PROPIETARIO', 'INCIDENCIA', 'INSERT', '2', 'Gol creado');
INSERT INTO auditoria_evento (id_auditoria, usuario_bd, tabla_afectada, operacion, clave_registro, detalle) VALUES (3, 'PROPIETARIO', 'PARTIDO', 'UPDATE', '5001', 'Resultado cargado');
INSERT INTO auditoria_evento (id_auditoria, usuario_bd, tabla_afectada, operacion, clave_registro, detalle) VALUES (4, 'PROPIETARIO', 'TABLA_POSICIONES_E3', 'INSERT', '1-101', 'Posicion inicial');

COMMIT;
