select count(id) , id from data_source.source_leads
group by id order by 1 desc;

select *  from data_source.source_leads where id = 214418
select * from data_source.source_sales where lead_id = 214418


select count(id) , id from data_source.source_sales
group by id order by 1 desc;



select l.compound_id , s.compound_id ,l.area_id , s.area_id  from "data_source"."source_leads" l join "data_source"."source_sales" s on l.id = s.lead_id
where l.compound_id is not null or l.area_id is not null 