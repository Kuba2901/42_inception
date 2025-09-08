#!/bin/bash
set -e

INIT_MARKER="/var/lib/mysql/.mariadb_initialized"

if [ ! -f "$INIT_MARKER" ]; then

mariadbd-safe &

until mysqladmin ping --silent; do
echo "waiting for mariadb"
  sleep 1
done

echo "set root password and auth plugin"
mariadb -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('${MYSQL_ROOT_PASSWORD}'); FLUSH PRIVILEGES;"

echo "create database and user"
mariadb -u root -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
mariadb -u root -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mariadb -u root -p"${MYSQL_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';"
mariadb -u root -p"${MYSQL_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"

echo "shutdown for clean restart"
mariadb-admin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown

touch "$INIT_MARKER"
else
    echo "database already exist"
fi

echo "starting mariadb"
exec "$@"