# Screenshot testing
Here you could find quick setup of screenshot testing for React application which consists of:
1. Storybook
2. loki

The full article you could find [here](https://dev.to/marvinav/screenshot-testing-gotta-catch-em-all-3123) 

## Requirements
1. Docker
2. make (optional)

## How to start

### Using makefile
Makefile is a thin wrapper over docker compose commands. If you don't have c, or don't want to install it, you could use this command replacing SERVICE with desired service:
```sh
docker compose -p demo-screenshot-development -f infra/docker-compose.development.yml --env-file config/.env.public  run --rm SERVICE
```

### Run storybook
make run SERVICE=storybook

### Run screenshot tests
make run SERVICE=loki


## Project structure

### infra
All scripts and files related to development and deployment

### config
Env variables

### client
React application

### client/.loki
Loki output
