# FROM debian:bullseye

# RUN apt-get update && apt-get install -y \
#     nginx \
#     openssl \
#     && rm -rf /var/lib/apt/lists/*

# RUN mkdir -p /etc/nginx/ssl

# RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
#     -keyout /etc/nginx/ssl/nginx.key \
#     -out /etc/nginx/ssl/nginx.crt \
#     -subj "/C=IT/ST=Rome/L=Rome/O=42/OU=42/CN=${DOMAIN_NAME}"

# COPY conf/nginx.conf /etc/nginx/nginx.conf

# EXPOSE 443

# CMD ["nginx", "-g", "daemon off;"]

FROM debian:bullseye

RUN apt-get update && apt-get install -y \
	nginx \
	openssl

COPY conf/nginx.conf /etc/nginx/sites-available/default

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj \
"/C=IT/ST=RM/L=Rome/O=42/OU=42/CN=jnenczak.42.fr/UID=jnenczak"

CMD [ "nginx", "-g", "daemon off;" ]
