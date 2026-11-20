-- Check project table storage to diagnose the model training quota error.
SELECT
  table_schema,
  table_name,
  total_logical_bytes,
  active_logical_bytes,
  total_physical_bytes
FROM `stately-mote-509700-r8.region-us.INFORMATION_SCHEMA.TABLE_STORAGE`
ORDER BY total_logical_bytes DESC;
