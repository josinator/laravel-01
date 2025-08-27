# Makefile para gestión del entorno Docker Laravel

.PHONY: help build up down restart logs shell shell-db shell-redis install clean composer npm artisan migrate fresh seed test

# Variables
DOCKER_COMPOSE = docker-compose
PHP_CONTAINER = app
DB_CONTAINER = laravel-db
REDIS_CONTAINER = laravel-redis

# Colores para output
GREEN = \033[0;32m
YELLOW = \033[1;33m
RED = \033[0;31m
NC = \033[0m # No Color

# Comando por defecto
help: ## Mostrar ayuda
	@echo "$(GREEN)Comandos disponibles:$(NC)"
	@echo ""
	@echo "$(YELLOW)🐳 Gestión de Docker:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | grep -E "🐳|⚡|🛠️|🗄️|🔧|📦" | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-15s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(YELLOW)🚀 Laravel/PHP:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | grep -E "🚀|🎯|🌱|🧪" | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-15s$(NC) %s\n", $$1, $$2}'

# Comandos Docker
build: ## 🛠️ Construir las imágenes Docker
	@echo "$(YELLOW)Construyendo imágenes Docker...$(NC)"
	$(DOCKER_COMPOSE) build --no-cache

up: ## ⚡ Levantar todos los contenedores
	@echo "$(YELLOW)Levantando contenedores...$(NC)"
	$(DOCKER_COMPOSE) up -d
	@echo "$(GREEN)✅ Contenedores iniciados!$(NC)"
	@echo "$(GREEN)🌐 Aplicación disponible en: http://localhost:8080$(NC)"

down: ## 🐳 Parar y eliminar contenedores
	@echo "$(YELLOW)Parando contenedores...$(NC)"
	$(DOCKER_COMPOSE) down
	@echo "$(GREEN)✅ Contenedores detenidos!$(NC)"

restart: ## ⚡ Reiniciar todos los contenedores
	@echo "$(YELLOW)Reiniciando contenedores...$(NC)"
	$(DOCKER_COMPOSE) restart
	@echo "$(GREEN)✅ Contenedores reiniciados!$(NC)"

stop: ## 🛑 Parar contenedores sin eliminarlos
	@echo "$(YELLOW)Parando contenedores...$(NC)"
	$(DOCKER_COMPOSE) stop
	@echo "$(GREEN)✅ Contenedores detenidos!$(NC)"

start: ## ▶️ Iniciar contenedores existentes
	@echo "$(YELLOW)Iniciando contenedores...$(NC)"
	$(DOCKER_COMPOSE) start
	@echo "$(GREEN)✅ Contenedores iniciados!$(NC)"

logs: ## 📋 Ver logs de todos los contenedores
	$(DOCKER_COMPOSE) logs -f

status: ## 📊 Ver estado de los contenedores
	@echo "$(YELLOW)Estado de los contenedores:$(NC)"
	$(DOCKER_COMPOSE) ps

# Acceso a contenedores
shell: ## 🔧 Acceder al contenedor PHP (bash)
	@echo "$(YELLOW)Accediendo al contenedor PHP...$(NC)"
	$(DOCKER_COMPOSE) exec $(PHP_CONTAINER) bash

shell-db: ## 🗄️ Acceder a MySQL (cliente mysql)
	@echo "$(YELLOW)Accediendo a MySQL...$(NC)"
	$(DOCKER_COMPOSE) exec $(DB_CONTAINER) mysql -u laravel -p laravel

shell-redis: ## 🔴 Acceder a Redis (redis-cli)
	@echo "$(YELLOW)Accediendo a Redis...$(NC)"
	$(DOCKER_COMPOSE) exec $(REDIS_CONTAINER) redis-cli

# Comandos Laravel
install: ## 🚀 Instalar Laravel en el contenedor
	@echo "$(YELLOW)Instalando Laravel...$(NC)"
	$(DOCKER_COMPOSE) exec $(PHP_CONTAINER) composer create-project laravel/laravel . --prefer-dist
	@echo "$(GREEN)✅ Laravel instalado!$(NC)"

composer: ## 📦 Instalar dependencias de Composer
	@echo "$(YELLOW)Instalando dependencias de Composer...$(NC)"
	$(DOCKER_COMPOSE) exec $(PHP_CONTAINER) composer install
	@echo "$(GREEN)✅ Dependencias instaladas!$(NC)"

npm: ## 📦 Instalar dependencias de NPM
	@echo "$(YELLOW)Instalando dependencias de NPM...$(NC)"
	$(DOCKER_COMPOSE) exec $(PHP_CONTAINER) npm install
	@echo "$(GREEN)✅ Dependencias NPM instaladas!$(NC)"

npm-dev: ## 🎯 Ejecutar npm run dev
	$(DOCKER_COMPOSE) exec $(PHP_CONTAINER) npm run dev

npm-build: ## 🎯 Ejecutar npm run build
	$(DOCKER_COMPOSE) exec $(PHP_CONTAINER) npm run build

npm-watch: ## 🎯 Ejecutar npm run watch
	$(DOCKER_COMPOSE) exec $(PHP_CONTAINER) npm run watch

# Comandos Artisan
artisan: ## 🚀 Ejecutar comando artisan (uso: make artisan cmd="make:controller Test")
	$(DOCKER_COMPOSE) exec $(PHP_CONTAINER) php artisan $(cmd)

migrate: ## 🌱 Ejecutar migraciones
	@echo "$(YELLOW)Ejecutando migraciones...$(NC)"
	$(DOCKER_COMPOSE) exec $(PHP_CONTAINER) php artisan migrate
	@echo "$(GREEN)✅ Migraciones ejecutadas!$(NC)"

fresh: ## 🌱 Refrescar base de datos (migrate:fresh)
	@echo "$(YELLOW)Refrescando base de datos...$(NC)"
	$(DOCKER_COMPOSE) exec $(PHP_CONTAINER) php artisan migrate:fresh
	@echo "$(GREEN)✅ Base de datos refrescada!$(NC)"

seed: ## 🌱 Ejecutar seeders
	@echo "$(YELLOW)Ejecutando seeders...$(NC)"
	$(DOCKER_COMPOSE) exec $(PHP_CONTAINER) php artisan db:seed
	@echo "$(GREEN)✅ Seeders ejecutados!$(NC)"

fresh-seed: ## 🌱 Refrescar BD y ejecutar seeders
	@echo "$(YELLOW)Refrescando BD y ejecutando seeders...$(NC)"
	$(DOCKER_COMPOSE) exec $(PHP_CONTAINER) php artisan migrate:fresh --seed
	@echo "$(GREEN)✅ BD refrescada con seeders!$(NC)"

# Testing
test: ## 🧪 Ejecutar tests de PHPUnit
	@echo "$(YELLOW)Ejecutando tests...$(NC)"
	$(DOCKER_COMPOSE) exec $(PHP_CONTAINER) php artisan test

test-filter: ## 🧪 Ejecutar test específico (uso: make test-filter filter="ExampleTest")
	$(DOCKER_COMPOSE) exec $(PHP_CONTAINER) php artisan test --filter $(filter)

# Limpieza
clean: ## 🧹 Limpiar contenedores, imágenes y volúmenes
	@echo "$(RED)⚠️  Esto eliminará todos los contenedores, imágenes y volúmenes!$(NC)"
	@echo "$(YELLOW)¿Continuar? [y/N]$(NC)" && read ans && [ $${ans:-N} = y ]
	$(DOCKER_COMPOSE) down -v --rmi all
	docker system prune -f
	@echo "$(GREEN)✅ Limpieza completada!$(NC)"

clean-volumes: ## 🧹 Eliminar solo volúmenes
	@echo "$(YELLOW)Eliminando volúmenes...$(NC)"
	$(DOCKER_COMPOSE) down -v
	@echo "$(GREEN)✅ Volúmenes eliminados!$(NC)"

# Setup completo
setup: ## 🚀 Setup completo del proyecto (build + up + install)
	@echo "$(YELLOW)Configurando proyecto completo...$(NC)"
	$(MAKE) build
	$(MAKE) up
	sleep 10
	$(MAKE) install
	$(MAKE) composer
	@echo "$(GREEN)🎉 ¡Proyecto configurado! Disponible en http://localhost:8080$(NC)"

# Backup y restore
backup-db: ## 💾 Hacer backup de la base de datos
	@echo "$(YELLOW)Creando backup de la base de datos...$(NC)"
	$(DOCKER_COMPOSE) exec $(DB_CONTAINER) mysqldump -u laravel -p laravel > backup_$(shell date +%Y%m%d_%H%M%S).sql
	@echo "$(GREEN)✅ Backup creado!$(NC)"
