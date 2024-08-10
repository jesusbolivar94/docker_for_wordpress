FROM php:8.1-apache

# Set working directory
WORKDIR /var/www/html

# Install required PHP extensions for WordPress
RUN apt-get update && apt-get install -y \
    bash \
    curl \
    git \
    autoconf \
    g++ \
    make \
    libtool \
    libfreetype6-dev \
    libjpeg-dev \
    libpng-dev \
    libzip-dev \
    zlib1g-dev \
    libonig-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mbstring zip mysqli pdo pdo_mysql opcache \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug
	
# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Enable Apache mod_rewrite for WordPress permalinks
RUN a2enmod rewrite

# Install Composer (Dependency Manager for PHP)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Expose port 80
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2-foreground"]