{{ config(materialized='table', alias = 'dim_lead_type' , schema = 'dwh'  ) }}

    SELECT 
    DISTINCT ON (lead_type_id)
    lead_type_id as lead_type_key,
    lead_type,
    md5(lead_type :: text) as lead_type_id

    FROM {{ref('stg_leads')}} 

    WHERE lead_type IS NOT NULL AND lead_type_id IS NOT NULL 
    