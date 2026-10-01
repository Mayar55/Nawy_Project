
  
    

  create  table "nawy_project_db"."dwh"."dim_contact_method__dbt_tmp"
  
  
    as
  
  (
    

SELECT
    DISTINCT
    ON (
        method_of_contact
    ) method_of_contact AS contact_method,
    md5(method_of_contact) AS contact_method_id
FROM
    "nawy_project_db"."stg_schema"."stg_leads"
WHERE
    method_of_contact IS NOT NULL
  );
  