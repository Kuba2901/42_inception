#!/bin/bash
set -e  # Exit on any error

echo "Starting WordPress setup..."

cd /var/www/html
echo "Current directory: $(pwd)"
echo "Directory contents before setup: $(ls -la)"

echo "Downloading wp-cli..."
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar

echo "Downloading WordPress core..."
./wp-cli.phar core download --allow-root

echo "Directory contents after WordPress download: $(ls -la)"

echo "Creating wp-config.php..."
./wp-cli.phar config create --dbname=wordpress --dbuser=wpuser --dbpass=password --dbhost=mariadb --allow-root

echo "Installing WordPress..."
./wp-cli.phar core install --url=localhost --title=inception --admin_user=admin --admin_password=admin --admin_email=admin@admin.com --allow-root

echo "Setting correct permissions..."
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

echo "Starting PHP-FPM..."
php-fpm7.4 -F