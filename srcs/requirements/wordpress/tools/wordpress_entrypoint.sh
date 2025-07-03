#!/bin/bash

# Run the WordPress setup script
/usr/local/bin/setup_wordpress.sh &

# Start PHP-FPM in the foreground
exec php-fpm7.4 -F