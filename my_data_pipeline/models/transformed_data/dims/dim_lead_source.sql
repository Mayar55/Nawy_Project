{{ config(
    materialized = 'table',
    alias = 'dim_lead_source',
    schema = 'dwh'
) }}

SELECT
    DISTINCT
    ON (
        lead_source
    ) lead_source,
    md5(lead_source) AS lead_source_id
FROM
    {{ ref('stg_leads') }}
WHERE
    lead_source IS NOT NULL
