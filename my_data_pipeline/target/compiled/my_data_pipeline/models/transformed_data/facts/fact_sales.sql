


SELECT
    DISTINCT
    ON (
    s.id
    ) s.id,
    l.id AS lead_id,
    dim_lead_typ.lead_type_id,
    prop_typ.property_type_id,
    C.category_id AS sale_category_id,
    camp.campaign_id,
    loc.location_id,
    s.unit_value,
    s.expected_value,
    s.actual_value,
    resdate.date_id AS updated_reservation_date_id,
    contrdate.date_id AS contraction_date_id,
    s.years_of_payment
FROM
    "nawy_project_db"."std_schema"."std_sales" s
    JOIN "nawy_project_db"."std_schema"."std_leads"
    l
    ON s.original_lead_id = l.original_source_id
    LEFT JOIN "nawy_project_db"."dwh"."dim_sale_category" C
    ON MD5(sale_category) = C.category_id
    LEFT JOIN "nawy_project_db"."dwh"."dim_property_type"
    prop_typ
    ON MD5(
        s.property_type_id :: text
    ) = prop_typ.property_type_id
    LEFT JOIN "nawy_project_db"."dwh"."dim_lead_type"
    dim_lead_typ
    ON MD5(
        l.lead_type_id :: text
    ) = dim_lead_typ.lead_type_id
    LEFT JOIN "nawy_project_db"."dwh"."dim_campaign"
    camp
    ON MD5(
        l.campaign
    ) = camp.campaign_id
    LEFT JOIN "nawy_project_db"."dwh"."dim_date"
    resdate
    ON MD5(
        GREATEST(
            s.reservation_date :: text,
            s.reservation_last_update_date :: text
        )
    ) = resdate.date_id
    LEFT JOIN "nawy_project_db"."dwh"."dim_date"
    contrdate
    ON MD5(
        s.contraction_date :: text
    ) = contrdate.date_id
    LEFT JOIN "nawy_project_db"."dwh"."dim_location"
    loc
    ON MD5(COALESCE(s.area_id :: text, '') || COALESCE(s.compound_id :: text, '')) = loc.location_id