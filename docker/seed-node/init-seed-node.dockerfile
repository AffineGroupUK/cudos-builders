FROM golang:buster

# RUN apk add --no-cache jq make bash g++

RUN apt update

RUN apt install -y jq build-essential

WORKDIR /usr/cudos

COPY ./CudosNode ./

COPY ./CudosBuilders/docker/seed-node/init-seed.sh ./

COPY ./CudosBuilders/docker/config ./external-config

ARG GENESIS_FILENAME

ARG SEEDS_FILENAME

ARG PERSISTENT_PEERS_FILENAME

RUN mv "./external-config/${PERSISTENT_PEERS_FILENAME}" ./external-config/persistent-peers.config && \
    mv "./external-config/${SEEDS_FILENAME}" ./external-config/seeds.config && \
    mv "./external-config/${GENESIS_FILENAME}" ./external-config/genesis.json && \
    make && \
    chmod +x ./init-seed.sh && \
    sed -i 's/\r$//' ./init-seed.sh

CMD ["/bin/bash", "./init-seed.sh"]
