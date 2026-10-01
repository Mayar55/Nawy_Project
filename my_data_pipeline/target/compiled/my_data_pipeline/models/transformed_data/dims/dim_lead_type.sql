

    SELECT 
    DISTINCT ON (lead_type_id)
    lead_type_id as lead_type_key,
    lead_type,
    md5(lead_type :: text) as lead_type_id

    FROM "nawy_project_db"."stg_schema"."stg_leads" 

    WHERE lead_type IS NOT NULL AND lead_type_id IS NOT NULL