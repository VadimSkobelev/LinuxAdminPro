#!/bin/bash

# Файлу для блокировки параллельных запусков скрипта
LOCKFILE="/tmp/.lock"

# Проверка наличия уже запущенной копии скрипта
if [ -f "$LOCKFILE" ]; then
    echo "ERROR: Script is already running."
    exit 1
else
    touch "$LOCKFILE"
fi

# Путь к файлу с логами
LOG_FILE="/var/log/nginx/access.log"

#Временный файл для обработки
TMP_LOG_FILE="/tmp/tmp_access.log"

# Email адрес, на который будет отправлено письмо
EMAIL="admin@test.test"

# Email адрес отправителя
SENDER="email_from@test.test"

# Путь к файлу с отчетом
REPORT="/tmp/report.txt"

# Текущее время
TIME_NOW=$(date "+%d/%b/%Y:%H:%M:%S")

#Время предыдущего отчёта
if [ -f "$REPORT" ]; then
  LAST_TIME=$(awk '/^Time/{print $2}')
else
  LAST_TIME=$(date --date="-1 hour" "+%d/%b/%Y:%H:%M:%S")
fi

#Убираем символ [ для дальнейшего использования утилиты awk
sed 's/\[//' $LOG_FILE > $TMP_LOG_FILE

# Формирование файла отчёта
rm -f $REPORT
echo "Cписок IP адресов с наибольшим количеством запросов:" > $REPORT
awk '$4 > /$LAST_TIME && $4 < /$TIME_NOW {print $1}' $TMP_LOG_FILE | sort | uniq -c | sort -rn | head -n 10 >> $REPORT

echo >> $REPORT
echo "Cписок запрашиваемых URL с наибольшим количеством запросов:" >> $REPORT
awk '$4 > /$LAST_TIME && $4 < /$TIME_NOW {print $7}' $TMP_LOG_FILE |sed 's/400/Ошиба запроса (400 Bad Request)/' | sort | uniq -c | sort -rn | head -n 10 >> $REPORT

echo >> $REPORT
echo "Cписок ошибок веб-сервера/приложения:" >> $REPORT
awk '$4 > /$LAST_TIME && $4 < /$TIME_NOW {if ($9 >= 500) {print $9}}' $TMP_LOG_FILE | sort | uniq -c | sort -rn >> $REPORT

echo >> $REPORT
echo "Cписок всех кодов HTTP ответов и их количество:" >> $REPORT
awk '$4 > /$LAST_TIME && $4 < /$TIME_NOW {print $9}' $TMP_LOG_FILE | sed 's/"-"/400/' | sort | uniq -c | sort -rn >> $REPORT

echo >> $REPORT
echo "Time stamp: $TIME_NOW" >> $REPORT

mail -s "Отчет за период с $LAST_TIME по $TIME_NOW" -r $SENDER $EMAIL < $REPORT

rm -f $TMP_LOG_FILE $LOCKFILE
