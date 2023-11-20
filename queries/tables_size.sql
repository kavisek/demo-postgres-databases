-- Desc: This query is used to view the size of the tables in the database
SELECT 
    current_database() AS "database_name",
    table_schema AS "schema_name",
    table_name,
    pg_size_pretty(pg_total_relation_size('"' || table_schema || '"."' || table_name || '"')) AS "total_size",
    pg_size_pretty(pg_total_relation_size('"' || table_schema || '"."' || table_name || '"')/1024/1024/1024) AS "size_in_gb"
FROM 
    information_schema.tables
WHERE 
    table_schema NOT IN ('pg_catalog', 'information_schema')
ORDER BY 
    pg_total_relation_size('"' || table_schema || '"."' || table_name || '"') DESC;
