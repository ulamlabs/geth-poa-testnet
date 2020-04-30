#!/bin/sh
set -e

export ETH_CHAIN_ID=${ETH_CHAIN_ID:-5555}

replace_env() {
  for var in $(env | sed 's;=.*;;' | grep ETH_); do
    sed -i "s|\$$var|${!var}|g" $1
  done
}

# replace $ETH_... strings with env variable values without overwriting genesis.json
cp genesis.json .genesis.json
cp config.toml .config.toml
replace_env .genesis.json
replace_env .config.toml

echo $ETH_PASSWORD > /tmp/eth_pass
echo $ETH_PRIVATE_KEY > /tmp/eth_private_key

geth --datadir /data init ./.genesis.json
geth --datadir /data account import --password /tmp/eth_pass /tmp/eth_private_key || true

if [[ $# -eq 0 ]] ; then
  exec geth --config .config.toml --allow-insecure-unlock --nousb --verbosity 5 --gcmode=archive --mine --miner.threads 1 --unlock $ETH_ADDRESS --password /tmp/eth_pass
else
  exec "$@"
fi

