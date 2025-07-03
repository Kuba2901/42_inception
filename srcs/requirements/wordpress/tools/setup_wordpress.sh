#!/bin/bash

# src/requirements/wordpress/tools/setup_wordpress.sh

# Wait for MariaDB to be ready
echo "Waiting for MariaDB..."
while ! mariadb -h mariadb -u "${MYSQL_USER}" -p"${MYSQL_PASSWORD}" -e "SELECT 1;" > /dev/null 2>&1; do
    sleep 2
done
echo "MariaDB is up!"

# Navigate to WordPress directory
cd /var/www/html/wordpress

# Create wp-config.php if it doesn't exist
if [ ! -f wp-config.php ]; then
    wp config create \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --dbhost=mariadb \
        --allow-root

    # Install WordPress
    wp core install \
        --url="${WORDPRESS_URL}" \
        --title="${WORDPRESS_TITLE}" \
        --admin_user="${WORDPRESS_ADMIN_USER}" \
        --admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
        --admin_email="${WORDPRESS_ADMIN_EMAIL}" \
        --allow-root

    echo "WordPress installed successfully!"
else
    echo "wp-config.php already exists, skipping WordPress installation."
fi

# Ensure correct permissions for WordPress files
chown -R www-data:www-data /var/www/html/wordpress
chmod -R 755 /var/www/html/wordpress