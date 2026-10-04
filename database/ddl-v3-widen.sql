-- ddl-v3-widen.sql  (4 October 2026)
-- Every NVARCHAR(400) column that is not part of a key or an index becomes NVARCHAR(MAX), in every table.
-- Why: the first full Dataflow run failed on aab_records.whyItMatters ("String or binary data would be
-- truncated"): advisory text, comments and task wording are free text with no natural length. Key and
-- indexed columns keep their limits (an index cannot be built on MAX). Safe to run more than once:
-- the second run finds nothing to change. Paste the whole script into a New Query in SACRED DATA, Run.

DECLARE @sql NVARCHAR(MAX) = N'';
SELECT @sql += N'ALTER TABLE ' + QUOTENAME(s.name) + N'.' + QUOTENAME(t.name)
             + N' ALTER COLUMN ' + QUOTENAME(c.name) + N' NVARCHAR(MAX) '
             + CASE WHEN c.is_nullable = 1 THEN N'NULL' ELSE N'NOT NULL' END + N';' + CHAR(10)
FROM sys.columns c
JOIN sys.tables  t ON t.object_id = c.object_id
JOIN sys.schemas s ON s.schema_id = t.schema_id
JOIN sys.types  ty ON ty.user_type_id = c.user_type_id
WHERE s.name = 'dbo'
  AND ty.name = 'nvarchar' AND c.max_length = 800          -- NVARCHAR(400)
  AND NOT EXISTS (SELECT 1 FROM sys.index_columns ic
                  WHERE ic.object_id = c.object_id AND ic.column_id = c.column_id);

PRINT @sql;
EXEC sp_executesql @sql;

-- What changed: should list the widened columns as -1 (MAX); keys and indexed columns are untouched.
SELECT t.name AS [table], COUNT(*) AS columns_now_max
FROM sys.columns c JOIN sys.tables t ON t.object_id = c.object_id JOIN sys.types ty ON ty.user_type_id = c.user_type_id
WHERE ty.name = 'nvarchar' AND c.max_length = -1
GROUP BY t.name ORDER BY t.name;
