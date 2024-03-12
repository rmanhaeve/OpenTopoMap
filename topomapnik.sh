#!/bin/bash

###############################################
#   OpenTopoMap
#   (c) 2012-2018 Stefan Erhardt
#   https://github.com/der-stefan/OpenTopoMap
#
#   opentopomap.org
#
#   Modified by Robin Manhaeve 2024
#
###############################################


# HOWTO install OpenTopoMap on Debian 12
#===========================================================

ROOT_DIR="~/opentopo/"
OSM_FILE="https://planet.openstreetmap.org/pbf/planet-latest.osm.pbf"
DB_USER="gis"

# Install requirements:
sudo apt install git

# Download OpenTopoMap files

cd $ROOT_DIR
git clone https://github.com/der-stefan/OpenTopoMap.git
cd $ROOT_DIR/OpenTopoMap/mapnik
	
# get the generalized water polygons from http://openstreetmapdata.com/
mkdir data && cd data
wget http://data.openstreetmapdata.com/water-polygons-generalized-3857.zip
wget http://data.openstreetmapdata.com/water-polygons-split-3857.zip
unzip water-polygons*.zip


#TODO
# Now you need to create the hillshade and contours. We can't provide the data, since it consumes ~500 GB.
# But there is a long howto in HOWTO_DEM



# Install Mapnik renderer
sudo apt install libmapnik3.0 libmapnik-dev mapnik-utils python-mapnik unifont


# Install osm2pgsql
sudo apt install osm2pgsql

# Create user and database
if id "$DB_USER" >/dev/null 2>&1; then
    echo 'user already exists'
else
    useradd --system $DB_USER
fi
sudo -u postgres createuser gis
sudo -u postgres createdb --temaplte=template0 --encoding=UTF8 --owner=gis gis
sudo -u postgres psql gis --command='CREATE EXTENSION postgis;'
sudo -u postgres psql gis --command='CREATE EXTENSION hstore;'


# Load data into database
mkdir $ROOT_DIR/data && cd $ROOT_DIR/data
wget $OSM_FILE


osm2pgsql -d gis --number-processes 4 --style $ROOT_DIR/OpenTopoMap/mapnik/osm2pgsql/opentopomap.style $ROOT_DIR/data/*.pbf


# TODO
# Now do the preprocessing of the OSM data for low zoom levels
	# A complete copy-paste guide is HOWTO_Preprocessing
	
	
# Find out the sizes of the databases:
sudo -u gis psql -d gis -c "SELECT pg_database.datname, pg_size_pretty(pg_database_size(pg_database.datname)) AS size FROM pg_database;"
	