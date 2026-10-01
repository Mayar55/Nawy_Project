SELECT id, campaign_standardized
FROM {{ ref('fact_leads') }}
WHERE LOWER(TRIM(campaign_standardized)) = '(none)'