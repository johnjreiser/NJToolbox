CREATE TABLE landuse_muni (
    yearcode integer NOT NULL,
    muncode character varying(4),
    lucode integer,
    acres numeric(12,2),
    isacres numeric(12,2)
);

CREATE TABLE landuse_muni_1986 (
	CHECK ( yearcode = 1986 ) 
) INHERITS ( landuse_muni );

CREATE TABLE landuse_muni_1995 (
	CHECK ( yearcode = 1995 ) 
) INHERITS ( landuse_muni );

CREATE TABLE landuse_muni_2002 (
	CHECK ( yearcode = 2002 ) 
) INHERITS ( landuse_muni );

CREATE TABLE landuse_muni_2007 (
	CHECK ( yearcode = 2007 ) 
) INHERITS ( landuse_muni );

CREATE TABLE landuse_muni_2012 (
	CHECK ( yearcode = 2012 ) 
) INHERITS ( landuse_muni );

