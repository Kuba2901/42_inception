FROM debian:11.11

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update -y && apt upgrade -y

RUN apt install -y \
	nginx \
	openssl \
	&& rm -rf /var/lib/apt/lists/*

# Copy Custom NGINX configuration
COPY ./conf/nginx.conf /etc/nginx/sites-available/default
RUN chmod 644 /etc/nginx/sites-available/default

# Link the default site to be enabled
RUN ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# Generate SSL certificate and Key
# This should be automated or securely handled in a real project, but for this exercise, we generate a self-signed one
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/ssl/certs/nginx-key.pem \
	-out /etc/ssl/certs/nginx-certificate.pem \
	-subj "/C=IT/ST=Lazio/L=Rome/O=Inception/OU=42/CN=${DOMAIN_NAME}"

# Ensure correct permissions for SSL files
RUN chmod 600 /etc/ssl/certs/nginx-key.pem && \
	chmod 644 /etc/ssl/certs/nginx-certificate.pem

EXPOSE 443

# Start NGINX in the foreground
CMD ["nginx", "-g", "daemon off;"]