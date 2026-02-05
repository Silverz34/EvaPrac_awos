--ROLES.SQL 

--por si ya existe el usuario 
DROP ROLE IF EXISTS app_user;

-- Crear usuario de la aplicación 
CREATE ROLE app_user WITH 
LOGIN 
PASSWORD 'firewall113'
NOSUPERUSER
NOCREATEDB
NOCREATEROLE
INHERIT;

--Permiso basico de conexion 
GRANT USAGE ON SCHEMA public TO app_user;

--Minimos permisos a solo lectura
GRANT SELECT ON reports_vw_1 TO app_user;
GRANT SELECT ON reports_vw_2 TO app_user;
GRANT SELECT ON reports_vw_3 TO app_user;
GRANT SELECT ON reports_vw_4 TO app_user;
GRANT SELECT ON reports_vw_5 TO app_user;

