-- Entrega 3 BASICA - Ampliacion (solo conceptos basicos)
-- Requiere 01_ddl.sql y 02_datos_prueba.sql BASICOS.
-- Solo usa CREATE TABLE / ALTER TABLE ADD con PK, FK simples,
-- UNIQUE, CHECK, DEFAULT, NUMBER/VARCHAR2/DATE y 2 indices.
-- NO usa: PL/SQL, secuencias, TIMESTAMP, FK compuestas, ventanas,
-- funciones, procedimientos ni triggers.
-- La tabla de posiciones se llena con INSERT SELECT (ver 10),
-- la auditoria es MANUAL con INSERT (sin triggers).
-- Ejecutar una sola vez con Run Script (F5).

SET DEFINE OFF;

------------------------------------------------------------------------
-- 1. Columnas nuevas en tablas E1 (nullable, sin validacion compleja)
------------------------------------------------------------------------

ALTER TABLE estadio ADD (id_ciudad NUMBER(10));

ALTER TABLE partido ADD (id_grupo NUMBER(10));

------------------------------------------------------------------------
-- 2. Catalogos de sedes, ciudades y grupos (FK simples)
------------------------------------------------------------------------

CREATE TABLE sede (
    id_sede       NUMBER(10) CONSTRAINT pk_e3_sede PRIMARY KEY,
    nombre        VARCHAR2(120) NOT NULL,
    pais          VARCHAR2(120) NOT NULL,
    activa        CHAR(1) DEFAULT 'S' NOT NULL,
    CONSTRAINT uq_e3_sede_nombre UNIQUE (nombre),
    CONSTRAINT ck_e3_sede_activa CHECK (activa IN ('S', 'N'))
);

CREATE TABLE edicion_sede (
    id_edicion   NUMBER(4) NOT NULL,
    id_sede      NUMBER(10) NOT NULL,
    es_principal CHAR(1) DEFAULT 'S' NOT NULL,
    CONSTRAINT pk_e3_edicion_sede PRIMARY KEY (id_edicion, id_sede),
    CONSTRAINT ck_e3_edicion_sede_principal CHECK (es_principal IN ('S', 'N')),
    CONSTRAINT fk_e3_edicion_sede_edicion
        FOREIGN KEY (id_edicion)
        REFERENCES edicion_mundial (id_edicion),
    CONSTRAINT fk_e3_edicion_sede_sede
        FOREIGN KEY (id_sede)
        REFERENCES sede (id_sede)
);

CREATE TABLE ciudad (
    id_ciudad NUMBER(10) CONSTRAINT pk_e3_ciudad PRIMARY KEY,
    id_sede   NUMBER(10) NOT NULL,
    nombre    VARCHAR2(80) NOT NULL,
    pais      VARCHAR2(120) NOT NULL,
    CONSTRAINT uq_e3_ciudad_sede_nombre UNIQUE (id_sede, nombre),
    CONSTRAINT fk_e3_ciudad_sede
        FOREIGN KEY (id_sede)
        REFERENCES sede (id_sede)
);

CREATE TABLE grupo_torneo (
    id_grupo   NUMBER(10) CONSTRAINT pk_e3_grupo PRIMARY KEY,
    id_edicion NUMBER(4) NOT NULL,
    codigo     VARCHAR2(10) NOT NULL,
    nombre     VARCHAR2(80) NOT NULL,
    fase       VARCHAR2(30) DEFAULT 'FASE DE GRUPOS' NOT NULL,
    CONSTRAINT uq_e3_grupo_codigo UNIQUE (id_edicion, codigo),
    CONSTRAINT ck_e3_grupo_fase CHECK (fase = 'FASE DE GRUPOS'),
    CONSTRAINT fk_e3_grupo_edicion
        FOREIGN KEY (id_edicion)
        REFERENCES edicion_mundial (id_edicion)
);

CREATE TABLE inscripcion_grupo (
    id_inscripcion NUMBER(12) CONSTRAINT pk_e3_inscripcion_grupo PRIMARY KEY,
    id_grupo       NUMBER(10) NOT NULL,
    id_seleccion   NUMBER(10) NOT NULL,
    posicion       NUMBER(2),
    CONSTRAINT uq_e3_inscripcion_grupo_sel UNIQUE (id_grupo, id_seleccion),
    CONSTRAINT uq_e3_inscripcion_seleccion UNIQUE (id_seleccion),
    CONSTRAINT ck_e3_inscripcion_posicion CHECK (posicion IS NULL OR posicion BETWEEN 1 AND 4),
    CONSTRAINT fk_e3_inscripcion_grupo
        FOREIGN KEY (id_grupo)
        REFERENCES grupo_torneo (id_grupo),
    CONSTRAINT fk_e3_inscripcion_seleccion
        FOREIGN KEY (id_seleccion)
        REFERENCES seleccion (id_seleccion)
);

------------------------------------------------------------------------
-- 3. Jugadores, convocatorias y cuerpo tecnico (FK simples)
------------------------------------------------------------------------

CREATE TABLE jugador (
    id_jugador       NUMBER(12) CONSTRAINT pk_e3_jugador PRIMARY KEY,
    nombres          VARCHAR2(80) NOT NULL,
    apellidos        VARCHAR2(80) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    nacionalidad     VARCHAR2(100) NOT NULL,
    posicion         VARCHAR2(20) NOT NULL,
    activo           CHAR(1) DEFAULT 'S' NOT NULL,
    CONSTRAINT ck_e3_jugador_posicion CHECK (
        posicion IN ('ARQUERO', 'DEFENSA', 'MEDIOCAMPISTA', 'DELANTERO')
    ),
    CONSTRAINT ck_e3_jugador_activo CHECK (activo IN ('S', 'N')),
    CONSTRAINT ck_e3_jugador_fecha CHECK (
        fecha_nacimiento >= DATE '1950-01-01'
    )
);

CREATE TABLE convocatoria (
    id_convocatoria NUMBER(12) CONSTRAINT pk_e3_convocatoria PRIMARY KEY,
    id_edicion      NUMBER(4) NOT NULL,
    id_seleccion    NUMBER(10) NOT NULL,
    fecha_registro  DATE DEFAULT SYSDATE NOT NULL,
    estado          VARCHAR2(15) DEFAULT 'ACTIVA' NOT NULL,
    CONSTRAINT uq_e3_convocatoria_seleccion UNIQUE (id_seleccion),
    CONSTRAINT ck_e3_convocatoria_estado CHECK (
        estado IN ('ACTIVA', 'CERRADA', 'ANULADA')
    ),
    CONSTRAINT fk_e3_convocatoria_edicion
        FOREIGN KEY (id_edicion)
        REFERENCES edicion_mundial (id_edicion),
    CONSTRAINT fk_e3_convocatoria_seleccion
        FOREIGN KEY (id_seleccion)
        REFERENCES seleccion (id_seleccion)
);

CREATE TABLE convocatoria_jugador (
    id_convocatoria NUMBER(12) NOT NULL,
    id_jugador      NUMBER(12) NOT NULL,
    dorsal          NUMBER(2) NOT NULL,
    capitan        CHAR(1) DEFAULT 'N' NOT NULL,
    CONSTRAINT pk_e3_convocatoria_jugador PRIMARY KEY (id_convocatoria, id_jugador),
    CONSTRAINT uq_e3_convocatoria_dorsal UNIQUE (id_convocatoria, dorsal),
    CONSTRAINT ck_e3_convocatoria_dorsal CHECK (dorsal BETWEEN 1 AND 99),
    CONSTRAINT ck_e3_convocatoria_capitan CHECK (capitan IN ('S', 'N')),
    CONSTRAINT fk_e3_cj_convocatoria
        FOREIGN KEY (id_convocatoria)
        REFERENCES convocatoria (id_convocatoria)
        ON DELETE CASCADE,
    CONSTRAINT fk_e3_cj_jugador
        FOREIGN KEY (id_jugador)
        REFERENCES jugador (id_jugador)
);

CREATE TABLE cuerpo_tecnico (
    id_cuerpo_tecnico NUMBER(12) CONSTRAINT pk_e3_cuerpo_tecnico PRIMARY KEY,
    nombres           VARCHAR2(80) NOT NULL,
    apellidos         VARCHAR2(80) NOT NULL,
    cargo             VARCHAR2(40) NOT NULL,
    nacionalidad      VARCHAR2(100) NOT NULL,
    activo            CHAR(1) DEFAULT 'S' NOT NULL,
    CONSTRAINT ck_e3_cuerpo_cargo CHECK (
        cargo IN ('DIRECTOR TECNICO', 'ASISTENTE', 'PREPARADOR FISICO',
                  'ENTRENADOR DE ARQUEROS', 'MEDICO')
    ),
    CONSTRAINT ck_e3_cuerpo_activo CHECK (activo IN ('S', 'N'))
);

CREATE TABLE asignacion_cuerpo_tecnico (
    id_seleccion      NUMBER(10) NOT NULL,
    id_cuerpo_tecnico NUMBER(12) NOT NULL,
    fecha_inicio      DATE NOT NULL,
    fecha_fin         DATE,
    es_principal      CHAR(1) DEFAULT 'N' NOT NULL,
    CONSTRAINT pk_e3_asignacion_cuerpo PRIMARY KEY (
        id_seleccion, id_cuerpo_tecnico
    ),
    CONSTRAINT ck_e3_asignacion_fechas CHECK (
        fecha_fin IS NULL OR fecha_fin >= fecha_inicio
    ),
    CONSTRAINT ck_e3_asignacion_principal CHECK (es_principal IN ('S', 'N')),
    CONSTRAINT fk_e3_asignacion_seleccion
        FOREIGN KEY (id_seleccion)
        REFERENCES seleccion (id_seleccion),
    CONSTRAINT fk_e3_asignacion_cuerpo
        FOREIGN KEY (id_cuerpo_tecnico)
        REFERENCES cuerpo_tecnico (id_cuerpo_tecnico)
);

------------------------------------------------------------------------
-- 4. Estadisticas e incidencias (FK simples)
------------------------------------------------------------------------

CREATE TABLE estadistica_jugador_partido (
    id_estadistica       NUMBER(14) CONSTRAINT pk_e3_estadistica PRIMARY KEY,
    id_partido           NUMBER(10) NOT NULL,
    id_seleccion         NUMBER(10) NOT NULL,
    id_jugador            NUMBER(12) NOT NULL,
    minutos_jugados      NUMBER(3) DEFAULT 0 NOT NULL,
    goles                NUMBER(3) DEFAULT 0 NOT NULL,
    asistencias          NUMBER(3) DEFAULT 0 NOT NULL,
    tarjetas_amarillas   NUMBER(2) DEFAULT 0 NOT NULL,
    tarjetas_rojas       NUMBER(2) DEFAULT 0 NOT NULL,
    titular               CHAR(1) DEFAULT 'N' NOT NULL,
    CONSTRAINT uq_e3_estadistica_partido_jugador UNIQUE (id_partido, id_jugador),
    CONSTRAINT ck_e3_estadistica_minutos CHECK (minutos_jugados BETWEEN 0 AND 130),
    CONSTRAINT ck_e3_estadistica_goles CHECK (goles BETWEEN 0 AND 99),
    CONSTRAINT ck_e3_estadistica_asistencias CHECK (asistencias BETWEEN 0 AND 99),
    CONSTRAINT ck_e3_estadistica_amarillas CHECK (tarjetas_amarillas BETWEEN 0 AND 2),
    CONSTRAINT ck_e3_estadistica_rojas CHECK (tarjetas_rojas BETWEEN 0 AND 1),
    CONSTRAINT ck_e3_estadistica_titular CHECK (titular IN ('S', 'N')),
    CONSTRAINT fk_e3_estadistica_partido
        FOREIGN KEY (id_partido)
        REFERENCES partido (id_partido),
    CONSTRAINT fk_e3_estadistica_seleccion
        FOREIGN KEY (id_seleccion)
        REFERENCES seleccion (id_seleccion),
    CONSTRAINT fk_e3_estadistica_jugador
        FOREIGN KEY (id_jugador)
        REFERENCES jugador (id_jugador)
);

CREATE TABLE tipo_incidencia (
    id_tipo_incidencia NUMBER(4) CONSTRAINT pk_e3_tipo_incidencia PRIMARY KEY,
    nombre             VARCHAR2(60) NOT NULL,
    categoria          VARCHAR2(20) NOT NULL,
    CONSTRAINT uq_e3_tipo_incidencia_nombre UNIQUE (nombre),
    CONSTRAINT ck_e3_tipo_incidencia_categoria CHECK (
        categoria IN ('DISCIPLINARIA', 'DEPORTIVA', 'OPERATIVA', 'TECNOLOGICA')
    )
);

CREATE TABLE incidencia (
    id_incidencia      NUMBER(14) CONSTRAINT pk_e3_incidencia PRIMARY KEY,
    id_partido         NUMBER(10) NOT NULL,
    id_tipo_incidencia NUMBER(4) NOT NULL,
    minuto             NUMBER(3) NOT NULL,
    id_seleccion       NUMBER(10),
    id_jugador         NUMBER(12),
    descripcion        VARCHAR2(500) NOT NULL,
    revisada           CHAR(1) DEFAULT 'N' NOT NULL,
    CONSTRAINT ck_e3_incidencia_minuto CHECK (minuto BETWEEN 0 AND 130),
    CONSTRAINT ck_e3_incidencia_revisada CHECK (revisada IN ('S', 'N')),
    CONSTRAINT fk_e3_incidencia_partido
        FOREIGN KEY (id_partido)
        REFERENCES partido (id_partido)
        ON DELETE CASCADE,
    CONSTRAINT fk_e3_incidencia_tipo
        FOREIGN KEY (id_tipo_incidencia)
        REFERENCES tipo_incidencia (id_tipo_incidencia),
    CONSTRAINT fk_e3_incidencia_seleccion
        FOREIGN KEY (id_seleccion)
        REFERENCES seleccion (id_seleccion),
    CONSTRAINT fk_e3_incidencia_jugador
        FOREIGN KEY (id_jugador)
        REFERENCES jugador (id_jugador)
);

------------------------------------------------------------------------
-- 5. Posiciones, cierres y auditoria MANUAL (DATE, sin secuencias)
------------------------------------------------------------------------

CREATE TABLE tabla_posiciones_e3 (
    id_edicion       NUMBER(4) NOT NULL,
    id_seleccion     NUMBER(10) NOT NULL,
    id_grupo         NUMBER(10),
    partidos_jugados NUMBER(4) DEFAULT 0 NOT NULL,
    victorias        NUMBER(4) DEFAULT 0 NOT NULL,
    empates          NUMBER(4) DEFAULT 0 NOT NULL,
    derrotas         NUMBER(4) DEFAULT 0 NOT NULL,
    puntos           NUMBER(5) DEFAULT 0 NOT NULL,
    goles_favor      NUMBER(5) DEFAULT 0 NOT NULL,
    goles_contra     NUMBER(5) DEFAULT 0 NOT NULL,
    diferencia_goles NUMBER(6) DEFAULT 0 NOT NULL,
    CONSTRAINT pk_e3_tabla_posiciones PRIMARY KEY (id_edicion, id_seleccion),
    CONSTRAINT fk_e3_tabla_edicion
        FOREIGN KEY (id_edicion)
        REFERENCES edicion_mundial (id_edicion),
    CONSTRAINT fk_e3_tabla_seleccion
        FOREIGN KEY (id_seleccion)
        REFERENCES seleccion (id_seleccion),
    CONSTRAINT fk_e3_tabla_grupo
        FOREIGN KEY (id_grupo)
        REFERENCES grupo_torneo (id_grupo)
);

CREATE TABLE cierre_fase (
    id_edicion   NUMBER(4) NOT NULL,
    fase         VARCHAR2(30) NOT NULL,
    estado       VARCHAR2(12) DEFAULT 'CERRADA' NOT NULL,
    fecha_cierre DATE DEFAULT SYSDATE NOT NULL,
    usuario_cierre VARCHAR2(128) NOT NULL,
    CONSTRAINT pk_e3_cierre_fase PRIMARY KEY (id_edicion, fase),
    CONSTRAINT ck_e3_cierre_estado CHECK (estado IN ('ABIERTA', 'CERRADA')),
    CONSTRAINT fk_e3_cierre_edicion
        FOREIGN KEY (id_edicion)
        REFERENCES edicion_mundial (id_edicion),
    CONSTRAINT ck_e3_cierre_fase CHECK (
        fase IN (
            'FASE DE GRUPOS', 'DIECISEISAVOS', 'OCTAVOS', 'CUARTOS',
            'SEMIFINALES', 'TERCER PUESTO', 'FINAL'
        )
    )
);

-- Auditoria manual: se registra con INSERT (sin triggers ni secuencias).
CREATE TABLE auditoria_evento (
    id_auditoria   NUMBER(18) CONSTRAINT pk_e3_auditoria PRIMARY KEY,
    fecha_evento   DATE DEFAULT SYSDATE NOT NULL,
    usuario_bd     VARCHAR2(128) NOT NULL,
    tabla_afectada VARCHAR2(40) NOT NULL,
    operacion      VARCHAR2(10) NOT NULL,
    clave_registro VARCHAR2(200) NOT NULL,
    detalle        VARCHAR2(4000),
    CONSTRAINT ck_e3_auditoria_operacion CHECK (
        operacion IN ('INSERT', 'UPDATE', 'DELETE')
    )
);

------------------------------------------------------------------------
-- 6. Indices basicos (solo 2, opcionales)
------------------------------------------------------------------------

CREATE INDEX idx_e3_partido_grupo
    ON partido (id_grupo);

CREATE INDEX idx_e3_estadistica_seleccion
    ON estadistica_jugador_partido (id_seleccion);
