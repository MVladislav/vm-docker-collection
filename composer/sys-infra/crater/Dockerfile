FROM php:8.1-fpm

# Arguments defined in docker-compose.yml
ARG user
ARG uid
ENV uid=$uid

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
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

RUN rm -rf /var/www

# Set working directory
WORKDIR /var/www

# clone project files
RUN git clone https://github.com/crater-invoice/crater /var/www/
RUN touch .env
RUN chown -R $user:$user /var/www/
RUN chmod 775 storage/framework/
RUN chmod 775 storage/logs/
RUN chmod 775 bootstrap/cache/

COPY --chmod=755 config/docker-entrypoint.sh /docker-entrypoint.sh

# set user to non root
USER $user

# # init project
# RUN composer install --no-interaction --prefer-dist --optimize-autoloader
# RUN php artisan storage:link || true

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "php-fpm" ]
