FROM andrewdotnich/docker-crystal:latest

MAINTAINER Andy Nicholson <andrew@anicholson.net>

RUN apt-get install -yy git nodejs --no-install-suggests

ENV WORKDIR /usr/local/src

COPY . $WORKDIR

WORKDIR $WORKDIR/server

RUN shards install

RUN crystal build src/microfinance.cr

ENTRYPOINT ./microfinance
