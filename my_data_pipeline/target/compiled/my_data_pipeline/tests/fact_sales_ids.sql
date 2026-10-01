WITH sales AS (
    SELECT *
    FROM "nawy_project_db"."dwh"."fact_sales"
),
duplicate_ids AS (
    SELECT id
    FROM sales
    GROUP BY id
    HAVING COUNT(*) > 1
)
SELECT 'id is null' AS reason, id::text AS invalid_value
FROM sales
WHERE id IS NULL

UNION ALL

SELECT 'id is not unique', id::text
FROM duplicate_ids

UNION ALL

SELECT 'lead_id is null', lead_id::text
FROM sales
WHERE lead_id IS NULL

UNION ALL

SELECT 'lead_id has no fact_leads row', sales.lead_id::text
FROM sales
LEFT JOIN "nawy_project_db"."dwh"."fact_leads" AS leads
    ON sales.lead_id = leads.id
WHERE sales.lead_id IS NOT NULL
  AND leads.id IS NULL