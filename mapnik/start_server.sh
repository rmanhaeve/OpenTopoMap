#!/bin/bash

make && cd flask-wms && flask --app server run --host=0.0.0.0 --debug -p 5000