-- Entrega 2 BASICA - Ampliacion normalizada (solo conceptos basicos)
-- Requiere haber ejecutado los scripts 01 a 07 de la Entrega 1 BASICA.
-- Solo usa: CREATE TABLE con PK, FK simples, UNIQUE, CHECK, DEFAULT,
-- NUMBER/VARCHAR2/DATE y 2 indices simples (temas 2 y 8).
-- NO usa: PLSQL/Triggers, secuencias, TIMESTAMP, FK compuestas,
-- funciones de ventana, WITH, ni PL/SQL.
-- La auditoria es una tabla manual (sin trigger): se inserta con INSERT
-- y se verifica con SELECT en 14_verificacion_entrega2.sql.
-- Ejecutar una sola vez con Run Script (F5).

SET DEFINE OFF;

------------------------------------------------------------------------
-- 1. Sedes normalizadas (pais -> ciudad -> estadio)
------------------------------------------------------------------------

CREATE TABLE pais_sede_e2 (
    id_pais_sede    NUMBER(4) CONSTRAINT pk_pais_sede_e2 PRIMARY KEY,
    nombre          VARCHAR2(80) NOT NULL,
    codigo_iso      VARCHAR2(3) NOT NULL,
    CONSTRAINT uq_pais_sede_e2_nombre UNIQUE (nombre),
    CONSTRAINT uq_pais_sede_e2_iso UNIQUE (codigo_iso)
);

CREATE TABLE edicion_pais_e2 (
    id_edicion      NUMBER(4) NOT NULL,
    id_pais_sede    NUMBER(4) NOT NULL,
    tipo_sede       VARCHAR2(10) NOT NULL,
    CONSTRAINT pk_edicion_pais_e2 PRIMARY KEY (id_edicion, id_pais_sede),
    CONSTRAINT ck_edicion_pais_e2_tipo
        CHECK (tipo_sede IN ('PRINCIPAL', 'COSEDE')),
    CONSTRAINT fk_e2_ep_edicion
        FOREIGN KEY (id_edicion)
        REFERENCES edicion_mundial (id_edicion),
    CONSTRAINT fk_e2_ep_pais
        FOREIGN KEY (id_pais_sede)
        REFERENCES pais_sede_e2 (id_pais_sede)
);

CREATE TABLE ciudad_e2 (
    id_ciudad       NUMBER(10) CONSTRAINT pk_ciudad_e2 PRIMARY KEY,
    id_pais_sede    NUMBER(4) NOT NULL,
    nombre          VARCHAR2(80) NOT NULL,
    CONSTRAINT uq_ciudad_e2_nombre UNIQUE (id_pais_sede, nombre),
    CONSTRAINT fk_e2_ciudad_pais
        FOREIGN KEY (id_pais_sede)
        REFERENCES pais_sede_e2 (id_pais_sede)
);

-- Relacion 1:1 que normaliza la ciudad del ESTADIO heredado de la E1.
CREATE TABLE estadio_ciudad_e2 (
    id_estadio      NUMBER(10) CONSTRAINT pk_estadio_ciudad_e2 PRIMARY KEY,
    id_ciudad       NUMBER(10) NOT NULL,
    CONSTRAINT fk_e2_ec_estadio
        FOREIGN KEY (id_estadio)
        REFERENCES estadio (id_estadio),
    CONSTRAINT fk_e2_ec_ciudad
        FOREIGN KEY (id_ciudad)
        REFERENCES ciudad_e2 (id_ciudad)
);

------------------------------------------------------------------------
-- 2. Catalogo de fases y relacion partido-fase (FK simples)
------------------------------------------------------------------------

CREATE TABLE fase_e2 (
    id_fase         NUMBER(2) CONSTRAINT pk_fase_e2 PRIMARY KEY,
    codigo          VARCHAR2(30) NOT NULL,
    orden_fase      NUMBER(2) NOT NULL,
    tipo_fase       VARCHAR2(15) NOT NULL,
    CONSTRAINT uq_fase_e2_codigo UNIQUE (codigo),
    CONSTRAINT uq_fase_e2_orden UNIQUE (orden_fase),
    CONSTRAINT ck_fase_e2_tipo
        CHECK (tipo_fase IN ('GRUPOS', 'ELIMINATORIA'))
);

CREATE TABLE partido_fase_e2 (
    id_partido      NUMBER(10) CONSTRAINT pk_partido_fase_e2 PRIMARY KEY,
    id_edicion      NUMBER(4) NOT NULL,
    id_fase         NUMBER(2) NOT NULL,
    CONSTRAINT fk_e2_pf_partido
        FOREIGN KEY (id_partido)
        REFERENCES partido (id_partido),
    CONSTRAINT fk_e2_pf_edicion
        FOREIGN KEY (id_edicion)
        REFERENCES edicion_mundial (id_edicion),
    CONSTRAINT fk_e2_pf_fase
        FOREIGN KEY (id_fase)
        REFERENCES fase_e2 (id_fase)
);

------------------------------------------------------------------------
-- 3. Jugadores y posiciones
------------------------------------------------------------------------

CREATE TABLE posicion_jugador_e2 (
    id_posicion     NUMBER(2) CONSTRAINT pk_posicion_jugador_e2 PRIMARY KEY,
    codigo          VARCHAR2(10) NOT NULL,
    nombre          VARCHAR2(40) NOT NULL,
    CONSTRAINT uq_posicion_e2_codigo UNIQUE (codigo),
    CONSTRAINT uq_posicion_e2_nombre UNIQUE (nombre)
);

CREATE TABLE jugador_e2 (
    id_jugador          NUMBER(10) CONSTRAINT pk_jugador_e2 PRIMARY KEY,
    nombres             VARCHAR2(80) NOT NULL,
    apellidos           VARCHAR2(80) NOT NULL,
    fecha_nacimiento    DATE NOT NULL,
    id_posicion         NUMBER(2) NOT NULL,
    pie_dominante       CHAR(1) NOT NULL,
    CONSTRAINT uq_jugador_e2_identidad
        UNIQUE (nombres, apellidos, fecha_nacimiento),
    CONSTRAINT ck_jugador_e2_pie
        CHECK (pie_dominante IN ('D', 'I')),
    CONSTRAINT fk_e2_jugador_posicion
        FOREIGN KEY (id_posicion)
        REFERENCES posicion_jugador_e2 (id_posicion)
);

------------------------------------------------------------------------
-- 4. Grupos y convocatorias (FK simples, sin FK compuestas)
------------------------------------------------------------------------

CREATE TABLE grupo_e2 (
    id_grupo        NUMBER(6) CONSTRAINT pk_grupo_e2 PRIMARY KEY,
    id_edicion      NUMBER(4) NOT NULL,
    codigo          VARCHAR2(4) NOT NULL,
    nombre          VARCHAR2(40) NOT NULL,
    CONSTRAINT uq_grupo_e2_edicion_codigo UNIQUE (id_edicion, codigo),
    CONSTRAINT fk_e2_grupo_edicion
        FOREIGN KEY (id_edicion)
        REFERENCES edicion_mundial (id_edicion)
);

CREATE TABLE inscripcion_grupo_e2 (
    id_grupo            NUMBER(6) NOT NULL,
    id_seleccion        NUMBER(10) NOT NULL,
    orden_inicial       NUMBER(2) NOT NULL,
    es_cabeza_serie     CHAR(1) NOT NULL,
    CONSTRAINT pk_inscripcion_grupo_e2
        PRIMARY KEY (id_grupo, id_seleccion),
    CONSTRAINT uq_inscripcion_e2_orden
        UNIQUE (id_grupo, orden_inicial),
    CONSTRAINT ck_inscripcion_e2_orden
        CHECK (orden_inicial BETWEEN 1 AND 48),
    CONSTRAINT ck_inscripcion_e2_cabeza
        CHECK (es_cabeza_serie IN ('S', 'N')),
    CONSTRAINT fk_e2_ig_grupo
        FOREIGN KEY (id_grupo)
        REFERENCES grupo_e2 (id_grupo),
    CONSTRAINT fk_e2_ig_seleccion
        FOREIGN KEY (id_seleccion)
        REFERENCES seleccion (id_seleccion)
);

CREATE TABLE convocatoria_e2 (
    id_convocatoria    NUMBER(8) CONSTRAINT pk_convocatoria_e2 PRIMARY KEY,
    id_edicion         NUMBER(4) NOT NULL,
    id_seleccion       NUMBER(10) NOT NULL,
    fecha_corte        DATE NOT NULL,
    estado             VARCHAR2(12) NOT NULL,
    CONSTRAINT uq_convocatoria_e2_edicion
        UNIQUE (id_edicion, id_seleccion),
    CONSTRAINT ck_convocatoria_e2_estado
        CHECK (estado IN ('PRESELECCION', 'OFICIAL')),
    CONSTRAINT fk_e2_conv_edicion
        FOREIGN KEY (id_edicion)
        REFERENCES edicion_mundial (id_edicion),
    CONSTRAINT fk_e2_conv_seleccion
        FOREIGN KEY (id_seleccion)
        REFERENCES seleccion (id_seleccion)
);

CREATE TABLE convocatoria_jugador_e2 (
    id_convocatoria    NUMBER(8) NOT NULL,
    id_jugador         NUMBER(10) NOT NULL,
    dorsal             NUMBER(2) NOT NULL,
    es_capitan         CHAR(1) NOT NULL,
    CONSTRAINT pk_convoc_jugador_e2
        PRIMARY KEY (id_convocatoria, id_jugador),
    CONSTRAINT uq_convoc_e2_dorsal
        UNIQUE (id_convocatoria, dorsal),
    CONSTRAINT ck_convoc_e2_dorsal
        CHECK (dorsal BETWEEN 1 AND 99),
    CONSTRAINT ck_convoc_e2_capitan
        CHECK (es_capitan IN ('S', 'N')),
    CONSTRAINT fk_e2_cj_convocatoria
        FOREIGN KEY (id_convocatoria)
        REFERENCES convocatoria_e2 (id_convocatoria),
    CONSTRAINT fk_e2_cj_jugador
        FOREIGN KEY (id_jugador)
        REFERENCES jugador_e2 (id_jugador)
);

------------------------------------------------------------------------
-- 5. Arbitraje, eventos y estadisticas por jugador (FK simples)
------------------------------------------------------------------------

CREATE TABLE arbitro_e2 (
    id_arbitro       NUMBER(6) CONSTRAINT pk_arbitro_e2 PRIMARY KEY,
    nombres          VARCHAR2(80) NOT NULL,
    apellidos        VARCHAR2(80) NOT NULL,
    confederacion    VARCHAR2(20) NOT NULL,
    activo           CHAR(1) NOT NULL,
    CONSTRAINT uq_arbitro_e2_identidad UNIQUE (nombres, apellidos),
    CONSTRAINT ck_arbitro_e2_confed
        CHECK (confederacion IN (
            'AFC', 'CAF', 'CONCACAF', 'CONMEBOL', 'OFC', 'UEFA', 'OTRA'
        )),
    CONSTRAINT ck_arbitro_e2_activo
        CHECK (activo IN ('S', 'N'))
);

CREATE TABLE rol_arbitral_e2 (
    id_rol          NUMBER(2) CONSTRAINT pk_rol_arbitral_e2 PRIMARY KEY,
    codigo          VARCHAR2(15) NOT NULL,
    nombre          VARCHAR2(50) NOT NULL,
    CONSTRAINT uq_rol_arbitral_e2_codigo UNIQUE (codigo)
);

CREATE TABLE asignacion_arbitral_e2 (
    id_partido       NUMBER(10) NOT NULL,
    id_arbitro       NUMBER(6) NOT NULL,
    id_rol           NUMBER(2) NOT NULL,
    calificacion     NUMBER(3,1),
    CONSTRAINT pk_asignacion_arbitral_e2
        PRIMARY KEY (id_partido, id_arbitro, id_rol),
    CONSTRAINT uq_asignacion_e2_rol
        UNIQUE (id_partido, id_rol),
    CONSTRAINT ck_asignacion_e2_calif
        CHECK (calificacion BETWEEN 0 AND 10),
    CONSTRAINT fk_e2_aa_partido
        FOREIGN KEY (id_partido)
        REFERENCES partido (id_partido),
    CONSTRAINT fk_e2_aa_arbitro
        FOREIGN KEY (id_arbitro)
        REFERENCES arbitro_e2 (id_arbitro),
    CONSTRAINT fk_e2_aa_rol
        FOREIGN KEY (id_rol)
        REFERENCES rol_arbitral_e2 (id_rol)
);

CREATE TABLE tipo_evento_e2 (
    id_tipo_evento     NUMBER(2) CONSTRAINT pk_tipo_evento_e2 PRIMARY KEY,
    codigo             VARCHAR2(20) NOT NULL,
    nombre             VARCHAR2(60) NOT NULL,
    afecta_marcador    CHAR(1) NOT NULL,
    CONSTRAINT uq_tipo_evento_e2_codigo UNIQUE (codigo),
    CONSTRAINT ck_tipo_evento_e2_marcador
        CHECK (afecta_marcador IN ('S', 'N'))
);

CREATE TABLE evento_partido_e2 (
    id_evento          NUMBER(12) CONSTRAINT pk_evento_partido_e2 PRIMARY KEY,
    id_partido         NUMBER(10) NOT NULL,
    minuto             NUMBER(3) NOT NULL,
    minuto_adicional   NUMBER(2) DEFAULT 0 NOT NULL,
    id_tipo_evento     NUMBER(2) NOT NULL,
    id_seleccion       NUMBER(10),
    id_jugador         NUMBER(10),
    descripcion        VARCHAR2(200) NOT NULL,
    CONSTRAINT ck_evento_e2_minuto
        CHECK (minuto BETWEEN 1 AND 130),
    CONSTRAINT ck_evento_e2_adicional
        CHECK (minuto_adicional BETWEEN 0 AND 30),
    CONSTRAINT fk_e2_evento_partido
        FOREIGN KEY (id_partido)
        REFERENCES partido (id_partido),
    CONSTRAINT fk_e2_evento_tipo
        FOREIGN KEY (id_tipo_evento)
        REFERENCES tipo_evento_e2 (id_tipo_evento),
    CONSTRAINT fk_e2_evento_seleccion
        FOREIGN KEY (id_seleccion)
        REFERENCES seleccion (id_seleccion),
    CONSTRAINT fk_e2_evento_jugador
        FOREIGN KEY (id_jugador)
        REFERENCES jugador_e2 (id_jugador)
);

CREATE TABLE estadistica_jugador_e2 (
    id_partido          NUMBER(10) NOT NULL,
    id_jugador          NUMBER(10) NOT NULL,
    id_convocatoria     NUMBER(8) NOT NULL,
    minutos             NUMBER(3) NOT NULL,
    goles               NUMBER(3) NOT NULL,
    asistencias         NUMBER(3) NOT NULL,
    remates             NUMBER(3) NOT NULL,
    tarjetas_amarillas  NUMBER(2) NOT NULL,
    tarjetas_rojas      NUMBER(1) NOT NULL,
    es_titular          CHAR(1) NOT NULL,
    CONSTRAINT pk_estadistica_jugador_e2
        PRIMARY KEY (id_partido, id_jugador),
    CONSTRAINT ck_estadistica_e2_minutos
        CHECK (minutos BETWEEN 0 AND 130),
    CONSTRAINT ck_estadistica_e2_goles
        CHECK (goles BETWEEN 0 AND 99),
    CONSTRAINT ck_estadistica_e2_asist
        CHECK (asistencias BETWEEN 0 AND 99),
    CONSTRAINT ck_estadistica_e2_remates
        CHECK (remates BETWEEN 0 AND 99),
    CONSTRAINT ck_estadistica_e2_amarillas
        CHECK (tarjetas_amarillas BETWEEN 0 AND 2),
    CONSTRAINT ck_estadistica_e2_rojas
        CHECK (tarjetas_rojas BETWEEN 0 AND 1),
    CONSTRAINT ck_estadistica_e2_titular
        CHECK (es_titular IN ('S', 'N')),
    CONSTRAINT fk_e2_est_partido
        FOREIGN KEY (id_partido)
        REFERENCES partido (id_partido),
    CONSTRAINT fk_e2_est_convocatoria
        FOREIGN KEY (id_convocatoria)
        REFERENCES convocatoria_e2 (id_convocatoria),
    CONSTRAINT fk_e2_est_jugador
        FOREIGN KEY (id_jugador)
        REFERENCES jugador_e2 (id_jugador)
);

------------------------------------------------------------------------
-- 6. Incidencias y auditoria MANUAL (sin trigger ni secuencia)
------------------------------------------------------------------------

CREATE TABLE tipo_incidencia_e2 (
    id_tipo_incidencia  NUMBER(2)
        CONSTRAINT pk_tipo_incidencia_e2 PRIMARY KEY,
    codigo              VARCHAR2(20) NOT NULL,
    nombre              VARCHAR2(60) NOT NULL,
    severidad           VARCHAR2(10) NOT NULL,
    CONSTRAINT uq_tipo_inc_e2_codigo UNIQUE (codigo),
    CONSTRAINT ck_tipo_inc_e2_severidad
        CHECK (severidad IN ('BAJA', 'MEDIA', 'ALTA'))
);

CREATE TABLE incidencia_e2 (
    id_incidencia       NUMBER(12) CONSTRAINT pk_incidencia_e2 PRIMARY KEY,
    id_partido          NUMBER(10) NOT NULL,
    id_tipo_incidencia  NUMBER(2) NOT NULL,
    minuto              NUMBER(3) NOT NULL,
    descripcion         VARCHAR2(300) NOT NULL,
    resuelta            CHAR(1) NOT NULL,
    CONSTRAINT ck_incidencia_e2_minuto
        CHECK (minuto BETWEEN 1 AND 130),
    CONSTRAINT ck_incidencia_e2_resuelta
        CHECK (resuelta IN ('S', 'N')),
    CONSTRAINT fk_e2_inc_partido
        FOREIGN KEY (id_partido)
        REFERENCES partido (id_partido),
    CONSTRAINT fk_e2_inc_tipo
        FOREIGN KEY (id_tipo_incidencia)
        REFERENCES tipo_incidencia_e2 (id_tipo_incidencia)
);

-- Auditoria manual: cada INSERT/UPDATE/DELETE sobre INCIDENCIA_E2
-- se registra con un INSERT explicito (tema Modificadores).
-- Usa DATE + SYSDATE (basico) en vez de TIMESTAMP/SYSTIMESTAMP.
CREATE TABLE auditoria_e2 (
    id_auditoria     NUMBER(14) CONSTRAINT pk_auditoria_e2 PRIMARY KEY,
    tabla_afectada   VARCHAR2(40) NOT NULL,
    operacion        VARCHAR2(10) NOT NULL,
    id_registro      NUMBER(12) NOT NULL,
    usuario_bd       VARCHAR2(128) NOT NULL,
    fecha_evento     DATE DEFAULT SYSDATE NOT NULL,
    detalle          VARCHAR2(400),
    CONSTRAINT ck_auditoria_e2_operacion
        CHECK (operacion IN ('INSERT', 'UPDATE', 'DELETE'))
);

------------------------------------------------------------------------
-- 7. Indices basicos (Modelo Fisico). Solo 2, opcionales.
------------------------------------------------------------------------

CREATE INDEX idx_e2_inscripcion_seleccion
    ON inscripcion_grupo_e2 (id_seleccion);

CREATE INDEX idx_e2_stats_jugador
    ON estadistica_jugador_e2 (id_jugador);

-- Nota: sin trigger de auditoria (tema no visto). La trazabilidad se
-- demuestra insertando en AUDITORIA_E2 junto a cada INCIDENCIA_E2 y
-- verificando con LEFT JOIN en 14_verificacion_entrega2.sql.
