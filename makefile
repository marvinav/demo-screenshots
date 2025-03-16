include .makerc

## !!! Override make environment variables in .makerc file !!!
# Environment
PROJECT_NAME		?= demo-screenshot 	# Project name
HOST_DOCKER_PATH	?= /tmp/builds/		# Directory on the host where to put builds
TARGET				?= Development		# Environment target. Ensure to have .env.TATGET and docker-compose.TARGET.yml files
TAG					?= latest			# Tag version docker images		

# Calculated and internal env. DO NOT OVERRIDE
MAKEFLAGS				+= --no-print-directory
SHELL					:=/bin/bash
COMPOSE_PROJECT_NAME	= ${PROJECT_NAME}-${TARGET}
COMPOSE_FILE			= docker-compose.${TARGET}.yml
COMMAND_BASE			= docker compose -p ${COMPOSE_PROJECT_NAME} -f ${COMPOSE_FILE}
API_ENV					= .env.${TARGET} --env-file .env.public
COMMAND_ENV				= ${COMMAND_BASE} --env-file ${API_ENV}

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
## Development
## ---

attach: ## Attach to container [make attach SERVICE=service_name]
	@${COMMAND_ENV} exec ${SERVICE} bash

# HEX Id of docker container (required for vscode)
CODE_HEX 				= $(shell printf "$$($(COMMAND_ENV) ps -q $(or ${SERVICE},dev))" | od -A n -t x1 | sed 's/ *//g' | tr -d '\n')
# Workdir of docker container
WORKDIR 				= $(shell printf "$$($(COMMAND_ENV) exec $${SERVICE:-dev} pwd)")

attach-code: ## Attach VSCode to container [make attach-code SERVICE=service_name]
	code --folder-uri vscode-remote://attached-container+${CODE_HEX}${WORKDIR}

## ---
## Deploy
## ---

tag: ## Build containers or container (SERVICE=servince_name)
	@docker image tag ${COMPOSE_PROJECT_NAME}-${SERVICE} ${COMPOSE_PROJECT_NAME}-${SERVICE}:${TAG}

pack: ## Pack the latest docker image
	@mkdir -p builds
	docker save -o builds/${COMPOSE_PROJECT_NAME}-${SERVICE}.tar ${COMPOSE_PROJECT_NAME}-${SERVICE}:${TAG}

publish: ## Upload the latest packed docker image to a remote host
	scp builds/${COMPOSE_PROJECT_NAME}-${SERVICE}.tar ${HOST}:${HOST_DOCKER_PATH}

unpack: ## Unpack the latest packed docker image
	docker load -i ${HOST_DOCKER_PATH}/${COMPOSE_PROJECT_NAME}-${SERVICE}.tar