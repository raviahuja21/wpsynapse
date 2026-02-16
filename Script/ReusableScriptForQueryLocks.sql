SELECT 
    request_id,
    session_id,
    status,
    command,
    total_elapsed_time / 1000 AS elapsed_seconds,
    resource_class,
    submit_time,
    start_time,
    end_compile_time,
    total_elapsed_time,
    [label],
    error_id
FROM sys.dm_pdw_exec_requests
WHERE status NOT IN ('Completed', 'Cancelled', 'Failed')
ORDER BY start_time DESC;

--
kill 'SID332264'
  
