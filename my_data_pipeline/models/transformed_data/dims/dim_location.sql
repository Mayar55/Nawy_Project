{{ config(
    materialized = 'table',
    alias = 'dim_location',
    schema = 'dwh',
    post_hook = ["alter table {{ this }} add primary key (location_id)" ]
) }}

WITH loca AS (

    SELECT
        area_id,
        compound_id,
        MD5(COALESCE(area_id :: text, '') || COALESCE(compound_id :: text, '')) AS location_id,
        unit_location AS location
    FROM
        {{ ref('stg_sales') }}
    WHERE
        area_id IS NOT NULL
        OR compound_id IS NOT NULL
)
SELECT
    DISTINCT
    ON (location_id) area_id,
    compound_id,
    location_id,
    location
FROM
    loca
