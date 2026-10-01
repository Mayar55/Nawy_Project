
{{ config(materialized='table', alias = 'stg_sales' , schema = 'stg_schema'  ) }}

select 
*
from 

{{ ref('source_sales') }}
