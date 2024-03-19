include ../settings.mk

all: .functions .saddles .isolation

.functions:
	psql --host=db --username=$(POSTGRES_USER) gis < arealabel.sql
	psql --host=db --username=$(POSTGRES_USER) gis < stationdirection.sql
	psql --host=db --username=$(POSTGRES_USER) gis < viewpointdirection.sql
	psql --host=db --username=$(POSTGRES_USER) gis < pitchicon.sql
	touch .functions

	
saddledirection:
	cc -o saddledirection saddledirection.c -lm -lgdal
isolation:
	cc -Wall -o isolation isolation.c -lgdal -lm -O2
	
.saddles: saddledirection ../dem/raw.tif 
	psql --host=db --username=$(POSTGRES_USER) -A -t -F ";" gis -c \
	"SELECT osm_id,ST_X(ST_Astext(ST_Transform(way,4326))),ST_Y(ST_Astext(ST_Transform(way,4326))),direction \
	FROM planet_osm_point WHERE \"natural\" IN ('saddle','col','notch') AND \
	(direction IS NULL or direction NOT SIMILAR TO '[0-9]+');;" \
	| ./saddledirection -f ../dem/raw.tif -o sql | psql --host=db --username=$(POSTGRES_USER) gis 
	touch .saddles
	
.columns:
	psql --host=db --username=$(POSTGRES_USER)  -d gis -c "ALTER TABLE planet_osm_point ADD COLUMN otm_isolation text;"
	psql --host=db --username=$(POSTGRES_USER)  -d gis -c "ALTER TABLE planet_osm_polygon ADD COLUMN otm_isolation text;"
	touch .columns
	
.isolation: .columns isolation ../dem/raw.tif 
	psql --host=db --username=$(POSTGRES_USER) -A -t -F ";" gis -c \
	"SELECT osm_id,ST_X(ST_Astext(ST_Transform(way,4326))),ST_Y(ST_Astext(ST_Transform(way,4326))),ele \
	FROM planet_osm_point WHERE \"natural\" IN ('peak','volcano') AND \
	(otm_isolation IS NULL or otm_isolation NOT SIMILAR TO '[0-9]+');;" \
	| ./isolation -f ../dem/raw.tif  -o sql | psql --host=db --username=$(POSTGRES_USER) gis 
	touch .isolation
