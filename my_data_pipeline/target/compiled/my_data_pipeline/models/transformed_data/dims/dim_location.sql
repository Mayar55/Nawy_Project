

WITH loca AS (

    SELECT
        area_id,
        compound_id,
        MD5(COALESCE(area_id :: text, '') || COALESCE(compound_id :: text, '')) AS location_id,
        unit_location AS location
    FROM
        "nawy_project_db"."stg_schema"."stg_sales"
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