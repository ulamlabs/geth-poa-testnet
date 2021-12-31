#!/bin/sh
set -e

export ETH_VERBOSITY=${ETH_VERBOSITY:-1}
export ETH_CHAIN_ID=${ETH_CHAIN_ID:-5555}

replace_env() {
  for key in $(env | sed 's;=.*;;' | grep ETH_); do
    val=$(eval echo \$$key)  # sh doesn't support indirect substitution
    sed -i "s|\$$key|$val|g" $1
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

#
# Create buffer account (start)
# 
echo carsdrivefasterbecausetheyhavebrakes > /tmp/buffer_pass
echo 766df34218d5a715018d54789d6383798a1885088d525670802ed8cf152db5b4 > /tmp/buffer_private_key
geth account import --datadir /data --password /tmp/buffer_pass /tmp/buffer_private_key || true
#
# Create buffer account (end)
#

#
# Create exchange account (start)
# 
echo a-turkey-is-a-chicken-designed-by-a-committee > /tmp/exchange_pass
echo b07aedf303f832664eb7a5295be737776cb1ad17a277ec287b3b3c7bac154e5e > /tmp/exchange_private_key
geth account import --datadir /data  --password /tmp/exchange_pass  /tmp/exchange_private_key || true
#
# Create exchange account (end)
# 

if [[ $# -eq 0 ]] ; then
  exec geth --config .config.toml --allow-insecure-unlock --nousb --verbosity $ETH_VERBOSITY --gcmode=archive --mine --miner.threads 1 --unlock $ETH_ADDRESS --password /tmp/eth_pass --rpcapi="db,eth,net,web3,personal,txpool,debug"
else
  exec "$@"
fi

