{{ config(
    materialized = 'table',
    alias = 'dim_campaign',
    schema = 'dwh'
) }}

WITH cleaned_campaigns AS (

    SELECT
        campaign,
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
            END AS campaign_standardized
            FROM
                {{ ref('stg_leads') }}
        ),
        campaigns AS (
            SELECT
                campaign_standardized,
                MIN(TRIM(campaign)) AS source_campaign
            FROM
                cleaned_campaigns
            WHERE
                campaign_standardized IS NOT NULL
            GROUP BY
                campaign_standardized)
            SELECT
                MD5(campaign_standardized) AS campaign_id,
                campaign_standardized,
                source_campaign,
                CASE
                    WHEN campaign_standardized ~ 'cooing [0-9]+' THEN SUBSTRING(
                        campaign_standardized
                        FROM
                            '(cooing [0-9]+)'
                    )
                    WHEN campaign_standardized ILIKE 'dev -%' THEN 'developer'
                    ELSE 'nawy'
                END AS campaign_maker,
                CASE
                    WHEN campaign_standardized ILIKE '%lead%' THEN 'lead generation'
                    WHEN campaign_standardized ILIKE '%remarketing%' THEN 'remarketing'
                    WHEN campaign_standardized ILIKE '%financing%' THEN 'financing'
                    WHEN campaign_standardized ILIKE '%hiring%' THEN 'hiring'
                    WHEN campaign_standardized ILIKE '%branding%' THEN 'branding'
                    WHEN campaign_standardized ILIKE '%traffic%' THEN 'traffic'
                    WHEN campaign_standardized ILIKE '%a/b test%' THEN 'a/b testing'
                    WHEN campaign_standardized ILIKE '%pmax%' THEN 'pmax'
                    WHEN campaign_standardized ILIKE '%brand%' THEN 'branding'
                    WHEN campaign_standardized ILIKE 'dev -%' THEN 'developer campaign'
                    WHEN campaign_standardized ILIKE '%dynamic target%' THEN 'dynamic targeting'
                    ELSE 'other'
                END AS campaign_type
            FROM
                campaigns
