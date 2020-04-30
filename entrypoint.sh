#!/bin/sh
set -e

# replace $ETH_... strings with env variable values without overwriting genesis.json
cp genesis.json .genesis.json
sed -i "s|\$ETH_ADDRESS|$ETH_ADDRESS|g" .genesis.json
sed -i "s|\$ETH_BUFFER|$ETH_BUFFER|g" .genesis.json

echo $ETH_PASSWORD > /tmp/eth_pass
echo $ETH_PRIVATE_KEY > /tmp/eth_private_key

geth --datadir /data init ./.genesis.json
geth --datadir /data account import --password /tmp/eth_pass /tmp/eth_private_key || true

if [[ $# -eq 0 ]] ; then
  exec geth --config config.toml --allow-insecure-unlock --nousb --verbosity 5 --gcmode=archive --mine --miner.threads 1 --unlock $ETH_ADDRESS --password /tmp/eth_pass
else
  exec "$@"
fi

