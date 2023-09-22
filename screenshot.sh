#! /run/current-system/sw/bin/sh

DATE_STRING="$(date "+%Y-%m-%d-%H-%M-%S")"
FILE_NAME="/home/lukacsf/pix/screenshots/screenshot-"$DATE_STRING".jpg"

magick import $FILE_NAME
