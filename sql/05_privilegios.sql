-- Entrega 1 - Privilegios básicos para Oracle
-- Ejecutar conectado al esquema propietario de las tablas, con permisos para
-- crear roles y otorgar privilegios. Si el DBA crea los roles, los GRANT y
-- la consulta de evidencia deben ejecutarse después como el propietario.
-- No contiene contraseñas ni crea usuarios reales.
-- Los nombres de rol incluyen E1_ANDRES para evitar colisiones entre grupos.

SET DEFINE OFF;
SET SERVEROUTPUT ON;

-- Si se vuelve a ejecutar, comentar estas dos líneas cuando los roles ya
-- existan. Si el nombre estuviera ocupado por un usuario, la ejecución debe
-- detenerse y se debe escoger otro nombre, nunca otorgar permisos a ese usuario.
CREATE ROLE rol_fifa_e1_andres_consulta;
CREATE ROLE rol_fifa_e1_andres_operativo;

------------------------------------------------------------------------
-- Rol de solo consulta
------------------------------------------------------------------------

GRANT SELECT ON edicion_mundial TO rol_fifa_e1_andres_consulta;
GRANT SELECT ON estadio TO rol_fifa_e1_andres_consulta;
GRANT SELECT ON seleccion TO rol_fifa_e1_andres_consulta;
GRANT SELECT ON partido TO rol_fifa_e1_andres_consulta;
GRANT SELECT ON participacion_partido TO rol_fifa_e1_andres_consulta;

GRANT SELECT ON vw_marcador_partidos TO rol_fifa_e1_andres_consulta;
GRANT SELECT ON vw_tabla_posiciones TO rol_fifa_e1_andres_consulta;
GRANT SELECT ON vw_goleadores_sel TO rol_fifa_e1_andres_consulta;
GRANT SELECT ON vw_ocupacion_estadio TO rol_fifa_e1_andres_consulta;
GRANT SELECT ON vw_partidos_atipicos TO rol_fifa_e1_andres_consulta;

-- El rol de consulta nunca recibe privilegios DML. Estas revocaciones hacen
-- el script seguro si un administrador le hubiera otorgado alguno antes.
DECLARE
    PROCEDURE revocar_si_existe(p_sentencia VARCHAR2) IS
    BEGIN
        EXECUTE IMMEDIATE p_sentencia;
    EXCEPTION
        WHEN OTHERS THEN
            -- ORA-01927: el privilegio no estaba otorgado.
            IF SQLCODE <> -1927 THEN
                RAISE;
            END IF;
    END;
BEGIN
    revocar_si_existe(
        'REVOKE INSERT ON edicion_mundial FROM rol_fifa_e1_andres_consulta'
    );
    revocar_si_existe(
        'REVOKE UPDATE ON edicion_mundial FROM rol_fifa_e1_andres_consulta'
    );
    revocar_si_existe(
        'REVOKE DELETE ON edicion_mundial FROM rol_fifa_e1_andres_consulta'
    );
    revocar_si_existe(
        'REVOKE INSERT ON estadio FROM rol_fifa_e1_andres_consulta'
    );
    revocar_si_existe(
        'REVOKE UPDATE ON estadio FROM rol_fifa_e1_andres_consulta'
    );
    revocar_si_existe(
        'REVOKE DELETE ON estadio FROM rol_fifa_e1_andres_consulta'
    );
    revocar_si_existe(
        'REVOKE INSERT ON seleccion FROM rol_fifa_e1_andres_consulta'
    );
    revocar_si_existe(
        'REVOKE UPDATE ON seleccion FROM rol_fifa_e1_andres_consulta'
    );
    revocar_si_existe(
        'REVOKE DELETE ON seleccion FROM rol_fifa_e1_andres_consulta'
    );
    revocar_si_existe(
        'REVOKE INSERT ON partido FROM rol_fifa_e1_andres_consulta'
    );
    revocar_si_existe(
        'REVOKE UPDATE ON partido FROM rol_fifa_e1_andres_consulta'
    );
    revocar_si_existe(
        'REVOKE DELETE ON partido FROM rol_fifa_e1_andres_consulta'
    );
    revocar_si_existe(
        'REVOKE INSERT ON participacion_partido FROM rol_fifa_e1_andres_consulta'
    );
    revocar_si_existe(
        'REVOKE UPDATE ON participacion_partido FROM rol_fifa_e1_andres_consulta'
    );
    revocar_si_existe(
        'REVOKE DELETE ON participacion_partido FROM rol_fifa_e1_andres_consulta'
    );
END;
/

------------------------------------------------------------------------
-- Rol operativo
------------------------------------------------------------------------

-- El rol operativo necesita consultar catálogos y registrar el ciclo
-- transaccional de partidos. No recibe DELETE.
GRANT SELECT ON edicion_mundial TO rol_fifa_e1_andres_operativo;
GRANT SELECT ON estadio TO rol_fifa_e1_andres_operativo;
GRANT SELECT ON seleccion TO rol_fifa_e1_andres_operativo;
GRANT SELECT ON partido TO rol_fifa_e1_andres_operativo;
GRANT SELECT ON participacion_partido TO rol_fifa_e1_andres_operativo;

GRANT INSERT, UPDATE ON partido TO rol_fifa_e1_andres_operativo;
GRANT INSERT, UPDATE ON participacion_partido TO rol_fifa_e1_andres_operativo;

DECLARE
    PROCEDURE revocar_si_existe(p_sentencia VARCHAR2) IS
    BEGIN
        EXECUTE IMMEDIATE p_sentencia;
    EXCEPTION
        WHEN OTHERS THEN
            -- ORA-01927: el privilegio no estaba otorgado.
            IF SQLCODE <> -1927 THEN
                RAISE;
            END IF;
    END;
BEGIN
    revocar_si_existe(
        'REVOKE DELETE ON edicion_mundial FROM rol_fifa_e1_andres_operativo'
    );
    revocar_si_existe(
        'REVOKE DELETE ON estadio FROM rol_fifa_e1_andres_operativo'
    );
    revocar_si_existe(
        'REVOKE DELETE ON seleccion FROM rol_fifa_e1_andres_operativo'
    );
    revocar_si_existe(
        'REVOKE DELETE ON partido FROM rol_fifa_e1_andres_operativo'
    );
    revocar_si_existe(
        'REVOKE DELETE ON participacion_partido FROM rol_fifa_e1_andres_operativo'
    );
END;
/

-- No existe tabla de auditoría en el modelo inicial. Cuando se agregue en
-- una entrega posterior, no se otorgará ningún privilegio sobre ella al rol
-- operativo.

------------------------------------------------------------------------
-- Evidencia de privilegios otorgados al nivel del esquema
------------------------------------------------------------------------

SELECT grantee, table_name, privilege
  FROM user_tab_privs_made
 WHERE grantee IN (
        'ROL_FIFA_E1_ANDRES_CONSULTA',
        'ROL_FIFA_E1_ANDRES_OPERATIVO'
       )
 ORDER BY grantee, table_name, privilege;

-- Pruebas manuales requeridas con usuarios de prueba del servidor:
--
-- 1. Otorgar el rol de consulta a un usuario:
--    GRANT rol_fifa_e1_andres_consulta TO usuario_consulta_entrega1;
--    SELECT * FROM <ESQUEMA>.vw_tabla_posiciones;
--    INSERT INTO <ESQUEMA>.partido (...) VALUES (...); -- debe fallar ORA-01031
--
-- 2. Otorgar el rol operativo a otro usuario:
--    GRANT rol_fifa_e1_andres_operativo TO usuario_operativo_entrega1;
--    INSERT/UPDATE sobre PARTIDO y PARTICIPACION_PARTIDO -- debe funcionar;
--    DELETE FROM <ESQUEMA>.partido WHERE ...; -- debe fallar ORA-01031
--
-- El nombre real de los usuarios y el esquema deben ser suministrados por
-- el administrador del curso; no se incluyen credenciales en GitHub.
