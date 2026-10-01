with distinct_campaigns as
( 
    SELECT DISTINCT campaign  
    FROM "nawy_project_db"."dwh"."fact_leads"
    WHERE campaign IS NOT NULL

)
,
 cleaning_campaign_name AS
(
    SELECT 
    campaign as original_source_campaign,
    TRIM(REPLACE(
    REPLACE(
        REPLACE(
            LOWER(campaign), -- First, make the whole string lowercase
            '_', ''
        ),
        '+', ''
    ),
    '.', ''))AS cleaned_campaign
 
 FROM distinct_campaigns

 ),
 final AS
 (



SELECT DISTINCT ON(cleaned_campaign)original_source_campaign,cleaned_campaign,

    REGEXP_SUBSTR(
            cleaned_campaign,
            '(cooing [0-9]+|gaa[1-9]|nawy)', 
            1, 1, 'i'
        ) AS tag,



(
    CASE
            WHEN 
                LOWER(original_source_campaign) LIKE 'dev - %' OR 
                LOWER(original_source_campaign) LIKE 'dev_-_%' OR 
                LOWER(original_source_campaign) LIKE 'discover_-_dev_-_%'
           
           
            THEN 
                
            SPLIT_PART(
                SPLIT_PART(
                    SPLIT_PART(
                        REPLACE(
                            REPLACE(
                                REPLACE(
                                    REPLACE(
                                        REGEXP_SUBSTR(
                                            LOWER(TRIM(original_source_campaign)),
                                            '(?:dev_-_|dev - |discover_-_dev_-_)(.*?)(?:_-_| - |$)',
                                            1,
                                            1,
                                            'i'
                                        ),
                                        'discover_-_dev-_',
                                        ''
                                    ),
                                    'dev_-_',
                                    ''
                                ),
                                'dev-',
                                ''
                            ),
                            'discover_-_',
                            ''
                        ),
                        '_-_',
                        1
                    ),
                    '_vbb',
                    1
                ),
                '_ar',
                1
            )
        

                WHEN 
                original_source_campaign LIKE '% -%- %' OR
                original_source_campaign LIKE '%--%--%'
            THEN

                SPLIT_PART(REPLACE(original_source_campaign, '--', ' - '), ' - ', 1)

    END
)


    AS developer_name



    FROM cleaning_campaign_name
 )
 SELECT 
 md5(cleaned_campaign) AS campaign_id,
 tag,
 TRIM(
     REGEXP_REPLACE(
        developer_name,
        '[^a-z ]',   
                ' ',
        'g'
    )
     )
    as developer

 FROM final