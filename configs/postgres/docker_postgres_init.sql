CREATE USER user_keycloak WITH PASSWORD 'changeme';
CREATE DATABASE db_keycloak;
GRANT ALL PRIVILEGES ON DATABASE db_keycloak TO user_keycloak;

CREATE USER user_boundary WITH PASSWORD 'changeme';
CREATE DATABASE db_boundary;
GRANT ALL PRIVILEGES ON DATABASE db_boundary TO user_boundary;

\connect db_keycloak

GRANT ALL PRIVILEGES ON                  SCHEMA public TO user_keycloak;
GRANT ALL PRIVILEGES ON ALL TABLES    IN SCHEMA public TO user_keycloak;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO user_keycloak;

\connect db_boundary

GRANT ALL PRIVILEGES ON                  SCHEMA public TO user_boundary;
GRANT ALL PRIVILEGES ON ALL TABLES    IN SCHEMA public TO user_boundary;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO user_boundary;

