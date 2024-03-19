FROM ubuntu:mantic

WORKDIR /var

RUN apt update && apt install -y sed git unzip wget python3-mapnik make gdal-bin python3-pip python3-full postgresql-client osm2pgsql libgdal-dev
RUN python3 -m venv --system-site-packages topomapnik_venv
RUN topomapnik_venv/bin/pip install pyhgtmap
# Optional dependencies for the Flask WMS server
RUN apt install -y python3-pyproj python3-flask python3-pillow
RUN echo "db:5432:gis:gis:postgres" > ~/.pgpass
RUN chmod 0600 ~/.pgpass
CMD cd TopoMapnik && bash start_server.sh