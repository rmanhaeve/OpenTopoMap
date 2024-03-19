include settings.mk

WATER_POLYGON_FILES = data/simplified-water-polygons-split-3857 data/water-polygons-split-3857
DATA_OSM_FILES = $(addprefix data/,$(OSM_FILES))

.PHONY: all dem preprocess
all: $(WATER_POLYGON_FILES) $(DATA_OSM_FILES) dem .contours .osm_data preprocess

dem:
	$(MAKE) -C dem

preprocess: .osm_data
	$(MAKE) -C tools


$(WATER_POLYGON_FILES):
	mkdir -p data
	cd data && wget https://osmdata.openstreetmap.de/download/$(@F).zip && unzip $(@F).zip && rm $(@F).zip


$(DATA_OSM_FILES):
	mkdir -p data
	cd data && wget https://download.geofabrik.de/europe/$(@F)


.contours:  dem/contours.pbf
	osm2pgsql --host=db --username=$(POSTGRES_USER) --slim -d gis -p contours -C 12000 -W --style osm2pgsql/contours.style dem/contours.pbf
	touch .contours


.osm_data: $(DATA_OSM_FILES)
	osm2pgsql --host=db --username=$(POSTGRES_USER) --slim -d gis -C 12000 -W --style osm2pgsql/opentopomap.style $(DATA_OSM_FILES)
	touch .osm_data