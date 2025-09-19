# SQStat Enhanced - Краткий обзор функций

## 🚀 Основные улучшения

### 1. Исправлено обрезание URL
- ✅ В строке **Total** показывается общая скорость всех соединений
- ✅ Формат: `Total: X users and Y connections, Speed: XX.XX Mb/s`

### 3. Исправлено обрезание URL
- ✅ Настройка `SQSTAT_SHOWLEN` теперь работает для **всех** типов URI
- ✅ Поддержка: http://, https://, ftp:// и обычный текст
- ✅ Красивое обрезание с добавлением "..."

### 4. Правильный часовой пояс
- ✅ Время "Created at:" соответствует часовому поясу сервера
- ✅ Автоопределение из системы или ручная настройка
- ✅ Поддержка всех мировых часовых поясов

## 📋 Структура таблицы

```
┌─────────┬─────┬─────────────┬───────────┬──────┬───────┬──────┐
│ User/IP │ URI │ Curr. Speed │ Avg. Speed│ Size │ Speed │ Time │
├─────────┼─────┼─────────────┼───────────┼──────┼───────┼──────┤
│ john    │http…│   2.34 Mb/s │  1.89 Mb/s│ 15MB  0:45 │
│ mary    │https│   1.23 Mb/s │  1.45 Mb/s│ 8MB   0:22 │
├─────────┴─────┴─────────────┴───────────┴──────┴───────┴──────┤
│ Total: 2 users and 2 connections, Speed: 1.6 Mb/s 🆕      │
└──────────────────────────────────────────────────────────────┘
```

🆕 = Новые функции

## ⚙️ Конфигурация

```php
// config.inc.php

// Длина URL для отображения (теперь работает!)
DEFINE("SQSTAT_SHOWLEN", 40);

// Часовой пояс (опционально)
DEFINE("SQSTAT_TIMEZONE", "Europe/Moscow");
```

## 🔧 Быстрая установка (Debian 12)

```bash
# 1. Установка пакетов
sudo apt install apache2 php libapache2-mod-php squid -y

# 2. Копирование файлов в /var/www/html/sqstat/
sudo cp -r sqstat/* /var/www/html/sqstat/

# 3. Настройка прав
sudo chown -R www-data:www-data /var/www/html/sqstat/

# 4. Редактирование config.inc.php под ваши настройки

# 5. Открыть в браузере: http://your-server-ip/sqstat/
```

## 📊 Примеры отображения

**Индивидуальные скорости:**
- `1.06 Mb/s` - активная загрузка
- `0.03 Mb/s` - медленное соединение  
- `-` - нет данных о скорости

- `Speed: 19.60 Mb/s` - общая пропускная способность

**Обрезание URL:**
- Было: `http://very-long-domain-name.com/very/long/path/to/file.zip`
- Стало: `http://very-long-domain-name.com/very/l....`

## 💡 Полезные команды

```bash
# Проверка времени сервера
date

# Настройка часового пояса
sudo timedatectl set-timezone Europe/Moscow

# Проверка состояния Squid
sudo systemctl status squid

# Просмотр логов
sudo tail -f /var/log/apache2/error.log
```
