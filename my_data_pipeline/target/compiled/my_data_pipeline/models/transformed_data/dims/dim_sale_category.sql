

    SELECT DISTINCT ON (sale_category)
    sale_category AS category ,
    md5(sale_category) AS category_id
     
    FROM "nawy_project_db"."stg_schema"."stg_sales" 
    WHERE sale_category IS NOT NULL