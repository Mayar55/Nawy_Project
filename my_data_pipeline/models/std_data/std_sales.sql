{{ config(
    materialized = 'table',
    alias = 'std_sales',
    schema = 'std_schema'
) }}

SELECT
    MD5(id::text) AS id,
    id :: bigint AS original_source_id,
    sale_category,
    lead_id :: bigint AS original_lead_id,
    area_id :: bigint AS area_id,
    compound_id :: bigint AS compound_id,
    unit_location,
    property_type_id :: INT AS property_type_id,
    property_type,
    unit_value :: numeric AS unit_value,
    expected_value :: numeric AS expected_value,
    CASE
        WHEN date_of_contraction IS NOT NULL THEN COALESCE(
            actual_value :: numeric,
            unit_value :: numeric
        )
        ELSE actual_value :: numeric END AS actual_value,
        date_of_reservation :: TIMESTAMP AS reservation_date,
        COALESCE(
            reservation_update_date :: TIMESTAMP,
            date_of_contraction :: TIMESTAMP,
            date_of_reservation :: TIMESTAMP
        ) AS reservation_last_update_date,
        date_of_contraction :: TIMESTAMP AS contraction_date,
        years_of_payment :: INT AS years_of_payment
        FROM
            {{ ref('stg_sales') }}
            s
