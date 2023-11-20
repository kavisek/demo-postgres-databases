-- Desc: This query is used to close the connection to the database
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'postgres'
AND usename = 'postgres'
AND pid <> pg_backend_pid();
