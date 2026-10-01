

SELECT
    DISTINCT
    ON (
        lead_source
    ) lead_source,
    md5(lead_source) AS lead_source_id
FROM
    "nawy_project_db"."stg_schema"."stg_leads"
WHERE
    lead_source IS NOT NULL