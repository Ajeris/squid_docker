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
├── Dockerfile           # Build instructions
├── config/
│   └── squid.conf      # Squid configuration
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

## Ports
- **3128**: HTTP proxy
- **3129**: HTTPS proxy (requires SSL certificates)

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

## Порты
- 3128: HTTP proxy
- 3129: HTTPS proxy (требует SSL сертификаты)

## Примечания
- Для HTTPS функциональности необходимо добавить SSL сертификаты в директорию `/etc/squid/ssl/`
- Логи сохраняются в директории `logs/`
- Кеш сохраняется в директории `cache/`
- Конфигурацию можно изменить в файле `config/squid.conf`
##  Собранная версия docker-compose.yml
...yaml
version: "3.9"

services:
  squid:
    image: ajeris/squid_docker:latest
    container_name: squid-proxy
    ports:
      - "3128:3128"
      # - "3129:3129" # enable only if SSL-bump is required
    volumes:
      - ./config:/etc/squid
      - ./cache:/var/spool/squid
      - ./logs:/var/log/squid
    environment:
      TZ: Asia/Qyzylorda
    entrypoint: >
      sh -c "if [ ! -d /var/spool/squid/00 ]; then
               echo 'Initializing Squid cache...';
               squid -z;
             fi &&
             exec squid -N -d 1"
    restart: unless-stopped
    networks:
      - squid-net

networks:
  squid-net:
    driver: bridge
...
