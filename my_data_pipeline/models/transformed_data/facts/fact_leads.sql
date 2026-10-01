{{ config(
    materialized = 'table',
    alias = 'fact_leads',
    schema = 'dwh',
    post_hook = ["alter table {{ this }} add primary key (id)" ]
) }}


    SELECT
        l.id,
        l.is_seller,
        l.is_buyer,
        l.best_time_to_call,
        l.status_name,
        l.customer_id,
        l.budget,
        l.original_source_id,
        lead_type.lead_type_id,
        src.lead_source_id,
        methods.contact_method_id,
        d1.date_id AS created_at_id,
        d2.date_id AS updated_at_id,
        d3.date_id AS date_of_last_contact_id,
        camp.campaign_id,
        {# loc.location_id #}
    FROM
        {{ ref('std_leads') }} l
        LEFT JOIN {{ ref('dim_lead_type') }}
        lead_type
        ON MD5(
            l.lead_type_id :: text
        ) = lead_type.lead_type_id
        LEFT JOIN {{ ref('dim_contact_method') }}
        methods
        ON MD5(
            l.method_of_contact
        ) = methods.contact_method_id
        LEFT JOIN {{ ref('dim_lead_source') }}
        src
        ON MD5(
            l.lead_source
        ) = src.lead_source_id
        LEFT JOIN {{ ref('dim_date') }}
        d1
        ON MD5(
            l.created_at :: text
        ) = d1.date_id
        LEFT JOIN {{ ref('dim_date') }}
        d2
        ON MD5(
            l.updated_at :: text
        ) = d2.date_id
        LEFT JOIN {{ ref('dim_date') }}
        d3
        ON MD5(
            l.last_contact_date :: text
        ) = d3.date_id
        LEFT JOIN {{ ref('dim_campaign') }}
        camp
        ON MD5(
            l.campaign
        ) = camp.campaign_id
        LEFT JOIN LATERAL (
            SELECT
        
                s.location_id
            
            FROM
                {{ ref('fact_sales') }} s
            WHERE
                s.lead_id = l.id
            ORDER BY
                s.id
            LIMIT 1
        ) loc ON TRUE
  