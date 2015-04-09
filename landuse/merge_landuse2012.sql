-- In case you need to bring two tables together... 

/*
with tbl as (
  select oid from pg_catalog.pg_class where relname = 'landuse2012'
)
select attname 
from pg_catalog.pg_attribute 
join tbl on oid = attrelid
where attstattarget = -1;
*/

INSERT INTO landuse2012 (shape, acres, lu12, label12, type12, is12, isacres12, dv12, nhd_fcode, fcode_desc, lu07, label07, type07, is07, isacres07, dv07, fcode07, change12, ischange12, hu8, status, approved, nhd_ftype, ftype_desc, shape_leng, shape_area )
SELECT shape, acres, lu12, label12, type12, is12, isacres12, dv12, nhd_fcode, fcode_desc, lu07, label07, type07, is07, isacres07, dv07, fcode07, change12, ischange12, hu8, status, approved, nhd_ftype, ftype_desc, shape_leng, shape_area
FROM tmp02030105;
