FROM php:8.1-fpm

# Arguments defined in docker-compose.yml
ARG uid=1000
ENV uid=$uid

ENV CRATER_USER=crater-user

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    libzip-dev \
    libmagickwand-dev \
    mariadb-client

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pecl install imagick \
    && docker-php-ext-enable imagick

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl bcmath gd

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $uid -d /home/$CRATER_USER $CRATER_USER
RUN mkdir -p /home/$CRATER_USER/.composer && \
    chown -R $CRATER_USER:$CRATER_USER /home/$CRATER_USER

RUN rm -rf /var/www

# Set working directory
WORKDIR /var/www

# clone project files
RUN git clone https://github.com/crater-invoice/crater /var/www/
RUN touch .env
RUN chown -R $CRATER_USER:$CRATER_USER /var/www/
RUN chmod 775 storage/framework/
RUN chmod 775 storage/logs/
RUN chmod 775 bootstrap/cache/

COPY --chmod=755 config/docker-entrypoint.sh /docker-entrypoint.sh

# set user to non root
USER $CRATER_USER

VOLUME /var/www

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "php-fpm" ]
