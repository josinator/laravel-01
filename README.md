# Laravel Docker Environment

Este proyecto está configurado para ejecutarse en Docker con PHP 8.4.

## Servicios incluidos:
- **PHP 8.4-FPM** con extensiones para Laravel
- **Nginx** como servidor web
- **MySQL 8.0** como base de datos
- **Redis** para cache y sesiones

## Comandos útiles:

### Iniciar el entorno
```bash
docker-compose up -d
```

### Detener el entorno
```bash
docker-compose down
```

### Acceder al contenedor de la aplicación
```bash
docker-compose exec app bash
```

### Instalar Laravel (primera vez)
```bash
docker-compose exec app composer create-project laravel/laravel .
```

### Ejecutar comandos de Artisan
```bash
docker-compose exec app php artisan migrate
docker-compose exec app php artisan make:controller ExampleController
```

### Instalar dependencias
```bash
docker-compose exec app composer install
docker-compose exec app npm install
```

## Acceso:
- **Aplicación**: http://localhost:8080
- **Base de datos**: localhost:3306
- **Redis**: localhost:6379

## Credenciales de la base de datos:
- **Host**: db
- **Database**: laravel
- **Username**: laravel
- **Password**: laravel
- **Root Password**: root
