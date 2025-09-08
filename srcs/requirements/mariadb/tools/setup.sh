#!/bin/bash

service mariadb start;

sleep 5;

cat > /tmp/init.sql << 'SQL'
CREATE DATABASE IF NOT EXISTS `${MYSQL_DATABASE}`;
-- Ensure application user exists for remote and localhost connections
CREATE USER IF NOT EXISTS `${MYSQL_USER}`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
CREATE USER IF NOT EXISTS `${MYSQL_USER}`@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';
-- Keep application user password in sync with current env
ALTER USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
ALTER USER '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON `${MYSQL_DATABASE}`.* TO '${MYSQL_USER}'@'%';
GRANT ALL PRIVILEGES ON `${MYSQL_DATABASE}`.* TO '${MYSQL_USER}'@'localhost';
-- Ensure local root uses password auth (disable unix_socket for root@localhost)
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
-- Keep remote root user in sync as well
CREATE USER IF NOT EXISTS 'root'@'%';
ALTER USER 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
SQL

# Prefer password auth; fall back to socket/no-password for first boot
if mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "SELECT 1" >/dev/null 2>&1; then
    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" < /tmp/init.sql
else
    mysql -u root < /tmp/init.sql
fi

# Clean shutdown of the temp server before starting mysqld_safe
if mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "SELECT 1" >/dev/null 2>&1; then
    mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown;
else
    mysqladmin -u root shutdown;
fi

exec mysqld_safe;