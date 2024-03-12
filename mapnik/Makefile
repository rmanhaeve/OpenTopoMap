DB_USER := gis
POSTGRES_ROOT := /etc/postgresql/15/main
.PHONY: all
all: download_data setup_db


.PHONY: data
download_data:
	$(MAKE) -C data

setup_db: .user .db .extensions .permissions

.permissions:
	echo "local	gis	$(DB_USER)	trust" | sudo tee -a $(POSTGRES_ROOT)/pg_hba.conf
	touch .permissions
.extensions:
	sudo -u postgres psql gis --command='CREATE EXTENSION postgis;'
	sudo -u postgres psql gis --command='CREATE EXTENSION hstore;'
	touch .extensions
.db:
	sudo -u postgres createdb --template=template0 --encoding=UTF8 --owner=$(DB_USER) gis
	touch .db
.user:
	sudo -u postgres createuser  $(DB_USER)
	touch .user

