SELECT id, cnt, chk, ein, eout, the_geom
	FROM public.da_nang_explode_vertices_pgr;
	
select * from pgr_dijkstra('SELECT id_1 as id, source, target, st_length(the_geom) as cost FROM public.da_nang_explode',
402, 598, false, false
);

SELECT id_1 as id, source, target, st_length(the_geom) as cost FROM public.da_nang_explode

SELECT seq, id1 AS node, id2 AS edge, cost, the_geom
FROM pgr_dijkstra(
'SELECT id_1 as id, source, target, st_length(the_geom) as cost FROM public.da_nang_explode',
1, 3000, false, false
) as di
JOIN public.da_nang_explode pt
ON di.id2 = pt.id_1;

alter table public.da_nang_explode add column source integer;
alter table public.da_nang_explode add column target integer;

alter table public.da_nang_explode drop column source;
alter table public.da_nang_explode drop column target;

select pgr_createTopology('public.da_nang_explode', 0.0001, 'the_geom', 'id_1');


// shortest
select seq, id, the_geom, name, now
from (
    select seq, lag(node) over (order by seq) as bef,
           node as now
    from pgr_dijkstra('select id_0 as id, source, target, st_length(the_geom) as cost, (CASE WHEN directed THEN -1 ELSE st_length(the_geom) END) as reverse_cost from bk_road',%a%,%b%,true) as di
) t
JOIN public.bk_road e
ON ((now = e.source and bef = e.target) or (bef = e.source and now = e.target) or (now  = e.source and now = e.target))

// danang_nearest
SELECT v.id, v.the_geom, string_agg(distinct(e.name),',') AS name
FROM bk_road_vertices_pgr AS v,	bk_road AS e
WHERE v.id = (SELECT id FROM bk_road_vertices_pgr ORDER BY the_geom <-> ST_SetSRID(ST_MakePoint(%x%,%y%), 4326) LIMIT 1)
  AND (e.source = v.id OR e.target = v.id)
GROUP BY v.id, v.the_geom


SELECT id_1, the_geom, id, name, oneway
	FROM public.da_nang_explode_01;
	
ALTER TABLE public.da_nang_explode_01 RENAME COLUMN id_0 to id;

ALTER TABLE public.da_nang_explode_01 DROP COLUMN bicycle,
DROP COLUMN horse,
DROP COLUMN tracktype,
DROP COLUMN incline,
DROP COLUMN sac_scale,
DROP COLUMN trail_visi,
DROP COLUMN width,
DROP COLUMN noexit,
DROP COLUMN note,
DROP COLUMN footway,
DROP COLUMN tunnel,
DROP COLUMN "3dmr",
DROP COLUMN lit,
DROP COLUMN comment,
DROP COLUMN wheelchair,
DROP COLUMN source_wid,
DROP COLUMN turn_lanes,
DROP COLUMN name_de,
DROP COLUMN destinatio,
DROP COLUMN landuse,
DROP COLUMN roundabout,
DROP COLUMN destinat_1,
DROP COLUMN ford,
DROP COLUMN embankment,
DROP COLUMN survey,
DROP COLUMN constructi,
DROP COLUMN check_date,
DROP COLUMN basin,
DROP COLUMN narrow,
DROP COLUMN level,
DROP COLUMN int_name,
DROP COLUMN area,
DROP COLUMN covered,
DROP COLUMN parking_la,
DROP COLUMN crossing,
DROP COLUMN postal_cod,
DROP COLUMN colour,
DROP COLUMN start_date,
DROP COLUMN tourism,
DROP COLUMN material,
DROP COLUMN descriptio,
DROP COLUMN sport,
DROP COLUMN waterway,
DROP COLUMN step_count;

alter table public.da_nang_exploded drop column source;
alter table public.da_nang_exploded add column source integer;
alter table public.da_nang_exploded add column target integer;
alter table public.da_nang_exploded add column directed boolean;

SELECT id_1, the_geom, id, name, oneway, source, target, directed
	FROM public.da_nang_exploded;
	
select pgr_createTopology('public.da_nang_exploded', 0.0001, 'the_geom', 'id_1');

SELECT seq, id1 AS node, id2 AS edge, cost, the_geom
FROM pgr_dijkstra(
'SELECT id_1 as id, source, target, st_length(the_geom) as cost FROM public.da_nang_explode_01',
1, 3000, false, false
) as di
JOIN public.da_nang_explode_01 pt
ON di.id2 = pt.id_1;

SELECT id, the_geom, id_0, name, oneway, directed, source, target
FROM public.da_nang_explode_01
where id = 2655

UPDATE public.da_nang_explode_01
	SET directed=true 
	WHERE id > 2644 and id < 2666

SELECT seq, id1 AS node, id2 AS edge, cost, the_geom
FROM pgr_dijkstra(
'SELECT id, source, target, st_length(the_geom) as cost, (CASE WHEN directed THEN -1 ELSE st_length(the_geom) END) as reverse_cost FROM public.da_nang_explode_01',
2791, 2788, true
) as di
JOIN public.da_nang_explode_01 pt
ON di.edge = pt.id;

SELECT seq, node, edge, cost, the_geom
FROM pgr_dijkstra(
'SELECT id, source, target, st_length(the_geom) as cost, (CASE WHEN directed THEN -1 ELSE st_length(the_geom) END) as reverse_cost FROM public.da_nang_explode_01',
2791, 2788, true
) as di
JOIN public.da_nang_explode_01 pt
ON di.edge = pt.id;

SELECT id, the_geom, id_0, name, oneway, directed, source, target
FROM public.da_nang_explode_01
where id = 2655

SELECT id, cnt, chk, ein, eout, the_geom
	FROM public.da_nang_explode_01_vertices_pgr;

alter table public.da_nang_explode_01_vertices_pgr add column level_water integer;
alter table public.da_nang_explode_01_vertices_pgr add column max_level integer;
alter table public.da_nang_explode_01_vertices_pgr add column time_update date;
alter table public.da_nang_explode_01_vertices_pgr add column time_update TIMESTAMP;
-- alter table public.da_nang_explode_01 add column highway CHARACTER(14);

CREATE OR REPLACE FUNCTION pgr_update_water_level(
IN _level integer, IN _id integer,
OUT id integer, OUT the_geom geometry, OUT water_level integer, OUT max_level integer)
RETURNS SETOF record AS
$BODY$
DECLARE
rec record;
sql text;

BEGIN
-- Update
EXECUTE 'update supham_split_vertices_pgr set water_level = ' || _level || ' where id = ' || _id ||'';
-- Update
sql := 'SELECT id, the_geom, water_level, max_level FROM supham_split_vertices_pgr where id = ' || _id ||'';
FOR rec IN EXECUTE sql
LOOP
    -- Return record
    id := rec.id;
    the_geom := rec.the_geom;
    water_level := rec.water_level;
    max_level := rec.max_level;
    RETURN NEXT;
END LOOP;

RETURN;
END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE STRICT;



CREATE OR REPLACE FUNCTION pgr_update_water_level(
IN _id integer, IN _level integer,
OUT id integer, OUT the_geom geometry, OUT level_water integer, OUT max_level integer)
RETURNS SETOF record AS
$BODY$
DECLARE
rec record;
sql text;

BEGIN
-- Update
EXECUTE 'update da_nang_explode_01_vertices_pgr set time_update = NOW(), level_water = ' || _level || '  where id = ' || _id ||'';
-- Update
sql := 'SELECT id, the_geom, level_water, max_level FROM da_nang_explode_01_vertices_pgr where id = ' || _id ||'';
FOR rec IN EXECUTE sql
LOOP
    -- Return record
    id := rec.id;
    the_geom := rec.the_geom;
    level_water := rec.level_water;
    max_level := rec.max_level;
    RETURN NEXT;
END LOOP;

RETURN;
END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE STRICT;

 steps *
 trunk *
 trunk_link *
 road *
 cycleway *
 footway *
 secondary *
 secondary_link * 
 tertiary * 
 tertiary_link * 
 construction * 
 living_street *
 pedestrian *
 primary *
 primary_link *
 residential *
 track *
 motorway_link
 motorway *
 service *
 unclassified *
 path

SELECT id_1, id_0, id, _id, the_geom, highway, name, oneway, directed
	FROM public.da_nang_exploded WHERE junction like 'roundabout';


select seq, id, the_geom, name, now
from (
    select seq, lag(node) over (order by seq) as bef,
           node as now
    from pgr_dijkstra('select id_0 as id, source, target, st_length(the_geom) as cost, (CASE WHEN directed THEN -1 ELSE st_length(the_geom) END) as reverse_cost from da_nang_exploded',1,3000,true) as di
) t
JOIN public.da_nang_exploded e
ON ((now = e.source and bef = e.target) or (bef = e.source and now = e.target) or (now  = e.source and now = e.target))

alter table public.da_nang_point drop column "name:ar",
DROP COLUMN "name:cs",
DROP COLUMN "name:en",
DROP COLUMN "name:he",
DROP COLUMN "name:ja",
DROP COLUMN "name:ka",
DROP COLUMN "name:ko",
DROP COLUMN "name:lt",
DROP COLUMN "name:mn",
DROP COLUMN "name:ms",
DROP COLUMN "name:ne",
DROP COLUMN "name:nl",
DROP COLUMN "name:no"; 
alter table public.da_nang_point
DROP COLUMN "name:de",
DROP COLUMN "name:pt",
DROP COLUMN "name:ru",
DROP COLUMN "name:sr",
DROP COLUMN "name:sv",
DROP COLUMN "name:th",
DROP COLUMN "name:ua",
DROP COLUMN "name:uk",
DROP COLUMN "name:ur",
DROP COLUMN "name:zh";

-- SELECT id_0, id, geom, name, place, amenity, "addr:city", "addr:district", "addr:housenumber", "addr:street", phone, operator, "addr:subdistrict", fixme, mountain_pass, tourism, "addr:province", email, shop, website, atm, cuisine, alt_name, "natural", opening_hours, leisure, waterway, note, stars, office, highway, "addr:full", toilets
--  FROM public.da_nang_point order by id_0; 

-- SELECT pp.id_0, pp.id, pp.geom, pp.name, plg.name_2
--  FROM public.da_nang_point pp, public.gadm36_vnm_2 plg where gid_1 like 'VNM.19%' and ST_Contains(plg.geom, pp.geom);
    
 -- SELECT pp.id_0, pp.id, pp.geom, pp.name, plg2.name_2, plg.name_3
 -- FROM public.da_nang_point pp, public.gadm36_vnm_3 plg, public.gadm36_vnm_2 plg2
 -- where plg.gid_1 like 'VNM.19%'
 -- and plg2.gid_1 like 'VNM.19%'
 -- and ST_Contains(plg.geom, pp.geom)
 -- and ST_Contains(plg2.geom, pp.geom);

-- update public.da_nang_point set "addr:city"='Đà Nẵng'

SELECT
    pp.id_0 as id,
    pp.id as gid,
    4 as type,
    ST_GEOHASH(pp.geom) as location,
    pp.name as name,
    pp.name as kname,
    concat(plg.name_3, ', ', plg2.name_2, ', ', 'addr:city') as address,
    concat(plg.name_3, ', ', plg2.name_2, ', ', "addr:city") as kadd,
    false as has_sensor
    FROM public.da_nang_point pp, public.gadm36_vnm_3 plg, public.gadm36_vnm_2 plg2
    where plg.gid_1 like 'VNM.19%'
    and plg2.gid_1 like 'VNM.19%'
    and ST_Contains(plg.geom, pp.geom)
    and ST_Contains(plg2.geom, pp.geom);
    
SELECT pp.id_0 as id,  pp.id as gid, 4 as type, ST_GEOHASH(pp.geom) as location, pp.name as name,
pp.name as kname, concat(plg.name_3, ', ', plg2.name_2, ', ', "addr:city") as address,
concat(plg.name_3, ', ', plg2.name_2, ', ', "addr:city") as kadd, false as has_sensor FROM public.da_nang_point pp, public.gadm36_vnm_3 plg, public.gadm36_vnm_2 plg2 where plg.gid_1 like 'VNM.19%' and plg2.gid_1 like 'VNM.19%' and ST_Contains(plg.geom, pp.geom) and ST_Contains(plg2.geom, pp.geom)


SELECT min(d.id_0) as id, min(d._id) as gid, ST_GEOHASH(ST_Centroid(min(d.the_geom))) as location,
    min(d.name) as name, min(d.name) as kname,
    min(xa.name_3) as xas, concat(d.name, ', ', xa.name_2, ', ', xa.name_3) as address,
    min(xa.name_3) as xas, concat(d.name, ', ', xa.name_2, ', ', xa.name_3) as kadd,
    false as has_sensor
FROM
    public.da_nang_clip d,
    public.gadm36_vnm_3 xa
where   xa.gid_1 like 'VNM.19%' and
        ST_Intersects(xa.geom, d.the_geom) and
        d.name is not null
group by address;

id, name, address, time_create, last_update, level_water, max_level, type, geom, is_active

CREATE OR REPLACE FUNCTION pgr_get_map_sensor(
OUT id integer, OUT name integer, OUT the_geom geometry, OUT level_water integer, OUT max_level integer)
RETURNS SETOF record AS
$BODY$
DECLARE
rec record;
sql text;

BEGIN
-- Update
EXECUTE 'update da_nang_explode_01_vertices_pgr set time_update = NOW(), level_water = ' || _level || '  where id = ' || _id ||'';
-- Update
sql := 'SELECT id, the_geom, level_water, max_level FROM da_nang_explode_01_vertices_pgr where id = ' || _id ||'';
FOR rec IN EXECUTE sql
LOOP
    -- Return record
    id := rec.id;
    the_geom := rec.the_geom;
    level_water := rec.level_water;
    max_level := rec.max_level;
    RETURN NEXT;
END LOOP;

RETURN;
END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE STRICT;




name, address, time_create, last_update, level_water,
max_level, type, geom, is_active, source

CREATE OR REPLACE FUNCTION pgr_create_sensor(
IN _name VARCHAR(250), IN _address VARCHAR(250), IN _max_level integer, IN _type integer,
IN _lng real, IN _lat real,
OUT id integer, OUT name character varying, OUT address character varying, OUT max_level integer)
RETURNS SETOF record AS
$BODY$
DECLARE
rec record;
sql text;

BEGIN

INSERT INTO da_nang_point_sensor(name, address, time_create, last_update, level_water, max_level, type, geom, is_active, source)
VALUES (_name, _address, NOW(), NOW(), 0, _max_level, _type, ST_SetSRID(ST_MakePoint(_lng, _lat), 4326), true, null);

sql := 'SELECT id, name, address, max_level FROM da_nang_point_sensor where name = ' || _name ||' and address = ' || _address || '';
FOR rec IN EXECUTE sql
LOOP
    -- Return record
    id := rec.id;
    name := rec.name;
    address := rec.address;
    max_level := rec.max_level;
    RETURN NEXT;
END LOOP;

RETURN;
END;
$BODY$
LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION pgr_create_sensor(IN _name VARCHAR(250), IN _address VARCHAR(250),
IN _max_level integer, IN _type integer, IN _lng real, IN _lat real)
RETURNS void AS
$BODY$
BEGIN

INSERT INTO da_nang_point_sensor(name, address, time_create, last_update, level_water, max_level,
                                 type, geom, is_active, source)
VALUES (_name, _address, now(), now(), 0, _max_level, _type);

RETURN;
END;
$BODY$
LANGUAGE 'plpgsql';









CREATE OR REPLACE FUNCTION pgr_create_sensor(IN _name VARCHAR(20), IN _address VARCHAR(50),
IN _max_level integer, IN _type integer, IN _lng real, IN _lat real,
OUT id integer, OUT name VARCHAR(20), OUT address VARCHAR(50), OUT max_level integer)
RETURNS SETOF record AS
$BODY$
DECLARE
rec record;
sql text;

BEGIN

INSERT INTO da_nang_point_sensor(name, address, time_create, last_update, level_water, max_level,
                                 type, geom, is_active, source)
VALUES (_name, _address, now(), now(), 0, _max_level, _type, ST_SetSRID(ST_MakePoint(_lng, _lat), 4326),
       true, null);
       
sql := 'SELECT id, name, address, max_level FROM da_nang_point_sensor where name = \'tung\'';
FOR rec IN EXECUTE sql
LOOP
    -- Return record
    id := rec.id;
    name := rec.name;
    address := rec.address;
    max_level := rec.max_level;
    RETURN NEXT;
END LOOP;

RETURN;
END;
$BODY$
LANGUAGE 'plpgsql';

-- FUNCTION: public.pgr_create_sensor(character varying, character varying, integer, integer, real, real)

-- DROP FUNCTION public.pgr_create_sensor(character varying, character varying, integer, integer, real, real);

CREATE OR REPLACE FUNCTION pgr_create_sensor(IN _name VARCHAR(20), IN _address VARCHAR(50),
IN _max_level integer, IN _type integer, IN _lng real, IN _lat real, IN _trafic integer,
OUT id integer, OUT name VARCHAR(20), OUT address VARCHAR(50), OUT max_level integer)
RETURNS SETOF record AS
$BODY$
DECLARE
rec record;
sql text;

BEGIN
INSERT INTO da_nang_point_sensor(name, address, time_create, last_update, level_water, max_level,
                                 type, geom, is_active, source)
VALUES (_name, _address, now(), now(), 0, _max_level, _type, ST_SetSRID(ST_MakePoint(_lng, _lat), 4326),
       true, _trafic);
       
sql := 'SELECT id, name, address, max_level FROM da_nang_point_sensor ORDER BY Id DESC LIMIT 1';
FOR rec IN EXECUTE sql
LOOP
    -- Return record
    id := rec.id;
    name := rec.name;
    address := rec.address;
    max_level := rec.max_level;
    RETURN NEXT;
END LOOP;

RETURN;
END;
$BODY$;
LANGUAGE 'plpgsql';


select db.id_0 as id, db.source, db.target, st_length(db.the_geom) as cost, (CASE WHEN db.directed THEN -1 ELSE st_length(db.the_geom) END) as reverse_cost from da_nang_exploded db left join da_nang_point_sensor ss on ss.source = db.id where ss.source < 200 or ss.source is null

select db.id_0 as id, db.source, db.target, st_length(db.the_geom) as cost, (CASE WHEN directed THEN -1 ELSE st_length(db.the_geom) END) as reverse_cost from da_nang_exploded db left join da_nang_point_sensor ss on ss.source = db.source or ss.source = db.target where ss.level_water < 200 or ss.source is null

select
    db.id_0 as id,
    db.source,
    db.target,
    st_length(db.the_geom) as cost,
    (CASE WHEN directed THEN -1 ELSE st_length(db.the_geom) END) as reverse_cost
from da_nang_exploded db
left join da_nang_point_sensor ss on ss.source = db.source or ss.source = db.target
where ss.level_water < 200 or ss.source is null


select seq, id, the_geom, name, now
from (
    select seq, lag(node) over (order by seq) as bef,
           node as now
    from pgr_dijkstra('select db.id_0 as id, db.source, db.target, st_length(db.the_geom) as cost, (CASE WHEN directed THEN -1 ELSE st_length(db.the_geom) END) as reverse_cost from da_nang_exploded db left join da_nang_point_sensor ss on ss.source = db.source or ss.source = db.target where ss.level_water < 200 or ss.source is null',1,3000,true) as di
) t
JOIN public.da_nang_exploded e
ON ((now = e.source and bef = e.target) or (bef = e.source and now = e.target) or (now  = e.source and now = e.target))
