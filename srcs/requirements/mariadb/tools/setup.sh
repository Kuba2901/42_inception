#!/bin/bash

# Only initialize if database doesn't exist
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Database not initialized. Setting up MariaDB..."
    
    # Initialize the database structure
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
    
    # Start mysqld in safe mode for initialization
    mysqld --user=mysql --skip-networking --socket=/run/mysqld/mysqld.sock &
    MYSQL_PID=$!
    
    # Wait for MySQL to start
    echo "Waiting for MySQL to start..."
    until mysqladmin ping --socket=/run/mysqld/mysqld.sock --silent; do
        sleep 1
    done
    
    echo "MySQL is ready, running initialization..."
    
    # Run initialization commands
    mysql --socket=/run/mysqld/mysqld.sock << EOF
CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%';
GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'localhost';
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
FLUSH PRIVILEGES;
EOF
    
    # Stop the temporary mysqld process
    kill $MYSQL_PID
    wait $MYSQL_PID 2>/dev/null
    
    echo "MariaDB initialization complete."
else
    echo "Database already initialized, skipping setup."
fi

# Start mysqld normally as the main process
echo "Starting MariaDB server..."
exec mysqld --user=mysql --socket=/run/mysqld/mysqld.sock