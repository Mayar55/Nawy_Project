SELECT id, 'is_seller' AS column_name
FROM {{ ref('fact_leads') }}
WHERE is_seller IS NULL

UNION ALL

SELECT id, 'is_buyer' AS column_name
FROM {{ ref('fact_leads') }}
WHERE is_buyer IS NULL