#########################
#       DEV             #
#########################
# Dev environment for local development
FROM node:22 AS dev
USER root
RUN apt-get update && apt-get install -y zsh csh tcsh
RUN chsh -s /bin/zsh
RUN npm install -g npm@10.8.3
RUN mkdir -p /home/node
RUN chown node:node /home/node
USER node
RUN wget -O /home/node/.zshrc https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc
CMD tail -f /dev/null

#########################
#       client          #
#########################

FROM node:22 AS client-base

RUN mkdir -p /node/client && chown -R node:node /node/client
RUN mkdir -p /node/client/dist && chown -R node:node /node/client/dist
RUN mkdir -p /node/client/node_modules && chown -R node:node /node/client/node_modules
WORKDIR /node
COPY --chown=node:node ./client client
RUN npm install -g npm@10.8.3
RUN npx playwright install chromium --with-deps

### dev
FROM client-base AS client-dev
WORKDIR /node/client
USER node
RUN npm install
CMD npm run dev