.PHONY: help build up down logs clean restart rebuild test health install-deps

# Variables
COMPOSE_FILE := docker-compose.yml

# Colors for output
BLUE := \033[0;34m
GREEN := \033[0;32m
RED := \033[0;31m
YELLOW := \033[1;33m
NC := \033[0m

# Default target - show help
help:
	@echo "$(BLUE)╔═══════════════════════════════════════════════════════════════╗$(NC)"
	@echo "$(BLUE)║         User Management System - Makefile Commands              ║$(NC)"
	@echo "$(BLUE)╚═══════════════════════════════════════════════════════════════╝$(NC)"
	@echo ""
	@echo "$(GREEN)Development Commands:$(NC)"
	@echo "  $(YELLOW)make up$(NC)               - Start all containers"
	@echo "  $(YELLOW)make down$(NC)             - Stop all containers"
	@echo "  $(YELLOW)make build$(NC)            - Build Docker images"
	@echo "  $(YELLOW)make rebuild$(NC)          - Rebuild Docker images from scratch"
	@echo "  $(YELLOW)make restart$(NC)          - Restart all containers"
	@echo "  $(YELLOW)make logs$(NC)             - View logs from all containers"
	@echo "  $(YELLOW)make logs-backend$(NC)     - View backend logs only"
	@echo "  $(YELLOW)make logs-frontend$(NC)    - View frontend logs only"
	@echo "  $(YELLOW)make logs-db$(NC)          - View database logs only"
	@echo ""
	@echo "$(GREEN)Installation & Setup:$(NC)"
	@echo "  $(YELLOW)make install-deps$(NC)     - Install Node dependencies"
	@echo "  $(YELLOW)make install-backend$(NC)  - Install backend dependencies"
	@echo "  $(YELLOW)make install-frontend$(NC) - Install frontend dependencies"
	@echo ""
	@echo "$(GREEN)Testing & Verification:$(NC)"
	@echo "  $(YELLOW)make health$(NC)           - Check health of all containers"
	@echo "  $(YELLOW)make test-api$(NC)         - Test API endpoints"
	@echo "  $(YELLOW)make test-frontend$(NC)    - Test frontend is serving"
	@echo ""
	@echo "$(GREEN)Database Commands:$(NC)"
	@echo "  $(YELLOW)make db-shell$(NC)         - Open MySQL shell"
	@echo "  $(YELLOW)make db-backup$(NC)        - Backup database"
	@echo "  $(YELLOW)make db-restore$(NC)       - Restore database from backup"
	@echo ""

	@echo "$(GREEN)Cleanup & Maintenance:$(NC)"
	@echo "  $(YELLOW)make clean$(NC)            - Remove containers and volumes"
	@echo "  $(YELLOW)make clean-images$(NC)     - Remove Docker images"
	@echo "  $(YELLOW)make prune$(NC)            - Remove unused Docker resources"
	@echo "  $(YELLOW)make clean-all$(NC)        - Complete cleanup (containers, volumes, images)"
	@echo ""
	@echo "$(GREEN)Development:$(NC)"
	@echo "  $(YELLOW)make shell-backend$(NC)    - Open shell in backend container"
	@echo "  $(YELLOW)make shell-frontend$(NC)   - Open shell in frontend container"
	@echo "  $(YELLOW)make inspect-backend$(NC)  - Inspect backend container"
	@echo "  $(YELLOW)make inspect-frontend$(NC) - Inspect frontend container"
	@echo ""
	@echo "$(GREEN)Usage Examples:$(NC)"
	@echo "  $(YELLOW)make up build=true$(NC)    - Build and start containers"
	@echo "  $(YELLOW)make logs-backend follow=$(NC) - Follow backend logs"
	@echo ""

# ============================================================================
# Development Commands
# ============================================================================

## Start all containers
up:
	@echo "$(GREEN)Starting containers...$(NC)"
	docker-compose -f $(COMPOSE_FILE) up -d
	@echo "$(GREEN)✓ Containers started$(NC)"
	@echo "Frontend: http://localhost"
	@echo "API: http://localhost/api/users"

## Stop all containers
down:
	@echo "$(GREEN)Stopping containers...$(NC)"
	docker-compose -f $(COMPOSE_FILE) down
	@echo "$(GREEN)✓ Containers stopped$(NC)"

## Build Docker images
build:
	@echo "$(GREEN)Building images...$(NC)"
	docker-compose -f $(COMPOSE_FILE) build
	@echo "$(GREEN)✓ Images built successfully$(NC)"

## Rebuild Docker images from scratch
rebuild:
	@echo "$(GREEN)Rebuilding images (no cache)...$(NC)"
	docker-compose -f $(COMPOSE_FILE) build --no-cache
	@echo "$(GREEN)✓ Images rebuilt$(NC)"

## Restart all containers
restart: down up
	@echo "$(GREEN)✓ Containers restarted$(NC)"

## View logs from all containers
logs:
	@docker-compose -f $(COMPOSE_FILE) logs -f

## View backend logs
logs-backend:
	@docker-compose -f $(COMPOSE_FILE) logs -f youraws-backend

## View frontend logs
logs-frontend:
	@docker-compose -f $(COMPOSE_FILE) logs -f youraws-frontend

## View database logs
logs-db:
	@docker-compose -f $(COMPOSE_FILE) logs -f youraws-mysql

# ============================================================================
# Installation & Setup
# ============================================================================

## Install all Node dependencies
install-deps: install-backend install-frontend

## Install backend dependencies
install-backend:
	@echo "$(GREEN)Installing backend dependencies...$(NC)"
	cd backend && npm install
	@echo "$(GREEN)✓ Backend dependencies installed$(NC)"

## Install frontend dependencies
install-frontend:
	@echo "$(GREEN)Installing frontend dependencies...$(NC)"
	cd frontend && npm install
	@echo "$(GREEN)✓ Frontend dependencies installed$(NC)"

# ============================================================================
# Testing & Verification
# ============================================================================

## Check health of all containers
health:
	@echo "$(GREEN)Checking container health...$(NC)"
	@docker-compose -f $(COMPOSE_FILE) ps
	@echo ""
	@echo "$(GREEN)Testing API health check...$(NC)"
	@curl -s http://localhost/api/health && echo "" && echo "$(GREEN)✓ API is healthy$(NC)" || echo "$(RED)✗ API is not responding$(NC)"

## Test API endpoints
test-api:
	@echo "$(GREEN)Testing API endpoints...$(NC)"
	@echo ""
	@echo "$(YELLOW)1. GET /api/users$(NC)"
	@curl -s -w "\nStatus: %{http_code}\n" http://localhost/api/users | head -20
	@echo ""
	@echo "$(YELLOW)2. GET /api/users/1$(NC)"
	@curl -s -w "\nStatus: %{http_code}\n" http://localhost/api/users/1
	@echo ""
	@echo "$(GREEN)✓ API tests completed$(NC)"

## Test frontend is serving
test-frontend:
	@echo "$(GREEN)Testing frontend...$(NC)"
	@curl -s -I http://localhost | head -5
	@echo "$(GREEN)✓ Frontend is responding$(NC)"

# ============================================================================
# Database Commands
# ============================================================================

## Open MySQL shell
db-shell:
	@echo "$(GREEN)Opening MySQL shell...$(NC)"
	docker-compose -f $(COMPOSE_FILE) exec mysql mysql -u youraws_user -p youraws_db

## Backup database
db-backup:
	@echo "$(GREEN)Creating database backup...$(NC)"
	@mkdir -p ./backups
	@docker-compose -f $(COMPOSE_FILE) exec -T mysql mysqldump -u youraws_user -p youraws_db > ./backups/backup_$(shell date +%Y%m%d_%H%M%S).sql
	@echo "$(GREEN)✓ Backup created$(NC)"

## Restore database from latest backup
db-restore:
	@echo "$(YELLOW)Restoring database...$(NC)"
	@LATEST_BACKUP=$$(ls -t ./backups/*.sql | head -1); \
	if [ -z "$$LATEST_BACKUP" ]; then \
		echo "$(RED)No backup found$(NC)"; \
		exit 1; \
	fi; \
	docker-compose -f $(COMPOSE_FILE) exec -T mysql mysql -u youraws_user -p youraws_db < $$LATEST_BACKUP; \
	echo "$(GREEN)✓ Database restored from $$LATEST_BACKUP$(NC)"

# ============================================================================
# Cleanup & Maintenance
# ============================================================================

## Remove containers and volumes (keeps images)
clean:
	@echo "$(RED)Removing containers and volumes...$(NC)"
	docker-compose -f $(COMPOSE_FILE) down -v
	@echo "$(GREEN)✓ Cleanup complete$(NC)"

## Remove Docker images
clean-images:
	@echo "$(RED)Removing Docker images...$(NC)"
	docker rmi your-aws-backend:latest your-aws-frontend:latest your-aws-mysql:latest 2>/dev/null || true
	@echo "$(GREEN)✓ Images removed$(NC)"

## Remove unused Docker resources
prune:
	@echo "$(RED)Pruning Docker resources...$(NC)"
	docker system prune -f
	@echo "$(GREEN)✓ Prune complete$(NC)"

## Complete cleanup (containers, volumes, and images)
clean-all: clean clean-images prune
	@echo "$(GREEN)✓ Complete cleanup finished$(NC)"

# ============================================================================
# Development & Debugging
# ============================================================================

## Open shell in backend container
shell-backend:
	@echo "$(GREEN)Opening bash shell in backend container...$(NC)"
	docker-compose -f $(COMPOSE_FILE) exec youraws-backend /bin/sh

## Open shell in frontend container
shell-frontend:
	@echo "$(GREEN)Opening bash shell in frontend container...$(NC)"
	docker-compose -f $(COMPOSE_FILE) exec youraws-frontend /bin/sh

## Inspect backend container
inspect-backend:
	@docker inspect youraws-backend | grep -E '"Name"|"Image"|"Status"'

## Inspect frontend container
inspect-frontend:
	@docker inspect youraws-frontend | grep -E '"Name"|"Image"|"Status"'

# ============================================================================
# Utility Commands
# ============================================================================

## Show this help message
show-help: help

## Display Docker version info
docker-info:
	@echo "$(GREEN)Docker Information:$(NC)"
	@docker --version
	@docker-compose --version
	@echo ""

## List all running containers
ps:
	@docker-compose -f $(COMPOSE_FILE) ps

## Display disk usage
disk-usage:
	@echo "$(GREEN)Docker Disk Usage:$(NC)"
	@docker system df

.DEFAULT_GOAL := help
