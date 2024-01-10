# Utilities

## _variables.sh

This script holds all the repository-specific variables shared with most of the scripts in the [utils](/utils)- and [setup](/setup)-folder. This makes it easier to adjust the chain-id, binary name or node directory without having to change it in a lot of different scripts.

## fetch-state.sh

This script fetches the (most recent) `genesis.json` file for the chain-id configured in the [_variables.sh](/utils/_variables.sh) file. It uses the [`genesis-parameters`](https://github.com/zenodeapp/genesis-parameters) repo.

## fetch-peers.sh

This script fetches the (most recent) seeds and peers list for the chain-id configured in the [_variables.sh](/utils/_variables.sh) file and adds it to the config.toml file residing in the node's directory. Also leverages the [`genesis-parameters`](https://github.com/zenodeapp/genesis-parameters) repo.

## install-service.sh

This script installs the `tgenesisd` service, which will automatically start the node whenever the device reboots (see [tgenesisd.service](/services/tgenesisd.service)). Since this file already gets called from within the other scripts, it is not required to call this yourself.

## refresh-state-sync.sh

This script is useful if you want to recalibrate your state-sync configurations to a more recent height. **WARNING: this wipes your entire data folder, but will backup and restore the priv_validator_state.json file**. It uses the script(s) from https://github.com/zenodeapp/restate-sync/tree/main. If in doubt whether this is safe, you could always check the repository to see how it works.

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

## shift-ports.sh

This script is useful if you quickly want to replace the ports in the `config.toml` and `app.toml` files. It uses the script(s) from https://github.com/zenodeapp/port-shifter/tree/v1.0.0. If in doubt whether this is safe, you could always check the repository to see how it works.

```
sh shift-ports.sh <port_increment_value>
```
> <port_increment_value> is how much you would like to increment the value of the ports based on the default port values.