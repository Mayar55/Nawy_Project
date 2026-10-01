
  
    

  create  table "nawy_project_db"."stg_schema"."stg_sales__dbt_tmp"
  
  
    as
  
  (
    

select 
*
from 

"nawy_project_db"."data_source"."source_sales"
  );
  