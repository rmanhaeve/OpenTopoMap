#!/bin/bash

# Tested for Ubuntu 23.10

sudo apt install -y sed git unzip wget python3-mapnik make gdal-bin python3-pip python3-full postgresql postgis osm2pgsql libgdal-dev

if [ -d /path/to/directory ]
then
  echo "venv already exists"
else
  python3 -m venv --system-site-packages mapnik_venv
fi
mapnik_venv/bin/pip install pyhgtmap
