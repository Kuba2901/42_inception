#!/bin/bash

# Wait for MariaDB to be ready before continuing
wait_for_mariadb() {
	echo "Waiting for MariaDB to be ready..."
	
	while ! mysqladmin ping -h mariadb -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" --silent > /dev/null 2>&1; do
		echo "MariaDB not ready yet, waiting 5 seconds..."
		sleep 5
	done
	
	echo "MariaDB is ready!"
}

# Call the function
wait_for_mariadb

set -e  # Exit on any error

echo "Starting WordPress setup..."

cd /var/www/html
echo "Current directory: $(pwd)"
echo "Directory contents before setup: $(ls -la)"

# Check if WordPress is already downloaded
if [ ! -d "wp-content" ]; then
	echo "WordPress not found. Downloading..."
	
	echo "Downloading wp-cli..."
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x wp-cli.phar

	echo "Downloading WordPress core..."
	./wp-cli.phar core download --allow-root

	echo "Creating wp-config.php..."
	./wp-cli.phar config create --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=mariadb:3306 --allow-root

	echo "Installing WordPress..."
	./wp-cli.phar core install --url=$DOMAIN_NAME --title=inception --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL --allow-root

	echo "Creating additional user..."
	./wp-cli.phar user create $WP_USER $WP_USER_EMAIL --user_pass=$WP_USER_PASSWORD --allow-root
else
	echo "WordPress already installed, skipping installation..."
fi

echo "Setting correct permissions..."
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

echo "Starting PHP-FPM..."
php-fpm7.4 -F