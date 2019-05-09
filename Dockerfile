FROM alpine:latest
LABEL maintainer="Damien Guihal <dguihal@gmail.com>"

# Define Grav version and expected SHA1 signature
ENV GRAV_VERSION 1.6.9

EXPOSE 80

# Install dependencies
RUN apk update && \
    apk add --no-cache curl \
    unzip \
    apache2 \
    apache2-utils \
    php7 \
    php7-apache2 \
    php7-apcu \
    php7-curl \
    php7-ctype \
    php7-dom \
    php7-gd \
    php7-json \
    php7-mbstring \
    php7-opcache \
    php7-openssl \
    php7-session \
    php7-simplexml \
    php7-xml \
    php7-yaml \
    php7-zip

# Add apache to run and configure
RUN mkdir -p /run/apache2 \
    && sed -i "s/#LoadModule\ rewrite_module/LoadModule\ rewrite_module/" /etc/apache2/httpd.conf && \
    printf "\n<Directory \"/var/www/localhost/htdocs\">\n\tAllowOverride All\n</Directory>\n" >> /etc/apache2/httpd.conf

# Install grav
WORKDIR /var/www/localhost/
RUN rm -rf htdocs && \
    curl -o grav-admin.zip -SL https://getgrav.org/download/core/grav-admin/${GRAV_VERSION} && \
    unzip grav-admin.zip && \
    chown -R apache: grav-admin && \
    mv grav-admin htdocs && \
    rm grav-admin.zip

# Return to root user
USER root

COPY start.sh /start.sh
RUN chmod 0555 /start.sh

ENTRYPOINT [ "/start.sh" ]