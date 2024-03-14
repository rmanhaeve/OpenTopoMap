#!/bin/bash

#nik4 -v -s 25000 --ppi 300 -a 4 -c 673689.467321 674925.873282 --margin 10 -P "$(<transformation.proj4)" opentopomap.xml 4print.png
nik4 -v -s 25000 --ppi 300 -a 4 -c 4.675884 50.902600 --margin 10 -P "$(<transformation.proj4)" opentopomap.xml 4print.png

