include settings.mk
POSTGRES_ROOT := /etc/postgresql/15/main
OSM_FILES = $(wildcard data/*.pbf)
.PHONY: all
all: data dem .contours .osm_data .select_permissions


.PHONY: data
data:
	$(MAKE) -C data
.PHONY: dem
dem:
	$(MAKE) -C dem

#FIX permissions to stat of file
.db_permissions:
	sudo sed -i '1ilocal	all	$(DB_USER)	trust' $(POSTGRES_ROOT)/pg_hba.conf
	cd /tmp && sudo -u postgres psql -c 'SELECT pg_reload_conf();'
	touch .db_permissions
.extensions: .db
	cd /tmp && sudo -u postgres psql gis -c 'CREATE EXTENSION postgis;'
	cd /tmp && sudo -u postgres psql gis -c 'CREATE EXTENSION hstore;'
	cd /tmp && sudo -u postgres psql contours -c 'CREATE EXTENSION postgis;'
	cd /tmp && sudo -u postgres psql lowzoom -c "CREATE EXTENSION postgis;"
	cd /tmp && sudo -u postgres psql lowzoom -c "CREATE EXTENSION dblink;"
	cd /tmp && sudo -u postgres psql gis -c "CREATE EXTENSION IF NOT EXISTS dblink;"
	touch .extensions

.select_permissions: .contours preprocess
	cd /tmp && sudo -u postgres psql lowzoom -c "GRANT SELECT ON ALL TABLES IN SCHEMA public TO $(DB_USER);"
	cd /tmp && sudo -u postgres psql gis -c "GRANT SELECT ON ALL TABLES IN SCHEMA public TO $(DB_USER);"
	cd /tmp && sudo -u postgres psql contours -c "GRANT SELECT ON ALL TABLES IN SCHEMA public TO $(DB_USER);"
	touch .select_permissions
	
.db: .user .db_permissions
	createdb -U $(DB_USER) --template=template0 --encoding=UTF8 gis
	createdb -U $(DB_USER)  contours
	createdb -U $(DB_USER)  lowzoom
	touch .db
.user:
	cd /tmp && sudo -u postgres createuser  --createdb  $(DB_USER)
	touch .user


.contours: .extensions .db_permissions dem/contours.pbf
	osm2pgsql --username=$(DB_USER) --slim -d contours -C 12000 --number-processes 10 --style osm2pgsql/contours.style dem/contours.pbf
	touch .contours


.osm_data: .extensions .db_permissions $(OSM_FILES)
	osm2pgsql --username=$(DB_USER) --slim -d gis -C 12000 --number-processes 10 --style osm2pgsql/opentopomap.style $(OSM_FILES)
	touch .osm_data

preprocess: .osm_data
	$(MAKE) -C tools

clean:
	dropdb -U $(DB_USER) --if-exists lowzoom
	dropdb -U $(DB_USER) --if-exists contours
	dropdb -U $(DB_USER) --if-exists gis
	rm -f .osm_data
	rm -f .extensions
	rm -f .contours
	rm -f .db


