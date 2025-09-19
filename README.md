# Squid Proxy Docker Setup

![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Squid](https://img.shields.io/badge/Squid-Proxy-blue?style=for-the-badge)

## 🌍 Language / Язык
- [English](#english)
- [Русский](#русский)

---

# English

## Description
This configuration creates a Docker container with Squid proxy based on stable Debian with support for:
- squid-openssl (stable version)
- Kerberos authentication
- LDAP authentication

## Quick Start
```bash
# Clone the repository
git clone https://github.com/Ajeris/squid_docker.git
cd squid_docker

# Build and start
docker-compose up -d --build

# Check logs
docker-compose logs -f squid
```

## File Structure
```
.
├── docker-compose.yml    # Docker Compose configuration
├── Dockerfile           # Squid build instructions
├── apache/              # Apache analyzer service
│   ├── Dockerfile      # Apache build instructions
│   └── entrypoint-apache.sh # Apache startup script
├── config/
│   ├── squid.conf      # Squid configuration
│   └── apache/          # Apache configuration
├── config/squidanalyzer/  # SquidAnalyzer configuration
├── cache/              # Cache directory (auto-created)
├── logs/               # Logs directory
├── .dockerignore       # Docker build exclusions
├── .gitignore          # Git exclusions
└── LICENSE            # MIT License
```

## Usage

### Basic Commands
```bash
# Build and start
docker-compose up -d --build

# View logs
docker-compose logs -f squid

# Stop
docker-compose down

# Restart with rebuild
docker-compose down && docker-compose up -d --build
```

### Authentication Setup

#### Kerberos
Uncomment the corresponding lines in `config/squid.conf`:
```
auth_param negotiate program /usr/lib/squid/negotiate_kerberos_auth -s GSS_C_NO_NAME
auth_param negotiate children 10
auth_param negotiate keep_alive on
acl authenticated proxy_auth REQUIRED
```

#### LDAP
Uncomment and configure lines in `config/squid.conf`:
```
auth_param basic program /usr/lib/squid/basic_ldap_auth -R -b "dc=example,dc=com" -D "cn=squid,ou=services,dc=example,dc=com" -w "password" -f sAMAccountName=%s -h ldap.example.com
auth_param basic children 5
auth_param basic realm Squid proxy-caching web server
auth_param basic credentialsttl 2 hours
acl ldap_users proxy_auth REQUIRED
```

## Services

### Squid Proxy
- **Port 3128**: HTTP proxy
- **Port 3129**: HTTPS proxy (requires SSL certificates)

### Log Analysis Web Interface
- **Port 8080**: Apache server with SquidAnalyzer and SqStat
- **URL**: http://localhost:8080/
- **SquidAnalyzer**: http://localhost:8080/squidanalyzer/
- **SqStat**: http://localhost:8080/sqstat/

### Log Analysis Tools
- **SquidAnalyzer**: Comprehensive Squid log analyzer with detailed reports
- **SqStat**: Real-time PHP-based Squid statistics monitoring

## Configuration

### SquidAnalyzer Configuration

The SquidAnalyzer configuration is stored in `config/squidanalyzer/squidanalyzer.conf`. You can modify this file to customize:

- Log file paths
- Output directories
- Analysis parameters
- Language settings
- Exclusions and filters

### Installing Analysis Tools

By default, the apache container includes placeholder pages. To install the actual tools:

1. **SquidAnalyzer**: Uncomment the wget section in `apache/Dockerfile` or install manually
2. **SqStat**: Replace the placeholder in `/var/www/html/sqstat/` with the actual PHP application

The configuration files are externally mounted for easy customization.

## Notes
- For HTTPS functionality, add SSL certificates to `/etc/squid/ssl/` directory
- Logs are saved in `logs/` directory
- Cache is saved in `cache/` directory
- Configuration can be modified in `config/squid.conf`

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

# Русский

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

## Сервисы

### Squid Proxy
- **Порт 3128**: HTTP proxy
- **Порт 3129**: HTTPS proxy (требует SSL сертификаты)

### Веб-интерфейс анализа логов
- **Порт 8080**: Apache сервер с SquidAnalyzer и SqStat
- **URL**: http://localhost:8080/
- **SquidAnalyzer**: http://localhost:8080/squidanalyzer/
- **SqStat**: http://localhost:8080/sqstat/

### Инструменты анализа логов
- **SquidAnalyzer**: Полнофункциональный анализатор логов с детальными отчётами
- **SqStat**: PHP-приложение для мониторинга статистики Squid в реальном времени

## Конфигурация

### Конфигурация SquidAnalyzer

### Настройка SqStat

SqStat - это PHP-приложение для мониторинга статистики Squid в реальном времени через cachemgr интерфейс.

#### Конфигурация Squid для SqStat

В файле `config/squid.conf` уже настроены необходимые параметры для работы SqStat:

```bash
# Docker network ACLs for SqStat access
acl localhost src 127.0.0.1/32 ::1                    # localhost for cachemgr access
acl docker_net src 192.168.64.0/20                    # Docker network subnet
acl squid_apache_analyzer src 192.168.64.3/32         # squid-apache-analyzer container IP
acl squid_apache_analyzer_service host squid-apache-analyzer  # by service name

# Cache Manager access control for SqStat
# Разрешаем cachemgr только для localhost и squid-apache-analyzer контейнера
http_access allow manager localhost
http_access allow manager squid_apache_analyzer
http_access allow manager squid_apache_analyzer_service
http_access deny manager

# Cache Manager password for SqStat access
# Пароль для доступа к cachemgr интерфейсу (используется SqStat)
cachemgr_passwd squid_stats all
```

#### Настройка SqStat

1. **Автоматическая конфигурация**: При первом запуске контейнер создает базовую конфигурацию SqStat
2. **Доступ к cachemgr**: Настроен доступ по имени службы Docker (`squid-proxy-service`)
3. **Пароль cachemgr**: `squid_stats` (можно изменить в `squid.conf`)

#### Параметры подключения SqStat

- **Squid Host**: `squid-proxy-service` (имя службы Docker)
- **Squid Port**: `3128`
- **CacheMgr Password**: `squid_stats`

#### Доступ к SqStat

После запуска контейнеров SqStat будет доступен по адресу:
- http://localhost:8076/sqstat/

#### Устранение неполадок SqStat

Если SqStat не может подключиться к Squid:

1. **Проверьте сеть Docker**:
   ```bash
   docker network inspect squid-proxy-service_squid-net
   ```

2. **Проверьте IP адреса контейнеров**:
   ```bash
   docker inspect squid-proxy | grep IPAddress
   docker inspect squid-apache-analyzer | grep IPAddress
   ```

3. **Проверьте логи Squid**:
   ```bash
   docker logs squid-proxy
   ```

4. **Обновите ACL в squid.conf** если IP адреса изменились:
   ```bash
   # Найти новый IP apache-analyzer контейнера
   APACHE_IP=$(docker inspect squid-apache-analyzer | grep '"IPAddress"' | head -1 | cut -d'"' -f4)
   echo "Apache Analyzer IP: $APACHE_IP"
   
   # Обновить squid.conf с новым IP
   sed -i "s/acl squid_apache_analyzer src [0-9.]*/acl squid_apache_analyzer src $APACHE_IP/" config/squid.conf
   
   # Перезапустить Squid
   docker-compose restart squid-proxy-service
   ```

#### Альтернативный способ доступа

Если возникают проблемы с Docker DNS, можно настроить SqStat для подключения по внешнему IP:
- **Squid Host**: `host.docker.internal` или `localhost`
- **Squid Port**: `8078` (внешний порт)


Конфигурация SquidAnalyzer хранится в `config/squidanalyzer/squidanalyzer.conf`. Вы можете изменить этот файл для настройки:

- Пути к файлам логов
- Директории вывода
- Параметры анализа
- Настройки языка
- Исключения и фильтры

### Установка инструментов анализа

По умолчанию apache контейнер содержит страницы-заглушки. Для установки реальных инструментов:

1. **SquidAnalyzer**: Раскомментируйте wget секцию в `apache/Dockerfile` или установите вручную
2. **SqStat**: Замените заглушку в `/var/www/html/sqstat/` реальным PHP приложением

Конфигурационные файлы монтируются снаружи для лёгкой настройки.

## Примечания
- Для HTTPS функциональности необходимо добавить SSL сертификаты в директорию `/etc/squid/ssl/`
- Логи сохраняются в директории `logs/`
- Кеш сохраняется в директории `cache/`
- Конфигурацию можно изменить в файле `config/squid.conf`
