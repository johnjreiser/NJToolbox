-- Creates a table view that can be brought into Tableau for further exploration.

DROP VIEW IF EXISTS landuse_export;
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
