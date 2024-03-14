SHELL := /bin/bash
SRTM_FILES = M31 N31
WARP_LEVELS = 90 500 700 1000 5000
RELIEF_LEVELS = 500 5000
HILLSHADE_LEVELS = 90 500 700 1000 5000
TRANSFORMATION = $(file <../transformation.proj4)
.PHONY: all
all: $(patsubst %, warp-%.tif, $(WARP_LEVELS)) $(patsubst %, relief-%.tif, $(RELIEF_LEVELS)) $(patsubst %, hillshade-%.tif, $(HILLSHADE_LEVELS)) hillshade-90-jpeg.tif hillshade-30m-jpeg.tif contours.pbf
	
$(SRTM_FILES):
	mkdir -p combined
	wget -nc https://viewfinderpanoramas.org/dem3/$@.zip
	unzip $@.zip
	rm $@.zip
	mv $@/*.hgt combined/
	
	
	
raw.tif: $(SRTM_FILES)
	cd combined && for hgtfile in *.hgt;do gdal_fillnodata.py $$hgtfile $$hgtfile.tif; done
	gdal_merge.py -n 32767 -co BIGTIFF=YES -co TILED=YES -co COMPRESS=LZW -co PREDICTOR=2 -o raw.tif combined/*.hgt.tif
	
warp-%.tif: raw.tif
	gdalwarp -co BIGTIFF=YES -co TILED=YES -co COMPRESS=LZW -co PREDICTOR=2 -t_srs "$(TRANSFORMATION)" -r bilinear -tr $* $* raw.tif warp-$*.tif
contours.tif: raw.tif
	gdalwarp -co BIGTIFF=YES -co TILED=YES -co COMPRESS=LZW -co PREDICTOR=2 -t_srs "+proj=merc +ellps=sphere +R=6378137 +a=6378137 +units=m" -r bilinear -tr 90 90 raw.tif contours.tif


relief-%.tif: warp-%.tif
	gdaldem color-relief -co COMPRESS=LZW -co PREDICTOR=2 -alpha warp-$*.tif ../relief_color_text_file.txt relief-$*.tif

hillshade-5000.tif: warp-5000.tif
	gdaldem hillshade -z 7 -compute_edges -co COMPRESS=JPEG warp-5000.tif hillshade-5000.tif

hillshade-1000.tif: warp-1000.tif
	gdaldem hillshade -z 7 -compute_edges -co BIGTIFF=YES -co TILED=YES -co COMPRESS=JPEG warp-1000.tif hillshade-1000.tif

hillshade-700.tif: warp-700.tif
	gdaldem hillshade -z 4 -compute_edges -co BIGTIFF=YES -co TILED=YES -co COMPRESS=JPEG warp-700.tif hillshade-700.tif

hillshade-500.tif: warp-500.tif
	gdaldem hillshade -z 5 -compute_edges -co BIGTIFF=YES -co TILED=YES -co COMPRESS=JPEG warp-500.tif hillshade-500.tif

hillshade-90.tif: warp-90.tif
	gdaldem hillshade -z 2 -co compress=lzw -co predictor=2 -co bigtiff=yes -compute_edges warp-90.tif hillshade-90.tif
	
hillshade-90-jpeg.tif: hillshade-90.tif
	gdal_translate -co compress=JPEG -co bigtiff=yes -co tiled=yes hillshade-90.tif hillshade-90-jpeg.tif
hillshade-30m-jpeg.tif: warp-90.tif 
	gdaldem hillshade -z 5 -compute_edges -co BIGTIFF=YES -co TILED=YES -co COMPRESS=JPEG warp-90.tif hillshade-30m-jpeg.tif
	
contours.pbf: warp-90.tif
	source ../mapnik_venv/bin/activate && pyhgtmap --max-nodes-per-tile=0 -s 10 -0 --pbf warp-90.tif
	mv lon-*.osm.pbf contours.pbf
	
contours.pbf: contours.tif
	source ../mapnik_venv/bin/activate && pyhgtmap --max-nodes-per-tile=0 -s 10 -0 --pbf contours.tif
	mv lon-*.osm.pbf contours.pbf
