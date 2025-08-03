FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    mariadb-server

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/.

# Create directories with proper ownership
RUN mkdir -p /run/mysqld && \
    chown mysql:mysql /run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql

COPY ./tools/setup.sh /usr/bin/setup.sh

RUN chmod +x /usr/bin/setup.sh

CMD [ "/usr/bin/setup.sh" ]