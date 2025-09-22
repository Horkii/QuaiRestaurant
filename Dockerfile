# Étape 1 : Utilisation de l'image PHP de base
FROM php:8.3-fpm

# Étape 2 : Installation des dépendances système nécessaires
RUN apt-get update && apt-get install -y \
    libicu-dev \
    libxml2-dev \
    unzip \
    git \
    && docker-php-ext-install intl xml pdo pdo_mysql

# Étape 3 : Installation de Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Étape 4 : Copie des fichiers du projet dans le conteneur
WORKDIR /var/www/html
COPY . .

# Étape 5 : Installation des dépendances PHP via Composer
RUN composer install --no-dev --optimize-autoloader

# Étape 6 : Exposition du port 8000
EXPOSE 8000

# Étape 7 : Lancement de Symfony
CMD ["php", "bin/console", "server:run", "0.0.0.0:8000"]
