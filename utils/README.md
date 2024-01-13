# Utilities

## \_variables.sh

This script holds all the repository-specific variables shared with most of the scripts in the [utils](/utils)-, [setup](/setup)- and [setup-local](/setup-local)-folder. This makes it easier to adjust the chain-id, binary name or node directory without having to change it in a lot of different scripts.

## \_local-variables.sh

This script holds repository-specific variables for **local** testnet purposes.

## create-backup.sh

This script creates a backup for the current node-setup, if one existed.

```
sh utils/create-backup.sh [backup_dir_path]
```

> _[backup_dir_path]_ is optional (defaults: to a directory in the $HOME folder with a _unique_ name based on the system's current time).

## create-key.sh

This script creates a _new_ key (or prompts to overwrite one if the _alias_ already exists).

```
sh utils/create-key.sh <key_alias>
```

## fetch-peers.sh

This script fetches the (most recent) seeds and peers list for the chain-id configured in the [\_variables.sh](/utils/_variables.sh) file and adds it to the config.toml file residing in the node's directory. This script leverages the [`genesis-parameters`](https://github.com/zenodeapp/genesis-parameters) repo.

## fetch-state.sh

This script fetches the (most recent) `genesis.json` file for the chain-id configured in the [\_variables.sh](/utils/_variables.sh) file. This script leverages the [`genesis-parameters`](https://github.com/zenodeapp/genesis-parameters) repo.

## import-key.sh

This script imports an _existing_ key using the provided _private Ethereum key_.

```
sh utils/import-key.sh <key_alias> <private_eth_key>
```

## install-service.sh

This script installs the daemon as a service, which will automatically start the node whenever the device reboots (see [tgenesisd.service](/services/tgenesisd.service)). The setup scripts usually already call this, therefore it is not required to run this yourself.

## refresh-state-sync.sh

This script is useful if you want to recalibrate your state-sync configurations to a more recent height. **WARNING: this wipes your entire data folder, but will backup and restore the priv_validator_state.json file**. It uses the script(s) from the [`restate-sync`](https://github.com/zenodeapp/restate-sync/tree/main) repository (`main`). If in doubt whether this is safe, you could always check the repository to see how it works.

```
sh refresh-state-sync.sh [height_interval] [rpc_server_1] [rpc_server_2]
```

> [height_interval] is optional (default: 2000). This means it will set the trust_height to: latest_height - height_interval (rounded to nearest multiple of height_interval).
>
> [rpc_server_1] is optional (default: first rpc server configured in your config.toml file). If there is no rpc server configured, the script will abort.
>
> [rpc_server_2] is optional (default: rpc_server_1).

> [!NOTE]
> Leaving the _<rpc_server>_-arguments empty will leave the rpc_servers field in your config.toml untouched.

## my-peer-id.sh

This script will print out your peer-id: _node-id@ip-address:port_. This is useful for sharing your node with others so that they can add you as a persistent peer.

Bear in mind that the _port_ being echo'd is extracted from the _config.toml_-file. So if you start the node on a different port without explicitly stating this in the _config.toml_-file, then the outputted port may not represent the actual port this node uses.

> Add a --local flag to echo a local IP address, instead of your (public) external address.

## shift-ports.sh

This script is useful if you quickly want to replace the ports in the `config.toml` and `app.toml` files. It uses the script(s) from the [`port-shifter`](https://github.com/zenodeapp/port-shifter/tree/v1.0.0) repository (`v1.0.0`). If in doubt whether this is safe, you could always check the repository to see how it works.

```
sh shift-ports.sh <port_increment_value>
```

> <port_increment_value> is how much you would like to increment the value of the ports based on the default port values.
