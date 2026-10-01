
    
    

select
    id as unique_field,
    count(*) as n_records

from "nawy_project_db"."dwh"."fact_leads"
where id is not null
group by id
having count(*) > 1


