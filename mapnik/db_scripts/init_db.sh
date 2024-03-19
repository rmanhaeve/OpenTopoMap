#!/bin/bash

psql --username $(POSTGRES_USER) gis -c "CREATE EXTENSION IF NOT EXISTS dblink;"
createdb --username $(POSTGRES_USER) lowzoom
psql --username $(POSTGRES_USER) lowzoom -c "CREATE EXTENSION IF NOT EXISTS postgis;"
psql --username $(POSTGRES_USER) lowzoom -c "CREATE EXTENSION IF NOT EXISTSdblink;"
createdb --username $(POSTGRES_USER) contours
psql --username $(POSTGRES_USER) contours -c 'CREATE EXTENSION IF NOT EXISTS postgis;'