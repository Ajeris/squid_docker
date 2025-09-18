# Squid Proxy Docker Setup

## Описание
Данная конфигурация создает Docker-контейнер с Squid proxy на базе стабильной версии Debian с поддержкой:
- squid-openssl (стабильная версия)
- Kerberos аутентификация
- LDAP аутентификация

## Структура файлов
```
.
├── docker-compose.yml    # Конфигурация Docker Compose
├── Dockerfile           # Инструкции сборки образа
├── config/
│   └── squid.conf      # Конфигурация Squid
├── cache/              # Директория кеша (будет создана автоматически)
├── logs/               # Директория логов
└── .dockerignore       # Исключения для Docker build
```

## Использование

### 1. Сборка и запуск
```bash
docker-compose up -d --build
```

### 2. Просмотр логов
```bash
docker-compose logs -f squid
```

### 3. Остановка
```bash
docker-compose down
```

### 4. Перезапуск с пересборкой
```bash
docker-compose down
docker-compose up -d --build
```

## Настройка аутентификации

### Kerberos
Раскомментируйте соответствующие строки в `config/squid.conf`:
```
auth_param negotiate program /usr/lib/squid/negotiate_kerberos_auth -s GSS_C_NO_NAME
auth_param negotiate children 10
auth_param negotiate keep_alive on
acl authenticated proxy_auth REQUIRED
```

### LDAP  
Раскомментируйте и настройте строки в `config/squid.conf`:
```
auth_param basic program /usr/lib/squid/basic_ldap_auth -R -b "dc=example,dc=com" -D "cn=squid,ou=services,dc=example,dc=com" -w "password" -f sAMAccountName=%s -h ldap.example.com
auth_param basic children 5
auth_param basic realm Squid proxy-caching web server
auth_param basic credentialsttl 2 hours
acl ldap_users proxy_auth REQUIRED
```

## Порты
- 3128: HTTP proxy
- 3129: HTTPS proxy (требует SSL сертификаты)

## Примечания
- Для HTTPS функциональности необходимо добавить SSL сертификаты в директорию `/etc/squid/ssl/`
- Логи сохраняются в директории `logs/`
- Кеш сохраняется в директории `cache/`
- Конфигурацию можно изменить в файле `config/squid.conf`
