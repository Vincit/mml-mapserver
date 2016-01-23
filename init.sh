#!/usr/bin/env bash

mkdir ~/mml/
cd ~/mml/

rsync -arPv tiedostot.kartat.kapsi.fi::mml/maastokarttarasteri_50k_jhs180 .
rsync -arPv tiedostot.kartat.kapsi.fi::mml/maastokarttarasteri_100k_jhs180 .
rsync -arPv tiedostot.kartat.kapsi.fi::mml/maastokarttarasteri_250k_jhs180 .
rsync -arPv tiedostot.kartat.kapsi.fi::mml/maastokarttarasteri_500k_jhs180 .

find maastokarttarasteri_50k_jhs180 -iname "*.png" -print0 | xargs -0 -n100 gdaltindex maastokartta_50k.shp
find maastokarttarasteri_100k_jhs180 -iname "*.png" -print0 | xargs -0 -n100 gdaltindex maastokartta_100k.shp
find maastokarttarasteri_250k_jhs180 -iname "*.png" -print0 | xargs -0 -n100 gdaltindex maastokartta_250k.shp
find maastokarttarasteri_500k_jhs180 -iname "*.png" -print0 | xargs -0 -n100 gdaltindex maastokartta_500k.shp

shptree maastokartta_50k.shp
shptree maastokartta_100k.shp
shptree maastokartta_250k.shp
shptree maastokartta_500k.shp

gdalbuildvrt maastokartta_50k.vrt maastokartta_50k.shp
gdalbuildvrt maastokartta_100k.vrt maastokartta_100k.shp
gdalbuildvrt maastokartta_250k.vrt maastokartta_250k.shp
gdalbuildvrt maastokartta_500k.vrt maastokartta_500k.shp

#gdal_translate -of GTiff -a_srs EPSG:3067 -co BLOCKXSIZE=256 -co BLOCKYSIZE=256 -co COMPRESS=DEFLATE -co PREDICTOR=2 -co TILED=yes -co BIGTIFF=IF_NEEDED maastokartta_50k.vrt maastokartta_50k.tiff
gdal_translate -of GTiff -a_srs EPSG:3067 -co BLOCKXSIZE=256 -co BLOCKYSIZE=256 -co COMPRESS=DEFLATE -co PREDICTOR=2 -co TILED=yes -co BIGTIFF=IF_NEEDED maastokartta_100k.vrt maastokartta_100k.tiff
gdal_translate -of GTiff -a_srs EPSG:3067 -co BLOCKXSIZE=256 -co BLOCKYSIZE=256 -co COMPRESS=DEFLATE -co PREDICTOR=2 -co TILED=yes -co BIGTIFF=IF_NEEDED maastokartta_250k.vrt maastokartta_250k.tiff
gdal_translate -of GTiff -a_srs EPSG:3067 -co BLOCKXSIZE=256 -co BLOCKYSIZE=256 -co COMPRESS=DEFLATE -co PREDICTOR=2 -co TILED=yes -co BIGTIFF=IF_NEEDED maastokartta_500k.vrt maastokartta_500k.tiff

#gdaladdo maastokartta_50k.tiff -r gauss --config NUM_THREADS 4 --config COMPRESS_OVERVIEW DEFLATE --config PREDICTOR 2 --config INTERLEAVE_OVERVIEW PIXEL --config PHOTOMETRIC_OVERVIEW YCBCR 2 4 8 16 32 64 128 256 512 1024 2048 4096
gdaladdo maastokartta_100k.tiff -r gauss --config NUM_THREADS 4 --config COMPRESS_OVERVIEW DEFLATE --config PREDICTOR 2 --config INTERLEAVE_OVERVIEW PIXEL --config PHOTOMETRIC_OVERVIEW YCBCR 2 4 8 16 32 64 128 256 512 1024 2048 4096
gdaladdo maastokartta_250k.tiff -r gauss --config NUM_THREADS 4 --config COMPRESS_OVERVIEW DEFLATE --config PREDICTOR 2 --config INTERLEAVE_OVERVIEW PIXEL --config PHOTOMETRIC_OVERVIEW YCBCR 2 4 8 16 32 64 128 256 512 1024 2048 4096
gdaladdo maastokartta_500k.tiff -r gauss --config NUM_THREADS 4 --config COMPRESS_OVERVIEW DEFLATE --config PREDICTOR 2 --config INTERLEAVE_OVERVIEW PIXEL --config PHOTOMETRIC_OVERVIEW YCBCR 2 4 8 16 32 64 128 256 512 1024 2048 4096
