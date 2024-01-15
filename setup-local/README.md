# Setup (Local)

> [!IMPORTANT]
> The scripts in this folder are specifically written for **local** testnet purposes and require you to have already setup a testnet in your local network using a `tgenesis` branch in the [`genesis-ethermint`](https://github.com/zenodeapp/genesis-ethermint) repository.

## upgrade.sh

> [!WARNING]
> This script should only be used if you run a full-node and have to perform the **"plan_cronos"**-upgrade!
>
> This means that you are currently operating on the Evmos fork of GenesisL1 (repo: [`genesis-ethermint`](https://github.com/zenodeapp/genesis-ethermint)) and the node synced till height: `insert_height_here` which caused it to panic.

This script takes care of the needed steps to upgrade the node to the new fork:

- It stops the node (the service)
- Creates a backup of existing _config.toml_ or _app.toml_ files (as _.toml.bak_)
- Introduces new config files
- Builds the binaries
> This _local_ variant of the script doesn't fetch any seeds or peers _(so any configured persistent_peers and seeds get reset!)_

### Usage

```
sh setup-local/upgrade.sh
```
> After a successful upgrade, start the node again using `systemctl start tgenesisd` and monitor its status with `journalctl -fu tgenesisd -ocat`.

## state-sync.sh

> [!CAUTION]
> Running this will **wipe the entire database** (the _/data_-folder **excluding** the priv_validator_state.json file).
> 
> Make a backup if needed: [utils/create-backup.sh](/utils/create-backup.sh).

This script takes care of the needed steps to join the network via State Sync:

- It stops the service (if it exists)
- Installs all the necessary dependencies
- Builds the binaries
- Initializes the node
- Resets config files
- This _local_ variant of the script doesn't fetch any seeds or peers _(so any configured persistent_peers and seeds get reset!)_
- This _local_ variant of the script doesn't fetch any _genesis.json_-file _(add this yourself from the node that's already connected to the network)_
- This _local_ variant sets the _rpc_servers_-field to the variable [`$LOCAL_RPC_SERVERS`](/utils/_local-variables.sh)
- Installs the service
- Recalibrates **[statesync]** settings to a recent height (**default:** `<latest_height>` - [`$LOCAL_HEIGHT_INTERVAL`](/utils/_local-variables.sh))

### Usage

```
sh setup-local/state-sync.sh <moniker>
```
> Make sure that there's a peer providing a **[statesync]** snapshot in the network and add this peer to your _persistent_peers_-field _after_ running this command.
