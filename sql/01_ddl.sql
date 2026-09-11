-- Entrega 1 - DDL para Oracle Database
-- Ejecutar una sola vez, conectado al esquema asignado por el curso.
-- Ejecutar con Run Script (F5) en SQL Developer.

SET DEFINE OFF;
SET SERVEROUTPUT ON;

------------------------------------------------------------------------
-- 1. Tablas del modelo inicial
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

CREATE TABLE estadio (
    id_estadio       NUMBER(10) CONSTRAINT pk_estadio PRIMARY KEY,
    id_edicion       NUMBER(4) NOT NULL,
    nombre           VARCHAR2(120) NOT NULL,
    ciudad           VARCHAR2(80) NOT NULL,
    capacidad        NUMBER(6) NOT NULL,
    CONSTRAINT uq_estadio_id_edicion UNIQUE (id_estadio, id_edicion),
    CONSTRAINT uq_estadio_nombre UNIQUE (id_edicion, nombre),
    CONSTRAINT ck_estadio_capacidad CHECK (capacidad BETWEEN 10000 AND 120000),
    CONSTRAINT fk_estadio_edicion
        FOREIGN KEY (id_edicion)
        REFERENCES edicion_mundial (id_edicion)
);

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

CREATE TABLE partido (
    id_partido              NUMBER(10) CONSTRAINT pk_partido PRIMARY KEY,
    id_edicion              NUMBER(4) NOT NULL,
    id_estadio              NUMBER(10) NOT NULL,
    fecha_hora              TIMESTAMP NOT NULL,
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
        FOREIGN KEY (id_estadio, id_edicion)
        REFERENCES estadio (id_estadio, id_edicion)
);

CREATE TABLE participacion_partido (
    id_participacion   NUMBER(12) CONSTRAINT pk_participacion_partido PRIMARY KEY,
    id_partido         NUMBER(10) NOT NULL,
    id_edicion         NUMBER(4) NOT NULL,
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
        FOREIGN KEY (id_partido, id_edicion)
        REFERENCES partido (id_partido, id_edicion)
        ON DELETE CASCADE,
    CONSTRAINT fk_pp_seleccion
        FOREIGN KEY (id_seleccion, id_edicion)
        REFERENCES seleccion (id_seleccion, id_edicion)
);

------------------------------------------------------------------------
-- 2. Contexto interno para distinguir CASCADE de un DELETE directo
------------------------------------------------------------------------

CREATE OR REPLACE PACKAGE pkg_entrega1_borrado AS
    PROCEDURE limpiar;
    PROCEDURE marcar (p_id_partido NUMBER);
    FUNCTION es_partido_en_borrado (p_id_partido NUMBER) RETURN BOOLEAN;
END pkg_entrega1_borrado;
/

CREATE OR REPLACE PACKAGE BODY pkg_entrega1_borrado AS
    TYPE t_partidos IS TABLE OF BOOLEAN INDEX BY VARCHAR2(40);
    g_partidos t_partidos;

    FUNCTION clave (p_id_partido NUMBER) RETURN VARCHAR2 IS
    BEGIN
        RETURN TO_CHAR(p_id_partido);
    END clave;

    PROCEDURE limpiar IS
    BEGIN
        g_partidos.DELETE;
    END limpiar;

    PROCEDURE marcar (p_id_partido NUMBER) IS
    BEGIN
        IF p_id_partido IS NOT NULL THEN
            g_partidos(clave(p_id_partido)) := TRUE;
        END IF;
    END marcar;

    FUNCTION es_partido_en_borrado (p_id_partido NUMBER) RETURN BOOLEAN IS
    BEGIN
        IF p_id_partido IS NULL THEN
            RETURN FALSE;
        END IF;
        RETURN g_partidos.EXISTS(clave(p_id_partido));
    END es_partido_en_borrado;
END pkg_entrega1_borrado;
/

------------------------------------------------------------------------
-- 3. Triggers de reglas que no pueden expresarse con CHECK/FK
------------------------------------------------------------------------

-- Un partido debe usar un estadio de su edición, estar dentro de las fechas
-- de la edición y no superar la capacidad del estadio.
CREATE OR REPLACE TRIGGER trg_partido_validar
BEFORE INSERT OR UPDATE OF id_edicion, id_estadio, fecha_hora,
                           asistencia_registrada
ON partido
FOR EACH ROW
DECLARE
    v_fecha_inicio  DATE;
    v_fecha_fin     DATE;
    v_capacidad     NUMBER;
BEGIN
    SELECT e.fecha_inicio, e.fecha_fin, es.capacidad
      INTO v_fecha_inicio, v_fecha_fin, v_capacidad
      FROM edicion_mundial e
      JOIN estadio es
        ON es.id_edicion = e.id_edicion
       AND es.id_estadio = :NEW.id_estadio
     WHERE e.id_edicion = :NEW.id_edicion;

    IF :NEW.fecha_hora < CAST(v_fecha_inicio AS TIMESTAMP)
       OR :NEW.fecha_hora >= CAST(v_fecha_fin + 1 AS TIMESTAMP) THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'La fecha/hora del partido debe estar dentro de la edición.'
        );
    END IF;

    IF :NEW.asistencia_registrada > v_capacidad THEN
        RAISE_APPLICATION_ERROR(
            -20002,
            'La asistencia registrada no puede superar la capacidad del estadio.'
        );
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(
            -20003,
            'El estadio no pertenece a la edición indicada.'
        );
END;
/

-- Comprueba que el resultado textual corresponda al marcador de ambas
-- participaciones. Se valida cuando el partido ya tiene la pareja completa.
CREATE OR REPLACE TRIGGER trg_pp_resultado_consistente
FOR INSERT OR UPDATE OF id_partido, id_edicion, id_seleccion, condicion,
                        goles_marcados, resultado
ON participacion_partido
COMPOUND TRIGGER
    TYPE t_partidos IS TABLE OF participacion_partido.id_partido%TYPE
        INDEX BY PLS_INTEGER;
    g_partidos  t_partidos;
    g_total     PLS_INTEGER := 0;

    PROCEDURE registrar_partido (
        p_id_partido participacion_partido.id_partido%TYPE
    ) IS
    BEGIN
        IF p_id_partido IS NOT NULL THEN
            g_total := g_total + 1;
            g_partidos(g_total) := p_id_partido;
        END IF;
    END registrar_partido;

    AFTER EACH ROW IS
    BEGIN
        registrar_partido(:NEW.id_partido);
        IF UPDATING THEN
            registrar_partido(:OLD.id_partido);
        END IF;
    END AFTER EACH ROW;

    AFTER STATEMENT IS
        v_cantidad         NUMBER;
        v_locales          NUMBER;
        v_visitantes       NUMBER;
        v_goles_local      NUMBER;
        v_goles_visitante  NUMBER;
        v_incorrectos      NUMBER;
    BEGIN
        FOR i IN 1 .. g_total LOOP
            SELECT COUNT(*),
                   COUNT(CASE WHEN condicion = 'LOCAL' THEN 1 END),
                   COUNT(CASE WHEN condicion = 'VISITANTE' THEN 1 END),
                   MAX(CASE WHEN condicion = 'LOCAL' THEN goles_marcados END),
                   MAX(CASE WHEN condicion = 'VISITANTE' THEN goles_marcados END)
              INTO v_cantidad, v_locales, v_visitantes,
                   v_goles_local, v_goles_visitante
              FROM participacion_partido
             WHERE id_partido = g_partidos(i);

            IF v_cantidad = 2 THEN
                IF v_locales <> 1 OR v_visitantes <> 1 THEN
                    RAISE_APPLICATION_ERROR(
                        -20005,
                        'Cada partido completo debe tener un local y un visitante.'
                    );
                END IF;

                IF v_goles_local > v_goles_visitante THEN
                    SELECT COUNT(*)
                      INTO v_incorrectos
                      FROM participacion_partido
                     WHERE id_partido = g_partidos(i)
                       AND (
                            (condicion = 'LOCAL' AND resultado <> 'GANO')
                         OR (condicion = 'VISITANTE' AND resultado <> 'PERDIO')
                       );
                ELSIF v_goles_local < v_goles_visitante THEN
                    SELECT COUNT(*)
                      INTO v_incorrectos
                      FROM participacion_partido
                     WHERE id_partido = g_partidos(i)
                       AND (
                            (condicion = 'LOCAL' AND resultado <> 'PERDIO')
                         OR (condicion = 'VISITANTE' AND resultado <> 'GANO')
                       );
                ELSE
                    SELECT COUNT(*)
                      INTO v_incorrectos
                      FROM participacion_partido
                     WHERE id_partido = g_partidos(i)
                       AND resultado <> 'EMPATO';
                END IF;

                IF v_incorrectos > 0 THEN
                    RAISE_APPLICATION_ERROR(
                        -20006,
                        'El resultado no coincide con los goles del partido.'
                    );
                END IF;
            END IF;
        END LOOP;
    END AFTER STATEMENT;
END;
/

-- Un partido solo puede cerrarse cuando ya tiene exactamente dos
-- participaciones. PROGRAMADO es el estado transitorio de la carga.
CREATE OR REPLACE TRIGGER trg_partido_cierre
BEFORE INSERT OR UPDATE OF estado_partido
ON partido
FOR EACH ROW
DECLARE
    v_cantidad NUMBER;
BEGIN
    IF :NEW.estado_partido = 'FINALIZADO' THEN
        SELECT COUNT(*)
          INTO v_cantidad
          FROM participacion_partido
         WHERE id_partido = :NEW.id_partido;

        IF v_cantidad <> 2 THEN
            RAISE_APPLICATION_ERROR(
                -20007,
                'Un partido finalizado debe tener exactamente dos participaciones.'
            );
        END IF;
    END IF;
END;
/

-- Marca los partidos que están siendo eliminados para que el trigger de la
-- tabla hija no confunda un CASCADE legítimo con un DELETE directo.
CREATE OR REPLACE TRIGGER trg_partido_borrado_ctx
FOR DELETE ON partido
COMPOUND TRIGGER
    BEFORE STATEMENT IS
    BEGIN
        pkg_entrega1_borrado.limpiar;
    END BEFORE STATEMENT;

    BEFORE EACH ROW IS
    BEGIN
        pkg_entrega1_borrado.marcar(:OLD.id_partido);
    END BEFORE EACH ROW;

    AFTER STATEMENT IS
    BEGIN
        pkg_entrega1_borrado.limpiar;
    END AFTER STATEMENT;
END;
/

-- Impide dejar incompleto un partido finalizado mediante un DELETE o el
-- traslado de una participación. Durante ON DELETE CASCADE el contexto
-- anterior permite que las filas hijas sean eliminadas normalmente.
CREATE OR REPLACE TRIGGER trg_pp_proteger_finalizado
FOR DELETE OR UPDATE OF id_partido, id_edicion, id_seleccion, condicion
ON participacion_partido
COMPOUND TRIGGER
    TYPE t_partidos IS TABLE OF participacion_partido.id_partido%TYPE
        INDEX BY PLS_INTEGER;
    g_partidos  t_partidos;
    g_total     PLS_INTEGER := 0;

    PROCEDURE registrar_partido (
        p_id_partido participacion_partido.id_partido%TYPE
    ) IS
    BEGIN
        IF p_id_partido IS NOT NULL THEN
            g_total := g_total + 1;
            g_partidos(g_total) := p_id_partido;
        END IF;
    END registrar_partido;

    AFTER EACH ROW IS
    BEGIN
        IF DELETING OR UPDATING THEN
            registrar_partido(:OLD.id_partido);
        END IF;
        IF UPDATING THEN
            registrar_partido(:NEW.id_partido);
        END IF;
    END AFTER EACH ROW;

    AFTER STATEMENT IS
        v_estado   partido.estado_partido%TYPE;
        v_cantidad NUMBER;
    BEGIN
        FOR i IN 1 .. g_total LOOP
            IF NOT pkg_entrega1_borrado.es_partido_en_borrado(
                       g_partidos(i)
                   ) THEN
                BEGIN
                    SELECT estado_partido
                      INTO v_estado
                      FROM partido
                     WHERE id_partido = g_partidos(i);

                    IF v_estado = 'FINALIZADO' THEN
                        SELECT COUNT(*)
                          INTO v_cantidad
                          FROM participacion_partido
                         WHERE id_partido = g_partidos(i);

                        IF v_cantidad <> 2 THEN
                            RAISE_APPLICATION_ERROR(
                                -20013,
                                'No se puede dejar incompleto un partido finalizado.'
                            );
                        END IF;
                    END IF;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        NULL;
                END;
            END IF;
        END LOOP;
    END AFTER STATEMENT;
END;
/

-- Evita que un cambio posterior de fechas invalide partidos ya registrados.
CREATE OR REPLACE TRIGGER trg_edicion_proteger_fechas
BEFORE UPDATE OF fecha_inicio, fecha_fin
ON edicion_mundial
FOR EACH ROW
DECLARE
    v_partidos NUMBER;
BEGIN
    IF :NEW.fecha_inicio <> :OLD.fecha_inicio
       OR :NEW.fecha_fin <> :OLD.fecha_fin THEN
        SELECT COUNT(*)
          INTO v_partidos
          FROM partido
         WHERE id_edicion = :OLD.id_edicion;

        IF v_partidos > 0 THEN
            RAISE_APPLICATION_ERROR(
                -20014,
                'No se pueden cambiar las fechas de una edición con partidos.'
            );
        END IF;
    END IF;
END;
/

-- Valida que una reducción de capacidad no contradiga la asistencia
-- histórica de los partidos albergados.
CREATE OR REPLACE TRIGGER trg_estadio_validar_capacidad
BEFORE UPDATE OF capacidad
ON estadio
FOR EACH ROW
DECLARE
    v_max_asistencia NUMBER;
BEGIN
    SELECT NVL(MAX(asistencia_registrada), 0)
      INTO v_max_asistencia
      FROM partido
     WHERE id_estadio = :OLD.id_estadio
       AND id_edicion = :OLD.id_edicion;

    IF :NEW.capacidad < v_max_asistencia THEN
        RAISE_APPLICATION_ERROR(
            -20015,
            'La capacidad nueva no puede ser menor que una asistencia histórica.'
        );
    END IF;
END;
/

-- Oracle no ofrece ON UPDATE CASCADE en claves foráneas. Para conservar la
-- identidad de los registros se prohíbe cambiar las PK durante esta entrega.
CREATE OR REPLACE TRIGGER trg_no_pk_update_edicion
BEFORE UPDATE OF id_edicion ON edicion_mundial
FOR EACH ROW
BEGIN
    IF :NEW.id_edicion <> :OLD.id_edicion THEN
        RAISE_APPLICATION_ERROR(-20008, 'La PK de EDICION_MUNDIAL no se actualiza.');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_no_pk_update_estadio
BEFORE UPDATE OF id_estadio ON estadio
FOR EACH ROW
BEGIN
    IF :NEW.id_estadio <> :OLD.id_estadio THEN
        RAISE_APPLICATION_ERROR(-20009, 'La PK de ESTADIO no se actualiza.');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_no_pk_update_seleccion
BEFORE UPDATE OF id_seleccion ON seleccion
FOR EACH ROW
BEGIN
    IF :NEW.id_seleccion <> :OLD.id_seleccion THEN
        RAISE_APPLICATION_ERROR(-20010, 'La PK de SELECCION no se actualiza.');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_no_pk_update_partido
BEFORE UPDATE OF id_partido ON partido
FOR EACH ROW
BEGIN
    IF :NEW.id_partido <> :OLD.id_partido THEN
        RAISE_APPLICATION_ERROR(-20011, 'La PK de PARTIDO no se actualiza.');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_no_pk_update_pp
BEFORE UPDATE OF id_participacion ON participacion_partido
FOR EACH ROW
BEGIN
    IF :NEW.id_participacion <> :OLD.id_participacion THEN
        RAISE_APPLICATION_ERROR(
            -20012,
            'La PK de PARTICIPACION_PARTIDO no se actualiza.'
        );
    END IF;
END;
/

------------------------------------------------------------------------
-- 3. Índices estratégicos
------------------------------------------------------------------------

CREATE INDEX idx_estadio_ciudad
    ON estadio (id_edicion, ciudad);

CREATE INDEX idx_seleccion_confed
    ON seleccion (id_edicion, confederacion);

CREATE INDEX idx_partido_edicion_fase
    ON partido (id_edicion, fase);

CREATE INDEX idx_partido_fecha
    ON partido (fecha_hora);

CREATE INDEX idx_pp_seleccion_edicion
    ON participacion_partido (id_seleccion, id_edicion);

-- Nota de integridad referencial:
-- * PARTIDO -> PARTICIPACION_PARTIDO usa ON DELETE CASCADE.
-- * Las demás FKs usan NO ACTION implícito (Oracle no admite RESTRICT explícito).
-- * Oracle no admite ON UPDATE CASCADE; los triggers anteriores bloquean cambios de PK.
