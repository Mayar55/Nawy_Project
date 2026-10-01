{{ config(
    materialized = 'table',
    alias = 'dim_contact_method',
    schema = 'dwh'
) }}

SELECT
    DISTINCT
    ON (
        method_of_contact
    ) method_of_contact AS contact_method,
    md5(method_of_contact) AS contact_method_id
FROM
    {{ ref('stg_leads') }}
WHERE
    method_of_contact IS NOT NULL
