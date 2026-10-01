{{ config(materialized='table', alias = 'dim_property_type' , schema = 'dwh'  ) }}

    SELECT DISTINCT ON (property_type_id )

    property_type_id AS property_type_key,  
    property_type,
   md5(property_type_id :: text) as property_type_id
    



    FROM {{ref('stg_sales')}}

    WHERE
     property_type_id IS NOT NULL
     AND
     property_type IS NOT NULL



