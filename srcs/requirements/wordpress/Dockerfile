FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update -y && \
    apt upgrade -y && \
    apt install -y \
    php-fpm \
    php-mysql \
    php-cli \
    php-curl \
    php-gd \
    php-mbstring \
    php-xml \
    php-zip \
    wget \
    vim \
    mariadb-client && \
    rm -rf /var/lib/apt/lists/*

# Install WordPress CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Download WordPress
RUN mkdir -p /var/www/html && \
	wget https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz && \
    tar -xzf /tmp/wordpress.tar.gz -C /var/www/html && \
    rm /tmp/wordpress.tar.gz

# Set proper permissions for WordPress files
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Create the directory for PHP-FPM PID file and set permissions
RUN mkdir -p /run/php/ && \
    chown www-data:www-data /run/php/ && \
    chmod 755 /run/php/

# Copy custom WordPress configuration script
COPY ./tools/setup_wordpress.sh /usr/local/bin/setup_wordpress.sh
RUN chmod +x /usr/local/bin/setup_wordpress.sh

# Copy php-fpm configuration
COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# Use a custom entrypoint script to ensure MariaDB is ready before WordPress setup
COPY ./tools/wordpress_entrypoint.sh /usr/local/bin/wordpress_entrypoint.sh
RUN chmod +x /usr/local/bin/wordpress_entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/wordpress_entrypoint.sh"]