# Magic Makefile Help
.PHONY: help
help:
	@cat $(MAKEFILE_LIST) | grep -e "^[a-zA-Z_\-]*: *.*## *" | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# Variables
# ---------
APP_NAME = psql-crypto
REGISTRY_HOST = docker
DOCKER_REPO = dannyma
VERSION = 1.0.1

# Docker Tasks
# ------------
prune: ## Clear out Docker volumes
	docker system prune -f --all

zip-sql: ## zip all .sql files in sql/
	cd sql && tar -zcvf sql.gz *.sql && cd ..

build-nc: zip-sql ## Build the container without caching
	docker build --no-cache -t $(APP_NAME) .

run: build-nc ## Run container
	docker run -i -t --rm --name="$(APP_NAME)" $(APP_NAME) $(task)

psql: ## Run a PSQL shell using running docker - be wary of other containers!
	docker exec -it $(APP_NAME) psql -U postgres

stop: ## Stop container without waiting
	docker kill $(APP_NAME) || true

up-local: ## Spin up docker compose locally
	docker-compose -f docker-compose.debug.yml up --force-recreate --build -d

down-local: ## Shutdown docker compose locally
	docker-compose -f docker-compose.debug.yml down -v --rmi local --remove-orphans

up: ## Spin up docker compose
	docker-compose up --force-recreate -d

down: ## Shutdown docker compose
	docker-compose down -v --remove-orphans

zip-data: ## zip all .csv files in data/
	cd data && tar -zcvf data.gz *.csv && cd ..

# Multi-Arch builds
# -----------------
push: ## Build and push both amd and arm images in same manifest
	docker buildx build --push \
	--platform linux/arm64/v8,linux/amd64 \
	--no-cache --tag $(DOCKER_REPO)/$(APP_NAME):$(VERSION) \
	--tag $(DOCKER_REPO)/$(APP_NAME):latest .