
  
    

  create  table "nawy_project_db"."stg_schema"."stg_leads__dbt_tmp"
  
  
    as
  
  (
    

select 
	*

from 

"nawy_project_db"."data_source"."source_leads"
  );
  