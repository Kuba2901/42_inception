#!/bin/bash

# src/requirements/mariadb/tools/setup_mariadb.sh

# Only proceed with setup if the database directory is empty,
# indicating a fresh container start.
# This prevents re-initialization on subsequent container restarts.
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB..."
    # Initialize MariaDB data directory if it's a fresh volume
    mysql_install_db --user=mysql --ldata=/var/lib/mysql > /dev/null 2>&1

    # Start mariadbd temporarily to perform initial setup
    /usr/bin/mysqld_safe --datadir=/var/lib/mysql &
    PID=$! # Capture PID of the background process

    # Wait for MariaDB to be fully up
    echo "Waiting for MariaDB to start for initial setup..."
    while ! mysqladmin ping -h localhost --silent; do
        sleep 1
    done
    echo "MariaDB temporary server started."

    # Secure installation steps for MariaDB
    # Set root password
    mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
    
    # Remove anonymous users
    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "DELETE FROM mysql.user WHERE User='';"
    
    # Disallow remote root login (optional but good practice)
    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
    
    # Remove test database
    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "DROP DATABASE IF EXISTS test;"
    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
    
    # Create WordPress database and user
    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%' WITH GRANT OPTION;"
    
    # Flush privileges
    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"
    
    echo "MariaDB database and user created successfully."

    # Stop the temporary MariaDB server
    kill "$PID"
    wait "$PID" # Wait for the process to terminate
    echo "Temporary MariaDB server stopped."
else
    echo "MariaDB data directory already exists. Skipping initialization."
fi

# Finally, start MariaDB in the foreground to keep the container alive
echo "Starting MariaDB in foreground..."
exec /usr/bin/mysqld_safe --datadir=/var/lib/mysql