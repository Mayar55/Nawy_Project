SELECT id, created_at, updated_at
FROM "nawy_project_db"."std_schema"."std_leads"
WHERE updated_at < created_at