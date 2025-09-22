# Dockerfile

FROM php:8.3-apache

# Installer les extensions nécessaires
RUN apt-get update && apt-get install -y \
    git unzip zip libicu-dev libonig-dev libxml2-dev libzip-dev \
    && docker-php-ext-install intl pdo pdo_mysql zip \
    && a2enmod rewrite \
    && rm -rf /var/lib/apt/lists/*

# Définir le répertoire de travail
WORKDIR /var/www/html

# Copier les fichiers dans le conteneur
COPY . .

# Ajouter /var/www/html comme "safe directory" pour Git (composer)
RUN git config --global --add safe.directory /var/www/html

# Installer Composer depuis l'image officielle
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Installer les dépendances PHP
RUN composer install --no-interaction --optimize-autoloader

# Copier la configuration Apache
COPY docker/vhost.conf /etc/apache2/sites-available/000-default.conf

# Fixer les permissions
RUN chown -R www-data:www-data var

# Exposer le port 80
EXPOSE 80
