OSM_FILES = belgium-latest.osm.pbf
WATER_POLYGON_FILES = simplified-water-polygons-split-3857 water-polygons-split-3857

.PHONY: all
all: $(WATER_POLYGON_FILES) $(OSM_FILES)


$(WATER_POLYGON_FILES):
	wget https://osmdata.openstreetmap.de/download/$@.zip
	unzip $@.zip
	rm $@.zip
	


$(OSM_FILES):
	wget https://download.geofabrik.de/europe/$@
