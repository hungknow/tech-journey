/*
cursor can be anything
- Group of columns: date + id
- Single column: id

cursor = (last_date, last_id)

select * from pagination_data 
where (date, id) > (last_date, last_id) 
order by date, id 
limit [page_size];
*/