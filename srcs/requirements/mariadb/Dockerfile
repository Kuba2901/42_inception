# FROM debian:bullseye

# RUN apt-get update && apt-get install -y \
#     mariadb-server \
#     mariadb-client \
#     && rm -rf /var/lib/apt/lists/*

# RUN mkdir -p /var/run/mysqld && \
#     chown -R mysql:mysql /var/run/mysqld && \
#     chmod 777 /var/run/mysqld

# COPY tools/setup.sh /usr/local/bin/setup.sh
# RUN chmod +x /usr/local/bin/setup.sh

# EXPOSE 3306

# CMD ["/usr/local/bin/setup.sh"]

FROM debian:bullseye

RUN apt-get update && apt-get install -y \
	mariadb-server

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/.
COPY ./tools/init.sql /etc/mysql/init.sql

RUN mkdir -p /run/mysqld


CMD [ "mysqld" ]