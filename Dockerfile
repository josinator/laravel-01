FROM php:8.4-fpm

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    libzip-dev \
    libpq-dev \
    nodejs \
    npm

# Limpiar cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Instalar extensiones de PHP
RUN docker-php-ext-install pdo_mysql pdo_pgsql mbstring exif pcntl bcmath gd zip

# Obtener Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Crear usuario para la aplicación
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Copiar archivos existentes de la aplicación con permisos apropiados
COPY --chown=www:www . /var/www

# Cambiar el usuario actual a www
USER www

# Exponer puerto 9000 y iniciar servidor php-fpm
EXPOSE 9000
CMD ["php-fpm"]
