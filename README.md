# Fork note

This is a fork of [geth-poa-testnet](https://github.com/ulamlabs/geth-poa-testnet) tailored to the needs of [minimal crypto exchange](https://github.com/mentiflectax/minimal-crypto-exchange).

For issues see [this page](https://github.com/mentiflectax/minimal-crypto-exchange/issues).

# geth-poa-testnet

Docker image for Ethereum testnet using proof-of-authority consensus protocol. By default two accounts will be created, one serving as a signer and another one which holds all the coins on the testnet.

GitHub Repository is available at [ulamlabs/geth-poa-testnet](https://github.com/ulamlabs/geth-poa-testnet).

## Building

```console
$ docker build -t ulamlabs/geth-poa-testnet:latest .
```

## Usage

Docker container requires these environment variables to be set:

- `ETH_PASSWORD` - password for keystore file, 
- `ETH_PRIVATE_KEY` - signer account private key,
- `ETH_ADDRESS` - signer account address,
- `ETH_BUFFER` - account which holds all the coins,
- `ETH_CHAIN_ID` - chain ID, defaults to 5555

You can override `genesis.json` by mounting your own at `/app`. Please bear in mind that `$ETH_ADDRESS` and `$ETH_BUFFER` strings will be replaced with the environment variables.

```console
$ docker run -p 8178:8178 -p 8456:8456 ulamlabs/geth-poa-testnet:latest
```

