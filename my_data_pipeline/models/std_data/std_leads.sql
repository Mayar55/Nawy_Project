{{ config(
    materialized = 'table',
    alias = 'std_leads',
    schema = 'std_schema'
) }}



    SELECT
        DISTINCT
        ON (
            l.id
        ) MD5(
            l.id :: text
        ) AS id,
        id :: bigint AS original_source_id,
        COALESCE(
            buyer,
            FALSE
        ) :: BOOLEAN AS is_buyer,
        COALESCE(
            seller,
            FALSE
        ) :: BOOLEAN AS is_seller,
        best_time_to_call AS best_time_to_call,
        budget :: numeric AS budget,
        created_at :: TIMESTAMP AS created_at,
        updated_at :: TIMESTAMP AS updated_at,
        user_id :: bigint AS user_id,
        LOWER(TRIM(location)) AS prefered_location,
        date_of_last_contact :: TIMESTAMP AS last_contact_date,
        TRIM(LOWER(status_name)) AS status_name,
        COALESCE(
            commercial :: BOOLEAN,
            FALSE
        ) AS is_commercial,
        COALESCE(
            merged :: BOOLEAN,
            FALSE
        ) AS is_merged,
        area_id :: bigint AS area_id,
        compound_id :: bigint AS compound_id,
        developer_id :: bigint AS developer_id,
        CASE
            WHEN meeting_flag >= 1 THEN 1
            ELSE 0
        END :: BOOLEAN AS meeting_flag,
        do_not_call :: BOOLEAN AS do_not_call,
        lead_type_id :: INT AS lead_type_id,
        customer_id :: INT AS customer_id,
        method_of_contact,
        lead_source,
        CASE
            WHEN campaign IS NULL
            OR LOWER(TRIM(campaign)) IN (
                '',
                '1.20e+17',
                '#name?',
                '(none)',
                'none',
                'null',
                'n/a'
            ) THEN NULL
            ELSE TRIM(
                REGEXP_REPLACE(
                    REPLACE(REPLACE(LOWER(TRIM(campaign)), '_', ' '), '+', ' '),
                    '[[:space:]]+',
                    ' ',
                    'g')
                )
            END AS campaign,
            lead_type
            FROM
                {{ ref('stg_leads') }} as l
 