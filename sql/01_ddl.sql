-- Entrega 1 BASICA - DDL para Oracle Database
-- ALCANCE PERMITIDO (conceptos basicos vistos en clase):
--   2. Modelo Relacional (tablas, PK, FK, UNIQUE)
--   3. Introduccion a SQL (tipos NUMBER, VARCHAR2, DATE, NOT NULL, DEFAULT)
--   6. Vistas (no se crean aqui)
--   7. Modificadores (no se usan aqui)
--   8. Integridad y Privilegios (CHECK, UNIQUE, FK, ON DELETE CASCADE / NO ACTION)
-- NO se utiliza (temas aun no vistos - ver imagenes del curso):
--   PLSQL / Triggers, Transacciones-Concurrencia, NoSQL/MongoDB,
--   PL/SQL (PACKAGE, PROCEDURE, TRIGGER, DBMS_OUTPUT),
--   funciones de ventana (DENSE_RANK, OVER), ni clausula WITH compleja.
-- Por eso las reglas que exigirian triggers (fecha dentro de la edicion,
-- asistencia <= capacidad, resultado coherente con goles, exactamente
-- 2 participaciones al finalizar) se controlan con datos correctos y se
-- VERIFICAN con consultas en sql/07_verificacion.sql, no con triggers.
-- Ejecutar una sola vez con Run Script (F5) en SQL Developer.

SET DEFINE OFF;

------------------------------------------------------------------------
-- 1. EDICION_MUNDIAL
------------------------------------------------------------------------

CREATE TABLE edicion_mundial (
    id_edicion       NUMBER(4) CONSTRAINT pk_edicion_mundial PRIMARY KEY,
    anio             NUMBER(4) NOT NULL,
    pais_sede        VARCHAR2(120) NOT NULL,
    lema             VARCHAR2(200) NOT NULL,
    fecha_inicio     DATE NOT NULL,
    fecha_fin        DATE NOT NULL,
    CONSTRAINT uq_edicion_anio UNIQUE (anio),
    CONSTRAINT ck_edicion_anio CHECK (anio BETWEEN 1930 AND 2200),
    CONSTRAINT ck_edicion_fechas CHECK (fecha_fin > fecha_inicio)
);

------------------------------------------------------------------------
-- 2. ESTADIO: pertenece a una edicion (FK simple, concepto basico).
------------------------------------------------------------------------

CREATE TABLE estadio (
    id_estadio       NUMBER(10) CONSTRAINT pk_estadio PRIMARY KEY,
    id_edicion       NUMBER(4) NOT NULL,
    nombre           VARCHAR2(120) NOT NULL,
    ciudad           VARCHAR2(80) NOT NULL,
    capacidad        NUMBER(6) NOT NULL,
    CONSTRAINT uq_estadio_nombre UNIQUE (id_edicion, nombre),
    CONSTRAINT ck_estadio_capacidad CHECK (capacidad BETWEEN 10000 AND 120000),
    CONSTRAINT fk_estadio_edicion
        FOREIGN KEY (id_edicion)
        REFERENCES edicion_mundial (id_edicion)
);

------------------------------------------------------------------------
-- 3. SELECCION: participante de una edicion (FK simple).
------------------------------------------------------------------------

CREATE TABLE seleccion (
    id_seleccion     NUMBER(10) CONSTRAINT pk_seleccion PRIMARY KEY,
    id_edicion       NUMBER(4) NOT NULL,
    pais             VARCHAR2(100) NOT NULL,
    confederacion    VARCHAR2(20) NOT NULL,
    CONSTRAINT uq_seleccion_id_edicion UNIQUE (id_seleccion, id_edicion),
    CONSTRAINT uq_seleccion_pais UNIQUE (id_edicion, pais),
    CONSTRAINT ck_seleccion_confederacion CHECK (
        confederacion IN (
            'AFC', 'CAF', 'CONCACAF', 'CONMEBOL', 'OFC', 'UEFA', 'OTRA'
        )
    ),
    CONSTRAINT fk_seleccion_edicion
        FOREIGN KEY (id_edicion)
        REFERENCES edicion_mundial (id_edicion)
);

------------------------------------------------------------------------
-- 4. PARTIDO: usa DATE (mas basico que TIMESTAMP) y FK simples.
------------------------------------------------------------------------

CREATE TABLE partido (
    id_partido              NUMBER(10) CONSTRAINT pk_partido PRIMARY KEY,
    id_edicion              NUMBER(4) NOT NULL,
    id_estadio              NUMBER(10) NOT NULL,
    fecha_hora              DATE NOT NULL,
    fase                    VARCHAR2(30) NOT NULL,
    asistencia_registrada   NUMBER(6) DEFAULT 0 NOT NULL,
    estado_partido          VARCHAR2(15) DEFAULT 'PROGRAMADO' NOT NULL,
    CONSTRAINT uq_partido_id_edicion UNIQUE (id_partido, id_edicion),
    CONSTRAINT uq_partido_agenda UNIQUE (id_estadio, fecha_hora),
    CONSTRAINT ck_partido_asistencia CHECK (asistencia_registrada >= 0),
    CONSTRAINT ck_partido_fase CHECK (
        fase IN (
            'FASE DE GRUPOS',
            'DIECISEISAVOS',
            'OCTAVOS',
            'CUARTOS',
            'SEMIFINALES',
            'TERCER PUESTO',
            'FINAL'
        )
    ),
    CONSTRAINT ck_partido_estado CHECK (
        estado_partido IN ('PROGRAMADO', 'EN JUEGO', 'FINALIZADO', 'CANCELADO')
    ),
    CONSTRAINT fk_partido_edicion
        FOREIGN KEY (id_edicion)
        REFERENCES edicion_mundial (id_edicion),
    CONSTRAINT fk_partido_estadio
        FOREIGN KEY (id_estadio)
        REFERENCES estadio (id_estadio)
);

------------------------------------------------------------------------
-- 5. PARTICIPACION_PARTIDO: N:M entre PARTIDO y SELECCION.
-- UNIQUE(id_partido, condicion) garantiza un LOCAL y un VISITANTE
-- sin necesidad de triggers (concepto basico de integridad).
------------------------------------------------------------------------

CREATE TABLE participacion_partido (
    id_participacion   NUMBER(12) CONSTRAINT pk_participacion PRIMARY KEY,
    id_partido         NUMBER(10) NOT NULL,
    id_seleccion       NUMBER(10) NOT NULL,
    condicion          VARCHAR2(10) NOT NULL,
    goles_marcados     NUMBER(3) DEFAULT 0 NOT NULL,
    resultado          VARCHAR2(7) NOT NULL,
    CONSTRAINT uq_pp_partido_seleccion UNIQUE (id_partido, id_seleccion),
    CONSTRAINT uq_pp_partido_condicion UNIQUE (id_partido, condicion),
    CONSTRAINT ck_pp_condicion CHECK (condicion IN ('LOCAL', 'VISITANTE')),
    CONSTRAINT ck_pp_goles CHECK (goles_marcados BETWEEN 0 AND 99),
    CONSTRAINT ck_pp_resultado CHECK (resultado IN ('GANO', 'EMPATO', 'PERDIO')),
    CONSTRAINT fk_pp_partido
        FOREIGN KEY (id_partido)
        REFERENCES partido (id_partido)
        ON DELETE CASCADE,
    CONSTRAINT fk_pp_seleccion
        FOREIGN KEY (id_seleccion)
        REFERENCES seleccion (id_seleccion)
);

------------------------------------------------------------------------
-- 6. Indices basicos (Modelo Fisico, tema permitido).
-- Solo 2 indices simples de consulta frecuente. Son opcionales.
------------------------------------------------------------------------

CREATE INDEX idx_partido_edicion_fase
    ON partido (id_edicion, fase);

CREATE INDEX idx_pp_seleccion
    ON participacion_partido (id_seleccion);

-- Nota de integridad referencial (concepto basico):
-- * PARTIDO -> PARTICIPACION_PARTIDO usa ON DELETE CASCADE.
--   Al borrar un partido se borran sus 2 participaciones.
-- * Las demas FK usan NO ACTION implicito (valor por defecto en Oracle):
--   no se puede borrar una edicion/estadio/seleccion con hijos.
-- * Oracle no admite ON UPDATE CASCADE: las PK no se actualizan,
--   se mantienen estables (supuesto de modelado).
