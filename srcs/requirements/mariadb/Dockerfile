FROM debian:bullseye

RUN apt-get update && apt-get install -y \
	mariadb-server

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/.

RUN mkdir -p /run/mysqld

COPY ./tools/setup.sh /usr/bin/setup.sh

RUN chmod +x /usr/bin/setup.sh

CMD [ "/usr/bin/setup.sh" ]
