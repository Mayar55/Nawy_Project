SELECT sales.id, 'updated_reservation_date_id' AS column_name
FROM "nawy_project_db"."dwh"."fact_sales" AS sales
WHERE sales.updated_reservation_date_id IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM "nawy_project_db"."dwh"."dim_date" AS dates
      WHERE dates.date_id = sales.updated_reservation_date_id
  )

UNION ALL

SELECT sales.id, 'contraction_date_id' AS column_name
FROM "nawy_project_db"."dwh"."fact_sales" AS sales
WHERE sales.contraction_date_id IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM "nawy_project_db"."dwh"."dim_date" AS dates
      WHERE dates.date_id = sales.contraction_date_id
  )