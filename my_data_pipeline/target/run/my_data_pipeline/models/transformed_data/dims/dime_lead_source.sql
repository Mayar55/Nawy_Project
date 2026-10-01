
  
    

  create  table "nawy_project_db"."dwh"."dim_lead_source__dbt_tmp"
  
  
    as
  
  (
    

    SELECT DISTINCT ON (lead_source )

    lead_source ,
    md5(cast(coalesce(cast(lead_source as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as lead_source_id

    FROM "nawy_project_db"."stg_schema"."stg_leads"

    WHERE
     lead_source IS NOT NULL
  );
  