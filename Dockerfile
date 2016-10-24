FROM andrewdotnich/docker-crystal:latest

MAINTAINER Andy Nicholson <andrew@anicholson.net>

ENV WORKDIR /usr/local/src
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 5.0.0

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get install -y curl

RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash \
    && source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

RUN source $NVM_DIR/nvm.sh && \
    nvm use default && \
    npm install -g elm webpack

COPY . $WORKDIR

WORKDIR $WORKDIR/client

RUN source $NVM_DIR/nvm.sh && \
    nvm use default && \
    npm install && \
    elm-package install -y && \
    rm -rf elm-stuff/build-artifacts && \
    webpack --production && \
    rm -rf node_modules

WORKDIR $WORKDIR/server

RUN shards install
RUN crystal build src/microfinance.cr

ENV PORT 80

EXPOSE 80

ENTRYPOINT ./microfinance -p 80
