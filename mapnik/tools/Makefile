include ../settings.mk

all: .functions .lowzoom .saddles .isolation

.functions:
	psql -U $(DB_USER) gis < arealabel.sql
	psql -U $(DB_USER) gis < stationdirection.sql
	psql -U $(DB_USER) gis < viewpointdirection.sql
	psql -U $(DB_USER) gis < pitchicon.sql
	touch .functions

.lowzoom: 
	cd /tmp && sudo -u postgres ./update_lowzoom.sh
	touch .lowzoom
	
saddledirection:
	cc -o saddledirection saddledirection.c -lm -lgdal
isolation:
	cc -Wall -o isolation isolation.c -lgdal -lm -O2
	
.saddles: saddledirection ../dem/raw.tif 
	psql -U $(DB_USER) -A -t -F ";" gis -c \
	"SELECT osm_id,ST_X(ST_Astext(ST_Transform(way,4326))),ST_Y(ST_Astext(ST_Transform(way,4326))),direction \
	FROM planet_osm_point WHERE \"natural\" IN ('saddle','col','notch') AND \
	(direction IS NULL or direction NOT SIMILAR TO '[0-9]+');;" \
	| ./saddledirection -f ../dem/raw.tif -o sql | psql -U $(DB_USER) gis 
	touch .saddles
	
.columns:
	psql -U $(DB_USER)  -d gis -c "ALTER TABLE planet_osm_point ADD COLUMN otm_isolation text;"
	psql -U $(DB_USER)  -d gis -c "ALTER TABLE planet_osm_polygon ADD COLUMN otm_isolation text;"
	touch .columns
	
.isolation: .columns isolation ../dem/raw.tif 
	psql -U $(DB_USER) -A -t -F ";" gis -c \
	"SELECT osm_id,ST_X(ST_Astext(ST_Transform(way,4326))),ST_Y(ST_Astext(ST_Transform(way,4326))),ele \
	FROM planet_osm_point WHERE \"natural\" IN ('peak','volcano') AND \
	(otm_isolation IS NULL or otm_isolation NOT SIMILAR TO '[0-9]+');;" \
	| ./isolation -f ../dem/raw.tif  -o sql | psql -U $(DB_USER) gis 
	touch .isolation
