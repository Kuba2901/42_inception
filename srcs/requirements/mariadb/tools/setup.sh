#!/bin/bash

INIT_FILE="/etc/mysql/init.sql"

# Check if init file exists, create it if not
if [ ! -f "$INIT_FILE" ]; then
	echo "Initialization file doesn't exist. Creating..."
	touch $INIT_FILE
else
	echo "Initialization file already exists, appending to it."
	# Clear the file to avoid duplicate entries on restart
	> $INIT_FILE
fi

# MYSQL_ROOT_PASSWORD

echo "CREATE DATABASE $MYSQL_DATABASE;" >> $INIT_FILE

echo "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" >> $INIT_FILE

echo "GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_USER'@'%' WITH GRANT OPTION;" >> $INIT_FILE

echo "FLUSH PRIVILEGES;" >> $INIT_FILE

# Run mysqld with the initialization file
echo "Running mysqld with the initialization file"
mysqld --init-file=$INIT_FILE