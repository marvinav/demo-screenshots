# Screenshot testing
Here you could find quick setup of screenshot testing for React application which consists of:
1. Storybook
2. loki

## How to start

## Using makefile
Makefile is a thin wrapper over docker compose commands. If you don't have c, or don't want to install it, you could use this command replacing SERVICE with desired service:
```sh
docker compose -p demo-screenshot-development -f infra/docker-compose.development.yml --env-file config/.env.public  run --rm SERVICE
```

## Run storybook
make run SERVICE=storybook

## Run screenshot tests
make run SERVICE=loki