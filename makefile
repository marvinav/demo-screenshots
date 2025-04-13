-include config/.makerc

## !!! Override make environment variables in .makerc file !!!
# Environment
NODE_ENV	?=development
PROJECT_NAME	?=demo-screenshot# Project name
HOST_DOCKER_PATH	?=/tmp/builds/# Directory on the host where to put builds
TARGET	?=development# Environment target. Ensure to have .env.TATGET and docker-compose.TARGET.yml files
TAG	?=latest# Tag version docker images		

# Calculated and internal env. DO NOT OVERRIDE
MAKEFLAGS	+= --no-print-directory
SHELL	:=/bin/bash
COMPOSE_PROJECT_NAME	=${PROJECT_NAME}-${TARGET}
COMPOSE_FILE	=infra/docker-compose.${TARGET}.yml
COMMAND_BASE	=docker compose -p ${COMPOSE_PROJECT_NAME} -f ${COMPOSE_FILE}
API_ENV	=--env-file config/.env.public
COMMAND_ENV	=${COMMAND_BASE} ${API_ENV} 

## ---
## Make to build, run and manage project.
## Requirements
## Docker Engine: 28
## Docker API Version: 1.48
## make 4.4.1
## ---

help: ## Show this help
	@sed -ne '/@sed/!s/## //p' ${MAKEFILE_LIST}
	
## ---
## Docker Management
## ---

build: ## Build containers or container (SERVICE=servince_name)
	@${COMMAND_ENV} build ${SERVICE}

rebuild: ## Rebuild containers or container(--no-cache flag)
	@${COMMAND_ENV} build --no-cache ${SERVICE}

START_FLAG = $(if $(filter undefined,$(origin ATTACH)),-d,$(ATTACH))
start: ## Start services
	@${COMMAND_ENV} up $(START_FLAG) ${SERVICE}

run: ## Run service with custom command
	${COMMAND_ENV} run --rm ${SERVICE}

restart: ## Restart services
	@${COMMAND_ENV} restart ${SERVICE}

stop: ## Stop services
	${COMMAND_ENV} stop ${SERVICE}

status: ## Show services status
	@${COMMAND_ENV} ps --format "{{.Service}}\t {{.State}}"

logs: ## Show container(-s) logs [make logs] or [make logs SERVICE=service_name]
	@${COMMAND_ENV} logs -f -t ${SERVICE}


## ---
## Loki
## ---

LOKI_COMMAND=$(shell make run -n SERVICE=loki)
loki-approve: ## Approve new screenshots
	${LOKI_COMMAND} /bin/sh -c "./.loki/scripts/approve.sh"
loki-update: ## Update old screenshots
	${LOKI_COMMAND} /bin/sh -c "./.loki/scripts/update.sh"
