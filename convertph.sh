#!/bin/bash

# Цвета и форматирование для терминала
BLUE_BOLD=$(tput bold; tput setaf 4)			# Полужирный шрифт + синий цвет
RED=$(tput bold; tput setaf 1)					# Красный цвет для ошибок
RESET=$(tput sgr0)								# Сброс форматирования


# Проверка на наличие ffmpeg
if ! command -v ffmpeg &> /dev/null; then
	echo "${RED}Ошибка:${RESET} ffmpeg не установлен или не найден в PATH.\nПожалуйста, установите ffmpeg, прежде чем запускать этот скрипт.\n"
	exit 1
fi

# Проверяем, передан ли аргумент каталога
if [ -z "$1" ]; then
	echo -e "Использование: $0 ${BLUE_BOLD}[каталог с исходниками]${RESET}"
	exit 1
fi

# Переход в указанный каталог
directory="$1"

if [ -d "$directory" ]; then
	cd "$directory" || { echo -e "Не удалось перейти в каталог ${BLUE_BOLD}${directory}${RESET}"; exit 1; }
else
	echo -e "Каталог ${BLUE_BOLD}${directory}${RESET} не существует\n"
	exit 1
fi

# Проверка на существование папки cutted в указанном каталоге
if [ -d "cutted" ]; then
	echo -e "Каталог ${BLUE_BOLD}cutted${RESET} уже существует, пропускаем создание\n"
else
	mkdir cutted
	echo -e "Создан каталог ${BLUE_BOLD}cutted${RESET}\n"
fi

# Цикл для каждого файла *.mp4
for file in *.mp4; do
	# Проверяем, является ли текущий элемент файлом и имеет ли он расширение .mp4 (независимо от регистра)
	if [ -f "$file" ] && [[ "${file,,}" == *.mp4 ]]; then
    # Формируем имя выходного файла
    output_file="cutted/${file}"
    	# Проверяем, существует ли уже обработанный файл
    	if [ -f "$output_file" ]; then
    		echo -e "${BLUE_BOLD}${output_file}${RESET}: файл уже существует, пропускаем\n"
    	else
    		echo -e "${BLUE_BOLD}${file}${RESET}: обрезка видео...\n"
    		# Обрезка 4,15 секунд с начала видео для каждого файла в папке и запись готового видео в папку cutted с проверкой
			# кода возврата от ffmpeg. При ошибке - переход к следующему файлу
    		if ! ffmpeg -loglevel fatal -hide_banner -i "${file}" -ss 00:00:04.15 -to 01:00:00 -c copy "$output_file"; then
    			echo "${RED}Ошибка:${RESET} не удалось обработать файл ${BLUE_BOLD}${file}${RESET}, пропускаем"
        		continue  # Переход к следующему файлу
			else
			echo -e "${BLUE_BOLD}${output_file}${RESET}: файл успешно создан\n"
			fi
		fi
	else
		echo "Очередной элемент не является файлом .mp4, смотрим следующий...\n"
	fi
done