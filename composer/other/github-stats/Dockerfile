# ===============================
# Stage 1: Node build for github-readme-stats
# ===============================
FROM node:24.12.0-alpine AS stats-builder

# Workdir
WORKDIR /app/stats

# Install git
RUN apk add --no-cache git

# Clone repo
RUN git clone --depth=1 https://github.com/anuraghazra/github-readme-stats.git .

# Promote express from dev → prod
RUN npm pkg set dependencies.express="latest" && npm install

# ===============================
# Final image: PHP+Apache + Node runtime + Deno + apps
# ===============================
FROM php:8.3-apache@sha256:6be4ef702b2dd05352f7e5fe14667696a4ad091c9d2ad9083becbee4300dc3b1

# System deps + node/npm + supervisor + utilities
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git curl unzip ca-certificates \
        libicu-dev inkscape fonts-dejavu-core \
      supervisor nodejs npm \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install composer
COPY --from=composer/composer:latest-bin /composer /usr/bin/composer

# ===============================
# Streak (PHP) clone & composer install
# ===============================
WORKDIR /opt/streak
RUN git clone --depth=1 https://github.com/DenverCoder1/github-readme-streak-stats.git . && \
    composer install --no-dev --optimize-autoloader --no-scripts

# Move streak into Apache subfolder with vendor
RUN mkdir -p /var/www/html/streak && \
    cp -r src vendor /var/www/html/streak/ && \
    chown -R www-data:www-data /var/www/html

# ===============================
# Copy GitHub-Readme-Stats from builder
# ===============================
COPY --from=stats-builder /app/stats /opt/stats
RUN chown -R www-data:www-data /opt/stats

# -----------------------
# Github Profile Trophy (Deno) clone (no build stage, Deno caches on run)
# -----------------------
WORKDIR /opt/trophy
RUN git clone --depth=1 https://github.com/ryo-ma/github-profile-trophy.git .

# Install Deno to /usr/local (so binary is at /usr/local/bin/deno)
ENV DENO_INSTALL=/usr/local
RUN curl -fsSL https://deno.land/install.sh | sh -s v1.45.0
RUN deno cache main.ts
RUN chown -R www-data:www-data /opt/trophy

# ===============================
# Apache config + modules
# ===============================
COPY config/apache.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite headers proxy proxy_http deflate

# ===============================
# Supervisor + entrypoint
# ===============================
COPY config/supervisord.conf /etc/supervisor/supervisord.conf
COPY config/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# # Ensure permissions for Apache & runtimes
# RUN chown -R www-data:www-data /var/www/html /opt/stats /opt/streak /opt/trophy

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
