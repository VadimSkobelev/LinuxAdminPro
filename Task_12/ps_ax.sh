#!/bin/bash

# Печатаем шапку
echo "  PID TTY STAT    TIME  COMMAND"

# Получаем список директорий процессов
PID_DIR=$(ls /proc | grep -E ^[0-9]+$ | sort -n)

# Получаем число тиков процессора в секунду
CLK_TCK=$(getconf CLK_TCK)

# Формируем построчный вывод
for pid in $PID_DIR; do
    
    tmptty=$(ls -l /proc/$pid/fd/0 2>/dev/null |awk {'print $NF'} |cut -d / -f3)
    
    if [[ $tmptty == "" || $tmptty == "null" ]] 
    then
        tty="?"
    else
        tty=$(ls -l /proc/$pid/fd/0 2>/dev/null |awk {'print $NF'} |cut -d / -f3)
    fi

    stat=$(awk '{print $3}' /proc/$pid/stat 2>/dev/null)

    # Для расчёта времени утилизации процессора, для процесса, расчитываем по формуле (utime+stime)/CLK_TCK
    # utime - время использования процессора в user mode
    # stime - время использования процессора в kernel mode
    # CLK_TCK число тиков процессора в секунду
    utime=$(awk '{print $14}' /proc/$pid/stat 2>/dev/null)
    stime=$(awk '{print $15}' /proc/$pid/stat 2>/dev/null)
    
    # Данная проверка необходима, чтобы исключить деление на 0,
    # если за время формирования вывода процесс прекратил своё существование
    if [[ $utime == "" || $stime == "" ]] 
    then
        min=$"0"
        sec=$"0"
    else
    time=$(( ($utime + $stime) / $CLK_TCK ))
    min=$(($time / 60))
    sec=$(($time % 60))
    fi

    tmpcommand=$(cat /proc/$pid/cmdline 2>/dev/null | tr '\0' ' ')

    # Вывод процесса или потока ядра
    if [[ $tmpcommand == "" ]]
    then
        command="["$(cat /proc/$pid/comm 2>/dev/null)"]"
    else
        command=$(cat /proc/$pid/cmdline 2>/dev/null | tr '\0' ' ')
    fi
    
    # Построчный вывод результата на экран
    printf "%5s %-5s %-5s %02d:%02d %s\n" "$pid" "$tty" "$stat" "$min" "$sec" "$command"

done