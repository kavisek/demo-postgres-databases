-- Desc: Viewing blocker queries
select pid,
       usename as username,
       pg_blocking_pids(pid) as blocked_by,
       now() - backend_start as duration,
       query as blocked_query,
       datname as database_name,
       client_addr as client_address,
       application_name,
       backend_start,
       state,
       state_change
from pg_stat_activity
where cardinality(pg_blocking_pids(pid)) > 0
ORDER BY backend_start;