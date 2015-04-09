# Land Use

Tools for working with the New Jersey Land Use/Land Cover data.

## Dashboard

Working with the 2012 (and prior years) data enabled the creation of a [land use change dashboard](https://public.tableau.com/profile/john.reiser#!/vizhome/NewJerseyLandUse1986-2012/LandUseStory).

[https://public.tableau.com/profile/john.reiser#!/vizhome/NewJerseyLandUse1986-2012/LandUseStory](https://public.tableau.com/profile/john.reiser#!/vizhome/NewJerseyLandUse1986-2012/LandUseStory)

Information on how to use Tableau to create dashboards like this will be available on [my blog](http://njgeo.org/).

## Sources

* [NJ DEP Bureau of GIS - 2012 Land Use/Land Cover Update](http://www.nj.gov/dep/gis/lulc12.html)
* [Rowan University: Changing Landscapes in the Garden State](http://gis.rowan.edu/projects/luc/)
* [Rutgers University: Landscape Change Research](http://crssa.rutgers.edu/projects/lc/)
* [Anderson Land Use Classification System](http://landcover.usgs.gov/pdf/anderson.pdf) (PDF)
* [NJ DEP Modified Anderson System](http://www.state.nj.us/dep/gis/digidownload/metadata/lulc02/anderson2002.html) 

## Process

### Load ESRI data into PostGIS

If you have ArcGIS handy, you could use it to load the DEP-sourced shapefiles or geodatabases into PostgreSQL for further analysis.

If you want to work with this data and do not have ArcGIS available to you, do not despair!

`landuse_load_ogr.txt` has instructions on how to load the shapefile-formatted data from DEP into a PostGIS-enabled database. If you are on a Mac using the Homebrew version of GDAL/OGR, you could download all the shapefiles, change `landuse_load_ogr.txt` to `landuse_load_ogr.sh` and run it in the same directory as your shapefiles.

One of the shapefiles has an OID field that restarts at 1 (while the others are sequential) which results in a conflict when you try to append the files to the same database table. Refer to `merge_landuse2012.sql` for an INSERT INTO statement to append the conflicting data into the same table. 

### Calculate Municipal Level Statistics 

Once you have the 2012, 2007, 2002, 1995, and 1986 Land Use data loaded into the same database, you can now crunch municipal level statistics using PostGIS!

Load `table_schema.sql` into your database to create a master "landuse_muni" table and 5 child tables that inherit its schema. We will load the statistics for each of the 5 time periods into its respective child table. 

Next, process each land use table against a "municipalities" table you have loaded into the database. You can use the municipalities shapefile available on the NJGIN download page.

For reference, here is the statement that calculates municipal statistics on the 2012 Land Use:
```
INSERT INTO landuse_muni_2012
WITH spatial AS (
 SELECT 2012::integer AS yearcode                           -- hardcoded year value
      , CAST(m.mun_code AS character varying(4)) as muncode -- four digit mun code, as text
      , CAST(l.lu12 AS integer) as lucode                   -- four digit Anderson classification, as int 
      , ST_Area(ST_Intersection(m.shape, l.shape))/43560 as acres 
      , (l.is12::numeric(11,8)/100)*(ST_Area(ST_Intersection(m.shape, l.shape))/43560) as isacres
      -- impervious surface calculated using the percent impervious column, applied to the new geometry size
   FROM landuse2012 l
   JOIN municipalities m ON ST_Intersects(m.shape, l.shape)
)
-- roll up the values on year, municipality, and land use code
SELECT yearcode, muncode, lucode
     , SUM(acres) as acres
     , SUM(isacres) as isacres
  FROM spatial
 GROUP BY yearcode, muncode, lucode
;
```

Once run for each time period, with the results in the respective child table, the `landuse_muni` table can then be queried for any combination of year, municipality or land use code. 

### Crosswalk Table

Each LU data set has a different number of land use codes. Not every code is present in every dataset. For your ease in having the land use data values consistent across time periods, load the `lucrosswalk.csv` file into your database. It has every 4 digit Anderson code present in the 5 time periods, along with the description of the code and the top-level Anderson type ("URBAN", "WETLANDS", "FOREST", etc.)

### View for Export into Tableau

The following view definition (stored in `view_def.sql`) pulls the statistics together, calculating percentage fields for each municipality. The results can then be exported as a CSV (an export present in this repository as `landuse.csv`) for use in a visualization tool like Tableau. 

```
CREATE OR REPLACE VIEW landuse_export AS
SELECT a.yearcode, a.muncode, m.mun, m.county
     , a.lucode, l.ludesc, l.lutype
     , a.acres, a.isacres
     , (a.acres/(ST_Area(m.shape)/43560))::numeric(10,7) as pc_area
     , (a.isacres/(ST_Area(m.shape)/43560))::numeric(10,7) as pc_isarea
  FROM landuse_muni a
  LEFT JOIN lucrosswalk l ON a.lucode = l.lucode
  LEFT JOIN municipalities m ON a.muncode = m.mun_code
;
```

The results of this process can be viewed as a [Tableau dashboard](https://public.tableau.com/profile/john.reiser#!/vizhome/NewJerseyLandUse1986-2012/LandUseStory).

