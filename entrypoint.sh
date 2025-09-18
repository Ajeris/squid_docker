#!/bin/bash
set -e

# Удаляем старый PID файл если он есть
rm -f /var/run/squid/squid.pid

# Создаем swap directories если их нет
if [ ! -d "/var/spool/squid/00" ]; then
    echo "Initializing squid cache directories..."
    squid -z -f /etc/squid/squid.conf
    # Удаляем PID файл после инициализации
    rm -f /var/run/squid/squid.pid
fi

# Запускаем squid
echo "Starting squid..."
exec squid -N -d 1 -f /etc/squid/squid.conf
