INSERT INTO landuse_muni_1986 
WITH spatial AS (
 SELECT 1986::integer AS yearcode
      , CAST(m.mun_code AS character varying(4)) as muncode
      , CAST(l.lu86 AS integer) as lucode
      , ST_Area(ST_Intersection(m.shape, l.geometry))/43560 as acres
      , (l.is86::numeric(11,8)/100)*(ST_Area(ST_Intersection(m.shape, l.geometry))/43560) as isacres
   FROM landuse1986 l
   JOIN municipalities m ON ST_Intersects(m.shape, l.geometry)
  WHERE ST_GeometryType(l.geometry) IN ('ST_MultiPolygon', 'ST_Polygon')
)
SELECT yearcode, muncode, lucode
     , SUM(acres) as acres
     , SUM(isacres) as isacres
  FROM spatial
 GROUP BY yearcode, muncode, lucode
;

INSERT INTO landuse_muni_1995 
WITH spatial AS (
 SELECT 1995::integer AS yearcode
      , CAST(m.mun_code AS character varying(4)) as muncode
      , CAST(l.lu95 AS integer) as lucode
      , ST_Area(ST_Intersection(m.shape, l.geometry))/43560 as acres
      , (l.is95::numeric(11,8)/100)*(ST_Area(ST_Intersection(m.shape, l.geometry))/43560) as isacres
   FROM landuse1995 l
   JOIN municipalities m ON ST_Intersects(m.shape, l.geometry)
  WHERE ST_GeometryType(l.geometry) IN ('ST_MultiPolygon', 'ST_Polygon')
)
SELECT yearcode, muncode, lucode
     , SUM(acres) as acres
     , SUM(isacres) as isacres
  FROM spatial
 GROUP BY yearcode, muncode, lucode
;

INSERT INTO landuse_muni_2002 
WITH spatial AS (
 SELECT 2002::integer AS yearcode
      , CAST(m.mun_code AS character varying(4)) as muncode
      , CAST(l.lu02 AS integer) as lucode
      , ST_Area(ST_Intersection(m.shape, l.geometry))/43560 as acres
      , (l.is02::numeric(11,8)/100)*(ST_Area(ST_Intersection(m.shape, l.geometry))/43560) as isacres
   FROM landuse2002 l
   JOIN municipalities m ON ST_Intersects(m.shape, l.geometry)
  WHERE ST_GeometryType(l.geometry) IN ('ST_MultiPolygon', 'ST_Polygon')
)
SELECT yearcode, muncode, lucode
     , SUM(acres) as acres
     , SUM(isacres) as isacres
  FROM spatial
 GROUP BY yearcode, muncode, lucode
;

INSERT INTO landuse_muni_2007 
WITH spatial AS (
 SELECT 2007::integer AS yearcode
      , CAST(m.mun_code AS character varying(4)) as muncode
      , CAST(l.lu07 AS integer) as lucode
      , ST_Area(ST_Intersection(m.shape, l.geometry))/43560 as acres
      , (l.is07::numeric(11,8)/100)*(ST_Area(ST_Intersection(m.shape, l.geometry))/43560) as isacres
   FROM landuse2007 l
   JOIN municipalities m ON ST_Intersects(m.shape, l.geometry)
  WHERE ST_GeometryType(l.geometry) IN ('ST_MultiPolygon', 'ST_Polygon')
)
SELECT yearcode, muncode, lucode
     , SUM(acres) as acres
     , SUM(isacres) as isacres
  FROM spatial
 GROUP BY yearcode, muncode, lucode
;

INSERT INTO landuse_muni_2012 
WITH spatial AS (
 SELECT 2012::integer AS yearcode
      , CAST(m.mun_code AS character varying(4)) as muncode
      , CAST(l.lu12 AS integer) as lucode
      , ST_Area(ST_Intersection(m.shape, l.shape))/43560 as acres
      , (l.is12::numeric(11,8)/100)*(ST_Area(ST_Intersection(m.shape, l.shape))/43560) as isacres
   FROM landuse2012 l
   JOIN municipalities m ON ST_Intersects(m.shape, l.shape)
--WHERE ST_GeometryType(l.shape) IN ('ST_MultiPolygon', 'ST_Polygon')
)
SELECT yearcode, muncode, lucode
     , SUM(acres) as acres
     , SUM(isacres) as isacres
  FROM spatial
 GROUP BY yearcode, muncode, lucode
;
