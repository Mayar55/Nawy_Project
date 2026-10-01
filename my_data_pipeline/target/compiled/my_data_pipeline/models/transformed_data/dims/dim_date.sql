--  Sales


-- Leads





WITH all_dates AS (

    SELECT date_of_reservation AS date_value
    FROM "nawy_project_db"."stg_schema"."stg_sales"
    WHERE date_of_reservation IS NOT NULL

    UNION

    SELECT reservation_update_date AS date_value
    FROM "nawy_project_db"."stg_schema"."stg_sales"
    WHERE reservation_update_date IS NOT NULL

    UNION

    SELECT date_of_contraction AS date_value
    FROM "nawy_project_db"."stg_schema"."stg_sales"
    WHERE date_of_contraction IS NOT NULL

    UNION

    SELECT date_of_last_request AS date_value
    FROM "nawy_project_db"."stg_schema"."stg_leads"
    WHERE date_of_last_request IS NOT NULL

    UNION

    SELECT created_at AS date_value
    FROM "nawy_project_db"."stg_schema"."stg_leads"
    WHERE created_at IS NOT NULL

    UNION

    SELECT updated_at AS date_value
    FROM "nawy_project_db"."stg_schema"."stg_leads"
    WHERE updated_at IS NOT NULL

    UNION

    SELECT date_of_last_contact AS date_value
    FROM "nawy_project_db"."stg_schema"."stg_leads"
    WHERE date_of_last_contact IS NOT NULL
),

dates AS (

    SELECT DISTINCT
        date_value::date AS full_date
    FROM all_dates
)

SELECT
    md5(full_date :: text) AS date_id,
    -- Actual date
    full_date,

    -- Year
    EXTRACT(YEAR FROM full_date)::INTEGER AS year,

    -- Quarter
    EXTRACT(QUARTER FROM full_date)::INTEGER AS quarter,

    -- Month (numeric)
    EXTRACT(MONTH FROM full_date)::INTEGER AS month,
    -- Month (name)
    TO_CHAR(full_date, 'Month') AS month_name,

    -- Day 
    EXTRACT(DAY FROM full_date)::INTEGER AS day_of_month,

    TO_CHAR(full_date, 'Day') AS day_name


FROM dates
ORDER BY full_date