
    
    

with child as (
    select original_source_id as from_field
    from "nawy_project_db"."dwh"."fact_leads"
    where original_source_id is not null
),

parent as (
    select original_source_id as to_field
    from "nawy_project_db"."dwh"."std_leads"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


