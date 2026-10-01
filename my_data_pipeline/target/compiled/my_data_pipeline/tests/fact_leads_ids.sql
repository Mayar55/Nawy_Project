WITH leads AS (
    SELECT *
    FROM "nawy_project_db"."dwh"."fact_leads"
),
duplicate_ids AS (
    SELECT id
    FROM leads
    GROUP BY id
    HAVING COUNT(*) > 1
),
invalid_ids AS (
    SELECT 'id is null' AS reason, id::text AS invalid_value
    FROM leads
    WHERE id IS NULL

    UNION ALL

    SELECT 'original_source_id is null', original_source_id::text
    FROM leads
    WHERE original_source_id IS NULL

    UNION ALL

    SELECT 'id is not unique', id::text
    FROM duplicate_ids
)
SELECT reason, invalid_value
FROM invalid_ids

UNION ALL

SELECT 'original_source_id has no std_leads row', fact.original_source_id::text
FROM leads AS fact
LEFT JOIN "nawy_project_db"."std_schema"."std_leads" AS source
    ON fact.original_source_id = source.original_source_id
WHERE fact.original_source_id IS NOT NULL
  AND source.original_source_id IS NULL