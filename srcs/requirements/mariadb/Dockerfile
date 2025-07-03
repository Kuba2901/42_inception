FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update -y && apt upgrade -y

RUN apt install -y \
	mariadb-server && \
	rm -rf /var/lib/apt/lists/*

# Copy script to initialize database
COPY ./tools/setup_mariadb.sh /usr/local/bin/setup_mariadb.sh
RUN chmod +x /usr/local/bin/setup_mariadb.sh

# Copy MariaDB configuration file
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Ensure MariaDB data directory exists and has correct permissions
RUN mkdir -p /var/lib/mysql && \
	chown -R mysql:mysql /var/lib/mysql && \
	chmod -R 755 /var/lib/mysql

# Run initialization script when container starts
CMD [ "/usr/local/bin/setup_mariadb.sh" ]