include settings.mk

WATER_POLYGON_FILES = data/simplified-water-polygons-split-3857 data/water-polygons-split-3857
DATA_OSM_FILES = $(addprefix data/,$(OSM_FILES))

.PHONY: all dem preprocess select_permission
all: $(WATER_POLYGON_FILES) $(DATA_OSM_FILES) dem .contours .osm_data preprocess select_permission

$(WATER_POLYGON_FILES):
	mkdir -p data
	cd data && wget https://osmdata.openstreetmap.de/download/$(@F).zip && unzip $(@F).zip && rm $(@F).zip


$(DATA_OSM_FILES):
	mkdir -p data
	cd data && wget https://download.geofabrik.de/europe/$(@F)

dem:
	$(MAKE) -C dem

.user:
	cd /tmp && sudo -u postgres createuser $(DB_USER)
	touch .user

.db: .user
	cd /tmp && sudo -u postgres createdb --owner $(DB_USER) --template=template0 --encoding=UTF8 gis
	cd /tmp && sudo -u postgres createdb --owner $(DB_USER) contours
	cd /tmp && sudo -u postgres createdb --owner $(DB_USER) lowzoom
	touch .db

.extensions: .db
	cd /tmp && sudo -u postgres psql gis -c 'CREATE EXTENSION postgis;'
	cd /tmp && sudo -u postgres psql gis -c 'CREATE EXTENSION hstore;'
	cd /tmp && sudo -u postgres psql contours -c 'CREATE EXTENSION postgis;'
	cd /tmp && sudo -u postgres psql lowzoom -c "CREATE EXTENSION postgis;"
	cd /tmp && sudo -u postgres psql lowzoom -c "CREATE EXTENSION dblink;"
	cd /tmp && sudo -u postgres psql gis -c "CREATE EXTENSION IF NOT EXISTS dblink;"
	touch .extensions

.permissions: .db
	sudo sed -i '1ilocal	all	$(DB_USER)	trust' $(POSTGRES_ROOT)/pg_hba.conf
	cd /tmp && sudo -u postgres psql -c 'SELECT pg_reload_conf();'
	touch .permissions


.contours: .permissions .extensions dem/contours.pbf
	osm2pgsql --username=$(DB_USER) --slim -d contours -C 12000 --number-processes 10 --style osm2pgsql/contours.style dem/contours.pbf
	touch .contours


.osm_data: .permissions .extensions $(DATA_OSM_FILES)
	osm2pgsql --username=$(DB_USER) --slim -d gis -C 12000 --number-processes 10 --style osm2pgsql/opentopomap.style $(DATA_OSM_FILES)
	touch .osm_data

preprocess: .osm_data
	$(MAKE) -C tools

select_permission: preprocess
	cd /tmp && sudo -u postgres psql lowzoom -c "GRANT SELECT ON ALL TABLES IN SCHEMA public TO $(DB_USER);"
	cd /tmp && sudo -u postgres psql gis -c "GRANT SELECT ON ALL TABLES IN SCHEMA public TO $(DB_USER);"
	cd /tmp && sudo -u postgres psql contours -c "GRANT SELECT ON ALL TABLES IN SCHEMA public TO $(DB_USER);"


clean:
	dropdb -U $(DB_USER) --if-exists lowzoom
	dropdb -U $(DB_USER) --if-exists contours
	dropdb -U $(DB_USER) --if-exists gis
	rm -f .osm_data
	rm -f .extensions
	rm -f .contours
	rm -f .db
	rm -f .permissions
	rm -f .user
