-- Select users
SELECT *
FROM pg_roles
WHERE rolcanlogin = true;

-- Select roles
SELECT rolname FROM pg_roles;

-- List user permissions for each database
SELECT
   *
FROM
    information_schema.role_table_grants