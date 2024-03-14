include settings.mk
POSTGRES_ROOT := /etc/postgresql/15/main
OSM_FILES = $(wildcard data/*.pbf)
.PHONY: all
all: data dem setup_db


.PHONY: data
data:
	$(MAKE) -C data
.PHONY: dem
dem:
	$(MAKE) -C dem

setup_db: .contours .osm_data test.png

#FIX permissions to stat of file
.permissions:
	echo "local	gis	$(DB_USER)	trust" | sudo tee -a $(POSTGRES_ROOT)/pg_hba.conf
	echo "local	contours	$(DB_USER)	trust" | sudo tee -a $(POSTGRES_ROOT)/pg_hba.conf
	touch .permissions
.extensions: .db
	sudo -u postgres psql gis -c 'CREATE EXTENSION postgis;'
	sudo -u postgres psql gis -c 'CREATE EXTENSION hstore;'
	sudo -u postgres psql contours -c 'CREATE EXTENSION postgis;'
	sudo -u postgres psql lowzoom -c "CREATE EXTENSION postgis;"
	sudo -u postgres psql lowzoom -c "CREATE EXTENSION dblink;"
	sudo -u postgres psql lowzoom -c "GRANT SELECT ON ALL TABLES IN SCHEMA public TO $(DB_USER);"
	sudo -u postgres psql gis -c "CREATE EXTENSION IF NOT EXISTS dblink;"
	touch .extensions
.db: .user
	createdb -U $(DB_USER) --template=template0 --encoding=UTF8 gis
	createdb -U $(DB_USER)  contours
	createdb -U $(DB_USER)  lowzoom
	touch .db
.user:
	sudo -u postgres createuser  --createdb  $(DB_USER)
	touch .user


.contours: .extensions .permissions dem/contours.pbf
	osm2pgsql --username=$(DB_USER) --slim -d contours -C 12000 --number-processes 10 --style osm2pgsql/contours.style dem/contours.pbf
	touch .contours


.osm_data: .extensions .permissions $(OSM_FILES)
	osm2pgsql --username=$(DB_USER) --slim -d gis -C 12000 --number-processes 10 --style osm2pgsql/opentopomap.style $(OSM_FILES)
	touch .osm_data

preprocess: .osm_data
	$(MAKE) -C tools

test.png: .osm_data .contours preprocess
	python3 ~/Nik4/nik4.py -b 4.5715 50.8825 4.7173 50.9336 -z 10 opentopomap.xml test.png

clean:
	dropdb -U $(DB_USER) --if-exists lowzoom
	dropdb -U $(DB_USER) --if-exists contours
	dropdb -U $(DB_USER) --if-exists gis
	rm -f .osm_data
	rm -f .extensions
	rm -f .contours
	rm -f .db


