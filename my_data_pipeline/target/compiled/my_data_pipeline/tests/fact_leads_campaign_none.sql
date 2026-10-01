SELECT id, campaign_standardized
FROM "nawy_project_db"."dwh"."fact_leads"
WHERE LOWER(TRIM(campaign_standardized)) = '(none)'