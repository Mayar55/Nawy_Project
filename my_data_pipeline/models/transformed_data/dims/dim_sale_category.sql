{{ config(materialized='table', alias = 'dim_sale_category' , schema = 'dwh'  ) }}

    SELECT DISTINCT ON (sale_category)
    sale_category AS category ,
    md5(sale_category) AS category_id
     
    FROM {{ref('stg_sales')}} 
    WHERE sale_category IS NOT NULL 
