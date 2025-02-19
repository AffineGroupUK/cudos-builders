if [[ -z "${CUDOS_HOME}" ]]; then
    CUDOS_HOME="./cudos-data"
fi

if [ "$SHOULD_USE_GLOBAL_PEERS" = "true" ]; then
    PERSISTENT_PEERS=$(cat ./external-config/persistent-peers.config)
    SEEDS=$(cat ./external-config/seeds.config)
fi


WORKING_PATH=$(pwd) && cd $CUDOS_HOME && rm -Rf ./* && cd $WORKING_PATH

cudos-noded init $MONIKER

cp ./external-config/genesis.json "${CUDOS_HOME}/config/genesis.json"

sed -i "s/persistent_peers = \".*\"/persistent_peers = \"$PERSISTENT_PEERS\"/g" "${CUDOS_HOME}/config/config.toml"

sed -i "s/seeds = \".*\"/seeds = \"$SEEDS\"/g" "${CUDOS_HOME}/config/config.toml"

# sed -i "s/seed_mode = false/seed_mode = true/g" "${CUDOS_HOME}/config/config.toml"

sed -i "s/private_peer_ids = \"\"/private_peer_ids = \"$PRIVATE_PEERS\"/g" "${CUDOS_HOME}/config/config.toml"

cudos-noded tendermint show-node-id |& tee "${CUDOS_HOME}/tendermint.nodeid"