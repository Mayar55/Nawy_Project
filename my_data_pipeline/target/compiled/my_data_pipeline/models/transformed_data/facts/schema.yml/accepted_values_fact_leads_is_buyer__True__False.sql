
    
    

with all_values as (

    select
        is_buyer as value_field,
        count(*) as n_records

    from "nawy_project_db"."dwh"."fact_leads"
    group by is_buyer

)

select *
from all_values
where value_field not in (
    'True','False'
)


