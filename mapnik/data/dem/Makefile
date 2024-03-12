SRTM_FILES = M31 N31
.PHONY: all
all: raw.tif
	
$(SRTM_FILES):
	wget https://viewfinderpanoramas.org/dem3/$@.zip
	unzip $@.zip
	for hgtfile in $@/*.hgt;do gdal_fillnodata.py $$hgtfile $$hgtfile.tif; done
	rm $@.zip
	
combined: $(SRTM_FILES)
	mkdir -p combined
	mv $?/*.hgt.tif combined/
	
raw.tif: combined
	gdal_merge.py -n 32767 -co BIGTIFF=YES -co TILED=YES -co COMPRESS=LZW -co PREDICTOR=2 -o raw.tif combined/*.hgt.tif
