#!/bin/bash

@echo off
#TODO: Проверка: Создавать папку cutted, ЕСЛИ не существует

echo 'Создание папки вывода...'
mkdir cutted

for file in *.mp4; do
	
	echo 'Обрезка видео' ${file}'...'

	#Обрезка 4,15 секунд с начала видео для каждого файла в папке и запись готового видео в папку cutted
	ffmpeg -loglevel fatal -hide_banner -i "${file}" -ss 00:00:04.15 -to 01:00:00 -c copy "cutted/${file}"

done
