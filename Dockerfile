FROM debian:stable-slim

# Устанавливаем переменные окружения
ENV DEBIAN_FRONTEND=noninteractive

# Обновляем список пакетов и устанавливаем необходимые пакеты
RUN apt-get update && apt-get install -y \
    squid-openssl \
    krb5-user \
    libkrb5-dev \
    libsasl2-modules-gssapi-mit \
    libldap2-dev \
    ldap-utils \
    sasl2-bin \
    supervisor \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Создаем необходимые директории
RUN mkdir -p /var/spool/squid \
    && mkdir -p /var/log/squid \
    && mkdir -p /etc/squid/conf.d \
    && mkdir -p /var/run/squid

# Устанавливаем права доступа для squid
RUN chown -R proxy:proxy /var/spool/squid \
    && chown -R proxy:proxy /var/log/squid \
    && chown -R proxy:proxy /etc/squid \
    && chown -R proxy:proxy /var/run/squid

# Копируем конфигурационный файл squid и entrypoint скрипт
COPY config/squid.conf /etc/squid/squid.conf
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Устанавливаем права на entrypoint скрипт
RUN chmod +x /usr/local/bin/entrypoint.sh

# Переходим к пользователю proxy
USER proxy

# Открываем порты
EXPOSE 3128 3129

# Устанавливаем entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
