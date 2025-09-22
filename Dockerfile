# Utiliser l'image PHP officielle avec FPM
FROM php:8.3-fpm

# Installer les dépendances système nécessaires
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    && docker-php-ext-install zip

# Installer Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Créer un utilisateur non-root pour exécuter l'application
RUN useradd -ms /bin/bash symfonyuser
USER symfonyuser

# Définir le répertoire de travail
WORKDIR /var/www/html

# Copier tous les fichiers de ton projet dans le conteneur Docker
COPY . /var/www/html

# Installer les dépendances via Composer sans exécuter les scripts Symfony et sans plugins
RUN composer install --no-dev --optimize-autoloader --no-plugins --no-scripts

# Exposer le port 8000 pour l'application
EXPOSE 8000

# Commande pour démarrer l'application PHP en mode serveur web interne
CMD ["php", "-S", "0.0.0.0:8000", "-t", "public"]
