SELECT id, created_at, updated_at
FROM {{ ref('std_leads') }}
WHERE updated_at < created_at