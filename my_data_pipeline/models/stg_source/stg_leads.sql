
{{ config(materialized='table', alias = 'stg_leads' , schema = 'stg_schema'  ) }}

select 
	*

from 

{{ ref('source_leads') }}
